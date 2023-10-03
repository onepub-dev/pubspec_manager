part of 'internal_parts.dart';

/// Base class for each of the [Dependency] types.
abstract class Dependency extends Section {
  /// Loads a dependency located at [line].
  factory Dependency._loadFrom(Line line) {
    final children = line.childrenOf(type: LineType.key);

    if (children.isEmpty) {
      // pub hosted is the default and the only type
      // that has no children
      return PubHostedDependency._fromLine(line);
    }

    /// So not a pub hosted dep, we use the main key
    /// from each of the dependency types to discover
    /// which type of dependeny we have.
    final depTypeLine = line.findOneOf(
        [HostedDependency.key, PathDependency.key, GitDependency.key]);

    // none of the children had one of the expected keys.
    if (depTypeLine == null) {
      // there may have been multiple unexpcted children but we just
      // report the first one.
      throw PubSpecException(
          line, 'Unexpected child key found ${children.first.key}');
    }

    /// We know the type of dependency so lets load the details.
    switch (depTypeLine.key) {
      case HostedDependency.key:
        return HostedDependency._fromLine(line);
      case PathDependency.key:
        return PathDependency._fromLine(line);
      case GitDependency.key:
        return GitDependency._fromLine(line);
    }

    throw PubSpecException(
        depTypeLine, 'The child dependency does not appear to be valid.');
  }

  /// the name of the dependency package
  String get name;

  /// The line the dependeny starts on - ignoring leading comments
  int get lineNo;

  /// Update the version of the dependency.
  /// If the dependency does't support a version
  /// then this call is ignored.
  // ignore: avoid_setters_without_getters
  set version(String version);

  /// Returns the version constraint for the dependencies
  /// For dependencies that don't have a version constraint such as
  ///  [GitDependency] or [PathDependency] then [sm.VersionConstraint.any]
  ///  will be returned.
  /// For dependencies that do allow a version or if the version is empty
  /// the [sm.VersionConstraint.any] will be returned.
  sm.VersionConstraint get versionConstraint;

  void _attach(Pubspec pubspec, int lineNo);
}
