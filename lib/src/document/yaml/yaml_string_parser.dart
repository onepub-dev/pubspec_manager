// import 'package:fsm2/fsm2.dart';

// import 'builder_flow_double_quote.dart';
// import 'builder_flow_plain.dart';
// import 'builder_flow_single_quote.dart';
// import 'builder_folding_block.dart';
// import 'event.dart';
// import 'state.dart';

// ///
// /// Parser a yaml scalar string such as the 'description'
// /// in a pubspec.yaml file.
// /// ```dart
// /// var parser = await YamlStringParser.build();
// ///
// /// while (hasLines) {
// ///   parser.parseLine(line);
// /// }
// ///
// /// await parser.complete;
// /// var result = parser.result;
// /// ```
// class YamlStringParser {
//   YamlStringParser._internal();

//   late final StateMachine machine;
//   var _result = StringBuffer();

//   String get result => _result.toString();

//   Future<void> get complete => machine.complete;

//   static Future<YamlStringParser> build() async {
//     final parser = YamlStringParser._internal();
//     await parser._init();
//     return parser;
//   }

//   Future<void> _init() async {
//     machine = await _buildMachine();
//   }

//   /// Parse a complete scalar string contained in [content]
//   /// returning the parsed results.
//   Future<String> parseString(String content) async {
//     /// send stream to state machine
//     for (final c in content.codeUnits) {
//       final charType = classify(c);
//       machine.applyEvent(charType);
//     }

//     await machine.complete;
//     return _result.toString();
//   }

//   /// Parser a scalar string by passing in
//   /// one line in a time.
//   Future<void> parseLine(String line) async {
//     /// send stream to state machine
//     for (final c in line.codeUnits) {
//       final charType = classify(c);
//       machine.applyEvent(charType);
//     }
//   }

//   /// This method must be called once all characters have been
//   /// processed to give the parser a chance to perform cleanup
//   /// such as the Clip processing required by flow blocks.
//   void finalise() {
//     machine.applyEvent(OnFinish());
//   }

//   /// Build the FSM to parse yaml scalar strings
//   Future<StateMachine> _buildMachine() async => StateMachine.create((g) => g
//     ..initialState<Start>()
//     ..state<Start>((b) => b
//       // allow leading whitespace.
//       ..on<OnWhitespace, Start>()
//       // a non-special character as the first char means we have a plain flow
//       ..on<OnSimpleChar, FlowPlain>(sideEffect: (e) async => append(e))
//       // a double quote as the first character means a double quoted flow
//       ..on<OnDoubleQuoteChar, FlowDoubleQuoted>()
//       // a single quote as the first character means a single quoted flow
//       ..on<OnSingleQuoteChar, FlowSingleQuoted>()
//       // a '>' as the first character means a block where we replace newlines
//       // with spaces.
//       ..onFork<OnBlockReplaceChar>(
//           (b) => b
//             ..target<FoldingBlock>()
//             ..target<ReplaceNewLines>()
//             ..target<TrimClip>(),
//           sideEffect: (e) async => append(e))
//       // a '|' as the first character means a block where we keep newlines
//       ..onFork<OnBlockKeepChar>(
//           (b) => b
//             ..target<FoldingBlock>()
//             ..target<KeepNewLines>()
//             ..target<TrimClip>(),
//           sideEffect: (e) async => append(e)))
//     ..state<Finished>((b) {})

//     /// Flow Plain - Unquoted String
//     ..state<FlowPlain>((b) => flowPlainBuilder(this, b))

//     /// Double quoted String
//     ..state<FlowDoubleQuoted>((b) => doubleQuoteBuilder(this, b))

//     /// Single quoted string
//     ..state<FlowSingleQuoted>((b) => singleQuoteBuilder(this, b))

//     /// Folding Block
//     ..coregion<FoldingBlock>((b) => foldingBlockBuilder(this, b))
//     ..onTransition((fromState, event, toState) => print(
//         '''Transition: $event : ${fromState!.stateType} 
//-> ${toState!.stateType} : ^$_result^''')));

//   ///
//   /// We have seen an escape character so decided
//   /// how to process the following char.
//   void onEscapeChar(OnChar char, void Function(OnChar p1) append) {
//     /// \n is translated to a space.
//     if (char.asString == 'n') {
//       append(OnEmitChar(' '));
//     } else {
//       // all other chacters are output verbatum.
//       append(char);
//     }
//   }

//   void export(String path) {
//     machine.export(path);
//   }

//   void clip() {
//     if (_result.isEmpty) {
//       return;
//     }
//     // int count = 0;
//     // var content = result.toString();
//     // int index  = content.length;
//     // for (var char in content.substring(length - 2, length -1).)
//     // {

//     // }
//   }

//   void removeLast() {
//     // remove the last character
//     _result = StringBuffer(_result.toString()
//.substring(0, _result.length - 1));
//   }

//   void append(OnChar e) {
//     _result.writeCharCode(e.character);
//   }

//   /// replace the preceeding character with the [replacement]
//   void replace(OnChar replacement) {
//     removeLast();
//     // add the replacment character in its place
//     _result.writeCharCode(replacement.character);
//   }
// }
