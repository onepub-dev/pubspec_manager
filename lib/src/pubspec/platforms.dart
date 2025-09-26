
part of 'internal_parts.dart';

enum PlatformEnum {
  android,
  ios,
  linux,
  macos,
  web,
  windows,
}

/// Holds a list of supported platforms listed under the
/// 'platforms' keyword.
class Platforms {
  static const keyName = 'platforms';

  SectionImpl _section;

  /// The name of the dependency section such as
  /// dev_dpendencies
  late final String name;

  /// reference to the pubspec that has these dependencies.
  final PubSpec _pubspec;

  final _platforms = <PlatformSupport>[];

  Platforms._missing(this._pubspec)
      : _section = SectionImpl.missing(_pubspec.document, keyName);

  Platforms._fromLine(this._pubspec, LineImpl line)
      : _section = SectionImpl.fromLine(line) {
    name = line.key;
  }

  /// List of the platform's that this package supports.
  /// to modiify the list use [add], [addAll], [remove] and [removeAll]
  List<PlatformSupport> get list => List.unmodifiable(_platforms);

  /// the number of platforms listed
  int get length => _platforms.length;

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

  Platforms addAll(List<PlatformEnum> platforms) {
    for (final platform in platforms) {
      add(platform);
    }
    return this;
  }

  /// Add [platformEnum] as a supported platform.
  Platforms add(PlatformEnum platformEnum) {
    var line = _section.headerLine;

    if (_section.missing) {
      // create the section.
      line = _section.document.append(LineDetached('$keyName:'));
      _section = SectionImpl.fromLine(line);
    } else {
      if (_platforms.isNotEmpty) {
        line = _platforms.last._section.headerLine;
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

    _remove(platform);
  }

  void _remove(PlatformSupport platform) {
    _platforms.remove(platform);
    final lines = platform.lines;
    _pubspec.document.removeAll(lines);
  }

  void removeAll() {
    for (final platform in list.reversed) {
      _remove(platform);
    }
  }

  /// returns true if the list of platforms contains [platformEnum].
  bool exists(PlatformEnum platformEnum) => this[platformEnum] != null;
}
