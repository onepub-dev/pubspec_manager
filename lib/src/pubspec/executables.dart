part of 'internal_parts.dart';

/// Used to hold the list of [Executable]s under 'executables' key.
/// To add additinal executables use:
///
/// ```dart
/// final pubspec = PubSpecl.load();
/// pubspec.executables.add(name: 'test');
/// pubspec.save();
/// ```
class Executables implements Section {
  final PubSpec _pubspec;

  final SectionImpl _section;

  final _executables = <Executable>[];

  static const keyName = 'executables';

  Executables._missing(PubSpec pubspec)
      : _pubspec = pubspec,
        _section = SectionImpl.missing(pubspec.document, keyName);

  Executables._fromLine(PubSpec pubspec, LineImpl headerLine)
      : _pubspec = pubspec,
        _section = SectionImpl.fromLine(headerLine);

  /// List of the executables
  List<Executable> get list => List.unmodifiable(_executables);

  /// the number of executables in this section
  int get length => _executables.length;

  /// returns the [Executable] with the given [name]
  /// if it exists in this section.
  /// Returns null if it doesn't exist.
  Executable? operator [](String name) {
    for (final executable in _executables) {
      if (executable.name == name) {
        return executable;
      }
    }
    return null;
  }

  /// Add an executable to the PubSpec.
  ///
  Executables add({required String name, String? script}) {
    _ensure();
    final executable = ExecutableBuilder(name: name, script: script);
    var lineBefore = _section.headerLine;

    if (missing) {
      // create the section.
      lineBefore = _section.document.append(LineDetached('$keyName:'));
    } else {
      if (_executables.isNotEmpty) {
        lineBefore = _executables.last._section.headerLine;
      }
    }
    final attached = executable._attach(_pubspec, lineBefore);

    _executables.add(attached);

    return this;
  }

  /// Ensure that the executable section has been created
  /// by creating it if it doesn't exist.
  void _ensure() {
    if (missing) {
      _section.headerLine = _section.document.append(LineDetached('$keyName:'));
    }
  }

  void _appendAttached(Executable attached) {
    _executables.add(attached);
  }

  /// Remove an executable from the list of executables
  /// Throws a [ExecutableNotFound] exception if the
  /// executable doesn't exist.
  void remove(String name) {
    final executable = this[name];

    if (executable == null) {
      throw ExecutableNotFound(
          _pubspec.document, '$name not found in the $name section');
    }

    _remove(executable);
  }

  void _remove(Executable executable) {
    _executables.remove(executable);
    final lines = executable.lines;
    _pubspec.document.removeAll(lines);
  }

  /// Remove all executables from the list.
  void removeAll() {
    for (final executable in list.reversed) {
      _remove(executable);
    }
  }

  /// returns true if the list of executables contains an executable
  /// with the given name.
  bool exists(String name) => this[name] != null;

  @override
  Comments get comments => _section.comments;

  @override
  List<Line> get lines => _section.lines;

  @override
  bool get missing => _section.missing;
}
