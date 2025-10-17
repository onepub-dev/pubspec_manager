part of 'internal_parts.dart';

/// A dependench hosted on pub.dev.
/// A pub hosted dependency is of the form
/// dependencies:
///   dcli: ^3.0.1
class DependencyPubHosted extends Dependency implements DependencyVersioned {
  @override
  late SectionImpl _section;

  late String _name;

  late String? _version;

  /// The line this dependency is attached to.
  late final LineImpl _line;

  late final Dependencies _dependencies;

  DependencyPubHosted._fromLine(this._dependencies, LineImpl line)
      : _line = line,
        _section = SectionImpl.fromLine(line),
        super._() {
    // the line is of the form '<name>: <version>'
    _name = line.key;
    _version = line.value;
  }

  @override
  DependencyPubHosted._insertAfter(
    this._dependencies,
    PubSpec pubspec,
    Line lineBefore,
    DependencyBuilderPubHosted dependency,
  ) : super._() {
    _name = dependency.name;
    _version = dependency.versionConstraint;
    final line = LineImpl.forInsertion(pubspec.document, '  $_name: $_version');
    _line = pubspec.document.insertAfter(line, lineBefore);

    _section = SectionImpl.fromLine(_line);
  }

  @override
  String get name => _name;

  set name(String name) {
    _name = name;
    _line.key = name;
  }

  @override
  String get versionConstraint => _version ?? 'any';

  @override
  set versionConstraint(String version) {
    _version = version;
    _line.value = version;
  }

  /// List of comments associated with the
  /// dependency.
  @override
  Comments get comments => _section.comments;

  /// The line number within the pubspec.yaml
  /// where this dependency is located.
  @override
  int get lineNo => _section.headerLine.lineNo;

  @override
  Dependency add(DependencyBuilder dependency) {
    _dependencies.add(dependency);
    return this;
  }
}
