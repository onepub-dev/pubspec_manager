# pubspec_manager

pubspec_manager allows you to read, .modify and write pubspec.yaml files.

Why another pubspec.yaml manipulation file?

As a sometimes maintainer of the pubspec package and the creator of the fork
pubspec2 I've long been unhappy with the usability and maintainability of 
the pubspec package.

There are also a number of other pubspec maintinance packages but none of them
meet all of the criteria. In particualar none of them are able to preserve 
comments.

So the aim of pubspec_manager is to fix three problems

1) simplified API
2) fully type safe code based to ease maintenance
3) preservation of comments when modifying an existing pubspec.yaml
4) abiltity to modify every elment of a pubspec.yaml including comments.


```dart
import 'package:pubspec_manager/pubspec_manager.dart'

void main() {
  Pubspec.fromFile()
    ..name.value = 'new eric'
    ..version.value = '1.0.0-alpha.2'
    ..dependencies
        .append(HostedDependency(name: 'dcli', url: 'https://onepub.dev'))
    ..dependencies.append(PubHostedDependency(name: 'dcli', version: '1.0.0'))
    ..save();
}
```
