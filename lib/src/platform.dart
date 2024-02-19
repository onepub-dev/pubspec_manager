part of 'internal_parts.dart';

/// An Platform script that is attached to the [PubSpec].
class Platform extends SectionSingleLine {
  /// re-hydrate an Platform from a line.
  Platform._fromLine(this._line)
      : _platformEnum = PlatformEnum.values.byName(_line.key),
        super.fromLine(_line);

  Platform._attach(PubSpec pubspec, Line lineBefore, PlatformEnum platform)
      : _platformEnum = platform,
        _line = LineImpl.forInsertion(pubspec.document, _buildLine(platform)),
        super.attach(pubspec, lineBefore, platform.name, '');

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
  LineImpl get line => _line;

  @override
  Document get document => line.document;

  @override
  List<Line> get lines => [...comments.lines, _line];

  /// The last line number used by this  section
  @override
  int get lastLineNo => lines.last.lineNo;

  static String _buildLine(PlatformEnum platform) => '  ${platform.name}:';
}
