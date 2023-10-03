part of 'internal_parts.dart';

/// Holds the details of the environment section.
/// i.e. flutter and sdk versions.
class EnvironmentAttached extends Section {
  EnvironmentAttached.missing(Document document)
      : _line = Line.missing(document, LineType.key),
        _sdk = VersionAttached._missing(document),
        _flutter = VersionAttached._missing(document);

  /// Load the environment [Section] starting from the
  /// given [_line].
  EnvironmentAttached.fromLine(this._line) {
    _sdkLine = _line.findKeyChild('sdk');
    _flutterLine = _line.findKeyChild('flutter');

    _sdk = _sdkLine.missing
        ? VersionAttached._missing(document)
        : VersionAttached._fromLine(_sdkLine);

    _flutter = _flutterLine.missing
        ? VersionAttached._missing(document)
        : VersionAttached._fromLine(_flutterLine);

    comments = CommentsAttached(this);
  }

  EnvironmentAttached._attach(
      Pubspec pubspec, int lineNo, Environment environment) {
    final document = pubspec.document;

    _line = Line.forInsertion(document, 'environment:');
    document.insert(_line, lineNo++);

    if (environment._sdk != null) {
      pubspec.document.insert(
          _sdkLine = Line.forInsertion(
              pubspec.document, "  sdk: '${environment._sdk}'"),
          lineNo++);
      _sdk = VersionAttached._fromLine(_sdkLine);
    } else {
      _sdkLine = Line.missing(document, LineType.key);
      _sdk = VersionAttached._missing(document);
    }

    if (environment._flutter != null) {
      pubspec.document.insert(
          _flutterLine = Line.forInsertion(
              pubspec.document, "  flutter: '${environment._flutter}'"),
          lineNo++);
      _flutter = VersionAttached._fromLine(_flutterLine);
    } else {
      _flutterLine = Line.missing(document, LineType.key);
      _flutter = VersionAttached._missing(document);
    }
  }

  late final VersionAttached _sdk;
  late final VersionAttached _flutter;

  /// The starting line of the environment section.
  late final Line _line;
  late final Line _sdkLine;
  late final Line _flutterLine;

  @override
  Line get line => _line;

  @override
  late final CommentsAttached comments;

  Version get sdk => _sdk._versionConstraint;
  Version get flutter => _flutter._versionConstraint;

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
