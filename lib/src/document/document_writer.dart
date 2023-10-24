import 'dart:io';

import '../../pubspec_manager.dart';
import 'document.dart';
import 'line.dart';
import 'section.dart';

abstract class Writer {
  void init();
  void write(String s) {}
}

class StringWriter implements Writer {
  final _content = StringBuffer();

  @override
  void init() {
    // noop
  }

  @override
  void write(String line) {
    _content.writeln(line);
  }

  String get content => _content.toString();
}

class FileWriter implements Writer {
  FileWriter(this.pathTo) : file = File(pathTo);

  @override
  void init() {
    if (file.existsSync()) {
      file.deleteSync();
    }
  }

  String pathTo;
  File file;

  void close() {}

  @override
  void write(String line) {
    file.writeAsStringSync('$line$_lineTerminator', mode: FileMode.append);
  }

  /// Platform specific line terminator.
  String get _lineTerminator {
    if (Platform.isWindows) {
      return '\r\n';
    } else {
      return '\n';
    }
  }
}

class DocumentWriter {
  DocumentWriter(this.document);
  Document document;
  Map<int, Line> lines = <int, Line>{};

  void writeDoc() {}

  void render(Section? section) {
    if (section == null) {
      return;
    }
    for (final line in section.lines) {
      if (line.missing) {
        continue;
      }
      if (lines.containsKey(line.lineNo)) {
        throw PubSpecException(
            line, 'Oops you found a bug. Duplicate line no ${line.lineNo}');
      }
      lines.putIfAbsent(line.lineNo, () => line);
    }
  }

  /// Write the contents of the pubspec.yaml [writer]
  void write(Writer writer) {
    writer.init();
    final sorted = lines.keys.toList()..sort((a, b) => a - b);

    for (final lineNo in sorted) {
      final line = lines[lineNo];
      writer.write(line!.render());
    }
  }

  /// Any lines which are independent of known keys will not have
  /// been rendered so now we render them verbatum.
  void renderMissing() {
    final missing = <int, Line>{};
    for (var lineNo = 1; lineNo <= document.lines.length; lineNo++) {
      if (lines.containsKey(lineNo)) {
        continue;
      }

      final line = document.lines.elementAt(lineNo - 1);
      missing.putIfAbsent(lineNo, () => line);
    }
    lines.addAll(missing);
  }
}
