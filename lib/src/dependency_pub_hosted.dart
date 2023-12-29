part of 'internal_parts.dart';

/// A dependench hosted on pub.dev.
/// A pub hosted dependency is of the form
/// dependencies:
///   dcli: ^3.0.1
class DependencyPubHosted implements Dependency, DependencyVersioned {
  DependencyPubHosted._fromLine(this._dependencies, LineImpl line)
      : _line = line,
        section = SectionImpl.fromLine(line) {
    // the line is of the form '<name>: <version>'
    _name = line.key;
    _version = line.value;
  }

  @override
  DependencyPubHosted._insertAfter(
    this._dependencies,
    PubSpec pubspec,
    Line lineBefore,
    DependencyPubHostedBuilder dependency,
  ) {
    _name = dependency.name;
    _version = dependency.version;
    final line = LineImpl.forInsertion(pubspec.document, '  $_name: $_version');
    _line = pubspec.document.insertAfter(line, lineBefore);
    section = SectionImpl.fromLine(_line);
  }

  @override
  late Section section;

  late String _name;
  late String? _version;

  /// The line this dependency is attached to.
  late final LineImpl _line;

  late final Dependencies _dependencies;

  @override
  String get name => _name;

  set name(String name) {
    _name = name;
    _line.key = name;
  }

  @override
  String get version => _version ?? 'any';

  @override
  set version(String version) {
    _version = version;
    _line.value = version;
  }

  // @override
  // List<Line> get lines => [...comments.lines, _line];

  @override
  Dependency append(DependencyBuilder dependency) {
    _dependencies.append(dependency);
    return this;
  }
}
