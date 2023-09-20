part of 'internal_parts.dart';

/// Used to hold a list of [Dependency]s from
/// a single dependency section in the pubspec.yaml
/// e.g. the list of deps for the 'dependencies' key in pubspec.yaml
class Dependencies extends Section {
  /// Create a new dependencies section
  Dependencies._(this._pubspec, this.name) {
    missing = false;
    _pubspec.document.append(LineDetached('$name:'));
    comments = Comments.empty(this);
  }

  Dependencies._missing(this._pubspec, this.name) : super.missing();

  Dependencies._fromLine(this._pubspec, this.line) {
    missing = false;
    name = line.key;
    comments = Comments(this);
  }

  @override
  late final Line line;

  /// The name of the dependency section such as
  /// dev_dpendencies
  late final String name;

  /// reference to the pubspec that has these dependencies.
  final Pubspec _pubspec;

  final List<Dependency> _dependencies = <Dependency>[];

  /// List of the dependencies
  List<Dependency> get list => List.unmodifiable(_dependencies);

  /// the number of dependencies in this section
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
  Dependency? operator [](String name) {
    for (final dependency in _dependencies) {
      if (dependency.name == name) {
        return dependency;
      }
    }
    return null;
  }

  /// Add [dependency] to the PubSpec
  /// after the last dependency.
  void append(Dependency dependency, {bool attach = true}) {
    var insertAt = 0;
    if (missing) {
      missing = false;
      if (attach) {
        // create the section.
        line = document.append(LineDetached(name));
      }
    } else {
      if (_dependencies.isEmpty) {
        insertAt = line.lineNo + 1;
      } else {
        insertAt = _dependencies.last.lastLineNo + 1;
      }
    }

    _dependencies.add(dependency);

    if (attach) {
      dependency._attach(_pubspec, insertAt);
    }
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
  bool contains(String name) => this[name] != null;

  @override
  late final Comments comments;

  @override
  Document get document => line.document;

  /// The last line number used by this  section
  @override
  int get lastLineNo => lines.last.lineNo;
}

/// Thrown when you try to access a dependency by name
/// and that dependency doesn't exist.
class DependencyNotFound extends PubSpecException {
  DependencyNotFound(Document super.document, super.message)
      : super.forDocument();
}
