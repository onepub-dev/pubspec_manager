part of 'internal_parts.dart';

/// Holds the details of the environment section.
/// i.e. flutter and sdk versions.
class EnvironmentAttached extends Section {
  EnvironmentAttached.missing(Document document)
      : _line = Line.missing(document, LineType.key),
        environment = Environment.missing();

  /// Load the environment [Section] starting from the
  /// given [_line].
  EnvironmentAttached.fromLine(this._line) {
    _sdkLine = _line.findKeyChild('sdk');
    _flutterLine = _line.findKeyChild('flutter');

    final sdk = _sdkLine.missing
        ? VersionAttached._missing(document)
        : VersionAttached._fromLine(_sdkLine);

    final flutter = _flutterLine.missing
        ? VersionAttached._missing(document)
        : VersionAttached._fromLine(_flutterLine);

    environment = Environment(
        sdk: sdk.missing ? null : sdk.toString(),
        flutter: flutter.missing ? null : flutter.toString());

    comments = Comments(this);
  }

  EnvironmentAttached._attach(Pubspec pubspec, int lineNo, this.environment) {
    final document = pubspec.document;
    _line = Line.forInsertion(document, 'environment:');
    document.insert(_line, lineNo++);
    pubspec.document.insert(
        _sdkLine =
            Line.forInsertion(pubspec.document, '  sdk: ${environment.sdk}'),
        lineNo++);
    pubspec.document.insert(
        _flutterLine = Line.forInsertion(
            pubspec.document, '  flutter: ${environment.flutter}'),
        lineNo++);
  }

  /// The starting line of the environment section.
  late final Line _line;
  late final Line _sdkLine;
  late final Line _flutterLine;

  late final Environment environment;

  @override
  Line get line => _line;

  @override
  late final Comments comments;

  Version get sdk => environment.sdk;
  Version get flutter => environment.flutter;

  @override
  String toString() => _line.value;

  @override
  Document get document => line.document;

  @override
  List<Line> get lines => [
        _line,
        if (!_sdkLine.missing) _sdkLine,
        if (!_flutterLine.missing) _flutterLine
      ];

  /// The last line number used by this  section
  @override
  int get lastLineNo => lines.last.lineNo;

  static const String _key = 'environment';
}
