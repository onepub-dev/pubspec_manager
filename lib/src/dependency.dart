part of 'internal_parts.dart';

/// Base class for each of the [Dependency] types.
abstract class Dependency {
  /// the name of the dependency package
  String get name;

  DependencyAttached _attach(
      Dependencies dependencies, PubSpec pubspec, int lineNo);
}
