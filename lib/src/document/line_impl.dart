part of '../pubspec/internal_parts.dart';

/// Each line read from the pubspec.yaml is stored into a [Line]
/// and categorised into one of the [LineType]s.
class LineImpl implements Line, Renderer {
  /// Used when reading
  /// a pubspec.yaml line by line (which ultimately we do no matter
  /// how we loaded the pubspec.yaml)
  LineImpl(this.document, this._text, this.lineNo, [LineType? lineType])
      : missing = false {
    final trimmed = _text.trimLeft();

    // no further processing required for blank lines.
    if (trimmed.isEmpty) {
      this.lineType = LineType.blank;
      indent = 0;
      return;
    }

    // determine line type
    if (lineType != null) {
      this.lineType = lineType;
    } else if (trimmed.startsWith('#')) {
      this.lineType = LineType.comment;
    } else if (trimmed.startsWith('-')) {
      this.lineType = LineType.indexed;
    } else if (trimmed.startsWith(RegExp(r'[a-zA-z0-9_\-]+:'))) {
      this.lineType = LineType.key;
    } else {
      this.lineType = LineType.unknown;
    }
    // we must assign a type before we check for indent
    // as _indent can thrown an exception and if the [type]
    // hasn't been initialised then a secondary exception
    // will be thrown.
    indent = _indent(_text);

    // a comment can't have an inline comment
    // so no further process of the line is required.
    if (lineType == LineType.comment) {
      return;
    }

    // check for an inline comment.
    // name: fred # an inline comment
    var i = 0;
    commentOffset = 0;
    for (; i < _text.length; i++) {
      final c = _text.substring(i, i + 1);
      if (c == '#') {
        final whitespace = _preserverWhiteSpace(_text, i);
        inlineComment = whitespace + _text.substring(i);
        commentOffset = i;
        break;
      }
    }
  }

  LineImpl.copy(LineImpl line)
      : document = line.document,
        _text = line._text,
        lineNo = line.lineNo,
        indent = line.indent,
        lineType = line.lineType,
        missing = line.missing,
        _keyValue = line._keyValue,
        inlineComment = line.inlineComment,
        commentOffset = line.commentOffset;

  LineImpl.missing(this.document, this.lineType)
      : lineNo = -1,
        _text = '',
        indent = 0,
        missing = true;

  /// Creates a line that is ready to be inserted.
  /// It will not have a line number until it has been inserted.
  factory LineImpl.forInsertion(Document document, String text,
      [LineType? lineType]) {
    final line = LineImpl(document, text, -1, lineType);
    return line;
  }

  @override
  late final Document document;

  /// The text content of the line.
  String _text;

  @override
  int lineNo;
  @override
  late int indent;
  @override
  late final LineType lineType;

  @override
  bool missing;

  @override
  String get text => _text;

  // If the [type] is [LineType.key] then this will hold the
  // key/value pair.
  KeyValue? _keyValue;

  // If the line isn't a full line comment but
  // contains an inline comment then the comment is stored here.
  @override
  String? inlineComment;
  // the column the inline comment starts in
  @override
  int? commentOffset;

  /// calculate how far the line is idented.
  /// zero based.
  /// An indentation of 2 characters is returned as indent level 1.
  int _indent(String line) {
    var i = 0;
    for (; i < line.length; i++) {
      final c = line.substring(i, i + 1);
      if (c != ' ') {
        break;
      }
    }
    // we need to ensure that [indent] is initialised before
    // we throw an exception otherwise it will cause a secondary
    // exception due to [indent] being unitialised.
    indent = (i / 2).round();

    if (i.isOdd) {
      throw PubSpecException(this, 'Invalid indent on line $lineNo found $i');
    }
    return indent;
  }

  /// Returns the key/value pair for the line.
  /// If the line is not of [LineType.key] then an exception is thrown.
  KeyValue get keyValue {
    if (lineType != LineType.key) {
      throw PubSpecException(this,
          'Line $lineNo is not a key so you cannot extract a value: $this');
    }

    _keyValue ??= KeyValue.fromLine(this);
    return _keyValue!;
  }

