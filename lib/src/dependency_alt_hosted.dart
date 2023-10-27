part of 'internal_parts.dart';

/// a hosted dependency which takes the form:
/// dependencies:
///   dcli:
///     hosted: https://onepub.dev
///     version: ^2.3.1
/// If no version is specified then 'any' is assumed.
class DependencyAltHosted extends Section
    implements Dependency, DependencyVersioned {
  /// build a hosted dependency from a line in the document
  DependencyAltHosted._fromLine(this._dependencies, this._line) {
    _name = _line.key;

    _hostedUrlLine = _line.findRequiredKeyChild('hosted');
    _hostedUrl = _hostedUrlLine.value;

    _versionLine = _line.findKeyChild('version');
    if (!_versionLine.missing) {
      _version = _versionLine.value;
    }
    comments = Comments(this);
  }

  DependencyAltHosted.attach(this._dependencies, PubSpec pubspec,
      Line lineBefore, DependencyAltHostedBuilder dependency) {
    _name = dependency.name;
    _hostedUrl = dependency.hostedUrl;
    _version = dependency.version;

    _line = Line.forInsertion(pubspec.document, '  $_name: ');
    lineBefore = pubspec.document.insertAfter(_line, lineBefore);
    _hostedUrlLine =
        Line.forInsertion(pubspec.document, '    hosted: $_hostedUrl');
    lineBefore = pubspec.document.insertAfter(_hostedUrlLine, lineBefore);

    if (_version != null) {
      _versionLine =
          Line.forInsertion(pubspec.document, '    version: $_version');
      lineBefore = pubspec.document.insertAfter(_versionLine, lineBefore);
    } else {
      _versionLine = Line.missing(document, LineType.key);
    }
    comments = Comments(this);

    // ignore: prefer_foreach
    for (final comment in dependency.comments) {
      comments.append(comment);
    }
  }
  static const key = 'hosted';

  /// The dependency section this dependency belongs to
  final Dependencies _dependencies;

  late String _name;
  late String _hostedUrl;
  late String? _version;

  @override
  late final Comments comments;

  late final Line _line;
  late final Line _hostedUrlLine;
  late final Line _versionLine;

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

  @override
  Line get line => _line;

  @override
  Document get document => line.document;

  @override
  int get lineNo => _line.lineNo;

  @override
  List<Line> get lines => [
        ...comments.lines,
        _line,
        _hostedUrlLine,
        if (!_versionLine.missing) _versionLine
      ];

  /// The last line number used by this  section_versionLine
  @override
  int get lastLineNo => lines.last.lineNo;

  @override
  Dependency append(DependencyBuilder dependency) {
    _dependencies.append(dependency);
    return this;
  }
}
