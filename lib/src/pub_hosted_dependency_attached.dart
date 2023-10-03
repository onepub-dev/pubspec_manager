part of 'internal_parts.dart';

/// A dependench hosted on pub.dev.
/// A pub hosted dependency is of the form
/// dependencies:
///   dcli: ^3.0.1
class PubHostedDependencyAttached extends Section
    implements DependencyAttached, DependencyVersioned {
  PubHostedDependencyAttached._fromLine(this._dependencies, Line line)
      : _line = line {
    // the line is of the form '<name>: <version>'
    _name = line.key;
    _version = line.value;
    comments = CommentsAttached(this);
  }

  @override
  PubHostedDependencyAttached._attach(this._dependencies, Pubspec pubspec,
      int lineNo, PubHostedDependency dependency) {
    _name = dependency.name;
    version = dependency._version;
    _line = Line.forInsertion(pubspec.document,
        '  ${dependency._name}: ${dependency._version.constraint}');
    pubspec.document.insert(line, lineNo);
    comments = CommentsAttached(this);
  }

  String _name;
  String _version;

  /// The line this dependency is attached to.
  late final Line _line;

  late final Dependencies _dependencies;

  @override
  String get name => dependency.name;

  set name(String name) {
    _name = name;
    _line.value = name;
  }

  @override
  String get version => dependency._version.toString();

  @override
  Line get line => _line;

  @override
  Document get document => line.document;

  @override
  List<Line> get lines => [...comments.lines, _line];

  @override
  int get lineNo => _line.lineNo;

  @override
  late final CommentsAttached comments;

  /// The last line number used by this  section
  @override
  int get lastLineNo => lines.last.lineNo;

  @override
  DependencyAttached append(Dependency dependency) {
    _dependencies.append(dependency);
    return this;
  }

  @override
  set _version(String version) {
    // TODO: implement version
  }
}
