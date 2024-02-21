// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

part of 'internal_parts.dart';

/// Holds package version as declared in the pubspec.yaml
class Version {
  ///
  /// extract a version for an attached line.
  ///
  factory Version._fromDocument(Document document) {
    final section = document.getLineForKey(_key);

    return Version._fromLine(section.line);
  }

  ///
  /// extract a version for an attached line.
  ///
  Version._fromLine(LineImpl line) {
    _missing = line.missing;
    if (_missing) {
      _section = SectionSingleLine.missing(line.document, _key);
      _version = sm.Version.none;
    } else {
      _section = SectionSingleLine.fromLine(line);
      _version = parseVersion(line, line.value);
      quoted = _isQuoted(line.value);
    }
  }

  factory Version._append(PubSpec pubspec, VersionBuilder versionBuilder) {
    final detached = LineDetached('  $_key: ${versionBuilder._version}');
    final line = pubspec.document.append(detached);

    return Version._fromLine(line);
  }

  late final SectionImpl _section;

  /// There was a version key but no value
  bool get isEmpty => !_missing && _version.isEmpty;

  /// There was no version in the pubspec.
  bool get isMissing => _missing;

  late final bool _missing;

  bool quoted = false;

  late sm.Version _version;

  /// If a version has not been specified we return [sm.Version.none]
  sm.Version getSemVersion() =>
      _version.isEmpty || _missing ? sm.Version.none : _version;

  // ignore: avoid_setters_without_getters
  void setSemVersion(sm.Version value) {
    _version = value;
    _section.line.value = value.toString();
  }

  String get asString {
    if (quoted) {
      return "'${toString()}'";
    } else {
      return toString();
    }
  }

  @override
  String toString() => _version.toString();

  void set(String version) {
    try {
      sm.VersionConstraint.parse(version);
    } on FormatException catch (e) {
      throw VersionException('The passed version is invalid: ${e.message}');
    }
    quoted = _isQuoted(version);

    _section.line.value = _stripQuotes(version);
    _section.missing = false;
  }

  // void set(String version) => this.version = version;

  bool _isQuoted(String version) =>
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

  static sm.Version parseVersion(Line line, String value) {
    try {
      return sm.Version.parse(_stripQuotes(value));
    } on VersionException catch (e) {
      e.document = line.document;
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  static const String _key = 'version';
}
