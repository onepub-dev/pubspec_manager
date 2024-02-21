part of 'internal_parts.dart';

/// Holds the details of the environment section.
/// i.e. flutter and sdk versions.
class Environment extends SectionImpl implements Section {
  Environment.missing(Document document)
      : _sdk = VersionConstraint._missing(document, sdkKey),
        _flutter = VersionConstraint._missing(document, flutterKey),
        super.missing(document, _key);

  factory Environment._fromDocument(Document document) {
    final line = document.getLineForKey(Environment._key).sectionHeading;

    if (line.missing) {
      return Environment.missing(document);
    }

    return Environment._fromLine(line);
  }

  /// Load the existing environment [Section] starting from the
  /// given attached [line].
  Environment._fromLine(LineImpl line) : super.fromLine(line) {
    _sdkLine = line.findKeyChild('sdk');
    _flutterLine = line.findKeyChild('flutter');

    _sdk = _sdkLine.missing
        ? VersionConstraint._missing(document, sdkKey)
        : VersionConstraint._fromLine(_sdkLine);

    _flutter = _flutterLine.missing
        ? VersionConstraint._missing(document, sdkKey)
        : VersionConstraint._fromLine(_flutterLine);
  }

  /// Creates an Environment Section and adds it to the document.
  factory Environment._insertAfter(
      PubSpec pubspec, Line lineBefore, EnvironmentBuilder builder) {
    final document = pubspec.document;

    final line = LineImpl.forInsertion(document, 'environment:');
    document.insertAfter(line, lineBefore);

    LineImpl sdkLine;
    VersionConstraint? sdk;
    if (builder._sdk != null) {
      lineBefore = pubspec.document.insertAfter(
          sdkLine = LineImpl.forInsertion(
              pubspec.document, '  $sdkKey: ${builder._sdk}'),
          line);
      sdk = VersionConstraint._fromLine(sdkLine);
    } else {
      sdkLine = LineImpl.missing(document, LineType.key);
      sdk = VersionConstraint._missing(document, sdkKey);
    }

    LineImpl flutterLine;
    VersionConstraint? flutter;
    if (builder._flutter != null) {
      pubspec.document.insertAfter(
          flutterLine = LineImpl.forInsertion(
              pubspec.document, '  $flutterKey: ${builder._flutter}'),
          lineBefore);
      flutter = VersionConstraint._fromLine(flutterLine);
    } else {
      flutterLine = LineImpl.missing(document, LineType.key);
      flutter = VersionConstraint._missing(document, flutterKey);
    }

    final environment = Environment._fromLine(line)
      .._sdk = sdk
      .._flutter = flutter;
    return environment;
  }

  static const sdkKey = 'sdk';
  static const flutterKey = 'flutter';

  late VersionConstraint _sdk;
  late VersionConstraint _flutter;

  late LineImpl _sdkLine;
  late LineImpl _flutterLine;

  String get sdk => _sdk.version;
  String get flutter => _flutter.version;

  set sdk(String version) {
    _ensure();
    if (_sdk.missing) {
      final sdkLine = LineImpl.forInsertion(document, '  sdk: $version');
      append(sdkLine);
      _sdkLine = sdkLine;
      _sdk = VersionConstraint._fromLine(_sdkLine);
    } else {
      _sdk.version = version;
      _sdkLine.value = version;
    }
  }

  set flutter(String version) {
    _ensure();
    if (_flutter.missing) {
      final flutterLine =
          LineImpl.forInsertion(document, '  flutter: $version');
      append(flutterLine);
      _flutterLine = flutterLine;
      _flutter = VersionConstraint._fromLine(_flutterLine);
    } else {
      _flutter.version = version;
      _flutterLine.value = version;
    }
  }

  /// Ensure that the environment section has been created
  /// by creating it if it doesn't exist.
  void _ensure() {
    if (missing) {
      sectionHeading = document.append(LineDetached('$_key:'));
    }
  }

  @override
  String toString() {
    if (missing) {
      return '';
    }
    final sb = StringBuffer()..writeln('$key:');
    if (!_sdkLine.missing) {
      sb.writeln(_sdkLine);
    }

    if (!_flutterLine.missing) {
      sb.writeln(_flutterLine);
    }

    return sb.toString();
  }

  // @override
  // List<Line> get lines => [
  //       _line,
  //       if (!_sdkLine.missing) _sdkLine,
  //       if (!_flutterLine.missing) _flutterLine
  //     ];

  static const String _key = 'environment';
}
