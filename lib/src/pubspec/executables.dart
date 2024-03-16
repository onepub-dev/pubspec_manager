part of 'internal_parts.dart';

/// Used to hold a list of [Executable]s from
/// To add additinal executables use:
///
/// ```dart
/// final pubspec = PubSpecl.load();
/// pubspec.executables.append(ExecutableBuilder(name: 'test'));
/// pubspec.save();
/// ```
class Executables extends SectionImpl
    with IterableMixin<Executable>
    implements Section {
  Executables._missing(PubSpec pubspec)
      : _pubspec = pubspec,
        super.missing(pubspec.document, keyName);

  Executables._fromLine(PubSpec pubspec, super.headerLine)
      : _pubspec = pubspec,
        super.fromLine();

  final PubSpec _pubspec;

  final List<Executable> _executables = <Executable>[];

  /// List of the dependencies
  List<Executable> get list => List.unmodifiable(_executables);

  /// the number of dependencies in this section
  @override
  int get length => _executables.length;

  // @override
  // List<Line> get lines {
  //   final lines = <Line>[];
  //   if (missing) {
  //     return lines;
  //   }
  //   for (final executable in _executables) {
  //     lines.addAll(executable.lines);
  //   }
  //   return lines;
  // }

  /// returns the [ExecutableBuilder] with the given [name]
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

  /// Add an executable to the PubSpec
  /// after the last executable or at the end of the file.
  Executables append({required String name, String? script}) {
    _ensure();
    final executable = ExecutableBuilder(name: name, script: script);
    var lineBefore = headerLine;

    if (missing) {
      // create the section.
      lineBefore = _document.append(LineDetached('$key:'));
    } else {
      if (_executables.isNotEmpty) {
        lineBefore = _executables.last.headerLine;
      }
    }
    final attached = executable._attach(_pubspec, lineBefore);

    _executables.add(attached);

    // ignore: avoid_returning_this
    return this;
  }

  /// Ensure that the executable section has been created
  /// by creating it if it doesn't exist.
  void _ensure() {
    if (missing) {
      headerLine = _document.append(LineDetached('$key:'));
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

    _executables.remove(executable);
    final lines = executable.lines;
    _pubspec.document.removeAll(lines);
  }

  /// returns true if the list of dependencies contains a dependency
  /// with the given name.
  bool exists(String name) => this[name] != null;

  @override
  Iterator<Executable> get iterator => IteratorImpl(_executables);

  static const String keyName = 'executables';
}
