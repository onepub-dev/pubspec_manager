part of 'internal_parts.dart';

/// a hosted dependency which takes the form:
/// dependencies:
///   dcli:
///     hosted: https://onepub.dev
///     version: ^2.3.1
/// If no version is specified then 'any' is assumed.
class DependencyAltHosted implements Dependency, DependencyVersioned {
  /// build an [DependencyAltHosted] from an existing line in the document
  DependencyAltHosted._fromLine(this._dependencies, this._line)
      : section = SectionImpl.fromLine(_line) {
    _name = _line.key;

    _hostedUrlLine = _line.findRequiredKeyChild('hosted');
    _hostedUrl = _hostedUrlLine.value;

    _versionLine = _line.findKeyChild('version');
    if (!_versionLine.missing) {
      _version = _versionLine.value;
    }
  }

  /// Creates an  [DependencyAltHosted] inserting it into the document after
  /// [lineBefore]
  DependencyAltHosted._insertAfter(this._dependencies, PubSpec pubspec,
      Line lineBefore, DependencyAltHostedBuilder dependency) {
    _name = dependency.name;
    _hostedUrl = dependency.hostedUrl;
    _version = dependency.version;

    _line = LineImpl.forInsertion(pubspec.document, '  $_name: ');
    section = SectionImpl.fromLine(_line);

    lineBefore = pubspec.document.insertAfter(_line, lineBefore);
    _hostedUrlLine =
        LineImpl.forInsertion(pubspec.document, '    hosted: $_hostedUrl');
    lineBefore = pubspec.document.insertAfter(_hostedUrlLine, lineBefore);

    if (_version != null) {
      _versionLine =
          LineImpl.forInsertion(pubspec.document, '    version: $_version');
      lineBefore = pubspec.document.insertAfter(_versionLine, lineBefore);
    } else {
      _versionLine = LineImpl.missing(pubspec.document, LineType.key);
    }

    // // ignore: prefer_foreach
    // for (final comment in dependency.comments) {
    //   _section.comments.append(comment);
    // }
  }
  static const key = 'hosted';

  @override
  late Section section;

  /// The dependency section this dependency belongs to
  final Dependencies _dependencies;

  late String _name;
  late String _hostedUrl;
  late String? _version;

  late final LineImpl _line;
  late final LineImpl _hostedUrlLine;
  late final LineImpl _versionLine;

  @override
  String get name => _name;

  set name(String name) {
    _name = name;
    _line.value = name;
  }

  String get hostedUrl => _hostedUrl;

  set hostedUrl(String hostedUrl) {
    _hostedUrl = hostedUrl;
    _hostedUrlLine.value = _hostedUrl;
  }

  @override
  String get version => _version ?? 'any';

  @override
  set version(String version) {
    _version = version;
    _versionLine.value = version;
  }

  // @override
  // List<Line> get lines => [
  //       ...comments.lines,
  //       _line,
  //       _hostedUrlLine,
  //       if (!_versionLine.missing) _versionLine
  //     ];

  /// The last line number used by this  section_versionLine
  // @override
  // int get lastLineNo => lines.last.lineNo;

  @override
  Dependency append(DependencyBuilder dependency) {
    _dependencies.append(dependency);
    return this;
  }
}
