import 'package:pub_semver/pub_semver.dart';
import 'package:strings/strings.dart';

import '../eric.dart';
import 'document/comments.dart';
import 'document/document.dart';
import 'document/line.dart';
import 'document/section.dart';

/// Git style dependency.
class GitDependency extends Section implements Dependency {
  GitDependency(String name, {String? url, String? ref, String? path})
      : _name = name,
        details = GitDetails(url: url, ref: ref, path: path);

  /// Load the git dependency details starting
  /// from [line].
  GitDependency.fromLine(Line line) : _line = line {
    _name = _line.key;
    details = GitDetails.fromLine(_line);

    if (Strings.isNotBlank(_line.value) && details.refLine != null) {
      throw PubSpecException(_line,
          '''The git dependency for '$_name has the url specified twice. ''');
    }

    comments = Comments(this);
  }
  static const key = 'git';

  late final Line _line;
  late String _name;
  late final GitDetails details;

  @override
  String get name => _line.key;

  @override
  Line get line => _line;

  @override
  late final Comments comments;

  @override
  List<Line> get lines => [...comments.lines, _line, ...details.lines];

  @override
  void attach(PubSpec pubspec, int lineNo) {
    _line = Line.forInsertion(pubspec.document, '  $_name:');
    pubspec.document.insert(_line, lineNo);
    details.attach(pubspec, lineNo);
  }

  @override
  int get lineNo => _line.lineNo;

  @override
  Document get document => line.document;

  @override
  VersionConstraint get versionConstraint => VersionConstraint.any;
}

/// Holds the details of a git dependency.
class GitDetails {
  GitDetails({this.url, this.ref, this.path});

  GitDetails.fromLine(Line line)
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

  Line? urlLine;
  Line? refLine;
  Line? pathLine;

  List<Line> get lines => [
        if (urlLine != null) urlLine!,
        if (refLine != null) refLine!,
        if (pathLine != null) pathLine!
      ];

  void attach(PubSpec pubspec, int lineNo) {
    if (_attachLine(pubspec, lineNo, key: 'url', value: url)) {
      lineNo++;
    }
    if (_attachLine(pubspec, lineNo, key: 'url', value: url)) {
      lineNo++;
    }
    if (_attachLine(pubspec, lineNo, key: 'url', value: url)) {
      lineNo++;
    }
  }

  bool _attachLine(PubSpec pubspec, int lineNo,
      {required String key, required String? value}) {
    var attached = false;
    if (value != null) {
      final _line = Line.forInsertion(pubspec.document, '    $key: $value');
      pubspec.document.insert(_line, lineNo);
      attached = true;
    }
    return attached;
  }
}
