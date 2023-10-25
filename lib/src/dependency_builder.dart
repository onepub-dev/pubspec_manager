part of 'internal_parts.dart';

/// Base class for each of the [DependencyBuilder] types.
abstract class DependencyBuilder {
  /// the name of the dependency package
  String get name;

  Dependency _attach(Dependencies dependencies, PubSpec pubspec, int lineNo);
}
