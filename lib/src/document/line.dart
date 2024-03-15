part of '../pubspec/internal_parts.dart';

// ignore: one_member_abstracts
abstract class Renderer {
  String render();
}

abstract class Line {
  Document get document;

  String get text;

  int get lineNo;

  int get indent;

  LineType get lineType;

  bool get missing;

  String get key;

  String get value;

  String? get inlineComment;

  int? get commentOffset;

  String render();
}
