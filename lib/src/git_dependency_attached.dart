part of 'internal_parts.dart';

/// Git style dependency.
class GitDependencyAttached extends Section implements DependencyAttached {
  /// Load the git dependency details starting
  /// from [line].
  GitDependencyAttached._fromLine(this._dependencies, Line line)
      : _line = line {
    final name = _line.key;
    final details = GitDetails.fromLine(_line);

    if (Strings.isNotBlank(_line.value) && details.refLine != null) {
      throw PubSpecException(_line,
          '''The git dependency for '$name has the url specified twice. ''');
    }

    dependency = GitDependency._fromDetails(name, details);

    comments = Comments(this);
  }

  GitDependencyAttached._attach(Pubspec pubspec, int lineNo, this.dependency) {
    _line = Line.forInsertion(pubspec.document, '  ${dependency.name}:');
    pubspec.document.insert(_line, lineNo);
    comments = Comments(this);
  }

  late final Dependencies _dependencies;

  late final GitDependency dependency;

  late final Line _line;

  @override
  String get name => _line.key;

  @override
  Line get line => _line;

  @override
  late final Comments comments;

  @override
  List<Line> get lines =>
      [...comments.lines, _line, ...dependency.details.lines];

  @override
  int get lineNo => _line.lineNo;

  @override
  Document get document => line.document;

  @override
  Version get version => Version.empty();

  /// The last line number used by this  section
  @override
  int get lastLineNo => lines.last.lineNo;

  @override
  DependencyAttached append(Dependency dependency) {
    _dependencies.append(dependency);
    return this;
  }
}
