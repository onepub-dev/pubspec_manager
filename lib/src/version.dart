// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

part of 'internal_parts.dart';

/// Holds a dependency version
class Version {
  Version(this._version) : missing = false;

  factory Version.parse(String? versionConstraint) => versionConstraint != null
      ? Version(parseConstraint(versionConstraint))
      : Version.missing();

  /// Used to indicate that that a version key doesn't exist.
  /// This is different from [Version.empty()] which indicates
  /// that a version key was provided but the value was empty.
  Version.missing()
      : missing = true,
        _version = sm.VersionConstraint.empty;

  /// A version for which no value was supplied yet
  /// a key exist.
  /// An empty version is treated as 'any' but we need
  /// to record that it was empty so when writting out
  /// the version we leave it as blank to ensure the fidelity
  /// of the original document is maintained.
  Version.empty()
      : missing = false,
        _version = sm.VersionConstraint.empty;

  late final bool missing;
  late final sm.VersionConstraint _version;

  // The pubspec doc says that a blank version is to be
  // treated as 'any'. We however need to record that the
  // version string was blank so we use emtpy.
  // However is the user queries the version we return any.
  sm.VersionConstraint get constraint => _version == sm.VersionConstraint.empty
      ? sm.VersionConstraint.any
      : _version;

  bool get isEmpty => _version == sm.VersionConstraint.empty;

  @override
  bool operator ==(Object other) =>
      other is Version &&
      other.runtimeType == runtimeType &&
      other._version == _version;

  @override
  int get hashCode => _version.hashCode;

  @override
  String toString() {
    if (isEmpty || missing) {
      return '';
    } else {
      return _version.toString();
    }
  }

  static sm.VersionConstraint parseConstraint(String? version) {
    try {
      if (version == null) {
        return sm.VersionConstraint.empty;
      }
      return sm.VersionConstraint.parse(version);
    } on FormatException catch (e) {
      throw VersionException(e.message);
    }
  }
}
