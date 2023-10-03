part of 'internal_parts.dart';

/// represents a dependency that has a 'path' key
/// A path dependency is located on the local file
/// system. The path is a relative or absolute path
/// to the dependant package.
/// A path dependency takes the form of:
/// dependencies:
///   dcli:
///     path: ../dcli
class Executable extends Section {
  Executable({required String name, String? scriptPath})
      : _name = name,
        _scriptPath = scriptPath;

  Executable._fromLine(this._line) {
    _name = _line.key;
    _scriptPath = _line.value;
    comments = CommentsAttached(this);
  }
  static const key = 'path';

  late final Line _line;

  late final String _name;
  late final String? _scriptPath;

  String get name => _name;

  set name(String name) {
    _name = name;

    if (!_line.missing) {
      _line.key = _name;
    }
  }

  /// returns the project relative path to the script.
  ///
  /// e.g.
  /// executables:
  ///   dcli_install: dcli_install
  ///
  /// scriptPath => bin/dcli_install.dart
  ///
  String get scriptPath => join('bin', '${_scriptPath ?? name}.dart');

  @override
  Line get line => _line;

  late final Line _pathLine;

  @override
  Document get document => line.document;

  @override
  List<Line> get lines => [...comments.lines, _line, _pathLine];

  @override
  late final CommentsAttached comments;

  void _attach(Pubspec pubspec, int lineNo) {
    final script = _scriptPath ?? '';
    _line = Line.forInsertion(pubspec.document, '  $_name: $script');
    pubspec.document.insert(_line, lineNo);
  }

  /// The last line number used by this  section
  @override
  int get lastLineNo => lines.last.lineNo;
}
