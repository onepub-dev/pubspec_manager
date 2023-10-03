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
    final name = line.key;
    dependency = PubHostedDependency(name: name, version: line.value);
    comments = CommentsAttached(this);
  }

  @override
  PubHostedDependencyAttached._attach(
      this._dependencies, Pubspec pubspec, int lineNo, this.dependency) {
    _line = Line.forInsertion(pubspec.document,
        '  ${dependency._name}: ${dependency._version.constraint}');
    pubspec.document.insert(line, lineNo);
    comments = CommentsAttached(this);
  }

  /// The line this dependency is attached to.
  late final Line _line;
  late final PubHostedDependency dependency;

  late final Dependencies _dependencies;

  @override
  String get name => dependency.name;

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
  set version(String version) {
    // TODO: implement version
  }
}
