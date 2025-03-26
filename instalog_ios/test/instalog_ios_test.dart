import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instalog_ios/instalog_ios.dart';
import 'package:instalog_platform_interface/instalog_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('InstalogIOS', () {
    late InstalogIOS instalog;
    late List<MethodCall> log;

    setUp(() async {
      instalog = InstalogIOS();

      log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(instalog.methodChannel, (methodCall) async {
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
          case 'simulate_crash':
            return true;
          default:
            return null;
        }
      });
    });

    test('can be registered', () {
      InstalogIOS.registerWith();
      InstalogPlatform.instance = InstalogIOS();
      expect(InstalogPlatform.instance, isA<InstalogIOS>());
    });

    test('initialize sends correct data', () async {
      final result = await instalog.initialize(apiKey: 'test_key');
      expect(
        log,
        <Matcher>[
          isMethodCall('initialize', arguments: {
            'api_key': 'test_key',
            'options': {
              'isLogEnabled': true,
              'isLoggerEnabled': false,
              'isCrashEnabled': true,
              'isFeedbackEnabled': true
            }
          })
        ],
      );
      expect(result, isTrue);
    });

    test('logEvent sends correct data', () async {
      final result = await instalog.logEvent(
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

    test('showFeedbackModal sends correct data', () async {
      final result = await instalog.showFeedbackModal();
      expect(
        log,
        <Matcher>[isMethodCall('show_feedback_modal', arguments: null)],
      );
      expect(result, isTrue);
    });

    test('sendCrash sends correct data', () async {
      final result = await instalog.sendCrash(
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
  });
}
