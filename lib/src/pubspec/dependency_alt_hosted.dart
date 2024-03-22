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
class DependencyAltHosted
    with DependencyMixin
    implements Dependency, DependencyVersioned {
  /// build an [DependencyAltHosted] from an existing line in the document
  DependencyAltHosted._fromLine(this._dependencies, this._line)
      : _section = SectionImpl.fromLine(_line) {
    _name = _line.key;

    _hostedUrlLine = _line.findRequiredKeyChild('hosted');
    _hostedUrl = _hostedUrlLine.value;

    _versionLine = _line.findKeyChild('version');
    if (!_versionLine.missing) {
      _versionConstraint = _versionLine.value;
    }
  }

  /// Creates an  [DependencyAltHosted] inserting it into the document after
  /// [lineBefore]
  DependencyAltHosted._insertAfter(this._dependencies, PubSpec pubspec,
      Line lineBefore, DependencyAltHostedBuilder dependency) {
    _name = dependency.name;
    _hostedUrl = dependency.hostedUrl;
    _versionConstraint = dependency.versionConstraint;

    _line = LineImpl.forInsertion(pubspec.document, '  $_name: ');

    lineBefore = pubspec.document.insertAfter(_line, lineBefore);
    _hostedUrlLine =
        LineImpl.forInsertion(pubspec.document, '    hosted: $_hostedUrl');
    lineBefore = pubspec.document.insertAfter(_hostedUrlLine, lineBefore);

    if (_versionConstraint != null) {
      _versionLine = LineImpl.forInsertion(
          pubspec.document, '    version: $_versionConstraint');
      lineBefore = pubspec.document.insertAfter(_versionLine, lineBefore);
    } else {
      _versionLine = LineImpl.missing(pubspec.document, LineType.key);
    }
    _section = SectionImpl.fromLine(_line);
  }

  @override
  late SectionImpl _section;

  /// The dependency section this dependency belongs to
  final Dependencies _dependencies;

  late String _name;
  late String _hostedUrl;
  late String? _versionConstraint;

  late final LineImpl _line;
  late final LineImpl _hostedUrlLine;
  late final LineImpl _versionLine;

  @override
  String get name => _name;

  set name(String name) {
    _name = name;
    _line.value = name;
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

  @override
  Dependency add(DependencyBuilder dependency) {
    _dependencies.add(dependency);
    return this;
  }

  static const keyName = 'hosted';
}
