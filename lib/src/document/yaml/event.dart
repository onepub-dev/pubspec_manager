import 'package:fsm2/fsm2.dart';

/// Classify a character into an event type.
Event classify(int c) {
  if (c == codeUnit('"')) {
    return OnDoubleQuoteChar(c);
  } else if (c == codeUnit("'")) {
    return OnSingleQuoteChar(c);
  } else if (c == codeUnit(r'\')) {
    return OnEscapeChar(c);
  } else if (c == codeUnit('>')) {
    return OnBlockReplaceChar(c);
  } else if (c == codeUnit('|')) {
    return OnBlockKeepChar(c);
  } else if (c == codeUnit(' ')) {
    return OnWhitespace(c);
  } else if (c == codeUnit('\n')) {
    return OnNewLine(c);
  }

  return OnSimpleChar(c);
}

int codeUnit(String char) => char.codeUnitAt(0);

class OnSingleQuoteChar extends OnChar {
  OnSingleQuoteChar(super.character);
}

class OnDoubleQuoteChar extends OnChar {
  OnDoubleQuoteChar(super.character);
}

class OnEscapeChar extends OnChar {
  OnEscapeChar(super.character);
}

// >
class OnBlockReplaceChar extends OnChar {
  OnBlockReplaceChar(super.character);
}

// |
class OnBlockKeepChar extends OnChar {
  OnBlockKeepChar(super.character);
}

class OnPlusChar extends OnChar {
  OnPlusChar(super.character);
}

class OnMinusChar extends OnChar {
  OnMinusChar(super.character);
}

class OnSimpleChar extends OnChar {
  OnSimpleChar(super.character);
}

class OnNewLine extends OnChar {
  OnNewLine(super.character);
}

class OnWhitespace extends OnSimpleChar {
  OnWhitespace(super.character);
}

/// Emmitted after the parser reads the last charcter in the input.
class OnFinish extends OnSimpleChar {
  OnFinish() : super(0);
}

/// Little bit of a hack when we need
/// to pass an alternate character to
/// the append function.
class OnEmitChar extends OnChar {
  OnEmitChar(String character) : super(character.codeUnitAt(0));
}

/// Once we enter the finish state emit the [OnApplyTrim] to
/// cleanup the trailing newlines based on the [Trim] state.
class OnApplyTrim extends Event {}

class OnChar extends Event {
  OnChar(this.character);
  int character;

  String get asString => String.fromCharCode(character);

  @override
  // ignore: no_runtimetype_tostring
  String toString() => '$runtimeType: $asString';
}
