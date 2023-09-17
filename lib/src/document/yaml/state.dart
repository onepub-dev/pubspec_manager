import 'package:fsm2/fsm2.dart';

class Start extends State {}

class Finished extends State {}

class FlowPlain extends State {}

class FlowDoubleQuoted extends State {}

class FlowSingleQuoted extends State {}

class DoubleQuotedEscaping extends State {}

class SingleQuotedEscaping extends State {}

class PossibleQuoteEscape extends State {}

class Folding extends State {}

class FoldingBlock extends State {}

class NewLine extends State {}

class KeepNewLines extends State {}

class ReplaceNewLines extends State {}

class StartOfLine extends State {}

class WhiteSpace extends State {}

/// Controls how we process newlines at the end
/// of the string
class Trim extends State {}

// keep a single trailing  newline
class TrimClip extends State {}

/// strip all trailing new lines
class TrimStrip extends State {}

/// Keep all trailing newlines
class TrimKeep extends State {}

class FoldingEscaping extends State {}

class PlainEscaping extends State {}
