// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

part of 'internal_parts.dart';

/// Builds a Version that can be attached to a document.
class VersionBuilder {
  VersionBuilder({
    required this.key,
    required sm.Version version,
    List<String>? comments,
  })  : missing = false,
        _version = version,
        _comments = comments ?? <String>[];

  factory VersionBuilder.parse({required String key, String? version}) =>
      version != null
          ? VersionBuilder(key: key, version: parseVersion(version))
          : VersionBuilder.missing();

  /// Used to indicate that that a version key doesn't exist.
  /// This is different from [Version.empty()] which indicates
  /// that a version key was provided but the value was empty.
  VersionBuilder.missing()
      : missing = true,
        key = 'version',
        _version = sm.Version.none;

  /// A version for which no value was supplied yet
  /// a key exist.
  /// An empty version is treated as 'any' but we need
  /// to record that it was empty so when writting out
  /// the version we leave it as blank to ensure the fidelity
  /// of the original document is maintained.
  VersionBuilder.empty()
      : missing = false,
        key = 'version',
        _version = sm.Version.none;

  late final bool missing;
  final String key;
  late final sm.Version _version;
  late final List<String> _comments;

  List<String> get comments => _comments;

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
      other is VersionBuilder &&
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

  static sm.Version parseVersion(String? version) {
    try {
      if (version == null) {
        return sm.Version.none;
      }
      return sm.Version.parse(version);
    } on FormatException catch (e) {
      throw VersionException(e.message);
    }
  }

  Version _attach(PubSpec pubspec, Line lineBefore) {
    final attached = Version._attach(pubspec, lineBefore, this);

    return attached;
  }

  Version _append(PubSpec pubspec) {
    final attached = Version._append(pubspec, this);

    return attached;
  }
}
