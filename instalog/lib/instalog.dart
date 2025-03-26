import 'package:instalog/instalog_crash_catcher.dart';
import 'package:instalog_platform_interface/instalog_platform_interface.dart';

/// Main class for interacting with Instalog services.
/// Provides methods for initialization, event logging, feedback, and crash reporting.
class Instalog {
  Instalog._();

  static final Instalog _instance = Instalog._();

  /// Gets the singleton instance of Instalog.
  static Instalog get instance => _instance;

  static InstalogPlatform get _platform => InstalogPlatform.instance;

  /// Instance of [InstaCrashFlutter] for handling application crashes.
  final crash = InstaCrashFlutter();

  /// Initializes the Instalog SDK with the provided API key.
  ///
  /// [apiKey] - The API key for authenticating with Instalog services.
  /// Returns `Future<bool>` indicating whether initialization was successful.
  Future<bool> initialize({required String apiKey}) async {
    final res = await _platform.initialize(
      apiKey: apiKey,
    );

    return res ?? false;
  }

  /// Logs a custom event with optional parameters.
  ///
  /// [event] - The name of the event to log.
  /// [params] - Optional map of key-value pairs to include with the event.
  /// Returns `Future<Map<String, dynamic>>` indicating whether log was successful.
  Future<bool> logEvent({
    required String event,
    Map<String, String> params = const {},
  }) async {
    final res = await _platform.logEvent(
      event: event,
      params: params,
    );
    return res ?? false;
  }

  /// Displays the feedback modal to collect user feedback.
  ///
  /// Returns `Future<bool>` indicating whether the modal was shown successfully.
  Future<bool> showFeedbackModal() async {
    final res = await _platform.showFeedbackModal();
    return res ?? false;
  }

  /// Sends crash information to Instalog services.
  ///
  /// [error] - The error object or message to report.
  /// [stack] - Optional stack trace associated with the error.
  /// Returns `Future<bool>` indicating whether the crash was reported successfully.
  Future<bool> sendCrash(Object error, StackTrace? stack) async {
    final res = await _platform.sendCrash(
      error: '$error',
      stack: stack?.toString(),
    );

    return res ?? false;
  }
}
