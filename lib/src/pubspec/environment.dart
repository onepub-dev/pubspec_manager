part of 'internal_parts.dart';

/// Holds the details of the environment section.
/// i.e. flutter and sdk versions.
class Environment {
  Environment.missing(Document document)
      : _line = LineImpl.missing(document, LineType.key),
        _sdk = VersionConstraint._missing(document, sdkKey),
        _flutter = VersionConstraint._missing(document, flutterKey),
        _section = SectionImpl.missing(document, _key);

  factory Environment._fromDocument(Document document) {
    final line = document.getLineForKey(Environment._key).line;

    if (line.missing) {
      return Environment.missing(document);
    }

    return Environment._fromLine(line);
  }

  /// Load the existing environment [Section] starting from the
  /// given attached [_line].
  Environment._fromLine(this._line) {
    _sdkLine = _line.findKeyChild('sdk');
    _flutterLine = _line.findKeyChild('flutter');
    _section = SectionImpl.fromLine(_line);

    _sdk = _sdkLine.missing
        ? VersionConstraint._missing(_line.document, sdkKey)
        : VersionConstraint._fromLine(_sdkLine);

    _flutter = _flutterLine.missing
        ? VersionConstraint._missing(_line.document, sdkKey)
        : VersionConstraint._fromLine(_flutterLine);
  }

  /// Creates an Environment Section and adds it to the document.
  Environment._insertAfter(
      PubSpec pubspec, Line lineBefore, EnvironmentBuilder environment) {
    final document = pubspec.document;

    _line = LineImpl.forInsertion(document, 'environment:');
    document.insertAfter(_line, lineBefore);

    if (environment._sdk != null) {
      lineBefore = pubspec.document.insertAfter(
          _sdkLine = LineImpl.forInsertion(
              pubspec.document, '  $sdkKey: ${environment._sdk}'),
          _line);
      _sdk = VersionConstraint._fromLine(_sdkLine);
    } else {
      _sdkLine = LineImpl.missing(document, LineType.key);
      _sdk = VersionConstraint._missing(document, sdkKey);
    }

    if (environment._flutter != null) {
      pubspec.document.insertAfter(
          _flutterLine = LineImpl.forInsertion(
              pubspec.document, '  $flutterKey: ${environment._flutter}'),
          lineBefore);
      _flutter = VersionConstraint._fromLine(_flutterLine);
    } else {
      _flutterLine = LineImpl.missing(document, LineType.key);
      _flutter = VersionConstraint._missing(document, flutterKey);
    }
    _section = SectionImpl.fromLine(_line);
  }

  static const sdkKey = 'sdk';
  static const flutterKey = 'flutter';

  late VersionConstraint _sdk;
  late VersionConstraint _flutter;

  late final SectionImpl _section;

  /// The starting line of the environment section.
  late final LineImpl _line;
  late LineImpl _sdkLine;
  late LineImpl _flutterLine;

  String get sdk => _sdk.version;
  String get flutter => _flutter.version;

  set sdk(String version) {
    if (_sdk.missing) {
      final sdkLine =
          LineImpl.forInsertion(_section.document, '  sdk: $version');
      _section.insertAfter(sdkLine, _line);
      _sdkLine = sdkLine;
      _sdk = VersionConstraint._fromLine(_sdkLine);
    } else {
      _sdk.version = version;
      _sdkLine.value = version;
    }
  }

  set flutter(String version) {
    if (_flutter.missing) {
      final flutterLine =
          LineImpl.forInsertion(_section.document, '  flutter: $version');
      _section.insertAfter(flutterLine, _line);
      _flutterLine = flutterLine;
      _flutter = VersionConstraint._fromLine(_flutterLine);
    } else {
      _flutter.version = version;
      _flutterLine.value = version;
    }
  }

  @override
  String toString() => _line.value;

  // @override
  // List<Line> get lines => [
  //       _line,
  //       if (!_sdkLine.missing) _sdkLine,
  //       if (!_flutterLine.missing) _flutterLine
  //     ];

  static const String _key = 'environment';
}
