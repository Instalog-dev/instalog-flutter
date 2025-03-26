import 'package:instalog_platform_interface/src/method_channel_instalog.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of instalog must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `Instalog`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
///  this interface will be broken by newly added [InstalogPlatform] methods.
abstract class InstalogPlatform extends PlatformInterface {
  /// Constructs a InstalogPlatform.
  InstalogPlatform() : super(token: _token);

  static final Object _token = Object();

  static InstalogPlatform _instance = MethodChannelInstalog();

  /// The default instance of [InstalogPlatform] to use.
  ///
  /// Defaults to [MethodChannelInstalog].
  static InstalogPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [InstalogPlatform] when they register themselves.
  static set instance(InstalogPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Initializes the Instalog SDK with the provided API key.
  ///
  /// [apiKey] - The API key for authenticating with Instalog services.
  /// Returns `Future<bool?>` indicating whether initialization was successful.
  Future<bool?> initialize({required String apiKey});

  /// Logs a custom event with optional parameters.
  ///
  /// [event] - The name of the event to log.
  /// [params] - Optional map of key-value pairs to include with the event.
  /// Returns `Future<bool?>` indicating whether log was successful.
  Future<bool?> logEvent({
    required String event,
    Map<String, String> params = const {},
  });

  /// Displays the feedback modal to collect user feedback.
  ///
  /// Returns `Future<bool?>` indicating whether the modal was shown successfully.
  Future<bool?> showFeedbackModal();

  /// Sends crash information to Instalog services.
  ///
  /// [error] - The error message to report.
  /// [stack] - Optional stack trace associated with the error.
  /// Returns `Future<bool?>` indicating whether the crash was reported successfully.
  Future<bool?> sendCrash({
    required String error,
    String? stack,
  });
}
