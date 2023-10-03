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
    final path = line.findRequiredKeyChild('path');
    dependency = PathDependency(name: name, path: path.value);
    comments = CommentsAttached(this);
  }

  PathDependencyAttached._attach(
      Pubspec pubspec, int lineNo, PathDependency dependency) {
    _line = Line.forInsertion(pubspec.document, '  ${dependency._name}:');
    pubspec.document.insert(_line, lineNo);

    _line = Line.forInsertion(pubspec.document, '  path: ${dependency._path}');
    pubspec.document.insert(_line, lineNo);

    comments = CommentsAttached(this);
  }

  late final Dependencies _dependencies;
  late PathDependency dependency;

  /// Line that contained the dependency declaration
  late final Line _line;

  @override
  String get name => dependency.name;

  /// path dependencies don't have a version.
  @override
  Version get version => Version.missing();

  @override
  Line get line => _line;

  @override
  Document get document => line.document;

  @override
  List<Line> get lines => [...comments.lines, _line];

  @override
  late final CommentsAttached comments;

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
