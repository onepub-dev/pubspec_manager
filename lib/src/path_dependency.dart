part of 'internal_parts.dart';

/// represents a dependency that has a 'path' key
/// A path dependency is located on the local file
/// system. The path is a relative or absolute path
/// to the dependant package.
/// A path dependency takes the form of:
/// dependencies:
///   dcli:
///     path: ../dcli
class PathDependency implements Dependency {
  PathDependency(
      {required String name,
      required String path,
      List<String> comments = const <String>[]})
      : _name = name,
        _path = path {
    this.comments = Comments(comments);
  }

  static const key = 'path';

  late final String _name;
  late final String _path;

  @override
  String get name => _name;

  late final Comments comments;

  @override
  DependencyAttached _attach(
          Dependencies dependencies, Pubspec pubspec, int lineNo) =>
      PathDependencyAttached._attach(pubspec, lineNo, this);
}