  /// a short hand way of getting the value component
  /// of a line of type [LineType.key].
  /// If the line is not of type [LineType.key] then a [PubSpecException]
  /// is thrown.
  @override
  String get value => keyValue.value;

  set value(String value) {
    if (_keyValue == null) {
      _keyValue = KeyValue(key, value);
    } else {
      _keyValue = keyValue.copy(value: value);
    }
    _text = _keyValue.toString();
  }

  /// a short hand way of getting the key component
  /// of a line of type [LineType.key].
  /// If the line is not of type [LineType.key] then a [PubSpecException]
  /// is thrown.
  @override
  String get key => keyValue.key;

  set key(String key) {
    _keyValue = keyValue.copy(key: key);
    _text = _keyValue.toString();
  }

  /// Find the child of the current line that has the given [key]
  /// Return null if the [key] can't be found.
  LineImpl findKeyChild(String key) => document.findKeyChild(this, key);

  /// Find the child of the current line that has the given [key],
  /// Throw a [PubSpecException] if the key can't be found.
  LineImpl findRequiredKeyChild(String key) {
    if (lineType != LineType.key) {
      throw PubSpecException(
          this, 'This line is not a valid parent for a key ($key)');
    }
    final line = findKeyChild(key);

    if (line.missing) {
      throw PubSpecException(this, 'Missing required child key: $key');
    }

    return line;
  }

  /// Return all the children of the current line.
  /// If [type] is passed then only children of the given type will
  /// be returned.
  /// If [descendants] is true then all descendants are returned
  /// not just the immediate children.
  List<LineImpl> childrenOf({LineType? type, bool descendants = false}) =>
      document.childrenOf(this, type: type, descendants: descendants);

  /// Search for a child that has key that matches one of the
  /// passed [keys].
  /// Returns null if a child with one of the keys is not foun.d
  Line? findOneOf(List<String> keys) {
    final children = childrenOf(type: LineType.key);

    LineImpl? found;
    for (final child in children) {
      if (keys.contains(child.keyValue.key)) {
        if (found != null) {
          throw PubSpecException(this,
              '''Conflicting keys found: ${child.keyValue.key} and ${found.keyValue.key}''');
        }
        found = child;
      }
    }
    return found;
  }

  /// Render the Line as a String suitable to write
  /// back out to the pubspec.yaml
  @override
  String render() {
    String rendered;
    switch (lineType) {
      case LineType.key:
        if (value.isBlank()) {
          rendered = '$_expand$key:';
        } else {
          rendered = '$_expand$key: $value';
        }
        return '$rendered${renderInlineComment(rendered.length)}';
      case LineType.blank:
      case LineType.comment:
      case LineType.indexed:
      case LineType.multiline:
      case LineType.unknown:
        return _text;
    }
  }

  /// If the line has an inline comment the this method
  /// will render the comment.
  String renderInlineComment(int contentLength) {
    if (inlineComment == null) {
      return '';
    }

    return inlineComment!;
  }

  @override
  String toString() => 'Line No: $lineNo Type: ${lineType.name} $_text';

  /// Returns a [indent] * 2 spaces
  String get _expand => expandi(indent);

  /// returns [indent] * 2 spaces.
  static String expandi(int indent) => _spaces(indent * 2);

  static String _spaces(int count) => ' ' * count;

  /// returns the number of spaces to correctly indent
  /// a child of this line.
  String get childIndent => _spaces((indent + 1) * 2);

  static String buildLine(int indent, String key, String? value) {
    final sb = StringBuffer('''${expandi(indent)}$key:''');
    if (Strings.isNotBlank(value)) {
      sb.write(' $value');
    }
    return sb.toString();
  }

  /// If there is whitespace before an inline comment
  /// we want to preserve that whitespace so that
  /// when we write a file out it is identical to what we
  /// read in. So this method returns the whitespace
  /// before the comment.
  String _preserverWhiteSpace(String text, int startOfComment) {
    final whitespace = StringBuffer();
    if (startOfComment == 0) {
      return '';
    }
    var index = startOfComment - 1;

    for (; index > 0; index--) {
      final char = text.substring(index, index + 1);
      if (!Strings.isWhitespace(char)) {
        break;
      }
      whitespace.write(char);
    }
    return whitespace.toString();
  }
}
