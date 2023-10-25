part of 'internal_parts.dart';

/// represents a dependency that has a 'path' key
/// A path dependency is located on the local file
/// system. The path is a relative or absolute path
/// to the dependant package.
/// A path dependency takes the form of:
/// dependencies:
///   dcli:
///     path: ../dcli
class PathDependency extends Section implements Dependency {
  PathDependency._fromLine(this._dependencies, this._line) {
    _name = _line.key;
    _pathLine = line.findRequiredKeyChild('path');
    path = _pathLine.value;
    comments = Comments(this);
  }

  PathDependency._attach(
      PubSpec pubspec, Line lineBefore, PathDependencyBuilder dependency) {
    _name = dependency.name;
    path = dependency.path;

    _line = Line.forInsertion(pubspec.document, '  $_name:');
    pubspec.document.insertAfter(_line, lineBefore);

    _pathLine =
        Line.forInsertion(pubspec.document, '${_line.childIndent}path: $path');
    pubspec.document.insertAfter(_pathLine, _line);

    comments = Comments(this);

    // ignore: prefer_foreach
    for (final comment in dependency.comments) {
      comments.append(comment);
    }
  }
  static const key = 'path';

  late final String _name;
  late final String path;

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
  late final Comments comments;

  @override
  int get lineNo => _line.lineNo;

  /// The last line number used by this  section
  @override
  int get lastLineNo => lines.last.lineNo;

  /// Allows cascading calls to append
  @override
  Dependency append(DependencyBuilder dependency) {
    _dependencies.append(dependency);
    return this;
  }

  @override
  String toString() => lines.join('\n');
}
