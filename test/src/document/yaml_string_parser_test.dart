// import 'package:pubspec_manager/src/document/yaml/state.dart';
// import 'package:pubspec_manager/src/document/yaml/yaml_string_parser.dart';
import 'package:test/test.dart';

void main() {
  test('no op', () {
// just stop the test driver complaining.
    expect(true, isTrue);
  });
}
// void main() {
//   test('yaml scalar', () async {
//     final parser = await YamlStringParser.build();
//     final machine = parser.machine;

//     const doubleQuoted = r'''"Hello \\ World\n"''';
//     final result = await parser.parseString(doubleQuoted);

//     expect(result, r'''"Hello \ World "''');
//     expect(await machine.isInState<Finished>(), isTrue);
//   }, skip: true);

//   /// from: https://yaml-multiline.info/
//   test('folding block, clip, 2spaces', () async {
//     const input = '''
// >
//   Several lines of text,\n
//   with some "quotes" of various 'types',\n
//   and also a blank line:\n
//   \n
//   and some text with\n
//   ··extra indentation\n
//   on the next line,\n
//   plus another line at the end.\n
//   \n
//   \n
// ''';

//     const expected = '''
// >
// Several lines of text, with some "quotes" of various 'types', and also a blank line:\n
// and some text with\n
//   extra indentation\n
// on the next line, plus another line at the end.\n
// ''';
//     await doTest(input, expected);

//     /// For the moment we are taking the easy route and not parsing the scaler.
//   }, skip: true);
// }

// Future<void> doTest(String input, String expected) async {
//   final parser = await YamlStringParser.build();
//   final machine = parser.machine;

//   final result = await parser.parseString(input);

//   expect(result, expected);
//   expect(machine.isInState<Finished>(), isTrue);
// }

// // void append(OnChar e, StringBuffer sb) {
// //   sb.writeCharCode(e.character);
// // }

// // Future<(StateMachine, String)> parseString(String input) async {
// //   final sb = StringBuffer();
// //   final machine = await buildMachine((e) => append(e, sb));

// //   /// send stream to state machine
// //   for (final c in input.codeUnits) {
// //     final charType = classify(c);
// //     machine.applyEvent(charType);
// //   }

// //   await machine.complete;
// //   return (machine, sb.toString());
// // }

// // /// Build the FSM to parse yaml scalar strings
// // Future<StateMachine> buildMachine(void Function(OnChar) append) async =>
// //     StateMachine.create((g) => g
// //       ..initialState<Start>()
// //       ..state<Start>((b) => b
// //         // allow leading whitespace.
// //         ..on<OnSimpleChar, Start>(
// //             condition: (e) => e.asString == '' || e.asString == '\t')
// //         // a non-special character as the first char means we have a plain flow
// //         ..on<OnSimpleChar, FlowPlain>(sideEffect: (e) async => append(e))
// //         // a double quote as the first character means a double quoted flow
// //         ..on<OnDoubleQuoteChar, FlowDoubleQuoted>(
// //             sideEffect: (e) async => append(e))
// //         // a double quote as the first character means a double quoted flow
// //         ..on<OnSingleQuoteChar, FlowSingleQuoted>(
// //             sideEffect: (e) async => append(e))
// //         // a '>' as the first character means a block where we replace newlines
// //         // with spaces.
// //         ..onFork<OnBlockReplaceChar>(
// //             (b) => b
// //               ..target<FoldingBlock>()
// //               ..target<ReplaceNewLines>()
// //               ..target<TrimClip>(),
// //             sideEffect: (e) async => append(e))
// //         // a '|' as the first character means a block where we keep newlines
// //         ..onFork<OnBlockKeepChar>(
// //             (b) => b
// //               ..target<FoldingBlock>()
// //               ..target<KeepNewLines>()
// //               ..target<TrimClip>(),
// //             sideEffect: (e) async => append(e)))
// //       ..state<Finished>((b) {})

// //       /// Flow Plain - Unquoted String
// //       ..state<FlowPlain>((b) => flowPlainBuilder(b, append))

// //       /// Double quoted String
// //       ..state<FlowDoubleQuoted>((b) => doubleQuoteBuilder(b, append))

