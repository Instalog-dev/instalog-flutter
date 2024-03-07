import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';
import 'package:instalog_platform_interface/instalog_platform_interface.dart';

/// An implementation of [InstalogPlatform] that uses method channels.
class MethodChannelInstalog extends InstalogPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('instalog');

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
