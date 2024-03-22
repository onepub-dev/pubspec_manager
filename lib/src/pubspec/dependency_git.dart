part of 'internal_parts.dart';

/// A dependency that is hosted in a git repository
class DependencyGit with DependencyMixin implements Dependency {
  /// Load the git dependency from the [Document]  starting
  /// from [line].
  DependencyGit._fromLine(this._dependencies, LineImpl line)
      : _line = line,
        _section = SectionImpl.fromLine(line) {
    _name = _line.key;
    final details = _GitDetails.fromLine(_line);

    if (Strings.isNotBlank(_line.value) && details.refLine != null) {
      throw PubSpecException(_line,
          '''The git dependency for '$name has the url specified twice. ''');
    }
  }

  /// Create a Git dependency and insert it into the document
  DependencyGit._insertAfter(
      PubSpec pubspec, Line lineBefore, DependencyBuilderGit dependency) {
    _name = dependency.name;
    _line = LineImpl.forInsertion(pubspec.document, '  $_name:');
    pubspec.document.insertAfter(_line, lineBefore);

    _details = _GitDetails(dependency);
    _details._attach(_section, _line);

    _section = SectionImpl.fromLine(_line);
  }

  @override
  late final SectionImpl _section;

  late final String _name;

  /// The parent dependency key
  late final Dependencies _dependencies;

  late final _GitDetails _details;

  late final LineImpl _line;

  @override
  String get name => _name;

  set name(String name) {
    this.name = name;
    _line.key = name;
  }

  @override
  Dependency add(DependencyBuilder dependency) {
    _dependencies.add(dependency);
    return this;
  }

  static const keyName = 'git';
}

/// Holds the details of a git dependency.
class _GitDetails {
  // GitDetails({this.url, this.ref, this.path});
  _GitDetails(DependencyBuilderGit dependency)
      : url = dependency.url,
        ref = dependency.ref,
        path = dependency.path;

  /// Load the git details associated with the git dependency
  /// at [line]
  _GitDetails.fromLine(LineImpl line)
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
      final _line = LineImpl.forInsertion(section.document, '    $key: $value');
      section.document.insertAfter(_line, lineBefore);
      inserted(_line);
      attached = true;
    }
    return attached;
  }
}
