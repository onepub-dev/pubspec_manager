// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

part of 'internal_parts.dart';

/// Holds a dependency version
class VersionAttached extends LineSection {
  // not part of the public interface
  VersionAttached._fromLine(this.line, {bool required = false})
      : _missing = false,
        super.fromLine(line) {
    if (Strings.isBlank(line.value)) {
      if (required) {
        throw PubSpecException(line, 'Required version missing.');
      }
      // The pubspec doc says that a blank version is to be
      // treated as 'any'. We however need to record that the
      // version string was blank so we use emtpy.
      // However is the user queries the version we return any.
      _versionConstraint = Version.empty();
      return;
    }
    _versionConstraint = parseVersionConstraint(line, line.value);
  }

  /// The version key wasn't present in the pubspec
  VersionAttached._missing(Document document)
      : line = Line.missing(document, LineType.key),
        _missing = false,
        super.missing(document, 'version');

  /// There was a version key but no value
  bool get isEmpty => !_missing && _versionConstraint.isEmpty;

  /// There was no version in the pubspec.
  bool get isMissing => _missing;

  final bool _missing;

  late Version _versionConstraint;

  @override
  late Line line;

  // The pubspec doc says that a blank version is to be
  // treated as 'any'. We however need to record that the
  // version string was blank so we use emtpy.
  // However is the user queries the version we return any.
  sm.VersionConstraint get constraint => _versionConstraint.isEmpty || _missing
      ? sm.VersionConstraint.any
      : _versionConstraint._version;

  @override
  String toString() => _versionConstraint.toString();

  @override
  set value(String version) {
    try {
      sm.VersionConstraint.parse(version);
    } on FormatException catch (e) {
      throw VersionException('The passed version is invalid: ${e.message}');
    }
    line.value = version;
  }

  @override
  bool operator ==(Object other) =>
      other is Version &&
      other.runtimeType == runtimeType &&
      other._version == _versionConstraint._version;

  @override
  int get hashCode => _versionConstraint.hashCode;

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

  static Version parseVersionConstraint(Line line, String value) {
    try {
      return Version.parse(_stripQuotes(value));
    } on VersionException catch (e) {
      e.document = line.document;
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  @override
  List<Line> get lines => [line];
}
