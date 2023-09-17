import 'package:eric/src/document/document.dart';
import 'package:eric/src/document/line.dart';
import 'package:eric/src/document/line_type.dart';
import 'package:test/test.dart';

void main() {
  test('document ...', () async {
    const pubspec = '''
name: pubspec3
version: 0.0.1
description: A simple command-line application created by dcli
environment: 
  sdk: '>=2.19.0 <3.0.0'
dependencies: 
  dcli: 2.3.0
  dcli_core: 2.3.0
dev_dependencies: 
  lint_hard: ^3.0.0
  test: ^1.24.6
# a comment
key:
  # comment
  subKey: #inline comment
''';

    final document = Document.loadFromString(pubspec);

    final lines = document.lines;

    var index = 1;

    checkLine(lines, indent: 0, lineNo: index++, lineType: LineType.key);
    checkLine(lines, indent: 0, lineNo: index++, lineType: LineType.key);
    checkLine(lines, indent: 0, lineNo: index++, lineType: LineType.key);
    checkLine(lines, indent: 0, lineNo: index++, lineType: LineType.key);
    checkLine(lines, indent: 1, lineNo: index++, lineType: LineType.key);
    checkLine(lines, indent: 0, lineNo: index++, lineType: LineType.key);
    checkLine(lines, indent: 1, lineNo: index++, lineType: LineType.key);
    checkLine(lines, indent: 1, lineNo: index++, lineType: LineType.key);
    checkLine(lines, indent: 0, lineNo: index++, lineType: LineType.key);
    checkLine(lines, indent: 1, lineNo: index++, lineType: LineType.key);
    checkLine(lines, indent: 1, lineNo: index++, lineType: LineType.key);
    checkLine(lines, indent: 0, lineNo: index++, lineType: LineType.comment);
    checkLine(lines, indent: 0, lineNo: index++, lineType: LineType.key);
    checkLine(lines, indent: 1, lineNo: index++, lineType: LineType.comment);
    checkLine(lines,
        indent: 1,
        lineNo: index++,
        lineType: LineType.key,
        inline: '#inline comment',
        inlineIndex: 10);
  });
}

void checkLine(List<Line> lines,
    {required int indent,
    required int lineNo,
    required LineType lineType,
    String? inline,
    int? inlineIndex}) {
  final line = lines[lineNo - 1];
  expect(line.indent, equals(indent));
  expect(line.lineNo, equals(lineNo));
  expect(line.type, equals(lineType));

  if (inline != null) {
    expect(line.inlineComment, equals(inline));
    expect(line.commentOffset, equals(inlineIndex));
  }
}
