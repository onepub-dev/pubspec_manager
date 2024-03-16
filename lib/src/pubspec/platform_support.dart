part of 'internal_parts.dart';

/// A platform that the package supports.
class PlatformSupport extends SectionSingleLine {
  /// re-hydrate an Platform from a line.
  PlatformSupport._fromLine(this._line)
      : _platformEnum = PlatformEnum.values.byName(_line.key),
        super.fromLine(_line);

  PlatformSupport._attach(
      PubSpec pubspec, Line lineBefore, PlatformEnum platform)
      : _platformEnum = platform,
        _line = LineImpl.forInsertion(
            pubspec.document, LineImpl.buildLine(1, platform.name, '')),
        super.attach(pubspec, lineBefore, 1, platform.name, '');

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
  LineImpl get headerLine => _line;

  @override
  Document get _document => headerLine._document;

  @override
  List<Line> get lines => [...comments._lines, _line];

  /// The last line number used by this  section
  @override
  int get lastLineNo => lines.last.lineNo;
}
