part of 'internal_parts.dart';

/// A dependench hosted on pub.dev.
/// A pub hosted dependency is of the form
/// dependencies:
///   dcli: ^3.0.1
class DependencyPubHosted implements Dependency, DependencyVersioned {
  DependencyPubHosted._fromLine(this._dependencies, Line line)
      : _line = line,
        _section = Section.fromLine(line) {
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
    _line = Line.forInsertion(pubspec.document, '  $_name: $_version');
    _line = pubspec.document.insertAfter(_line, lineBefore);
    _section = Section.fromLine(_line);

    // // ignore: prefer_foreach
    // for (final comment in dependency.comments) {
    //   comments.append(comment);
    // }
  }

  @override
  late Section _section;

  late String _name;
  late String? _version;

  /// The line this dependency is attached to.
  late final Line _line;

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
