part of 'internal_parts.dart';

class StringListSection implements Section {
  SectionImpl _section;
  final PubSpec _pubspec;
  final String keyName;
  final _entries = <_StringListEntry>[];

  StringListSection._missing(this._pubspec, this.keyName)
      : _section = SectionImpl.missing(_pubspec.document, keyName);

  StringListSection._fromLine(this._pubspec, LineImpl line)
      : keyName = line.key,
        _section = SectionImpl.fromLine(line) {
    for (final child in line.childrenOf(type: LineType.indexed)) {
      _entries.add(_StringListEntry(_parseIndexedValue(child), child));
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
        _entries.isEmpty ? _section.headerLine : _entries.last.line;
    _section.document.insertAfter(line, lineBefore);
    _entries.add(_StringListEntry(value, line));
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
    _section.document.removeAll([removed.line]);
  }

  void removeAll() {
    _section.document.removeAll(_entries.map((entry) => entry.line).toList());
    _entries.clear();
  }

  static String _parseIndexedValue(LineImpl line) {
    final trimmed = line.text.trimLeft();
    if (!trimmed.startsWith('-')) {
      throw PubSpecException(line, 'Expected a list entry starting with "-"');
    }
    return trimmed.substring(1).trimLeft();
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
  final LineImpl line;

  _StringListEntry(this.value, this.line);
}
