// import 'package:fsm2/fsm2.dart';

// import 'event.dart';
// import 'state.dart';
// import 'yaml_string_parser.dart';

// ///
// /// Build the folding block state machine
// ///
// StateBuilder<FoldingBlock> foldingBlockBuilder(
//         YamlStringParser parser, StateBuilder<FoldingBlock> b) =>
//     b
//       ..state<Folding>((b) => b
//         ..onFork<OnPlusChar>((b) => b..target<TrimKeep>(),
//             sideEffect: (e) async => parser.append(e))
//         ..onFork<OnMinusChar>((b) => b..target<TrimStrip>(),
//             sideEffect: (e) async => parser.append(e))
//         ..on<OnEscapeChar, FoldingEscaping>()
//         ..on<OnSimpleChar, FlowDoubleQuoted>(
//             sideEffect: (e) async => parser.append(e))

//         /// We just saw an escape charater \
//         ..state<FoldingEscaping>((b) => b
//           // nested escape char is just a slash
//           ..on<OnEscapeChar, FlowDoubleQuoted>(
//               sideEffect: (e) async => parser.append(e))
//           ..on<OnSimpleChar, FlowDoubleQuoted>(
//               sideEffect: (e) async => parser.onEscapeChar(e, parser.append))))

//       /// costate
//       ..state<Trim>((b) => b
//         ..on<OnSimpleChar, Trim>(condition: (e) => false)
//         ..state<TrimClip>((b) =>
//             b.on<OnApplyTrim, Trim>(sideEffect: (e) async => parser.clip()))
//         ..state<TrimKeep>((b) => {})
//         ..state<TrimStrip>((b) => {}))

//       /// costate
//       ..state<NewLine>((b) => b
//         ..state<ReplaceNewLines>((b) => b
//           // replace newlines with spaces.
//           ..on<OnNewLine, ReplaceNewLines>(
//               sideEffect: (e) async => parser.append(OnEmitChar(' ')))
//           ..on<OnWhitespace, ReplaceNewLines>(
//               sideEffect: (e) async => parser.append(e)))
//         ..state<KeepNewLines>((b) => {}));
