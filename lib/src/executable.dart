part of 'internal_parts.dart';

/// represents an executable
/// executable:
///   dcli: dcli_tool
class Executable {
  Executable(this.name, this.script);
  Executable.missing()
      : name = '',
        script = '';

  String name;
  String script;

  ExecutableAttached _attach(PubSpec pubspec, int lineNo) =>
      ExecutableAttached._attach(pubspec, lineNo, this);
}

/// An executable script that is attached to the [PubSpec].
class ExecutableAttached extends SectionSingleLine {
  /// re-hydrate an executable from a line.
  ExecutableAttached._fromLine(this._line)
      : _name = _line.key,
        _script = _line.value,
        super.fromLine(_line.key, _line);

  ExecutableAttached._attach(PubSpec pubspec, int lineNo, Executable executable)
      : _name = executable.name,
        _script = executable.script,
        super.attach(executable.name, pubspec, lineNo, executable.script) {
    _line = Line.forInsertion(pubspec.document, '  $_name: $_script');
    pubspec.document.insert(_line, lineNo);
  }

  String _name;
  String? _script;

  late final Line _line;

  String get name => _name;

  set name(String name) {
    _name = name;

    if (!_line.missing) {
      _line.key = _name;
    }
  }

  /// Set the name of the dart library located in the bin directory.
  ///
  /// Do NOT pass the .dart extension just the basename.
  set script(String script) {
    _script = script;
    _line.value = script;
  }

  String get script => _script ?? name;

  /// returns the project relative path to the script.
  ///
  /// e.g.
  /// executables:
  ///   dcli_install: main
  ///
  /// scriptPath => bin/main.dart
  ///
  String get scriptPath =>
      join('bin', '${Strings.orElseOnBlank(_script, name)}.dart');

  @override
  Line get line => _line;

  @override
  Document get document => line.document;

  @override
  List<Line> get lines => [...comments.lines, _line];

  /// The last line number used by this  section
  @override
  int get lastLineNo => lines.last.lineNo;
}
