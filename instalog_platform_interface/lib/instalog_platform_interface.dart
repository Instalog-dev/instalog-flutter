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

  /// Return the current platform name.
  Future<String?> getPlatformName();
}
