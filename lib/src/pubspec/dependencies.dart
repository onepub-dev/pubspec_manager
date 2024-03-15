part of 'internal_parts.dart';

/// Used to hold a list of [Dependency]'s from
/// a single dependency section in the pubspec.yaml
/// e.g. the list of deps for the 'dependencies' key in pubspec.yaml
class Dependencies with IterableMixin<Dependency> {
  Dependencies._missing(this._pubspec, this.name)
      : _section = SectionImpl.missing(_pubspec.document, name);

  Dependencies._fromLine(this._pubspec, LineImpl line) {
    name = line.key;
    _section = SectionImpl.fromLine(line);
  }

  /// The [Document] [Section] that holds the dependencies
  late SectionImpl _section;

  /// The name of the dependency section such as
  /// dev_dpendencies
  late final String name;

  /// reference to the pubspec that has these dependencies.
  final PubSpec _pubspec;

  final List<Dependency> _dependencies = <Dependency>[];

  /// List of the dependencies
  List<Dependency> get list => List.unmodifiable(_dependencies);

  /// the number of dependencies in this section
  @override
  int get length => _dependencies.length;

  // @override
  // List<Line> get lines {
  //   final lines = <Line>[];
  //   if (missing) {
  //     return lines;
  //   }
  //   for (final dependency in _dependencies) {
  //     lines.addAll(dependency.lines);
  //   }
  //   return lines;
  // }

  /// returns the [DependencyBuilder] with the given [name]
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
  Dependency append(DependencyBuilder dependency) {
    // if we don't have a dependencies section then create it.
    if (_section.missing) {
      _section = SectionImpl.fromLine(
          _section.document.append(LineDetached('$name:')));
    }

    Line lineBefore = _section.headerLine;
    if (_dependencies.isNotEmpty) {
      lineBefore = _dependencies.last.section.lines.last;
    }
    final attached = dependency._attach(this, _pubspec, lineBefore);

    _dependencies.add(attached);

    return attached;
  }

  /// register a dependency that is already attached.
  Dependency _appendAttached(Dependency dependency) {
    _dependencies.add(dependency);
    return dependency;
  }

  /// Remove all dependencies from the section
  void removeAll() {
    _dependencies.removeWhere((value) => true);
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
    final lines = dependency.section.lines;
    for (final line in lines) {
      _section._removeChild(line);
    }
  }

  /// returns true if the list of dependencies contains a dependency
  /// with the given name.
  bool exists(String name) => this[name] != null;

  Comments get comments => _section.comments;

  @override
  Iterator<Dependency> get iterator => IteratorImpl(_dependencies);
}
