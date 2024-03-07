import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:instalog_platform_interface/instalog_platform_interface.dart';

/// The Android implementation of [InstalogPlatform].
class InstalogAndroid extends InstalogPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('instalog_android');

  /// Registers this class as the default instance of [InstalogPlatform]
  static void registerWith() {
    InstalogPlatform.instance = InstalogAndroid();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
