# Contributing to Daf++

:+1::tada: First off, thanks for taking the time to contribute! :tada::+1:

The following is a set of guidelines for contributing to Daf++, which are hosted in the [CAPSLOCK Organization](https://github.com/capslock-bmdc) on GitHub. These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

## Code of Conduct
This project and everyone participating in it is governed by the [CAPSLOCK Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to [capslock.bmdc@gmail.com](mailto:capslock.bmdc@gmail.com).

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check if the problem has already been reported. as you might find out that you don't need to create one. If it has **and the issue is still open**, add a comment to the existing issue instead of opening a new one. When you are creating a bug report, please include as many details as possible.

### Suggesting Enhancements

Before creating enhancement suggestions, please check  if the enhancement has already been suggested as you might find out that you don't need to create one. When you are creating an enhancement suggestion, please include as many details as possible.

### Your First Code Contribution

Unsure where to begin contributing? You can start by looking through the `first-good-issue` issues.

## Coding conventions

All Dart code must adhere to [Dart Standard Style](https://dart.dev/guides/language/effective-dart/style).

* Make sure to format your code before submitting a pull request (`Alt+Shift+F` in VScode on windows).
* Name the files what they are in the class name add what type is it (usually the name of containing folder). For example: file name `button.dart`, class name 'ButtonWidget`, file name `firestore.dart` class name `FirestoreService`.
* Private variables and functions must start with `_`.
* Make sure to specify the returned type from functions.
* Don't use dynamic types unless you absolutely must.
* As best practice, try to keep all const variables in the 'consts.dart' file.
* All text the is displayed to the user should be translatable. Also make sure that the app layout works in `RTL` and `LTR`.
* The app should build without an error or warnings.
* All imports shuold be absolute. (e.g. `import 'package:daf_plus_plus/models/masechet.dart';` and not `import '../models/masechet.dart';`)
