part of 'internal_parts.dart';

/// represents a dependency that has a 'path' key
/// A path dependency is located on the local file
/// system. The path is a relative or absolute path
/// to the dependant package.
/// A path dependency takes the form of:
/// dependencies:
///   flutter:
///     sdk: flutter
class DependencySdk extends Dependency {
  @override
  late final SectionImpl _section;

  @override
  late final String name;

  /// The sdk that provides this dependency
  /// e.g. flutter
  late final String sdk;

  /// The parent dependency key
  late final Dependencies _dependencies;

  /// Line that contained the dependency declaration
  late final LineImpl _line;

  static const keyName = 'sdk';

  /// Creates Path dependency from an existing [Line] in
  /// the document.
  DependencySdk._fromLine(this._dependencies, this._line)
      : _section = SectionImpl.fromLine(_line),
        super._() {
    name = _line.key;
    final sdkLine = _line.findRequiredKeyChild(keyName);
    sdk = sdkLine.value;
  }

  /// Creates an Sdk Dependency inserting it into the document after
  /// [lineBefore]
  DependencySdk._insertAfter(
      PubSpec pubspec, Line lineBefore, DependencyBuilderSdk dependency)
      : super._() {
    name = dependency.name;
    sdk = dependency.path;

    _line = LineImpl.forInsertion(pubspec.document, '  $name:');
    pubspec.document.insertAfter(_line, lineBefore);

    final sdkLine = LineImpl.forInsertion(
        pubspec.document, '${_line.childIndent}$keyName: $sdk');
    pubspec.document.insertAfter(sdkLine, _line);

    _section = SectionImpl.fromLine(_line);
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

  @override
  String toString() => _section.lines.join('\n');
}