// //       /// Single quoted string
// //       ..state<FlowSingleQuoted>((b) => singleQuoteBuilder(b, append))

// //       /// Folding Block
// //       ..coregion<FoldingBlock>((b) => foldingBlockBuilder(b, append))
// //       ..onTransition(
// //           // ignore: avoid_print
// //           (fromState, event, toState)
// //  => print('$fromState $event $toState ')));

// // ///
// // /// Build the Plain Flow state machine
// // ///
// // StateBuilder<FlowPlain> flowPlainBuilder(
// //         StateBuilder<FlowPlain> b, void Function(OnChar) append) =>
// //     b
// //       ..on<OnEscapeChar, PlainEscaping>()
// //       ..on<OnSimpleChar, FlowDoubleQuoted>(sideEffect: (e) async
// //=> append(e))
// //       ..on<OnDoubleQuoteChar, Finished>(sideEffect: (e) async => append(e))

// //       /// We just saw an escape charater \
// //       ..state<PlainEscaping>((b) => b
// //         // nested escape char is just a slash
// //         ..on<OnEscapeChar, FlowDoubleQuoted>(sideEffect: (e) async
// //=> append(e))
// //         ..on<OnSimpleChar, FlowDoubleQuoted>(
// //             sideEffect: (e) async => onEscapeChar(e, append)));

// // ///
// // /// Build the single quote state machine
// // ///
// // StateBuilder<FlowSingleQuoted> singleQuoteBuilder(
// //         StateBuilder<FlowSingleQuoted> b, void Function(OnChar) append) =>
// //     b
// //       ..on<OnEscapeChar, SingleQuotedEscaping>()
// //       ..state<SingleQuotedEscaping>((b) => b
// //         // nested escape char is just a slash
// //         ..on<OnEscapeChar, FlowSingleQuoted>(
// //             sideEffect: (e) async => append(e)))
// //       ..on<OnSingleQuoteChar, Finished>();

// // ///
// // /// build the double quote state machien
// // ///
// // StateBuilder<FlowDoubleQuoted> doubleQuoteBuilder(
// //         StateBuilder<FlowDoubleQuoted> b, void Function(OnChar) append) =>
// //     b
// //       ..on<OnEscapeChar, DoubleQuotedEscaping>()
// //       ..on<OnSimpleChar, FlowDoubleQuoted>(sideEffect: (e) async
// //=> append(e))
// //       ..on<OnDoubleQuoteChar, Finished>(sideEffect: (e) async => append(e))

// //       /// We just saw an escape charater \
// //       ..state<DoubleQuotedEscaping>((b) => b
// //         // nested escape char is just a slash
// //         ..on<OnEscapeChar, FlowDoubleQuoted>(sideEffect: (e) async
// //=> append(e))
// //         ..on<OnSimpleChar, FlowDoubleQuoted>(
// //             sideEffect: (e) async => onEscapeChar(e, append)));

// // ///
// // /// Build the folding block state machine
// // ///
// // StateBuilder<FoldingBlock> foldingBlockBuilder(
// //         StateBuilder<FoldingBlock> b, void Function(OnChar) append) =>
// //     b
// //       ..state<Folding>((b) => b
// //         ..onFork<OnPlusChar>((b) => b..target<TrimKeep>(),
// //             sideEffect: (e) async => append(e))
// //         ..onFork<OnMinusChar>((b) => b..target<TrimStrip>(),
// //             sideEffect: (e) async => append(e))
// //         ..on<OnEscapeChar, FoldingEscaping>()
// //         ..on<OnSimpleChar, FlowDoubleQuoted>(sideEffect: (e) async
// //=> append(e))

// //         /// We just saw an escape charater \
// //         ..state<FoldingEscaping>((b) => b
// //           // nested escape char is just a slash
// //           ..on<OnEscapeChar, FlowDoubleQuoted>(
// //               sideEffect: (e) async => append(e))
// //           ..on<OnSimpleChar, FlowDoubleQuoted>(
// //               sideEffect: (e) async => onEscapeChar(e, append))))

