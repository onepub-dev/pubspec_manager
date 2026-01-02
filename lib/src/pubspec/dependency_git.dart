part of 'internal_parts.dart';

/// A dependency that is hosted in a git repository
class DependencyGit extends Dependency {
  @override
  final SectionImpl _section;

  String _name;

  /// The parent dependency key
  final Dependencies _dependencies;

  final _GitDetails _details;

  final LineImpl _line;

  /// For future use - maybe
  // ignore: unused_field
  final LineImpl _gitLine;

  static const keyName = 'git';

  /// Load the git dependency from the [Document]  starting
  /// from [_line].
  DependencyGit._(this._dependencies, this._line, this._gitLine, this._section,
      this._name, this._details)
      : super._();

  factory DependencyGit._fromLine(Dependencies dependencies, LineImpl line) {
    final gitLine = line.findRequiredKeyChild(keyName);
    return DependencyGit._(
        dependencies,
        line,
        gitLine,
        SectionImpl.fromLine(line),
        line.key,
        _GitDetails.fromLine(gitLine, line.key));
  }

  /// Create a Git dependency and insert it into the document
  factory DependencyGit._insertAfter(Dependencies dependencies, PubSpec pubspec,
      Line lineBefore, DependencyBuilderGit dependency) {
    final url = dependency.url;
    final isSimple = dependency.isSimple;
    final directUrl = isSimple ? ' $url' : '';

    final line =
        LineImpl.forInsertion(pubspec.document, '  ${dependency.name}:');
    pubspec.document.insertAfter(line, lineBefore);

    final section = SectionImpl.fromLine(line);
    final details = _GitDetails(dependency);

    final gitLine =
        LineImpl.forInsertion(pubspec.document, '    $keyName:$directUrl');
    pubspec.document.insertAfter(gitLine, line);

    if (!isSimple) {
      details._attach(section, gitLine);
    }
    return DependencyGit._(
        dependencies, line, gitLine, section, dependency.name, details);
  }

  @override
  String get name => _name;

  set name(String name) {
    _name = name;
    _line.key = name;
  }

  String get url => _details.url;

  String? get ref => _details.ref;

  String? get path => _details.path;

  /// List of comments associated with the
  /// dependency.
  @override
  Comments get comments => _section.comments;

  /// The line number within the pubspec.yaml
  /// where this dependency is located.
  @override
  int get lineNo => _section.headerLine.lineNo;

  @override
  Dependency add(DependencyBuilder dependency) {
    _dependencies.add(dependency);
    return this;
  }
}

/// Holds the details of a git dependency.
class _GitDetails {
  final String url;

  final String? ref;

  final String? path;

  LineImpl? urlLine;

  LineImpl? refLine;

  LineImpl? pathLine;

  // GitDetails({this.url, this.ref, this.path});
  factory _GitDetails(DependencyBuilderGit dependency) => _GitDetails._(
        dependency.url,
        dependency.ref,
        dependency.path,
      );

  _GitDetails._(this.url, this.ref, this.path,
      {this.urlLine, this.refLine, this.pathLine});

  /// Load the git details associated with the git dependency
  /// at [line]
  factory _GitDetails.fromLine(LineImpl line, String name) {
    final urlLine = line.findKeyChild('url');
    final refLine = line.findKeyChild('ref');
    final pathLine = line.findKeyChild('path');

    final path = !pathLine.missing ? pathLine.value : null;
    final ref = !refLine.missing ? refLine.value : null;
    var url = !urlLine.missing ? urlLine.value : null;

    if (Strings.isNotBlank(line.value) && Strings.isNotBlank(url)) {
      throw PubSpecException(line,
          '''The git dependency for '$name' has the url specified twice. ''');
    }

    url ??= line.value; // if the url is not a key then it may be the value.

    if (Strings.isBlank(url)) {
      throw PubSpecException(line,
          '''The git dependency for '$name' requires a value or a 'url' key.''');
    }

    return _GitDetails._(url, ref, path,
        urlLine: urlLine, refLine: refLine, pathLine: pathLine);
  }

  List<Line> get lines => [
        if (urlLine != null) urlLine!,
        if (refLine != null) refLine!,
        if (pathLine != null) pathLine!
      ];

  void _attach(SectionImpl section, LineImpl lineBefore) {
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

  bool _attachLine(SectionImpl section, Line lineBefore,
      {required String key,
      required String? value,
      required void Function(LineImpl) inserted}) {
    var attached = false;
    if (value != null) {
      final line = LineImpl.forInsertion(
        section.document,
        '      $key: $value',
      );
      section.document.insertAfter(line, lineBefore);
      inserted(line);
      attached = true;
    }
    return attached;
  }
}
