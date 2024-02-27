

// void main() {
//   group('name  ...', () {
//     test('create', () async {
//       await create(
//           get: (pubspec) => pubspec.name.value,
//           set: (pubspec, value) => pubspec.name.value = value,
//           key: Name.keyName,
//           value: 'new_name');

//       await update(
//           set: (pubspec, value) => pubspec.publishTo.set(value),
//           get: (pubspec) => pubspec.name.value,
//           key: PublishTo.keyName,
//           value: 'old_name',
//           newValue: 'new_name');
//     });
//   });
// }
