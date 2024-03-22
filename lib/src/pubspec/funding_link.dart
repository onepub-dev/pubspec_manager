import 'package:path/path.dart';
import 'package:strings/strings.dart';

import '../../pubspec_manager.dart';
import 'internal_parts.dart';

/// A package FundingLink that will be added to the user's PATh
/// when the globally activate the package.
class FundingLink implements Section {
  /// re-hydrate an FundingLink from a line.
  FundingLink._fromLine(this._line)
      : _name = _line.key,
        _script = _line.value,
        _section = SectionSingleLine.fromLine(_line);

  FundingLink._attach(
      PubSpec pubspec, Line lineBefore, String url)
      : _url = url,
        _line =
            LineImpl.forInsertion(pubspec.document, _buildLine(FundingLink)),
        _section = SectionSingleLine.attach(
            pubspec, lineBefore, 1, url);

  final SectionSingleLine _section;

  String _url;

  late final LineImpl _line;

  String get name => _name;

  set name(String name) {
    _name = name;

    if (!_line.missing) {
      _line.key = _name;
    }
  }

  /// Set the name of the dart library located in the bin directory.
  ///
  /// Do NOT pass the .dart extension just the basename.
  set script(String script) {
    _script = script;
    _line.value = script;
  }

  String get script => Strings.orElseOnBlank(_script, name);

  /// returns the project relative path to the script.
  ///
  /// e.g.
  /// FundingLinks:
  ///   dcli_install: main
  ///
  /// scriptPath => bin/main.dart
  ///
  String get scriptPath => join('bin', '$script.dart');

  @override
  List<Line> get lines => [...comments._lines, _line];

  static String _buildLine(FundingLinkBuilder FundingLink) {
    final prefix = '  ${FundingLink.name}:';

    final script = FundingLink.script;
    if (Strings.isNotBlank(script)) {
      return '$prefix $script';
    } else {
      return prefix;
    }
  }

  @override
  Comments get comments => _section.comments;

  @override
  bool get missing => _section.missing;
}
