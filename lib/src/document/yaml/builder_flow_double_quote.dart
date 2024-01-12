import 'package:fsm2/fsm2.dart';

import 'event.dart';
import 'state.dart';
import 'yaml_string_parser.dart';

///
/// build the double quote state machien
///
StateBuilder<FlowDoubleQuoted> doubleQuoteBuilder(
        YamlStringParser parser, StateBuilder<FlowDoubleQuoted> b) =>
    b
      ..onEnter((fromState, e) async => parser.append(OnEmitChar('"')))
      ..on<OnEscapeChar, DoubleQuotedEscaping>()
      ..on<OnSimpleChar, FlowDoubleQuoted>(
          sideEffect: (e) async => parser.append(e))
      ..on<OnWhitespace, FlowDoubleQuoted>(
          sideEffect: (e) async => parser.append(e))
      ..on<OnDoubleQuoteChar, Finished>(
          sideEffect: (e) async => parser.append(e))

      /// We just saw an escape charater \
      ..state<DoubleQuotedEscaping>((b) => b
        // nested escape char is just a slash
        ..on<OnEscapeChar, FlowDoubleQuoted>(
            sideEffect: (e) async => parser.append(e))
        ..on<OnSimpleChar, FlowDoubleQuoted>(
            sideEffect: (e) async => parser.onEscapeChar(e, parser.append)));
