import 'funding_link.dart';
import 'internal_parts.dart';

/// Used to hold the list of [FundingLink]s under 'FundingLinks' key.
/// To add additinal FundingLinks use:
///
/// ```dart
/// final pubspec = PubSpecl.load();
/// pubspec.FundingLinks.add(name: 'test');
/// pubspec.save();
/// ```
class FundingLinks implements Section {
  FundingLinks._missing(PubSpec pubspec)
      : _pubspec = pubspec,
        _section = SectionImpl.missing(pubspec.document, keyName);

  FundingLinks._fromLine(PubSpec pubspec, LineImpl headerLine)
      : _pubspec = pubspec,
        _section = SectionImpl.fromLine(headerLine);

  final PubSpec _pubspec;

  final SectionImpl _section;

  final _FundingLinks = <FundingLink>[];

  /// List of the FundingLinks
  List<FundingLink> get list => List.unmodifiable(_FundingLinks);

  /// the number of FundingLinks in this section
  int get length => _FundingLinks.length;

  /// returns the [FundingLink] with the given [name]
  /// if it exists in this section.
  /// Returns null if it doesn't exist.
  FundingLink? operator [](String name) {
    for (final FundingLink in _FundingLinks) {
      if (FundingLink.name == name) {
        return FundingLink;
      }
    }
    return null;
  }

  /// Add an FundingLink to the PubSpec.
  ///
  FundingLinks add({required String name, String? script}) {
    _ensure();
    final FundingLink = FundingLinkBuilder(name: name, script: script);
    var lineBefore = _section.headerLine;

    if (missing) {
      // create the section.
      lineBefore = _section.document.append(LineDetached('$keyName:'));
    } else {
      if (_FundingLinks.isNotEmpty) {
        lineBefore = _FundingLinks.last._section.headerLine;
      }
    }
    final attached = FundingLink._attach(_pubspec, lineBefore);

    _FundingLinks.add(attached);

    // ignore: avoid_returning_this
    return this;
  }

  /// Ensure that the FundingLink section has been created
  /// by creating it if it doesn't exist.
  void _ensure() {
    if (missing) {
      _section.headerLine = _section.document.append(LineDetached('$keyName:'));
    }
  }

  void _appendAttached(FundingLink attached) {
    _FundingLinks.add(attached);
  }

  /// Remove an FundingLink from the list of FundingLinks
  /// Throws a [FundingLinkNotFound] exception if the
  /// FundingLink doesn't exist.
  void remove(String name) {
    final FundingLink = this[name];

    if (FundingLink == null) {
      throw FundingLinkNotFound(
          _pubspec.document, '$name not found in the $name section');
    }

    _remove(FundingLink);
  }

  void _remove(FundingLink FundingLink) {
    _FundingLinks.remove(FundingLink);
    final lines = FundingLink.lines;
    _pubspec.document.removeAll(lines);
  }

  /// Remove all FundingLinks from the list.
  void removeAll() {
    for (final FundingLink in list.reversed) {
      _remove(FundingLink);
    }
  }

  /// returns true if the list of FundingLinks contains an FundingLink
  /// with the given name.
  bool exists(String name) => this[name] != null;

  static const String keyName = 'FundingLinks';

  @override
  Comments get comments => _section.comments;

  @override
  List<Line> get lines => _section.lines;

  @override
  bool get missing => _section.missing;
}
