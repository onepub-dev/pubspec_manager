part of 'internal_parts.dart';

/// Used to hold a list of [Dependency]s from
/// a single dependency section in the pubspec.yaml
/// e.g. the list of deps for the 'dependencies' key in pubspec.yaml
class Executables extends Section with IterableMixin<ExecutableAttached> {
  Executables._missing(this._pubspec) : super.missing();

  Executables._fromLine(this._pubspec, this.line) {
    missing = false;
    name = line.key;
    comments = CommentsAttached(this);
  }

  static const String key = 'executables';

  @override
  late final Line line;

  /// The name of the dependency section such as
  /// dev_dpendencies
  late final String name;

  /// reference to the pubspec that has these dependencies.
  final PubSpec _pubspec;

  final List<ExecutableAttached> _executables = <ExecutableAttached>[];

  /// List of the dependencies
  List<ExecutableAttached> get list => List.unmodifiable(_executables);

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

  /// returns the [Executable] with the given [name]
  /// if it exists in this section.
  /// Returns null if it doesn't exist.
  ExecutableAttached? operator [](String name) {
    for (final executable in _executables) {
      if (executable.name == name) {
        return executable;
      }
    }
    return null;
  }

  /// Add [executable] to the PubSpec
  /// after the last dependency.
  Executables append(Executable executable) {
    var insertAt = 0;
    if (missing) {
      missing = false;
      // create the section.
      line = document.append(LineDetached(name));
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

  void _appendAttached(ExecutableAttached attached) {
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
  late final CommentsAttached comments;

  @override
  Document get document => line.document;

  /// The last line number used by this  section
  @override
  int get lastLineNo => lines.last.lineNo;

  @override
  Iterator<ExecutableAttached> get iterator => ExecutableIterator(_executables);
}

class ExecutableIterator implements Iterator<ExecutableAttached> {
  ExecutableIterator(this._executables);

  int index = -1;

  final List<ExecutableAttached> _executables;

  @override
  ExecutableAttached get current => _executables.elementAt(0);

  @override
  bool moveNext() {
    if (index >= _executables.length) {
      return false;
    }
    index++;
    return true;
  }
}
