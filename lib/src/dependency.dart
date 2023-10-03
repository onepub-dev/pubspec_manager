part of 'internal_parts.dart';

/// Base class for each of the [Dependency] types.
abstract class Dependency {
  /// the name of the dependency package
  String get name;

  // /// Update the version of the dependency.
  // /// If the dependency does't support a version
  // /// then this call is ignored.
  // // ignore: avoid_setters_without_getters
  // set version(String version);

  /// Returns the version constraint for the dependencies
  /// For dependencies that don't have a version constraint such as
  ///  [GitDependency] or [PathDependency] then [sm.VersionConstraint.any]
  ///  will be returned.
  /// For dependencies that do allow a version or if the version is empty
  /// the [sm.VersionConstraint.any] will be returned.
  // String get version;

  DependencyAttached _attach(
      Dependencies dependencies, Pubspec pubspec, int lineNo);
}
