import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';
import 'package:instalog_platform_interface/instalog_platform_interface.dart';

/// An implementation of [InstalogPlatform] that uses method channels.
class MethodChannelInstalog extends InstalogPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dev.instalog.flutter/channel');

  @override
  Future<bool?> initialize({required String apiKey}) =>
      methodChannel.invokeMethod<bool>(
        'initialize',
        {'api_key': apiKey},
      );

  @override
  Future<bool?> logEvent({
    required String event,
    Map<String, String> params = const {},
  }) =>
      methodChannel.invokeMethod<bool>(
        'log',
        <String, dynamic>{
          'event': event,
          'params': params,
        },
      );

  @override
  Future<bool?> showFeedbackModal() =>
      methodChannel.invokeMethod<bool>('show_feedback_modal');

  @override
  Future<bool?> sendCrash({required String error, String? stack}) {
    return methodChannel.invokeMethod<bool>(
      'send_crash',
      <String, dynamic>{
        'error': error,
        'stack': stack,
      },
    );
  }
}
