part of 'internal_parts.dart';

/// Describes the dart repository that this package is published to.
/// If not set then a publish attempt will publish the package to 'pub.dev'.
/// To stop a package being accidently published you should set the
/// 'publish_to' value to 'none'.
class PublishTo implements Section {
  SectionSingleLine _section;

  String _url;

  static const keyName = 'publish_to';

  static const noneKeyword = 'none';

  /// build PublishTo from an imported document line
  factory PublishTo._fromDocument(Document document) {
    final lineSection = document.getLineForKey(PublishTo.keyName);
    if (lineSection.missing) {
      return PublishTo._missing(document);
    } else {
      return PublishTo._(lineSection.headerLine);
    }
  }

  PublishTo._(LineImpl line)
      : _url = line.value,
        _section = SectionSingleLine.fromLine(line);

  PublishTo._missing(Document document)
      : _url = '',
        _section = SectionSingleLine.missing(document, 0, keyName);

  /// Get the url that this package is published to.
  /// Note: the value can be 'none' which indicates that the package
  /// should never be published.
  /// If publish_to is missing or the url is empty then an
  /// empty string is returned. In this case the package would be
  /// published to the public repo pub.dev.
  String get value => _url;

  /// Set the url of a repository (e.g. https://onepub.dev) that this
  /// package will be published to.
  /// If the url is not set then any publish attempt will cause
  /// the package to be publisehd to the the public repo pub.dev.
  /// To prevent the package from being accidently published set this
  /// value to 'none'.
  PublishTo set(String url) {
    _url = url;
    _section.value = url;
    return this;
  }

  /// Returns true if the publish_to value is set to 'none'
  /// which indicates that the package should not be published.
  bool isNone() => _url == noneKeyword;

  /// Returns true if the publish_to value is missing or is an empty string.
  /// In this case the package would be published to the public repo pub
  bool isPubDev() => _url.isEmpty;

  /// Call this method to prevent the package from being published
  /// by setting the publish_to key to 'none'.
  /// ```dart
  /// final pubspec = PubSpec.load();
  /// pubspec.publishTo.setNone;
  /// pubspec.save();
  /// ```
  PublishTo setNone() {
    _url = noneKeyword;
    _section.value = noneKeyword;
    return this;
  }

  @override
  Comments get comments => _section.comments;

  @override
  List<Line> get lines => _section.lines;

  @override
  bool get missing => _section.missing;
}
