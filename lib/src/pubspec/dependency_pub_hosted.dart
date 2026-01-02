part of 'internal_parts.dart';

/// A dependench hosted on pub.dev.
/// A pub hosted dependency is of the form
/// dependencies:
///   dcli: ^3.0.1
class DependencyPubHosted extends Dependency implements DependencyVersioned {
  @override
  final SectionImpl _section;

  String _name;

  String? _version;

  /// The line this dependency is attached to.
  final LineImpl _line;

  final Dependencies _dependencies;

  DependencyPubHosted._(
      this._dependencies, this._line, this._section, this._name, this._version)
      : super._();

  factory DependencyPubHosted._fromLine(
          Dependencies dependencies, LineImpl line) =>
      // the line is of the form '<name>: <version>'
      DependencyPubHosted._(
          dependencies, line, SectionImpl.fromLine(line), line.key, line.value);

  @override
  factory DependencyPubHosted._insertAfter(
    Dependencies dependencies,
    PubSpec pubspec,
    Line lineBefore,
    DependencyBuilderPubHosted dependency,
  ) {
    final name = dependency.name;
    final version = dependency.versionConstraint;
    final line = LineImpl.forInsertion(pubspec.document, '  $name: $version');
    final inserted = pubspec.document.insertAfter(line, lineBefore);
    return DependencyPubHosted._(
        dependencies, inserted, SectionImpl.fromLine(inserted), name, version);
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
