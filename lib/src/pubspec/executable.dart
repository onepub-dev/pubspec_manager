part of 'internal_parts.dart';

/// A package executable that will be added to the user's PATh
/// when the globally activate the package.
class Executable implements Section {
  final SectionSingleLine _section;

  String _name;

  String _script;

  late final LineImpl _line;

  /// re-hydrate an executable from a line.
  Executable._fromLine(this._line)
      : _name = _line.key,
        _script = _line.value,
        _section = SectionSingleLine.fromLine(_line);

  Executable._attach(
      PubSpec pubspec, Line lineBefore, ExecutableBuilder executable)
      : _name = executable.name,
        _script = executable.script,
        _line = LineImpl.forInsertion(pubspec.document, _buildLine(executable)),
        _section = SectionSingleLine.attach(
            pubspec, lineBefore, 1, executable.name, executable.script);

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
  List<Line> get lines => [...comments._lines, _line];

  static String _buildLine(ExecutableBuilder executable) {
    final prefix = '  ${executable.name}:';

    final script = executable.script;
    if (Strings.isNotBlank(script)) {
      return '$prefix $script';
    } else {
      return prefix;
    }
  }

  @override
  Comments get comments => _section.comments;

  @override
  bool get missing => _section.missing;
}
