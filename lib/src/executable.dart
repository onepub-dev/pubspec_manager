part of 'internal_parts.dart';

/// An executable script that is attached to the [PubSpec].
class Executable extends SectionSingleLine {
  /// re-hydrate an executable from a line.
  Executable._fromLine(this._line)
      : _name = _line.key,
        _script = _line.value,
        super.fromLine(_line);

  Executable._attach(PubSpec pubspec, int lineNo, ExecutableBuilder executable)
      : _name = executable.name,
        _script = executable.script,
        _line = Line.forInsertion(pubspec.document, _buildLine(executable)),
        super.attach(pubspec, lineNo, executable.name, executable.script);

  String _name;
  String _script;

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

  String get script => Strings.orElseOnBlank(_script, name);

  /// returns the project relative path to the script.
  ///
  /// e.g.
  /// executables:
  ///   dcli_install: main
  ///
  /// scriptPath => bin/main.dart
  ///
  String get scriptPath => join('bin', '$script.dart');

  @override
  Line get line => _line;

  @override
  Document get document => line.document;

  @override
  List<Line> get lines => [...comments.lines, _line];

  /// The last line number used by this  section
  @override
  int get lastLineNo => lines.last.lineNo;

  static String _buildLine(ExecutableBuilder executable) {
    final prefix = '  ${executable.name}:';

    final script = executable.script;
    if (Strings.isNotBlank(script)) {
      return '$prefix $script';
    } else {
      return prefix;
    }
  }
}
