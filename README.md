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

A Flutter plugin for integrating Instalog analytics, logging, and crash reporting services into your Flutter applications. Instalog provides a comprehensive solution for monitoring app performance, user behavior, and error tracking.

## Features

- **Event Logging**: Track custom events with flexible parameters
- **User Identification**: Associate events with specific users
- **Crash Reporting**: Automatically capture and report crashes
- **Feedback Collection**: In-app feedback modal for user input

## Installation

Add `instalog_flutter: ^0.1.1` to your `pubspec.yaml`:

```yaml
dependencies:
  instalog_flutter: ^0.1.1
```


## Platform-specific Setup

### Android

For feedback functionality on Android, ensure you have the Instalog activity registered in your AndroidManifest.xml:

```xml
<activity
  android:name="dev.instalog.mobile.feedback.InstalogFeedbackActivity"
  android:label="Instalog"
  android:theme="@style/Theme.Instalog"/>
```

## Usage

### Initialization

Initialize the Instalog SDK at the start of your app:

```dart
import 'package:instalog_flutterinstalog.dart';

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

### Configuration Options

Customize Instalog SDK behavior with `InstalogOptions`:

```dart
import 'package:instalog_platform_interface/instalog_platform_interface.dart';

// Initialize with custom options
Instalog.instance.initialize(
  apiKey: 'your_api_key_here',
  options: const InstalogOptions(
    isLogEnabled: true,     // Enable event logging
    isLoggerEnabled: false, // Disable internal debug logs
    isCrashEnabled: true,   // Enable crash reporting
    isFeedbackEnabled: true // Enable feedback modal
  ),
);
```

All configuration options default to `true` except for `isLoggerEnabled` (defaults to `false`).

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

### User Identification

Associate events with a specific user:

```dart
// Identify user with a unique ID
Instalog.instance.identifyUser(userId: 'user_12345');
```

Identifying users allows you to track user-specific behavior and associate events and crashes with particular users, which is helpful for debugging and analytics.

## Platform-Specific Notes

#### iOS
Ensure you have added the necessary permissions to your `Info.plist` file if your app collects user data.

#### Android
If targeting Android 13 (API level 33) or higher, ensure you request the appropriate permissions for collecting user data.

## Advanced Example

Here's a complete example showing how to use multiple Instalog features together:

```dart
import 'package:flutter/material.dart';
import 'package:instalog_flutterinstalog.dart';
import 'package:instalog_platform_interface/instalog_platform_interface.dart';

void main() {
  // Set up crash handling
  Instalog.instance.crash.setup(
    appRunner: () => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Initialize with options
    Instalog.instance.initialize(
      apiKey: 'your_api_key_here',
      options: const InstalogOptions(
        isLogEnabled: true,
        isLoggerEnabled: false,
        isCrashEnabled: true,
        isFeedbackEnabled: true,
      ),
    );
    
    // Identify the user
    Instalog.instance.identifyUser(userId: 'user_${DateTime.now().millisecondsSinceEpoch}');
    
    // Log app start event
    Instalog.instance.logEvent(
      event: 'app_started',
      params: {
        'timestamp': DateTime.now().toIso8601String(),
        'version': '1.0.0',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Instalog Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Instalog.instance.showFeedbackModal(),
              child: const Text('Show Feedback Modal'),
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  // Simulate an error
                  throw Exception('Test exception');
                } catch (error, stack) {
                  Instalog.instance.sendCrash(error, stack);
                }
              },
              child: const Text('Simulate & Report Error'),
            ),
          ],
        ),
      ),
    );
  }
}

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[instalog_analysis_badge]: https://img.shields.io/badge/style-instalog_analysis-B22C89.svg
