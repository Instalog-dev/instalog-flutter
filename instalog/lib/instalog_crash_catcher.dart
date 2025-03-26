import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instalog/instalog.dart';

/// A class that catches and handles application crashes and errors.
///
/// This class provides functionality to:
/// - Catch and report unhandled exceptions and errors
/// - Allow custom error widgets to be displayed
/// - Register listeners to be notified of errors
/// - Integrate with Instalog's crash reporting system
class InstaCrashFlutter {
  /// Creates an instance of [InstaCrashFlutter].
  InstaCrashFlutter();

  final List<Function(Object, StackTrace?)> _listeners = [];
  ErrorWidgetBuilder? _customErrorWidget;

  /// Sets up the crash catcher with the given parameters.
  ///
  /// This method should be called before running the application to ensure
  /// all errors are properly caught and handled.
  ///
  /// Parameters:
  /// - [appRunner]: The function that runs the application (typically `runApp`)
  /// - [listeners]: Optional list of callback functions to be notified when an error occurs
  /// - [errorWidget]: Optional custom widget builder to display when an error occurs
  ///
  /// Example:
  /// ```dart
  /// Instalog.instance.crash.setup(
  ///   appRunner: () => runApp(MyApp()),
  ///   listeners: [myErrorHandler],
  ///   errorWidget: myCustomErrorWidget,
  /// );
  /// ```
  void setup({
    required Function() appRunner,
    List<Function(Object, StackTrace?)>? listeners,
    ErrorWidgetBuilder? errorWidget,
  }) {
    if (errorWidget != null) {
      _customErrorWidget = errorWidget;
      ErrorWidget.builder = _errorWidgetBuilder;
    }

    if (listeners != null) {
      _listeners.addAll(listeners);
    }

    // Handle Flutter framework errors
    FlutterError.onError = (details) {
      _handleError(details.exception, details.stack);
    };

    // Handle Dart errors
    PlatformDispatcher.instance.onError = (error, stack) {
      _handleError(error, stack);
      return true; // Prevent default error handling
    };

    // Run app in guarded zone
    runZonedGuarded(
      () {
        appRunner();
      },
      (error, stack) => _handleError(error, stack),
    );
  }

  /// Adds a listener to be notified when an error occurs.
  ///
  /// [listener]: The callback function to be called when an error occurs
  void addListener(Function(Object, StackTrace?) listener) {
    _listeners.add(listener);
  }

  /// Removes a previously added error listener.
  ///
  /// [listener]: The callback function to remove
  void removeListener(Function(Object, StackTrace?) listener) {
    _listeners.remove(listener);
  }

  /// Builds the error widget to be displayed when an error occurs.
  ///
  /// If a custom error widget was provided during setup, it will be used.
  /// Otherwise, the default Flutter error widget is used.
  Widget _errorWidgetBuilder(FlutterErrorDetails details) {
    if (_customErrorWidget != null) {
      return _customErrorWidget!(details);
    }
    return ErrorWidget(details.exception);
  }

  /// Handles an error by reporting it to Instalog and notifying all listeners.
  ///
  /// [error]: The error that occurred
  /// [stack]: The associated stack trace (if available)
  void _handleError(Object error, StackTrace? stack) {
    // Report the crash to Instalog
    Instalog.instance.sendCrash(error, stack);

    // Notify all registered listeners
    for (final listener in _listeners) {
      try {
        listener(error, stack);
      } catch (e) {
        // Prevent recursive errors if a listener itself throws an error
      }
    }
  }
}
