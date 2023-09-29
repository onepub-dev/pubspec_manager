part of 'internal_parts.dart';

/// A dependench hosted on pub.dev.
/// A pub hosted dependency is of the form
/// dependencies:
///   dcli: ^3.0.1
class PubHostedDependencyAttached extends Section
    implements DependencyAttached {
  PubHostedDependencyAttached._fromLine(Line line) : _line = line {
    // the line is of the form '<name>: <version>'
    final name = line.key;
    dependency = PubHostedDependency(name: name, version: line.value);
    comments = Comments(this);
  }

  @override
  PubHostedDependencyAttached._attach(
      Pubspec pubspec, int lineNo, this.dependency) {
    _line = Line.forInsertion(pubspec.document,
        '  ${dependency._name}: ${dependency.version.constraint}');
    pubspec.document.insert(line, lineNo);
    comments = Comments(this);
  }

  /// The line this dependency is attached to.
  late final Line _line;
  late final PubHostedDependency dependency;

  @override
  String get name => dependency.name;

  @override
  Version get version => dependency.version;

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
