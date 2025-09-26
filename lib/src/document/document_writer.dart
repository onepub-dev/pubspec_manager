part of '../pubspec/internal_parts.dart';

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
  String pathTo;

  io.File file;

  FileWriter(this.pathTo) : file = io.File(pathTo);

  @override
  void init() {
    if (file.existsSync()) {
      file.deleteSync();
    }
  }

  void close() {}

  @override
  void write(String line) {
    file.writeAsStringSync('$line$_lineTerminator', mode: io.FileMode.append);
  }

  /// Platform specific line terminator.
  String get _lineTerminator {
    if (io.Platform.isWindows) {
      return '\r\n';
    } else {
      return '\n';
    }
  }
}

class DocumentWriter {
  Document document;

  final lines = <int, LineImpl>{};

  DocumentWriter(this.document);

  void writeDoc() {}

  void render(Section? section) {
    if (section == null) {
      return;
    }
    for (final line in section.lines) {
      final lineImpl = line as LineImpl;
      if (lineImpl.missing) {
        continue;
      }
      if (lines.containsKey(lineImpl.lineNo)) {
        throw PubSpecException(lineImpl,
            'Oops you found a bug. Duplicate line no ${line.lineNo}');
      }
      lines.putIfAbsent(line.lineNo, () => lineImpl);
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
    final missing = <int, LineImpl>{};
    for (var lineNo = 1; lineNo <= document._lines.length; lineNo++) {
      if (lines.containsKey(lineNo)) {
        continue;
      }

      final line = document._lines.elementAt(lineNo - 1);
      missing.putIfAbsent(lineNo, () => line);
    }
    lines.addAll(missing);
  }
}
