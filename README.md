# Instalog

[![Very Good Ventures][logo_white]][very_good_ventures_link_dark]
[![Very Good Ventures][logo_black]][very_good_ventures_link_light]

Developed with 💙 by [Very Good Ventures][very_good_ventures_link] 🦄

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

A Flutter plugin for integrating Instalog analytics, logging, and crash reporting services into your Flutter applications. Instalog provides a comprehensive solution for monitoring app performance, user behavior, and error tracking.

## Features

- **Event Logging**: Track custom events with flexible parameters
- **User Identification**: Associate events with specific users
- **Crash Reporting**: Automatically capture and report crashes
- **Feedback Collection**: In-app feedback modal for user input

## Installation

Add `instalog` to your `pubspec.yaml`:

```yaml
dependencies:
  instalog: ^0.1.0
```

## Usage

### Initialization

Initialize the Instalog SDK at the start of your app:

```dart
import 'package:instalog/instalog.dart';

// Initialize in main.dart
void main() {
  // Set up crash handling
  Instalog.instance.crash.setup(
    appRunner: () => runApp(const MyApp()),
  );
}

// Initialize with your API key in a widget
@override
void initState() {
  super.initState();
  Instalog.instance.initialize(apiKey: 'your_api_key_here');
}
```

### Logging Events

Track custom events with optional parameters:

```dart
// Simple event
Instalog.instance.logEvent(event: 'button_clicked');

// Event with parameters
Instalog.instance.logEvent(
  event: 'user_login',
  params: {
    'user_id': '12345',
    'method': 'email',
    'timestamp': DateTime.now().toIso8601String(),
  },
);
```

### Showing Feedback Modal

Display the in-app feedback modal to collect user input:

```dart
await Instalog.instance.showFeedbackModal();
```

### Crash Reporting

Instalog automatically captures uncaught exceptions when set up with `crash.setup()`. To manually report a caught exception:

```dart
try {
  // Your code that might throw an exception
} catch (error, stack) {
  Instalog.instance.sendCrash(error, stack);
}
```

## Integration tests 🧪

Instalog uses [fluttium][fluttium_link] for integration tests. Those tests are located 
in the front facing package `instalog` example. 

**❗ In order to run the integration tests, you need to have the `fluttium_cli` installed. [See how][fluttium_install].**

To run the integration tests, run the following command from the root of the project:

```sh
cd instalog/example
fluttium test flows/test_platform_name.yaml
```

## Platform-Specific Notes

### iOS
Ensure you have added the necessary permissions to your `Info.plist` file if your app collects user data.

### Android
If targeting Android 13 (API level 33) or higher, ensure you request the appropriate permissions for collecting user data.

[coverage_badge]: instalog/coverage_badge.svg
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
[very_good_ventures_link]: https://verygood.ventures/?utm_source=github&utm_medium=banner&utm_campaign=core
[very_good_ventures_link_dark]: https://verygood.ventures/?utm_source=github&utm_medium=banner&utm_campaign=core#gh-dark-mode-only
[very_good_ventures_link_light]: https://verygood.ventures/?utm_source=github&utm_medium=banner&utm_campaign=core#gh-light-mode-only
[fluttium_link]: https://fluttium.dev/
[fluttium_install]: https://fluttium.dev/docs/getting-started/installing-cli