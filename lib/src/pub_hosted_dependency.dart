part of 'internal_parts.dart';

/// A dependench hosted on pub.dev.
/// A pub hosted dependency is of the form
/// dependencies:
///   dcli: ^3.0.1
class PubHostedDependency extends Section implements Dependency {
  PubHostedDependency({required String name, required String version})
      : _name = name {
    try {
      _versionConstraint = sm.Version.parse(version);
    } on FormatException catch (e) {
      throw VersionException(e.message);
    }
    comments = Comments.empty(this);
  }

  PubHostedDependency._fromLine(Line line) : _line = line {
    // the line is of the form '<name>: <version>'
    final _version = Version._fromLine(line);
    _name = _version.line.key;
    _versionConstraint = _version.constraint;
    comments = Comments(this);
  }

  @override
  void _attach(Pubspec pubspec, int lineNo) {
    _line = Line.forInsertion(pubspec.document, '  $name: $versionConstraint');
    pubspec.document.insert(_line, lineNo);
  }

  /// The line this dependency is attached to.
  late Line _line;
  late String _name;
  late sm.VersionConstraint _versionConstraint;

  set name(String name) {
    _name = name;
  }

  @override
  String get name => _name;

  @override
  sm.VersionConstraint get versionConstraint =>
      _versionConstraint == sm.VersionConstraint.empty
          ? sm.VersionConstraint.any
          : _versionConstraint;

  @override
  Line get line => _line;

  @override
  Document get document => line.document;

  @override
  List<Line> get lines => [...comments.lines, _line];

  @override
  int get lineNo => _line.lineNo;

  @override
  late final Comments comments;

  /// The last line number used by this  section
  @override
  int get lastLineNo => lines.last.lineNo;
}
