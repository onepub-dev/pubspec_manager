part of 'internal_parts.dart';

/// represents a dependency that has a 'path' key
/// A path dependency is located on the local file
/// system. The path is a relative or absolute path
/// to the dependant package.
/// A path dependency takes the form of:
/// dependencies:
///   dcli: ^2.3.1
class PathDependencyAttached extends Section implements DependencyAttached {
  PathDependencyAttached._fromLine(this._dependencies, this._line) {
    final name = _line.key;
    final version = Version(_line.value);
    dependency = PathDependency(name, version: version);
    comments = Comments(this);
  }

  PathDependencyAttached._attach(
      Pubspec pubspec, int lineNo, PathDependency dependency) {
    _line = Line.forInsertion(
        pubspec.document, '  ${dependency._name}: ${dependency._version}');
    pubspec.document.insert(_line, lineNo);
    comments = Comments(this);
  }

  late final Dependencies _dependencies;
  late PathDependency dependency;

  /// Line that contained the dependency declaration
  late final Line _line;

  @override
  String get name => dependency.name;

  @override
  Version get version => dependency.version;

  @override
  Line get line => _line;

  @override
  Document get document => line.document;

  @override
  List<Line> get lines => [...comments.lines, _line];

  @override
  late final Comments comments;

  @override
  int get lineNo => _line.lineNo;

  /// The last line number used by this  section
  @override
  int get lastLineNo => lines.last.lineNo;

  @override
  DependencyAttached append(Dependency dependency) {
    _dependencies.append(dependency);
    return this;
  }
}
