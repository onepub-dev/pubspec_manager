import '../pubspec/internal_parts.dart';

class KeyValue {
  late final String key;

  late final String value;

  KeyValue(this.key, this.value);

  factory KeyValue.fromLine(LineImpl line) {
    var content = line.text;
    if (line.inlineComment != null) {
      content = content.substring(0, line.commentOffset);
    }

    try {
      return KeyValue.fromText(content);
    } on PubSpecException catch (e) {
      throw PubSpecException(line, e.message);
    }
  }

  KeyValue.fromText(String text) {
    final delimiter = text.indexOf(':');

    if (delimiter == -1) {
      throw PubSpecException(
          null, 'Line contained invalid key format - missing colon(:)');
    }
    key = text.substring(0, delimiter).trim();
    value = text.substring(delimiter + 1).trim();
  }

  KeyValue copy({String? key, String? value}) =>
      KeyValue(key ?? this.key, value ?? this.value);

  @override
  String toString() => '$key: $value';
}
