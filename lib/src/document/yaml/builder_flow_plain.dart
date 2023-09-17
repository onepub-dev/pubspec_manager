import 'package:fsm2/fsm2.dart';

import 'event.dart';
import 'state.dart';
import 'yaml_string_parser.dart';

///
/// Build the Plain Flow state machine
///
StateBuilder<FlowPlain> flowPlainBuilder(
        YamlStringParser parser, StateBuilder<FlowPlain> b) =>
    b
      ..on<OnEscapeChar, PlainEscaping>()
      ..on<OnSimpleChar, FlowPlain>(sideEffect: (e) async => parser.append(e))
      ..on<OnWhitespace, FlowPlain>(sideEffect: (e) async => parser.append(e))
      ..on<OnNewLine, FlowPlain>(sideEffect: (e) async => parser.append(e))
      ..on<OnDoubleQuoteChar, Finished>(
          sideEffect: (e) async => parser.append(e))
      ..on<OnFinish, Finished>()

      /// We just saw an escape charater \
      ..state<PlainEscaping>((b) => b
        // nested escape char is just a slash
        ..on<OnEscapeChar, FlowPlain>(sideEffect: (e) async => parser.append(e))
        ..on<OnSimpleChar, FlowPlain>(
            sideEffect: (e) async => parser.onEscapeChar(e, parser.append)));
