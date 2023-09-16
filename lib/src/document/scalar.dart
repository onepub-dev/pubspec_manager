import '../../eric.dart';
import 'document.dart';
import 'line.dart';

class Scalar {
  Scalar();
  ScalarType? scalarType;

  Chomp? chomp;

  // between 1 and 9
  int indentation = 2;
  // set to true when we see an \
  bool escapeMode = false;

  State state = State.start;

  final StringBuffer _value = StringBuffer();

  /// The resulting string which we accumulate
  /// as we parse lines.
  /// You know the [value] is complete when state
  /// is [State.finalised]
  String get value => _value.toString();

  void processLines(List<Line> lines) {
    // ignore: prefer_foreach
    for (final line in lines) {
      processLine(line);
    }
    finalise();
  }

  void processLine(Line line) {
    final text = line.text;

    for (var i = 0; i < text.length; i++) {
      var c = text.substring(i, i + 1);
      switch (state) {
        case State.start:
          {
            if (c == ':') {
              state = State.postKey;
            }
          }
          break;
        case State.postKey:
          if (c == ' ') {
            continue;
          }

          if (c == '|') {
            scalarType = ScalarType.literal;
          } else if (c == '>') {
            scalarType = ScalarType.folded;
          }
          if (c == '"') {
            state = State.inDoubleQuote;
          } else if (c == "'") {
            state = State.inSingleQuote;
          }
          break;

        /// Single quotes don't support the \ escape operator
        /// but you can escape a single quote by placing two
        /// single quotes.
        case State.inSingleQuote:
          if (c == "'") {
            if (escapeMode) {
              escapeMode = false;
            } else {
              state = State.finalised;
            }
            _value.write(c);
          }

          break;

        // double quotes support escaping with \
        case State.inDoubleQuote:
          if (!escapeMode && c == '"') {
            state = State.finalised;
          }

          /// new lines are transformed into spaces
          /// unless escaped.
          if (!escapeMode && c == '\n') {
            c = ' ';
          }

          if (escapeMode) {
            c = transformEscapedCharacter(c);
          }
          if (c == r'\') {
            escapeMode = true;
            break;
          }
        case State.finalised:
          {
            if (c != ' ' && c != '\n') {
              throw PubSpecException(
                  line, 'Invalid character found after end "$c"');
            }
          }
      }
    }
  }

  void finalise() {
    // single quoted strings are a pain as the
    // single quote acts as a terminator but
    // also an escape character.
    // So when we see the last single quote we
    // don't know its a terminator until we realize
    // that there are no more characters/lines to
    // process.
    if (state == State.inSingleQuote && escapeMode) {
      state = State.finalised;
    }
  }

  /// transform an escaped chacter into
  /// the intended character.
  String transformEscapedCharacter(String c) {
    switch (c) {
      case r'\':
        return r'\';
      case 'n':
        return '\n';
      case "'":
        return c;
      case '"':
        return c;
      case '\n':
        return c;
      default:
        return c;
    }
  }

  void processString(String example) {
    final document = Document.loadFromString(example);
    processLines(document.lines);
  }
}

enum State {
  start,
  postKey,
  inDoubleQuote,
  inSingleQuote,
  finalised;
}

enum ScalarType {
  // replace newlines with spaces
  folded,
  // keep newlines
  literal;
}

/// controls how we treat newlines at the end of the
/// string.
enum Chomp {
  // single newline at end of string
  clip,
  // strip trailing newlines
  strip,
  // keep all new lines.
  keep;
}
