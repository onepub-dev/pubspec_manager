part of 'internal_parts.dart';

class StringListSection implements Section {
  SectionImpl _section;
  // We pass pubpsec to every element for consistency
  // ignore: unused_field
  final PubSpec _pubspec;
  final String keyName;
  final _entries = <_StringListEntry>[];

  StringListSection._missing(this._pubspec, this.keyName)
      : _section = SectionImpl.missing(_pubspec.document, keyName);

  StringListSection._fromLine(this._pubspec, LineImpl line)
      : keyName = line.key,
        _section = SectionImpl.fromLine(line) {
    for (final child in line.childrenOf(type: LineType.indexed)) {
      _entries.add(_StringListEntry(
          _parseIndexedValue(child), _collectEntryLines(child)));
    }
  }

  List<String> get list =>
      List.unmodifiable(_entries.map((entry) => entry.value));

  int get length => _entries.length;

  bool exists(String value) =>
      _entries.any((entry) => entry.value.trim() == value.trim());

  StringListSection add(String value) {
    _ensureSectionExists();
    final text = Strings.isBlank(value)
        ? '${_section.headerLine.childIndent}-'
        : '${_section.headerLine.childIndent}- $value';
    final line = LineImpl.forInsertion(_section.document, text);
    final lineBefore =
        _entries.isEmpty ? _section.headerLine : _entries.last.lines.last;
    _section.document.insertAfter(line, lineBefore);
    _entries.add(_StringListEntry(value, [line]));
    return this;
  }

  StringListSection addAll(List<String> values) {
    for (final value in values) {
      add(value);
    }
    return this;
  }

  void remove(String value) {
    final index =
        _entries.indexWhere((entry) => entry.value.trim() == value.trim());
    if (index == -1) {
      throw NotFoundException('$value not found in the $keyName section');
    }
    removeAt(index);
  }

  void removeAt(int index) {
    if (index < 0 || index >= _entries.length) {
      throw RangeError.range(index, 0, _entries.length - 1);
    }
    final removed = _entries.removeAt(index);
    for (final line in removed.lines.reversed) {
      _section._removeChild(line);
    }
  }

  void removeAll() {
    for (final entry in _entries.reversed) {
      for (final line in entry.lines.reversed) {
        _section._removeChild(line);
      }
    }
    _entries.clear();
  }

  static String _parseIndexedValue(LineImpl line) {
    final trimmed = line.text.trimLeft();
    if (!trimmed.startsWith('-')) {
      throw PubSpecException(line, 'Expected a list entry starting with "-"');
    }
    return trimmed.substring(1).trimLeft();
  }

  static List<LineImpl> _collectEntryLines(LineImpl indexedLine) {
    final lines = <LineImpl>[indexedLine];
    final document = indexedLine._document;

    for (final line in document._lines) {
      if (line.lineNo <= indexedLine.lineNo) {
        continue;
      }

      final isCommentOrBlank =
          line.lineType == LineType.comment || line.lineType == LineType.blank;

      if (!isCommentOrBlank && line.indent <= indexedLine.indent) {
        break;
      }

      if (isCommentOrBlank && line.indent <= indexedLine.indent) {
        continue;
      }

      lines.add(line);
    }

    return lines;
  }

  void _ensureSectionExists() {
    if (_section.missing) {
      final headerLine = _section.document.append(LineDetached('$keyName:'));
      _section = SectionImpl.fromLine(headerLine);
    }
  }

  @override
  Comments get comments => _section.comments;

  @override
  List<Line> get lines => _section.lines;

  @override
  bool get missing => _section.missing;
}

class _StringListEntry {
  final String value;
  final List<LineImpl> lines;

  _StringListEntry(this.value, this.lines);
}
