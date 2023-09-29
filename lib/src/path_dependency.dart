part of 'internal_parts.dart';

/// represents a dependency that has a 'path' key
/// A path dependency is located on the local file
/// system. The path is a relative or absolute path
/// to the dependant package.
/// A path dependency takes the form of:
/// dependencies:
///   dcli: ^2.3.1
class PathDependency implements Dependency {
  PathDependency(this._name, {Version? version})
      : _version = version ?? Version.empty();
  static const key = 'path';

  late final String _name;
  late final Version _version;

  @override
  String get name => _name;

  @override
  Version get version => _version;

  @override
  DependencyAttached _attach(Pubspec pubspec, int lineNo) =>
      PathDependencyAttached._attach(pubspec, lineNo, this);
}
