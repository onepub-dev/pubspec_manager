part of 'internal_parts.dart';

/// Base class for each of the [Dependency] types.
abstract class DependencyAttached extends Section {
  /// Loads a dependency located at [line].
  factory DependencyAttached._loadFrom(Dependencies dependencies, Line line) {
    final children = line.childrenOf(type: LineType.key);

    if (children.isEmpty) {
      // pub hosted is the default and the only type
      // that has no children
      return PubHostedDependencyAttached._fromLine(dependencies, line);
    }

    /// So not a pub hosted dep, we use the main key
    /// from each of the dependency types to discover
    /// which type of dependeny we have.
    final depTypeLine = line.findOneOf([
      HostedDependencyAttached.key,
      PathDependencyAttached.key,
      GitDependencyAttached.key
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
      case HostedDependencyAttached.key:
        return HostedDependencyAttached._fromLine(dependencies, line);
      case PathDependencyAttached.key:
        return PathDependencyAttached._fromLine(dependencies, line);
      case GitDependencyAttached.key:
        return GitDependencyAttached._fromLine(dependencies, line);
    }

    throw PubSpecException(
        depTypeLine, 'The child dependency does not appear to be valid.');
  }

  /// the name of the dependency package
  String get name;

  /// The line the dependeny starts on - ignoring leading comments
  int get lineNo;

  DependencyAttached append(Dependency pubHostedDependency);
}

/// Some dependency define a package version number
/// Dependencies that do so must implent this interface.
abstract class DependencyVersioned {
  set version(String version);
  String get version;
}