// //       /// costate
// //       ..state<Trim>((b) => b
// //         ..on<OnSimpleChar, Trim>(sideEffect: (e) async => append(e))
// //         ..state<TrimClip>((b) =>
// //             b.on<OnApplyTrim, Trim>(sideEffect: (e) async
// //=> TrimClip.trim()))
// //         ..state<TrimKeep>((b) => {})
// //         ..state<TrimStrip>((b) => {}))

// //       /// costate
// //       ..state<NewLine>((b) => b
// //         ..state<ReplaceNewLines>((b) => {})
// //         ..state<KeepNewLines>((b) => {}));

// // ///
// // /// We have seen an escape character so decided
// // /// how to process the following char.
// // void onEscapeChar(OnChar char, void Function(OnChar p1) append) {
// //   /// \n is translated to a space.
// //   if (char.asString == 'n') {
// //     append(OnEmitChar(' '));
// //   } else {
// //     // all other chacters are output verbatum.
// //     append(char);
// //   }
// // }

// // Event classify(int c) {
// //   if (c == '"'.codeUnitAt(0)) {
// //     return OnDoubleQuoteChar(c);
// //   } else if (c == "'".codeUnitAt(0)) {
// //     return OnSingleQuoteChar(c);
// //   } else if (c == r'\'.codeUnitAt(0)) {
// //     return OnEscapeChar(c);
// //   } else if (c == '>'.codeUnitAt(0)) {
// //     return OnBlockReplaceChar(c);
// //   } else if (c == '|'.codeUnitAt(0)) {
// //     return OnBlockKeepChar(c);
// //   }

// //   return OnSimpleChar(c);
// // }

// // class Start extends State {}

// // class Finished extends State {}

// // class FlowPlain extends State {}

// // class FlowDoubleQuoted extends State {}

// // class FlowSingleQuoted extends State {}

// // class DoubleQuotedEscaping extends State {}

// // class SingleQuotedEscaping extends State {}

// // class Folding extends State {}

// // class FoldingBlock extends State {}

// // class NewLine extends State {}

// // class KeepNewLines extends State {}

// // class ReplaceNewLines extends State {}

// // /// Controls how we process newlines at the end
// // /// of the string
// // class Trim extends State {}

// // // keep a single trailing  newline
// // // ignore: avoid_classes_with_only_static_members
// // class TrimClip extends State {
// //   static void trim() {}
// // }

// // /// strip all trailing new lines
// // class TrimStrip extends State {}

// // /// Keep all trailing newlines
// // class TrimKeep extends State {}

// // class FoldingEscaping extends State {}

// // class PlainEscaping extends State {}

// // class OnSingleQuoteChar extends OnChar {
// //   OnSingleQuoteChar(super.character);
// // }

// // class OnDoubleQuoteChar extends OnChar {
// //   OnDoubleQuoteChar(super.character);
// // }

// // class OnEscapeChar extends OnChar {
// //   OnEscapeChar(super.character);
// // }

// // // >
// // class OnBlockReplaceChar extends OnChar {
// //   OnBlockReplaceChar(super.character);
// // }

// // // |
// // class OnBlockKeepChar extends OnChar {
// //   OnBlockKeepChar(super.character);
// // }

// // class OnPlusChar extends OnChar {
// //   // ignore: unreachable_from_main
// //   OnPlusChar(super.character);
// // }

// // class OnMinusChar extends OnChar {
// //   // ignore: unreachable_from_main
// //   OnMinusChar(super.character);
// // }

// // class OnSimpleChar extends OnChar {
// //   OnSimpleChar(super.character);
// // }

// // /// Little bit of a hack when we need
// // /// to pass an alternate character to
// // /// the append function.
// // class OnEmitChar extends OnChar {
// //   OnEmitChar(String character) : super(character.codeUnitAt(0));
// // }

// // /// Once we enter the finish state emit the [OnApplyTrim] to
// // /// cleanup the trailing newlines based on the [Trim] state.
// // class OnApplyTrim extends Event {}

// // class OnChar extends Event {
// //   OnChar(this.character);
// //   int character;

// //   String get asString => String.fromCharCode(character);

// //   @override
// //   // ignore: no_runtimetype_tostring
// //   String toString() => '$runtimeType: $asString';
// // }
