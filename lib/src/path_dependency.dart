import 'package:pub_semver/pub_semver.dart' as sm;

import '../eric.dart';
import 'document/comments.dart';
import 'document/document.dart';
import 'document/line.dart';
import 'document/section.dart';

/// represents a dependency that has a 'path' key
/// A path dependency is located on the local file
/// system. The path is a relative or absolute path
/// to the dependant package.
/// A path dependency takes the form of:
/// dependencies:
///   dcli: ^2.3.1
class PathDependency extends Section implements Dependency {
  PathDependency.fromLine(this._line) {
    _name = _line.key;
    _version = Version.parse(_line.value);
    comments = Comments(this);
  }
  static const key = 'path';

  late final Line _line;

  late String _name;
  late sm.VersionConstraint _version;

  @override
  String get name => _name;

  @override
  sm.VersionConstraint get versionConstraint =>
      _version == sm.VersionConstraint.empty
          ? sm.VersionConstraint.any
          : _version;

  @override
  Line get line => _line;

  @override
  Document get document => line.document;

  @override
  List<Line> get lines => [...comments.lines, _line];

  @override
  late final Comments comments;

  @override
  void attach(PubSpec pubspec, int lineNo) {
    _line = Line.forInsertion(pubspec.document, '  $_name: $_version');
    pubspec.document.insert(_line, lineNo);
  }

  @override
  int get lineNo => _line.lineNo;
}
