import 'package:meta/meta.dart';

import '../pubspec_exception.dart';
import 'document.dart';
import 'key_value.dart';
import 'line_type.dart';

// ignore: one_member_abstracts
abstract class Renderer {
  String render();
}

/// Each line read from the pubspec.yaml is stored into a [Line]
/// and categorised into one of the [LineType]s.
class Line implements Renderer {
  /// Construct a Line. Used when reading
  /// a pubspec.yaml line by line (which ultimately we do no matter
  /// how we loaded the pubspec.yaml)
  Line(this.document, this.text, this.lineNo) : missing = false {
    indent = _indent(text);
    final trimmed = text.trimLeft();

    // final lastLine = document.lastLine;

    // if (lastLine != null && lastLine.continues) {
    //   type = LineType.multiline;
    // } else

    // determine line type
    if (trimmed.startsWith('#')) {
      type = LineType.comment;
    } else if (trimmed.startsWith('-')) {
      type = LineType.indexed;
    } else if (trimmed.isEmpty) {
      type = LineType.blank;
    } else {
      type = LineType.key;
    }

    // a comment can't have an inline comment
    // so no further process of the line is required.
    if (type == LineType.comment) {
      return;
    }

    // check for an inline comment.
    // name: fred # an inline comment
    var i = 0;
    commentOffset = 0;
    for (; i < text.length; i++) {
      final c = text.substring(i, i + 1);
      if (c == '#') {
        inlineComment = text.substring(i);
        commentOffset = i;
        break;
      }
    }
  }
  Line.copy(Line line)
      : document = line.document,
        text = line.text,
        lineNo = line.lineNo,
        indent = line.indent,
        type = line.type,
        missing = line.missing,
        _keyValue = line._keyValue,
        inlineComment = line.inlineComment,
        commentOffset = line.commentOffset;

  Line.missing(this.document)
      : lineNo = -1,
        text = '',
        missing = true;

  /// Creates a line that is ready to be inserted.
  /// It will not have a line number until it has been inserted.
  factory Line.forInsertion(Document document, String text) {
    final line = Line(document, text, -1);
    return line;
  }

  @visibleForTesting
  Line.test(this.document, this.text)
      : lineNo = 9999,
        type = LineType.key,
        missing = false;

  late final Document document;

  /// The text content of the line.
  String text;
  int lineNo;
  late int indent;
  late final LineType type;

  bool missing;

  // If the [type] is [LineType.key] then this will hold the
  // key/value pair.
  KeyValue? _keyValue;

  // If the line isn't a full line comment but
  // contains an inline comment then the comment is stored here.
  String? inlineComment;
  // the column the inline comment starts in
  int? commentOffset;

  // bool get continues {
  //   if (text.endsWith('|') || text.endsWith('|>'))

  //   return false;
  // }

  /// calculate how far the line is idented.
  /// zero based.
  /// An indentation of 2 is returned as indent level 1.
  int _indent(String line) {
    var i = 0;
    for (; i < line.length; i++) {
      final c = line.substring(i, i + 1);
      if (c != ' ') {
        break;
      }
    }
    if (i.isOdd) {
      throw PubSpecException(this, 'Invalid indent on line $lineNo found $i');
    }
    return (i / 2).round();
  }

  /// Returns the key/value pair for the line.
  /// If the line is not of [LineType.key] then an exception is thrown.
  KeyValue get keyValue {
    if (type != LineType.key) {
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
  String get value => keyValue.value;

  set value(String value) => _keyValue = keyValue.copy(value: value);

  /// a short hand way of getting the key component
  /// of a line of type [LineType.key].
  /// If the line is not of type [LineType.key] then a [PubSpecException]
  /// is thrown.
  String get key => keyValue.key;

  set key(String key) => _keyValue = keyValue.copy(key: key);

  /// Find the child of the current line that has the given [key]
  /// Return null if the [key] can't be found.
  Line? findKeyChild(String key) => document.findKeyChild(this, key);

  /// Find the child of the current line that has the given [key],
  /// Throw a [PubSpecException] if the key can't be found.
  Line findRequiredKeyChild(String key) {
    if (type != LineType.key) {
      throw PubSpecException(
          this, 'This line is not a valid parent for a key ($key)');
    }
    final line = findKeyChild(key);

    if (line == null) {
      throw PubSpecException(this, 'Missing required child key: $key');
    }

    return line;
  }

  /// Return all the children of the current line.
  /// If [type] is passed then only children of the given type will
  /// be returned.
  /// If [descendants] is true then all descendants are returned
  /// not just he immediate children.
  List<Line> childrenOf({LineType? type, bool descendants = false}) =>
      document.childrenOf(this, type: type, descendants: descendants);

  /// Search for a child that has key that matches one of the
  /// passed [keys].
  /// Returns null if a child with one of the keys is not foun.d
  Line? findOneOf(List<String> keys) {
    final children = childrenOf(type: LineType.key);

    Line? found;
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
    switch (type) {
      case LineType.key:
        rendered = '${' ' * indent * 2}$key: $value';
        return '$rendered${renderInlineComment(rendered.length)}';
      case LineType.blank:
      case LineType.comment:
      case LineType.indexed:
      case LineType.multiline:
      case LineType.unknown:
        return text;
    }
  }

  // String get _indentRender => ' ' * indent * 2;

  /// If the line has an inline comment the this method
  /// will render the comment.
  String renderInlineComment(int contentLength) {
    if (inlineComment == null) {
      return '';
    }
    final space = commentOffset! - contentLength - 1;

    return "${' ' * space} ${inlineComment!}";
  }

  @override
  String toString() => 'Line No: $lineNo Type: ${type.name} $text';
}
