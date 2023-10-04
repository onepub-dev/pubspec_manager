part of 'internal_parts.dart';

/// represents a dependency that has a 'path' key
/// A path dependency is located on the local file
/// system. The path is a relative or absolute path
/// to the dependant package.
/// A path dependency takes the form of:
/// dependencies:
///   dcli:
///     path: ../dcli
class PathDependencyAttached extends Section implements DependencyAttached {
  PathDependencyAttached._fromLine(this._dependencies, this._line) {
    _name = _line.key;
    _pathLine = line.findRequiredKeyChild('path');
    _path = _pathLine.value;
    comments = CommentsAttached(this);
  }

  PathDependencyAttached._attach(
      Pubspec pubspec, int lineNo, PathDependency dependency) {
    _name = dependency.name;
    _path = dependency.path;

    _line = Line.forInsertion(pubspec.document, '  $_name:');
    pubspec.document.insert(_line, lineNo);

    _line = Line.forInsertion(pubspec.document, '  path: $_path');
    pubspec.document.insert(_line, lineNo);

    comments = CommentsAttached(this);

    // ignore: prefer_foreach
    for (final comment in dependency.comments) {
      comments.append(comment);
    }
  }
  static const key = 'path';

  late final String _name;
  late final String _path;

  /// The parent dependency key
  late final Dependencies _dependencies;

  /// Line that contained the dependency declaration
  late final Line _line;
  late final Line _pathLine;

  @override
  String get name => _name;

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

  /// Allows cascading calls to append
  @override
  DependencyAttached append(Dependency dependency) {
    _dependencies.append(dependency);
    return this;
  }
}
