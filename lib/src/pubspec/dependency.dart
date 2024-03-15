part of 'internal_parts.dart';

/// Base class for each of the [Dependency] types.
/// This is an abstract class that should be used directly
abstract class Dependency {
  /// Loads a dependency located at [line].
  factory Dependency._loadFrom(Dependencies dependencies, LineImpl line) {
    final children = line.childrenOf(type: LineType.key);

    if (children.isEmpty) {
      // pub hosted is the default and the only type
      // that has no children
      return DependencyPubHosted._fromLine(dependencies, line);
    }

    /// So not a pub hosted dep, we use the main key
    /// from each of the dependency types to discover
    /// which type of dependeny we have.
    final depTypeLine = line.findOneOf([
      DependencyAltHosted.key,
      DependencyPath.key,
      DependencyGit.key,
      DependencySdk.key
    ]);

    // none of the children had one of the expected keys.
    if (depTypeLine == null) {
      // there may have been multiple unexpcted children but we just
      // report the first one.
      throw PubSpecException(
          line, 'Unexpected child key found ${children.first.key}');
    }

    /// We know the type of dependency so lets load the details.
    switch (depTypeLine.key) {
      case DependencyAltHosted.key:
        return DependencyAltHosted._fromLine(dependencies, line);
      case DependencyPath.key:
        return DependencyPath._fromLine(dependencies, line);
      case DependencyGit.key:
        return DependencyGit._fromLine(dependencies, line);
      case DependencySdk.key:
        return DependencySdk._fromLine(dependencies, line);
    }

    throw PubSpecException(
        depTypeLine, 'The child dependency does not appear to be valid.');
  }

  /// The name of the dependency package
  String get name;

  @visibleForTesting
  Section get section;

  Dependency append(DependencyBuilder dependency);
}

/// Some dependency define a package version number
/// Dependencies that do so must implent this interface.
abstract class DependencyVersioned {
  set version(String version);
  String get version;
}
