part of 'internal_parts.dart';

/// a hosted dependency which takes the form:
/// dependencies:
///   dcli:
///     hosted: https://onepub.dev
///     version: ^2.3.1
/// If no version is specified then 'any' is assumed.
class HostedDependencyAttached extends Section implements DependencyAttached {
  /// build a hosted dependency from a line in the document
  HostedDependencyAttached._fromLine(this._line) {
    final name = _line.key;
    _hostedUrlLine = _line.findRequiredKeyChild('hosted');
    final hostedUrl = _hostedUrlLine.value;
    _versionLine = _line.findKeyChild('version');

    String? version;

    if (!_versionLine.missing) {
      version = _versionLine.value;
    }

    _dependency =
        HostedDependency(name: name, url: hostedUrl, version: version);

    comments = Comments(this);
  }

  HostedDependencyAttached.attach(
      Pubspec pubspec, int lineNo, HostedDependency dependency) {
    _line = Line.forInsertion(pubspec.document, '  ${dependency.name}: ');
    pubspec.document.insert(_line, lineNo++);
    _hostedUrlLine = Line.forInsertion(
        pubspec.document, '    hosted: ${dependency.hostedUrl}');
    pubspec.document.insert(_hostedUrlLine, lineNo++);

    if (!dependency.version.isEmpty) {
      _versionLine = Line.forInsertion(
          pubspec.document, '    version: ${dependency.version}');
      pubspec.document.insert(_versionLine, lineNo++);
    } else {
      _versionLine = Line.missing(document, LineType.key);
    }
    comments = Comments(this);
  }

  late HostedDependency _dependency;
  late Line _line;
  late Line _hostedUrlLine;
  late Line _versionLine;

  @override
  Version get version => _dependency.version;

  @override
  String get name => _dependency._name;

  String get hostedUrl => _dependency.hostedUrl;

  @override
  Line get line => _line;

  @override
  Document get document => line.document;

  @override
  int get lineNo => _line.lineNo;

  @override
  late final Comments comments;

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
}
