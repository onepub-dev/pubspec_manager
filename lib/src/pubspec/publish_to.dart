part of 'internal_parts.dart';

/// Describes the dart repository that this package is published to.
/// If not set then a publish attempt will publish the package to 'pub.dev'.
/// To stop a package being accidently published you should set the
/// 'publish_to' value to 'none'.
class PublishTo implements Section {
  /// build PublishTo from an imported document line
  factory PublishTo._fromDocument(Document document) {
    final lineSection = document.getLineForKey(PublishTo.keyName);
    if (lineSection.missing) {
      return PublishTo.missing(document);
    } else {
      return PublishTo._(lineSection.headerLine);
    }
  }

  PublishTo._(LineImpl line) : _section = SectionSingleLine.fromLine(line);

  PublishTo.missing(Document document)
      : _section = SectionSingleLine.missing(document, 0, keyName);

  SectionSingleLine _section;

  /// Get the url that this package is published to.
  /// Note: the value can be 'none' which indicates that the package
  /// should never be published.
  String get value => _section.value;

  /// Call this method to prevent the package from being published
  /// by setting the publish_to key to 'none'.
  /// ```dart
  /// final pubspec = PubSpec.load();
  /// pubspec.publishTo.none;
  /// pubspec.save();
  /// ```
  PublishTo get none {
    _section.value = noneKeyword;
    // ignore: avoid_returning_this
    return this;
  }

  /// Set the url of a repository (e.g. https://onepub.dev) that this
  /// package will be published to.
  /// If the url is not set then any publish attempt will cause
  /// the package to be publisehd to the the public repo pub.dev.
  /// To prevent the package from being accidently published set this
  /// value to 'none'.
  PublishTo set(String url) {
    _section.value = url;
    // ignore: avoid_returning_this
    return this;
  }

  static const String keyName = 'publish_to';

  static const String noneKeyword = 'none';

  @override
  Comments get comments => _section.comments;

  @override
  List<Line> get lines => _section.lines;

  @override
  bool get missing => _section.missing;
}
