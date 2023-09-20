part of 'internal_parts.dart';

/// a hosted dependency which takes the form:
/// dependencies:
///   dcli:
///     hosted: https://onepub.dev
///     version: ^2.3.1
/// If no version is specified then 'any' is assumed.
class HostedDependency extends Section implements Dependency {
  HostedDependency(
      {required String name, required String url, String version = 'any'}) {
    _name = name;
    hostedUrl = url;
    try {
      _version = sm.VersionConstraint.parse(version);
    } on FormatException catch (e) {
      throw VersionException(e.message);
    }

    comments = Comments.empty(this);
  }
  HostedDependency._fromLine(this._line) {
    _name = _line.key;
    _hostedUrlLine = _line.findRequiredKeyChild('hosted');
    hostedUrl = _hostedUrlLine.value;
    final v = _line.findKeyChild('version');
    if (v != null) {
      _versionLine = Version._fromLine(v);
      _version = _versionLine!.constraint;
    }

    comments = Comments(this);
  }
  static const key = 'hosted';
  late final String _name;
  late final String hostedUrl;
  late final sm.VersionConstraint _version;

  late Line _line;
  late Line _hostedUrlLine;
  late Version? _versionLine;

  @override
  sm.VersionConstraint get versionConstraint =>
      _version == sm.VersionConstraint.empty
          ? sm.VersionConstraint.any
          : _version;

  @override
  String get name => _name;

  @override
  Line get line => _line;

  @override
  Document get document => line.document;

  @override
  int get lineNo => _line.lineNo;

  @override
  late final Comments comments;

  @override
  List<Line> get lines =>
      [...comments.lines, _line, _hostedUrlLine, ...?_versionLine?.lines];

  /// The last line number used by this  section
  @override
  int get lastLineNo => lines.last.lineNo;

  @override
  void _attach(Pubspec pubspec, int lineNo) {
    _line = Line.forInsertion(pubspec.document, '  $_name: ');
    pubspec.document.insert(_line, lineNo++);
    _hostedUrlLine =
        Line.forInsertion(pubspec.document, '    hosted: $hostedUrl');
    pubspec.document.insert(_hostedUrlLine, lineNo++);
    _versionLine = Version._fromLine(
        Line.forInsertion(pubspec.document, '    version: $_version'));
    pubspec.document.insert(_versionLine!.line, lineNo++);
  }
}
