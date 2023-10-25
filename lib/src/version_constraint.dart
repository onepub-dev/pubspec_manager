// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

part of 'internal_parts.dart';

/// Holds a dependency version
class VersionConstraint extends LineSection {
  ///
  /// extract a version from an attached line.
  ///
  VersionConstraint._fromLine(this.line, {bool required = false})
      : _missingValue = false,
        super.fromLine(line) {
    if (Strings.isBlank(line.value)) {
      if (required) {
        throw PubSpecException(line, 'Required version missing.');
      }
      // The pubspec doc says that a blank version is to be
      // treated as 'any'. We however need to record that the
      // version string was blank so we use emtpy.
      // However is the user queries the version we return any.
      _versionConstraint = sm.VersionConstraint.empty;
      return;
    }
    _versionConstraint = parseVersionConstraint(line, line.value);
    quoted = _isQuoted(line.value);
  }

  /// The version key wasn't present in the pubspec
  VersionConstraint._missing(super.document, super.key)
      : line = Line.missing(document, LineType.key),
        _missingValue = true,
        super.missing();

  // @override
  // factory VersionConstraint._attach(PubSpec pubspec, Line lineBefore,
  //     VersionConstraintBuilder versionBuilder) {
  //   final line = Line.forInsertion(
  //       pubspec.document, '  version: ${versionBuilder._version}');
  //   pubspec.document.insertAfter(line, lineBefore);

  //   final vc = VersionConstraint._fromLine(line);

  //   // ignore: prefer_foreach
  //   for (final comment in versionBuilder.comments) {
  //     vc.comments.append(comment);
  //   }
  //   return vc;
  // }

  /// There was no value for the version key in the pubspec.
  bool get isMissingValue => _missingValue;

  bool _missingValue;

  /// We track if the original constraint was wrapped in quotes
  /// so that when we write the value back out we can include
  /// the quotes.
  bool quoted = false;

  late sm.VersionConstraint _versionConstraint;

  @override
  late Line line;

  // The pubspec doc says that a blank version is to be
  // treated as 'any'. We however need to record that the
  // version string was blank so we use emtpy.
  // However is the user queries the version we return any.
  sm.VersionConstraint get constraint =>
      _versionConstraint.isEmpty || _missingValue
          ? sm.VersionConstraint.any
          : _versionConstraint;

  @override
  String toString() => _missingValue ? '' : constraint.toString();

  set version(String version) {
    quoted = _isQuoted(version);
    line.value = _stripQuotes(version);

    if (Strings.isEmpty(line.value)) {
      _versionConstraint = sm.VersionConstraint.empty;
      _missingValue = true;
      return;
    }

    try {
      _versionConstraint = sm.VersionConstraint.parse(line.value);
    } on FormatException catch (e) {
      throw VersionException('The passed version is invalid: ${e.message}');
    }
    _missingValue = false;
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
      other._version == _versionConstraint;

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

  static sm.VersionConstraint parseVersionConstraint(Line line, String value) {
    try {
      return VersionConstraintBuilder.parseConstraint(_stripQuotes(value));
    } on VersionException catch (e) {
      e.document = line.document;
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  @override
  List<Line> get lines => [line];
}
