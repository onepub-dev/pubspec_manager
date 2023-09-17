import 'package:fsm2/fsm2.dart';

import 'event.dart';
import 'state.dart';
import 'yaml_string_parser.dart';

///
/// Build the single quote state machine
///
StateBuilder<FlowSingleQuoted> singleQuoteBuilder(
        YamlStringParser parser, StateBuilder<FlowSingleQuoted> b) =>
    b
      ..on<OnWhitespace, FlowSingleQuoted>(
          sideEffect: (e) async => parser.append(e))
      ..on<OnSimpleChar, FlowSingleQuoted>(
          sideEffect: (e) async => parser.append(e))
      // escape char \ means nothing for singlquoted flwos.
      ..on<OnEscapeChar, FlowSingleQuoted>(
          sideEffect: (e) async => parser.append(e))
      ..on<OnNewLine, StartOfLine>(
          // a single newline is replaced with a space
          sideEffect: (e) async => parser.append(OnEmitChar(' ')))
      ..state<StartOfLine>((b) => b
        // two newlines in a row causes us to emit an actual newline.
        // but we need to remove the original inserted space.
        ..on<OnNewLine, StartOfLine>(
            sideEffect: (e) async => parser.replace(OnEmitChar('\n')))
        // ignore whitespace at start of a line.
        ..on<OnWhitespace, WhiteSpace>()
        ..on<OnSimpleChar, FlowSingleQuoted>(
            sideEffect: (e) async => parser.append(e))
        ..state<WhiteSpace>((b) => b
          ..on<OnWhitespace, WhiteSpace>()
          ..on<OnSimpleChar, FlowSingleQuoted>(
              sideEffect: (e) async => parser.append(e)))
        // a final newline is not retained and since we emmited a space
        // when we saw the newline we need to remove it.
        ..on<OnFinish, Finished>(sideEffect: (e) async => parser.removeLast()))

      // could be the end of the string or a pair of single
      // quotes which is an escaped quote
      ..on<OnSingleQuoteChar, PossibleQuoteEscape>()
      ..state<PossibleQuoteEscape>((b) => b
        // two quotes in a row so we emit this one.
        ..on<OnSingleQuoteChar, FlowSingleQuoted>(
            sideEffect: (e) async => parser.append(e))
        // a trialing single quote so remove it.
        ..on<OnFinish, Finished>());
