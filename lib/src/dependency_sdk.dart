part of 'internal_parts.dart';

/// represents a dependency that has a 'path' key
/// A path dependency is located on the local file
/// system. The path is a relative or absolute path
/// to the dependant package.
/// A path dependency takes the form of:
/// dependencies:
///   dcli:
///     path: ../dcli
class DependencySdk implements Dependency {
  /// Creates Path dependency from an existing [Line] in
  /// the document.
  DependencySdk._fromLine(this._dependencies, this._line)
      : section = SectionImpl.fromLine(_line) {
    _name = _line.key;
    _pathLine = _line.findRequiredKeyChild(key);
    path = _pathLine.value;
  }

  /// Creates an Sdk Dependency inserting it into the document after
  /// [lineBefore]
  DependencySdk._insertAfter(
      PubSpec pubspec, Line lineBefore, DependencySdkBuilder dependency) {
    _name = dependency.name;
    path = dependency.path;

    _line = LineImpl.forInsertion(pubspec.document, '  $_name:');
    pubspec.document.insertAfter(_line, lineBefore);

    _pathLine = LineImpl.forInsertion(
        pubspec.document, '${_line.childIndent}$key: $path');
    pubspec.document.insertAfter(_pathLine, _line);

    section = SectionImpl.fromLine(_line);

    // // ignore: prefer_foreach
    // for (final comment in dependency.comments) {
    //   comments.append(comment);
    // }
  }
  static const key = 'sdk';

  @override
  late final Section section;
  late final String _name;
  late final String path;

  /// The parent dependency key
  late final Dependencies _dependencies;

  /// Line that contained the dependency declaration
  late final LineImpl _line;
  late final LineImpl _pathLine;

  @override
  String get name => _name;

  /// Allows cascading calls to append
  @override
  Dependency append(DependencyBuilder dependency) {
    _dependencies.append(dependency);
    return this;
  }

  @override
  String toString() => section.lines.join('\n');
}
