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
  final SectionImpl _section;

  @override
  final String name;

  /// The sdk that provides this dependency
  /// e.g. flutter
  final String sdk;

  /// The parent dependency key
  final Dependencies _dependencies;

  /// Line that contained the dependency declaration
  /// For future use - maybe
  // ignore: unused_field
  final LineImpl _line;

  static const keyName = 'sdk';

  /// Creates Path dependency from an existing [Line] in
  /// the document.
  DependencySdk._(this._dependencies, this._line, this._section, this.name,
      this.sdk)
      : super._();

  factory DependencySdk._fromLine(Dependencies dependencies, LineImpl line) {
    final sdkLine = line.findRequiredKeyChild(keyName);
    return DependencySdk._(dependencies, line, SectionImpl.fromLine(line),
        line.key, sdkLine.value);
  }

  /// Creates an Sdk Dependency inserting it into the document after
  /// [lineBefore]
  factory DependencySdk._insertAfter(
      Dependencies dependencies,
      PubSpec pubspec,
      Line lineBefore,
      DependencyBuilderSdk dependency) {
    final name = dependency.name;
    final sdk = dependency.path;

    final line = LineImpl.forInsertion(pubspec.document, '  $name:');
    pubspec.document.insertAfter(line, lineBefore);

    final sdkLine = LineImpl.forInsertion(
        pubspec.document, '${line.childIndent}$keyName: $sdk');
    pubspec.document.insertAfter(sdkLine, line);

    return DependencySdk._(
        dependencies, line, SectionImpl.fromLine(line), name, sdk);
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
