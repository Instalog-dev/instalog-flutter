import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:instalog_platform_interface/instalog_platform_interface.dart';

/// The iOS implementation of [InstalogPlatform].
class InstalogIOS extends InstalogPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('instalog_ios');

  /// Registers this class as the default instance of [InstalogPlatform]
  static void registerWith() {
    InstalogPlatform.instance = InstalogIOS();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
