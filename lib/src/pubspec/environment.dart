part of 'internal_parts.dart';

/// Holds the details of the environment section.
/// i.e. flutter and sdk versions.
/// To set/update the environment use:
///
/// ```dart
/// pubspec.environment.set(sdk: '>3.0.0 <=4.0.0', flutter: '1.0.0')
/// ```
class Environment implements Section {
  SectionImpl _section;

  late VersionConstraint _sdk;

  late VersionConstraint _flutter;

  late LineImpl _sdkLine;

  late LineImpl _flutterLine;

  static const _sdkKey = 'sdk';

  static const _flutterKey = 'flutter';

  static const keyName = 'environment';

  Environment._missing(Document document)
      : _sdk = VersionConstraint._missing(document, _sdkKey),
        _flutter = VersionConstraint._missing(document, _flutterKey),
        _section = SectionImpl.missing(document, keyName);

  factory Environment._fromDocument(Document document) {
    final line = document.getLineForKey(Environment.keyName).headerLine;

    if (line.missing) {
      return Environment._missing(document);
    }

    return Environment._fromLine(line);
  }

  /// Load the existing environment [Section] starting from the
  /// given attached [line].
  Environment._fromLine(LineImpl line) : _section = SectionImpl.fromLine(line) {
    _sdkLine = line.findKeyChild('sdk');
    _flutterLine = line.findKeyChild('flutter');

    _sdk = _sdkLine.missing
        ? VersionConstraint._missing(_section.document, _sdkKey)
        : VersionConstraint._fromLine(_sdkLine);

    _flutter = _flutterLine.missing
        ? VersionConstraint._missing(_section.document, _sdkKey)
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
              pubspec.document, '  $_sdkKey: ${builder._sdk}'),
          line);
      sdk = VersionConstraint._fromLine(sdkLine);
    } else {
      sdkLine = LineImpl.missing(document, LineType.key);
      sdk = VersionConstraint._missing(document, _sdkKey);
    }

    LineImpl flutterLine;
    VersionConstraint? flutter;
    if (builder._flutter != null) {
      pubspec.document.insertAfter(
          flutterLine = LineImpl.forInsertion(
              pubspec.document, '  $_flutterKey: ${builder._flutter}'),
          lineBefore);
      flutter = VersionConstraint._fromLine(flutterLine);
    } else {
      flutterLine = LineImpl.missing(document, LineType.key);
      flutter = VersionConstraint._missing(document, _flutterKey);
    }

    final environment = Environment._fromLine(line)
      .._sdk = sdk
      .._flutter = flutter;
    return environment;
  }

  /// Get the version constraint for the dart sdk as a String
  String get sdk => _sdk.version;

  /// Get the version constraint for the dart sdk.
  /// If no constraint is specified then VersionConstraint.any is returned.
  sm.VersionConstraint get sdkConstraint => _sdk.constraint;

  /// Get the version constraint for the flutter sdk as a String
  String get flutter => _flutter.version;

  /// Get the version constraint for the flutter sdk.
  /// If no constraint is specified then VersionConstraint.any is returned.
  sm.VersionConstraint get flutterConstraint => _flutter.constraint;

  /// Set the sdk and flutter version constraints
  Environment set({String? sdk, String? flutter}) {
    if (sdk != null) {
      this.sdk = sdk;
    }

    if (flutter != null) {
      this.flutter = flutter;
    }
    return this;
  }

  /// Set the [versionConstraint] for the dart sdk.
  /// ```dart
  /// pubspec.environment.sdk = '>=3.0.0 <4.0.0'
  /// ```
  set sdk(String versionConstraint) {
    _ensure();
    if (_sdk.missing) {
      final sdkLine =
          LineImpl.forInsertion(_section.document, '  sdk: $versionConstraint');
      _section.appendLine(sdkLine);
      _sdkLine = sdkLine;
      _sdk = VersionConstraint._fromLine(_sdkLine);
    } else {
      _sdk.version = versionConstraint;
      _sdkLine.value = versionConstraint;
    }
  }

  /// Set the [versionConstraint] for the flutter sdk.
  /// ```dart
  /// pubspec.environment.flutter = '>=3.0.0'
  /// ```
  set flutter(String versionConstraint) {
    _ensure();
    if (_flutter.missing) {
      final flutterLine = LineImpl.forInsertion(
          _section.document, '  flutter: $versionConstraint');
      _section.appendLine(flutterLine);
      _flutterLine = flutterLine;
      _flutter = VersionConstraint._fromLine(_flutterLine);
    } else {
      _flutter.version = versionConstraint;
      _flutterLine.value = versionConstraint;
    }
  }

  /// Ensure that the environment section has been created
  /// by creating it if it doesn't exist.
  void _ensure() {
    if (missing) {
      _section.headerLine = _section.document.append(LineDetached('$keyName:'));
    }
  }

  @override
  String toString() {
    if (missing) {
      return '';
    }
    final sb = StringBuffer()..writeln('$keyName:');
    if (!_sdkLine.missing) {
      sb.writeln(_sdkLine);
    }

    if (!_flutterLine.missing) {
      sb.writeln(_flutterLine);
    }

    return sb.toString();
  }

  @override
  Comments get comments => _section.comments;

  @override
  List<Line> get lines => _section.lines;

  @override
  bool get missing => _section.missing;
}
