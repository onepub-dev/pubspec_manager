part of 'internal_parts.dart';

/// A dependency hosted on an alternate dart repository (such as onepub.dev).
///
/// The yaml form of the dependency is:
///
/// ``` yaml
///   dcli:
///     hosted: https://onepub.dev
///     version: ^2.3.1
/// ```
///
/// If no version is specified then 'any' is assumed.
///
/// See: for dependencies hosted on pub.dev use [DependencyPubHosted]
class DependencyAltHosted extends Dependency implements DependencyVersioned {
  @override
  final SectionImpl _section;

  /// The dependency section this dependency belongs to
  final Dependencies _dependencies;

  String _name;

  String _hostedUrl;

  String? _versionConstraint;

  final LineImpl _line;

  final LineImpl _hostedUrlLine;

  final LineImpl _versionLine;

  static const keyName = 'hosted';

  DependencyAltHosted._(
      this._dependencies,
      this._line,
      this._hostedUrlLine,
      this._versionLine,
      this._section,
      this._name,
      this._hostedUrl,
      this._versionConstraint)
      : super._();

  /// build an [DependencyAltHosted] from an existing line in the document
  factory DependencyAltHosted._fromLine(
      Dependencies dependencies, LineImpl line) {
    final section = SectionImpl.fromLine(line);
    final name = line.key;
    final hostedUrlLine = line.findRequiredKeyChild('hosted');
    final hostedUrl = hostedUrlLine.value.trim();
    final versionLine = line.findKeyChild('version');
    final versionConstraint = versionLine.missing ? null : versionLine.value;
    return DependencyAltHosted._(dependencies, line, hostedUrlLine, versionLine,
        section, name, hostedUrl, versionConstraint);
  }

  /// Creates an  [DependencyAltHosted] inserting it into the document after
  /// [lineBefore]
  factory DependencyAltHosted._insertAfter(Dependencies dependencies,
      PubSpec pubspec, Line lineBefore, DependencyBuilderAltHosted dependency) {
    final name = dependency.name;
    final hostedUrl = dependency.hostedUrl;
    final versionConstraint = dependency.versionConstraint;

    final line = LineImpl.forInsertion(pubspec.document, '  $name: ');

    lineBefore = pubspec.document.insertAfter(line, lineBefore);
    final hostedUrlLine =
        LineImpl.forInsertion(pubspec.document, '    $keyName: $hostedUrl');
    lineBefore = pubspec.document.insertAfter(hostedUrlLine, lineBefore);

    LineImpl versionLine;
    if (versionConstraint != null) {
      versionLine = LineImpl.forInsertion(
          pubspec.document, '    version: $versionConstraint');
      lineBefore = pubspec.document.insertAfter(versionLine, lineBefore);
    } else {
      versionLine = LineImpl.missing(pubspec.document, LineType.key);
    }

    return DependencyAltHosted._(dependencies, line, hostedUrlLine, versionLine,
        SectionImpl.fromLine(line), name, hostedUrl, versionConstraint);
  }

  @override
  String get name => _name;

  set name(String name) {
    _name = name;
    _line.key = name;
  }

  /// The url where this package is hosted.
  /// e.g. https://onepub.dev/packages/money
  String get hostedUrl => _hostedUrl;

  set hostedUrl(String hostedUrl) {
    _hostedUrl = hostedUrl;
    _hostedUrlLine.value = _hostedUrl;
  }

  /// The version constraint of the dependency.
  /// If no version is provided then `any` is used.
  ///
  ///  e.g. ^1.0.0
  @override
  String get versionConstraint => _versionConstraint ?? 'any';

  @override
  set versionConstraint(String version) {
    _versionConstraint = version;
    _versionLine.value = version;
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
