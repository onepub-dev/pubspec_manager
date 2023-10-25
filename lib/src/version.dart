// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

part of 'internal_parts.dart';

/// Holds a dependency version
class Version extends SectionSingleLine {
  ///
  /// extract a version for an attached line.
  ///
  Version._fromLine(Line line, {bool required = false})
      : _missing = false,
        super.fromLine(line) {
    if (Strings.isBlank(line.value)) {
      if (required) {
        throw PubSpecException(line, 'Required version missing.');
      }
      _version = sm.Version.none;
      return;
    }
    _version = parseVersion(line, line.value);
    quoted = _isQuoted(line.value);
  }

  /// The version key wasn't present in the pubspec
  Version._missing(super.document, super.key)
      : _missing = true,
        super.missing();

  /// Attached the passed [VersionBuilder] to the [Document].
  @override
  factory Version._attach(
      PubSpec pubspec, Line lineBefore, VersionBuilder versionBuilder) {
    final line = Line.forInsertion(
        pubspec.document, '  version: ${versionBuilder._version}');
    pubspec.document.insertAfter(line, lineBefore);

    return Version._fromLine(line);
  }

  factory Version._append(PubSpec pubspec, VersionBuilder versionBuilder) {
    final detached = LineDetached('  version: ${versionBuilder._version}');
    final line = pubspec.document.append(detached);

    return Version._fromLine(line);
  }

  /// There was a version key but no value
  bool get isEmpty => !_missing && _version.isEmpty;

  /// There was no version in the pubspec.
  bool get isMissing => _missing;

  final bool _missing;

  bool quoted = false;

  late sm.Version _version;

  /// If a version has not been specified we return [sm.Version.none]
  sm.Version get value =>
      _version.isEmpty || _missing ? sm.Version.none : _version;

  set value(sm.Version value) {
    _version = value;
    line.value = value.toString();
  }

  @override
  String toString() => _version.toString();

  set version(String version) {
    try {
      sm.VersionConstraint.parse(version);
    } on FormatException catch (e) {
      throw VersionException('The passed version is invalid: ${e.message}');
    }
    quoted = _isQuoted(version);

    line.value = _stripQuotes(version);
    missing = false;
  }

  String get version {
    if (quoted) {
      return "'${toString()}'";
    } else {
      return toString();
    }
  }

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

  @override
  List<Line> get lines => [line];
}
