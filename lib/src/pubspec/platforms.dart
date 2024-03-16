// ignore_for_file: avoid_returning_this

part of 'internal_parts.dart';

enum PlatformEnum {
  android,
  ios,
  linux,
  macos,
  web,
  windows,
}

/// Used to hold a list of [DependencyBuilder]s from
/// a single dependency section in the pubspec.yaml
/// e.g. the list of deps for the 'dependencies' key in pubspec.yaml
class Platforms with IterableMixin<PlatformSupport> {
  Platforms._missing(this._pubspec)
      : _section = SectionImpl.missing(_pubspec.document, key);

  Platforms._fromLine(this._pubspec, LineImpl line)
      : _section = SectionImpl.fromLine(line) {
    name = line.key;
  }

  static const String key = 'platforms';

  SectionImpl _section;

  /// The name of the dependency section such as
  /// dev_dpendencies
  late final String name;

  /// reference to the pubspec that has these dependencies.
  final PubSpec _pubspec;

  final List<PlatformSupport> _platforms = <PlatformSupport>[];

  /// List of the dependencies
  List<PlatformSupport> get list => List.unmodifiable(_platforms);

  /// the number of dependencies in this section
  @override
  int get length => _platforms.length;

  // @override
  // List<Line> get lines {
  //   final lines = <Line>[];
  //   if (missing) {
  //     return lines;
  //   }
  //   for (final Platform in _Platforms) {
  //     lines.addAll(Platform.lines);
  //   }
  //   return lines;
  // }

  /// returns the [PlatformSupport] with the given [platformEnum]
  /// if it exists in this section.
  /// Returns null if it doesn't exist.
  PlatformSupport? operator [](PlatformEnum platformEnum) {
    for (final platform in _platforms) {
      if (platform.platformEnum == platformEnum) {
        return platform;
      }
    }
    return null;
  }

  Platforms appendAll(List<PlatformEnum> platforms) {
    for (final platform in platforms) {
      append(platform);
    }
    return this;
  }

  /// Add [platformEnum] to the PubSpec
  /// after the last dependency.
  Platforms append(PlatformEnum platformEnum) {
    var line = _section.headerLine;

    if (_section.missing) {
      // create the section.
      line = _section._document.append(LineDetached('$key:'));
      _section = SectionImpl.fromLine(line);
    } else {
      if (_platforms.isNotEmpty) {
        line = _platforms.last.headerLine;
      }
    }
    final attached = PlatformSupport._attach(_pubspec, line, platformEnum);

    _platforms.add(attached);

    return this;
  }

  void _appendAttached(PlatformSupport attached) {
    _platforms.add(attached);
  }

  /// Remove an Platform from the list of Platforms
  /// Throws a [PlatformNotFound] exception if the
  /// Platform doesn't exist.
  void remove(PlatformEnum name) {
    final platform = this[name];

    if (platform == null) {
      throw PlatformNotFound(
          _pubspec.document, '$name not found in the ${this.name} section');
    }

    _platforms.remove(platform);
    final lines = platform.lines;
    _pubspec.document.removeAll(lines);
  }

  /// returns true if the list of dependencies contains a dependency
  /// with the given name.
  bool exists(PlatformEnum platformEnum) => this[platformEnum] != null;

  @override
  Iterator<PlatformSupport> get iterator => IteratorImpl(_platforms);
}
