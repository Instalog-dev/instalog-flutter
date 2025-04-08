<!-- Logo that switches between light and dark mode on GitHub -->
<a href="https://instalog.dev">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/Instalog-dev/brand/refs/heads/main/logo/logo-text-dark.png">
    <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/Instalog-dev/brand/refs/heads/main/logo/logo-text-light.png">
    <img src="https://raw.githubusercontent.com/Instalog-dev/brand/refs/heads/main/logo/logo-text-light.png" alt="Instalog" width="200" style="max-width: 100%;">
  </picture>
</a>

Developed with 💙 by [Instalog](https://instalog.dev) 🚀

[![Pub Version](https://img.shields.io/pub/v/instalog.svg)](https://pub.dev/packages/instalog)
[![Coverage Status](https://coveralls.io/repos/github/Instalog-dev/instalog/badge.svg?branch=main)](https://coveralls.io/github/Instalog-dev/instalog?branch=main)
[![License: MIT][license_badge]][license_link]

A Flutter plugin for integrating Instalog analytics, logging, and crash reporting services into your Flutter applications. Instalog provides a comprehensive solution for monitoring app performance, user behavior, and error tracking.

## Features

- **Event Logging**: Track custom events with flexible parameters
- **User Identification**: Associate events with specific users
- **Crash Reporting**: Automatically capture and report crashes
- **Feedback Collection**: In-app feedback modal for user input

## Installation

Add `instalog_flutter` to your `pubspec.yaml`:

```yaml
dependencies:
  instalog_flutter: ^0.1.0
```

## Usage

### Initialization

Initialize the Instalog SDK at the start of your app:

```dart
import 'package:instalog_flutter/instalog_flutter.dart';

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


## Platform-Specific Notes

#### iOS
Ensure you have added the necessary permissions to your `Info.plist` file if your app collects user data.

#### Android
If targeting Android 13 (API level 33) or higher, ensure you request the appropriate permissions for collecting user data.

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[instalog_analysis_badge]: https://img.shields.io/badge/style-instalog_analysis-B22C89.svg