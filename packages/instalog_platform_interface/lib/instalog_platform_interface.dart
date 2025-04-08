import 'package:instalog_platform_interface/src/method_channel_instalog.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// Configuration options for the Instalog SDK.
class InstalogOptions {
  /// Creates a new instance of [InstalogOptions].
  ///
  /// All properties default to true if not specified.
  const InstalogOptions({
    this.isLogEnabled = true,
    this.isLoggerEnabled = false,
    this.isCrashEnabled = true,
    this.isFeedbackEnabled = true,
  });

  /// Whether event logging functionality is enabled.
  final bool isLogEnabled;

  /// Whether internal logging for debugging is enabled.
  final bool isLoggerEnabled;

  /// Whether crash reporting functionality is enabled.
  final bool isCrashEnabled;

  /// Whether feedback functionality is enabled.
  final bool isFeedbackEnabled;

  /// Converts this options object to a map for serialization.
  Map<String, bool> toMap() => {
        'isLogEnabled': isLogEnabled,
        'isLoggerEnabled': isLoggerEnabled,
        'isCrashEnabled': isCrashEnabled,
        'isFeedbackEnabled': isFeedbackEnabled,
      };

  /// Creates a new [InstalogOptions] instance from a map.
  factory InstalogOptions.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const InstalogOptions();
    return InstalogOptions(
      isLogEnabled: map['isLogEnabled'] as bool? ?? true,
      isLoggerEnabled: map['isLoggerEnabled'] as bool? ?? true,
      isCrashEnabled: map['isCrashEnabled'] as bool? ?? true,
      isFeedbackEnabled: map['isFeedbackEnabled'] as bool? ?? true,
    );
  }

  InstalogOptions copyWith({
    bool? isLogEnabled,
    bool? isLoggerEnabled,
    bool? isCrashEnabled,
    bool? isFeedbackEnabled,
  }) =>
      InstalogOptions(
        isLogEnabled: isLogEnabled ?? this.isLogEnabled,
        isLoggerEnabled: isLoggerEnabled ?? this.isLoggerEnabled,
        isCrashEnabled: isCrashEnabled ?? this.isCrashEnabled,
        isFeedbackEnabled: isFeedbackEnabled ?? this.isFeedbackEnabled,
      );
}

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
  /// [options] - Configuration settings for the Instalog SDK.
  /// Returns `Future<bool?>` indicating whether initialization was successful.
  Future<bool?> initialize({
    required String apiKey,
    InstalogOptions options = const InstalogOptions(),
  });

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

  /// Identifies the current user for analytics and logging.
  ///
  /// [userId] - A unique identifier for the user.
  /// Returns `Future<bool?>` indicating whether the identification was successful.
  Future<bool?> identifyUser({required String userId});
}
