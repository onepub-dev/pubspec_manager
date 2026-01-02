part of 'internal_parts.dart';

/// represents a dependency that has a 'path' key
/// A path dependency is located on the local file
/// system. The path is a relative or absolute path
/// to the dependant package.
/// A path dependency takes the form of:
/// dependencies:
///   dcli:
///     path: ../dcli
@immutable
class DependencyBuilderSdk implements DependencyBuilder {
  @override
  final String name;

  final String path;

  final List<String> _comments;

  DependencyBuilderSdk({
    required this.name,
    required this.path,
    List<String>? comments,
  }) : _comments = comments ?? <String>[];

  List<String> get comments => _comments;

  @override
  Dependency _attach(
          Dependencies dependencies, PubSpec pubspec, Line lineBefore) =>
      DependencySdk._insertAfter(dependencies, pubspec, lineBefore, this);
}
