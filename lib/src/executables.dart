part of 'internal_parts.dart';

/// Used to hold a list of [DependencyBuilder]s from
/// a single dependency section in the pubspec.yaml
/// e.g. the list of deps for the 'dependencies' key in pubspec.yaml
class Executables extends Section with IterableMixin<Executable> {
  Executables._missing(this._pubspec) : super.missing();

  Executables._fromLine(this._pubspec, this.line) {
    missing = false;
    name = line.key;
    comments = Comments(this);
  }

  static const String key = 'executables';

  @override
  late final Line line;

  /// The name of the dependency section such as
  /// dev_dpendencies
  late final String name;

  /// reference to the pubspec that has these dependencies.
  final PubSpec _pubspec;

  final List<Executable> _executables = <Executable>[];

  /// List of the dependencies
  List<Executable> get list => List.unmodifiable(_executables);

  /// the number of dependencies in this section
  @override
  int get length => _executables.length;

  @override
  List<Line> get lines {
    final lines = <Line>[];
    if (missing) {
      return lines;
    }
    for (final executable in _executables) {
      lines.addAll(executable.lines);
    }
    return lines;
  }

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

  /// Add [executable] to the PubSpec
  /// after the last dependency.
  Executables append(ExecutableBuilder executable) {
    var insertAt = 0;
    if (missing) {
      missing = false;
      // create the section.
      line = document.append(LineDetached(key));
    } else {
      if (_executables.isEmpty) {
        insertAt = line.lineNo + 1;
      } else {
        insertAt = _executables.last.lastLineNo + 1;
      }
    }
    final attached = executable._attach(_pubspec, insertAt);

    _executables.add(attached);

    // ignore: avoid_returning_this
    return this;
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
          _pubspec.document, '$name not found in the ${this.name} section');
    }

    _executables.remove(executable);
    final lines = executable.lines;
    _pubspec.document.removeAll(lines);
  }

  /// returns true if the list of dependencies contains a dependency
  /// with the given name.
  bool exists(String name) => this[name] != null;

  @override
  late final Comments comments;

  @override
  Document get document => line.document;

  /// The last line number used by this  section
  @override
  int get lastLineNo => lines.last.lineNo;

  @override
  Iterator<Executable> get iterator => ExecutableIterator(_executables);
}

class ExecutableIterator implements Iterator<Executable> {
  ExecutableIterator(this._executables);

  int index = -1;

  final List<Executable> _executables;

  @override
  Executable get current => _executables.elementAt(0);

  @override
  bool moveNext() {
    if (index >= _executables.length) {
      return false;
    }
    index++;
    return true;
  }
}
