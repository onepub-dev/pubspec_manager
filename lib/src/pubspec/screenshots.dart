part of 'internal_parts.dart';

class Screenshots implements Section {
  static const keyName = 'screenshots';

  SectionImpl _section;
  final PubSpec _pubspec;
  final _screenshots = <Screenshot>[];

  Screenshots._missing(this._pubspec)
      : _section = SectionImpl.missing(_pubspec.document, keyName);

  Screenshots._fromLine(this._pubspec, LineImpl line)
      : _section = SectionImpl.fromLine(line) {
    for (final item in line.childrenOf(type: LineType.indexed)) {
      _screenshots.add(Screenshot._fromIndexedLine(item));
    }
  }

  List<Screenshot> get list => List.unmodifiable(_screenshots);

  int get length => _screenshots.length;

  Screenshots add({required String description, required String path}) {
    _ensureSectionExists();
    var lineBefore = _section.headerLine;
    if (_screenshots.isNotEmpty) {
      lineBefore = _screenshots.last._lines.last;
    }

    final descriptionLine = LineImpl.forInsertion(_section.document,
        '${_section.headerLine.childIndent}- description: $description');
    lineBefore = _section.document.insertAfter(descriptionLine, lineBefore);
    final pathLine = LineImpl.forInsertion(
        _section.document, '${descriptionLine.childIndent}path: $path');
    lineBefore = _section.document.insertAfter(pathLine, lineBefore);

    _screenshots.add(Screenshot._fromAttachedLines(descriptionLine, pathLine));

    return this;
  }

  void removeAt(int index) {
    if (index < 0 || index >= _screenshots.length) {
      throw RangeError.range(index, 0, _screenshots.length - 1);
    }
    final screenshot = _screenshots.removeAt(index);
    _section.document.removeAll(screenshot._lines);
  }

  void removeAll() {
    final lines = <Line>[];
    for (final screenshot in _screenshots) {
      lines.addAll(screenshot._lines);
    }
    _section.document.removeAll(lines);
    _screenshots.clear();
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

class Screenshot {
  String _description;
  String _path;
  final List<LineImpl> _lines;

  Screenshot._(this._description, this._path, this._lines);

  factory Screenshot._fromAttachedLines(
          LineImpl descriptionLine, LineImpl pathLine) =>
      Screenshot._(_readValue(descriptionLine, requiredKey: 'description'),
          pathLine.value, [descriptionLine, pathLine]);

  factory Screenshot._fromIndexedLine(LineImpl indexedLine) {
    String? description;
    String? path;
    final lines = <LineImpl>[indexedLine];

    final inline = _extractInlineKeyValue(indexedLine);
    if (inline != null) {
      switch (inline.key) {
        case 'description':
          description = inline.value;
        case 'path':
          path = inline.value;
      }
    }

    for (final child in indexedLine.childrenOf(type: LineType.key)) {
      lines.add(child);
      switch (child.key) {
        case 'description':
          description = child.value;
        case 'path':
          path = child.value;
      }
    }

    if (description == null || path == null) {
      throw PubSpecException(indexedLine,
          'Each screenshot entry must contain both description and path.');
    }

    return Screenshot._(description, path, lines);
  }

  String get description => _description;

  String get path => _path;

  static KeyValue? _extractInlineKeyValue(LineImpl indexedLine) {
    final trimmed = indexedLine.text.trimLeft();
    if (!trimmed.startsWith('-')) {
      return null;
    }
    final inlineValue = trimmed.substring(1).trimLeft();
    if (!inlineValue.contains(':')) {
      return null;
    }
    return KeyValue.fromText(inlineValue);
  }

  static String _readValue(LineImpl line, {required String requiredKey}) {
    final trimmed = line.text.trimLeft();
    if (!trimmed.startsWith('-')) {
      throw PubSpecException(
          line, 'Invalid screenshot entry, expected "-" prefix.');
    }
    final keyValue = KeyValue.fromText(trimmed.substring(1).trimLeft());
    if (keyValue.key != requiredKey) {
      throw PubSpecException(
          line, 'Invalid screenshot entry, expected key: $requiredKey.');
    }
    return keyValue.value;
  }
}
