part of 'internal_parts.dart';

/// Used to hold a list of [Dependency]s from
/// a single dependency section in the pubspec.yaml
/// e.g. the list of deps for the 'dependencies' key in pubspec.yaml
class Dependencies extends Section with IterableMixin<DependencyAttached> {
  Dependencies._missing(this._pubspec, this.name)
      : document = _pubspec.document,
        super.missing();

  Dependencies._fromLine(this._pubspec, this.line) {
    document = _pubspec.document;
    missing = false;
    name = line.key;
    comments = CommentsAttached(this);
  }

  @override
  late final Document document;

  @override
  late final Line line;

  /// The name of the dependency section such as
  /// dev_dpendencies
  late final String name;

  /// reference to the pubspec that has these dependencies.
  final Pubspec _pubspec;

  final List<DependencyAttached> _dependencies = <DependencyAttached>[];

  /// List of the dependencies
  List<DependencyAttached> get list => List.unmodifiable(_dependencies);

  /// the number of dependencies in this section
  @override
  int get length => _dependencies.length;

  @override
  List<Line> get lines {
    final lines = <Line>[];
    if (missing) {
      return lines;
    }
    for (final dependency in _dependencies) {
      lines.addAll(dependency.lines);
    }
    return lines;
  }

  /// returns the [Dependency] with the given [name]
  /// if it exists in this section.
  /// Returns null if it doesn't exist.
  DependencyAttached? operator [](String name) {
    for (final dependency in _dependencies) {
      if (dependency.name == name) {
        return dependency;
      }
    }
    return null;
  }

  /// Add [dependency] to the PubSpec
  /// after the last dependency.
  DependencyAttached append(Dependency dependency) {
    var insertAt = 0;
    // if we don't have a dependencies section then create it.
    if (missing) {
      missing = false;
      line = document.append(LineDetached('$name:'));
    }

    if (_dependencies.isEmpty) {
      insertAt = line.lineNo + 1;
    } else {
      insertAt = _dependencies.last.lastLineNo + 1;
    }
    final attached = dependency._attach(this, _pubspec, insertAt);

    _dependencies.add(attached);

    return attached;
  }

  /// register a dependency that is already attached.
  DependencyAttached _appendAttached(DependencyAttached dependency) {
    _dependencies.add(dependency);
    return dependency;
  }

  /// Remove a dependency from the section
  /// Throws a [DependencyNotFound] exception if the
  /// dependency doesn't exist.
  void remove(String name) {
    final dependency = this[name];

    if (dependency == null) {
      throw DependencyNotFound(
          _pubspec.document, '$name not found in the ${this.name} section');
    }

    _dependencies.remove(dependency);
    final lines = dependency.lines;
    _pubspec.document.removeAll(lines);
  }

  /// returns true if the list of dependencies contains a dependency
  /// with the given name.
  bool exists(String name) => this[name] != null;

  @override
  late final CommentsAttached comments;

  /// The last line number used by this  section
  @override
  int get lastLineNo => lines.last.lineNo;

  @override
  Iterator<DependencyAttached> get iterator =>
      DependencyIterator(_dependencies);
}

class DependencyIterator implements Iterator<DependencyAttached> {
  DependencyIterator(this._dependencies);

  int index = -1;

  final List<DependencyAttached> _dependencies;

  @override
  DependencyAttached get current => _dependencies.elementAt(0);

  @override
  bool moveNext() {
    if (index >= _dependencies.length) {
      return false;
    }
    index++;
    return true;
  }
}
