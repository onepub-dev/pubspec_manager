part of 'internal_parts.dart';

/// Git style dependency.
class DependencyGit implements Dependency {
  /// Load the git dependency from the [Document]  starting
  /// from [line].
  DependencyGit._fromLine(this._dependencies, LineImpl line)
      : _line = line,
        section = SectionImpl.fromLine(line) {
    _name = _line.key;
    final details = GitDetails.fromLine(_line);

    if (Strings.isNotBlank(_line.value) && details.refLine != null) {
      throw PubSpecException(_line,
          '''The git dependency for '$name has the url specified twice. ''');
    }
  }

  /// Create a Git dependency and insert it into the document
  DependencyGit._insertAfter(
      PubSpec pubspec, Line lineBefore, DependencyGitBuilder dependency) {
    _name = dependency.name;
    _line = LineImpl.forInsertion(pubspec.document, '  $_name:');
    pubspec.document.insertAfter(_line, lineBefore);

    _details = GitDetails(dependency);
    _details._attach(section, _line);

    section = SectionImpl.fromLine(_line);

    // // ignore: prefer_foreach
    // for (final comment in dependency.comments) {
    //   comments.append(comment);
    // }
  }
  static const key = 'git';

  @override
  late final Section section;

  late final String _name;

  /// The parent dependency key
  late final Dependencies _dependencies;

  late final GitDetails _details;

  late final LineImpl _line;

  @override
  String get name => _name;

  set name(String name) {
    this.name = name;
    _line.key = name;
  }

  // @override
  // List<Line> get lines =>
  //     [..._section.comments.lines, _line, ..._details.lines];

  @override
  Dependency append(DependencyBuilder dependency) {
    _dependencies.append(dependency);
    return this;
  }
}

/// Holds the details of a git dependency.
class GitDetails {
  // GitDetails({this.url, this.ref, this.path});
  GitDetails(DependencyGitBuilder dependency)
      : url = dependency.url,
        ref = dependency.ref,
        path = dependency.path;

  /// Load the git details associated with the git dependency
  /// at [line]
  GitDetails.fromLine(LineImpl line)
      : urlLine = line.findKeyChild('url'),
        refLine = line.findKeyChild('ref'),
        pathLine = line.findKeyChild('path') {
    path = pathLine?.value;
    ref = refLine?.value;
    url = urlLine?.value;
  }

  String? url;
  String? ref;
  String? path;

  LineImpl? urlLine;
  LineImpl? refLine;
  LineImpl? pathLine;

  List<Line> get lines => [
        if (urlLine != null) urlLine!,
        if (refLine != null) refLine!,
        if (pathLine != null) pathLine!
      ];

  void _attach(Section section, LineImpl lineBefore) {
    if (_attachLine(section, lineBefore,
        key: 'url', value: url, inserted: (line) => urlLine = line)) {
      lineBefore = urlLine!;
    }
    if (_attachLine(section, lineBefore,
        key: 'ref', value: ref, inserted: (line) => refLine = line)) {
      lineBefore = refLine!;
    }
    if (_attachLine(section, lineBefore,
        key: 'path', value: path, inserted: (line) => pathLine = line)) {
      lineBefore = pathLine!;
    }
  }

  bool _attachLine(Section section, Line lineBefore,
      {required String key,
      required String? value,
      required void Function(LineImpl) inserted}) {
    var attached = false;
    if (value != null) {
      final _line = LineImpl.forInsertion(section.document, '    $key: $value');
      section.document.insertAfter(_line, lineBefore);
      inserted(_line);
      attached = true;
    }
    return attached;
  }
}
