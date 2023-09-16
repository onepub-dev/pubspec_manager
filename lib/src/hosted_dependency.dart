import 'package:pub_semver/pub_semver.dart' as sm;

import '../eric.dart';
import 'document/comments.dart';
import 'document/document.dart';
import 'document/line.dart';
import 'document/section.dart';

/// a hosted dependency which takes the form:
/// dependencies:
///   dcli:
///     hosted: https://onepub.dev
///     version: ^2.3.1
/// If no version is specified then 'any' is assumed.
class HostedDependency extends Section implements Dependency {
  HostedDependency.fromLine(this._line) {
    _name = _line.key;
    _hostedUrlLine = _line.findRequiredKeyChild('hosted');
    hostedUrl = _hostedUrlLine.value;
    final v = _line.findKeyChild('version');
    if (v != null) {
      _versionLine = Version.fromLine(v);
      _version = _versionLine!.constraint;
    }

    comments = Comments(this);
  }
  static const key = 'hosted';
  late final String _name;
  late final String hostedUrl;
  late final sm.VersionConstraint _version;

  late Line _line;
  late Line _hostedUrlLine;
  late Version? _versionLine;

  @override
  sm.VersionConstraint get versionConstraint =>
      _version == sm.VersionConstraint.empty
          ? sm.VersionConstraint.any
          : _version;

  @override
  String get name => _name;

  @override
  Line get line => _line;

  @override
  Document get document => line.document;

  @override
  int get lineNo => _line.lineNo;

  @override
  late final Comments comments;

  @override
  List<Line> get lines =>
      [...comments.lines, _line, _hostedUrlLine, ...?_versionLine?.lines];

  @override
  void attach(PubSpec pubspec, int lineNo) {
    _line = Line.forInsertion(pubspec.document, '  $_name: ');
    pubspec.document.insert(_line, lineNo);
    _hostedUrlLine =
        Line.forInsertion(pubspec.document, '  hosted: $hostedUrl');
    pubspec.document.insert(_hostedUrlLine, lineNo);
    _versionLine = Version.fromLine(
        Line.forInsertion(pubspec.document, '  version: $_version'));
    pubspec.document.insert(_versionLine!.line, lineNo);
  }
}
