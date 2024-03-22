part of 'internal_parts.dart';

/// A platform that the package supports.
class PlatformSupport implements Section {
  /// re-hydrate an Platform from a line.
  PlatformSupport._fromLine(this._line)
      : _platformEnum = PlatformEnum.values.byName(_line.key),
        _section = SectionSingleLine.fromLine(_line);

  PlatformSupport._attach(
      PubSpec pubspec, Line lineBefore, PlatformEnum platform)
      : _platformEnum = platform,
        _line = LineImpl.forInsertion(
            pubspec.document, LineImpl.buildLine(1, platform.name, '')),
        _section =
            SectionSingleLine.attach(pubspec, lineBefore, 1, platform.name, '');

  SectionSingleLine _section;

  /// also the key in the pubspec.
  PlatformEnum _platformEnum;

  late final LineImpl _line;

  PlatformEnum get platformEnum => _platformEnum;

  set platformEnum(PlatformEnum name) {
    _platformEnum = name;

    if (!_line.missing) {
      _line.key = _platformEnum.name;
    }
  }

  @override
  Comments get comments => _section.comments;

  @override
  bool get missing => _section.missing;

  @override
  List<Line> get lines => _section.lines;
}
