import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instalog_platform_interface/instalog_platform_interface.dart';
import 'package:instalog_platform_interface/src/method_channel_instalog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MethodChannelInstalog', () {
    late MethodChannelInstalog methodChannelInstalog;
    final log = <MethodCall>[];

    setUp(() async {
      methodChannelInstalog = MethodChannelInstalog();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        methodChannelInstalog.methodChannel,
        (methodCall) async {
          log.add(methodCall);
          switch (methodCall.method) {
            case 'initialize':
              return true;
            case 'log':
              return true;
            case 'show_feedback_modal':
              return true;
            case 'send_crash':
              return true;
            case 'identify_user':
              return true;
            default:
              return null;
          }
        },
      );
    });

    tearDown(log.clear);

    test('initialize invokes the correct method', () async {
      final options = InstalogOptions(
        isLogEnabled: true,
        isLoggerEnabled: false,
        isCrashEnabled: true,
        isFeedbackEnabled: false,
      );

      final result = await methodChannelInstalog.initialize(
        apiKey: 'test_key',
        options: options,
      );
      expect(
        log,
        <Matcher>[
          isMethodCall('initialize', arguments: {
            'api_key': 'test_key',
            'options': options.toMap(),
          })
        ],
      );
      expect(result, isTrue);
    });

    test('logEvent invokes the correct method', () async {
      final result = await methodChannelInstalog.logEvent(
        event: 'test_event',
        params: {'param1': 'value1'},
      );
      expect(
        log,
        <Matcher>[
          isMethodCall('log', arguments: {
            'event': 'test_event',
            'params': {'param1': 'value1'}
          })
        ],
      );
      expect(result, isTrue);
    });

    test('showFeedbackModal invokes the correct method', () async {
      final result = await methodChannelInstalog.showFeedbackModal();
      expect(
        log,
        <Matcher>[isMethodCall('show_feedback_modal', arguments: null)],
      );
      expect(result, isTrue);
    });

    test('sendCrash invokes the correct method', () async {
      final result = await methodChannelInstalog.sendCrash(
        error: 'test_error',
        stack: 'test_stack',
      );
      expect(
        log,
        <Matcher>[
          isMethodCall('send_crash', arguments: {
            'error': 'test_error',
            'stack': 'test_stack',
          })
        ],
      );
      expect(result, isTrue);
    });

    test('identifyUser invokes the correct method', () async {
      final result = await methodChannelInstalog.identifyUser(
        userId: 'test_user_123',
      );
      expect(
        log,
        <Matcher>[
          isMethodCall('identify_user', arguments: {
            'id': 'test_user_123',
          })
        ],
      );
      expect(result, isTrue);
    });
  });
}
