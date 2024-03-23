// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

part of 'internal_parts.dart';

/// Holds package version as declared in the pubspec.yaml
class Version implements Section {
  ///
  /// extract the version from the underlying document.
  factory Version._fromDocument(Document document) {
    final section = document.getLineForKey(keyName);

    return Version._fromLine(section.headerLine);
  }

  /// Define a missing version.
  Version._missing(Document document)
      : _section = SectionImpl.missing(document, keyName) {
    // headerLine = LineImpl.missing(document, LineType.key);
  }

  ///
  /// extract a version for an attached line.
  ///
  factory Version._fromLine(LineImpl line) {
    if (line.missing) {
      return Version._missing(line._document);
    } else {
      return Version._missing(line._document)
        .._version = parseVersion(line, line.value)
        ..quoted = _isQuoted(line.value);
    }
  }

  factory Version._append(PubSpec pubspec, VersionBuilder versionBuilder) {
    final detached = LineDetached('$keyName: ${versionBuilder._version}');
    final line = pubspec.document.append(detached);

    return Version._fromLine(line);
  }

  SectionImpl _section;

  /// There was a version key but no value
  bool get isEmpty => !_section.missing && _version.isEmpty;

  /// There was no version in the pubspec.
  bool get isMissing => _section.missing;

  bool quoted = false;

  late sm.Version _version;

  /// If a version has not been specified we return [sm.Version.none]
  sm.Version getSemVersion() =>
      _version.isEmpty || _section.missing ? sm.Version.none : _version;

  // ignore: avoid_setters_without_getters
  void setSemVersion(sm.Version value) {
    _version = value;
    _section.headerLine.value = value.toString();
  }

  String get value {
    if (quoted) {
      return "'$_version'";
    } else {
      return _version.toString();
    }
  }

  @override
  String toString() => value;

  Version set(String version) {
    /// check for a valid version.
    try {
      _version = sm.Version.parse(version);
    } on FormatException catch (e) {
      throw VersionException('The passed version is invalid: ${e.message}');
    }
    quoted = _isQuoted(version);

    if (missing) {
      _section
        ..missing = false
        ..headerLine =
            _section.document.append(LineDetached('$keyName: $version'));
    } else {
      _section.headerLine.value = _stripQuotes(version);
    }

    // ignore: avoid_returning_this
    return this;
  }

  // void set(String version) => this.version = version;

  static bool _isQuoted(String version) =>
      version.contains("'") || version.contains('"');

  @override
  bool operator ==(Object other) =>
      other is VersionBuilder &&
      other.runtimeType == runtimeType &&
      other._version == _version;

  @override
  int get hashCode => _version.hashCode;

  // strips any quotes that surround the value
  static String _stripQuotes(String value) {
    if (value.isEmpty) {
      return value;
    }
    final first = value.substring(0, 1);

    // the version may have no quotes.
    if (first != "'" && first != '"') {
      return value;
    }

    // find the matching quote.
    final last = value.substring(value.length - 1, value.length);

    if (first == "'" || first == '"') {
      if (first != last) {
        throw PubSpecException.global(
            'The quotes around the version $value  do not match');
      }
      return value.substring(1, value.length - 1);
    }

    return value;
  }

  static sm.Version parseVersion(LineImpl line, String value) {
    try {
      return sm.Version.parse(_stripQuotes(value));
    } on VersionException catch (e) {
      e.document = line._document;
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  static const String keyName = 'version';

  @override
  Comments get comments => _section.comments;

  @override
  List<Line> get lines => _section.lines;

  @override
  bool get missing => _section.missing;
}
