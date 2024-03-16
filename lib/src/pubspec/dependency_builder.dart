part of 'internal_parts.dart';

/// Base class for each of the [DependencyBuilder] types.
/// Don't use this class directly.
abstract class DependencyBuilder {
  /// the name of the dependency package
  String get name;

  Dependency _attach(
      Dependencies dependencies, PubSpec pubspec, Line lineBefore);
}
