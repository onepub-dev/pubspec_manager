part of 'internal_parts.dart';

/// A dependency that is hosted in a git repository
class DependencyGit with DependencyMixin implements Dependency {
  /// Load the git dependency from the [Document]  starting
  /// from [line].
  DependencyGit._fromLine(this._dependencies, LineImpl line)
      : _line = line,
        _section = SectionImpl.fromLine(line) {
    _name = _line.key;
    _gitLine = _line.findRequiredKeyChild(keyName);
    _details = _GitDetails.fromLine(_gitLine, _name);
  }

  /// Create a Git dependency and insert it into the document
  DependencyGit._insertAfter(
      PubSpec pubspec, Line lineBefore, DependencyBuilderGit dependency) {
    _name = dependency.name;
    final url = dependency.url;
    final isSimple = dependency.isSimple;
    final directUrl = isSimple ? ' $url' : '';

    _line = LineImpl.forInsertion(pubspec.document, '  $_name:');
    pubspec.document.insertAfter(_line, lineBefore);

    _section = SectionImpl.fromLine(_line);
    _details = _GitDetails(dependency);

    _gitLine =
        LineImpl.forInsertion(pubspec.document, '    $keyName:$directUrl');
    pubspec.document.insertAfter(_gitLine, _line);

    if (!isSimple) {
      _details._attach(_section, _gitLine);
    }
  }

  @override
  late final SectionImpl _section;

  late final String _name;

  /// The parent dependency key
  late final Dependencies _dependencies;

  late final _GitDetails _details;

  late final LineImpl _line;
  late final LineImpl _gitLine;

  @override
  String get name => _name;

  set name(String name) {
    this.name = name;
    _line.key = name;
  }

  @visibleForTesting
  String get url => _details.url;
  @visibleForTesting
  String? get ref => _details.ref;
  @visibleForTesting
  String? get path => _details.path;

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
  _GitDetails.fromLine(LineImpl line, String name)
      : urlLine = line.findKeyChild('url'),
        refLine = line.findKeyChild('ref'),
        pathLine = line.findKeyChild('path') {
    String? url;
    path = !pathLine!.missing ? pathLine!.value : null;
    ref = !refLine!.missing ? refLine!.value : null;
    url = !urlLine!.missing ? urlLine!.value : null;

    if (Strings.isNotBlank(line.value) && Strings.isNotBlank(url)) {
      throw PubSpecException(line,
          '''The git dependency for '$name' has the url specified twice. ''');
    }

    url ??= line.value; // if the url is not a key then it may be the value.

    if (Strings.isBlank(url)) {
      throw PubSpecException(line,
          '''The git dependency for '$name' requires a value or a 'url' key.''');
    }

    this.url = url;
  }

  late String url;
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
      final _line = LineImpl.forInsertion(
        section.document,
        '      $key: $value',
      );
      section.document.insertAfter(_line, lineBefore);
      inserted(_line);
      attached = true;
    }
    return attached;
  }
}
