import 'package:flutter_test/flutter_test.dart';
import 'package:instalog_platform_interface/instalog_platform_interface.dart';

class InstalogMock extends InstalogPlatform {
  @override
  Future<bool?> initialize({
    required String apiKey,
    InstalogOptions options = const InstalogOptions(),
  }) =>
      Future.value(true);

  @override
  Future<bool?> logEvent({
    required String event,
    Map<String, String> params = const {},
  }) async {
    return true;
  }

  @override
  Future<bool?> showFeedbackModal() async => true;

  @override
  Future<bool?> sendCrash({required String error, String? stack}) {
    return Future.value(true);
  }

  @override
  Future<bool?> identifyUser({required String userId}) {
    return Future.value(true);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('InstalogPlatformInterface', () {
    late InstalogPlatform instalogPlatform;

    setUp(() {
      instalogPlatform = InstalogMock();
      InstalogPlatform.instance = instalogPlatform;
    });

    test('initialize returns correct result', () async {
      expect(
        await InstalogPlatform.instance.initialize(apiKey: 'test_key'),
        equals(true),
      );
    });

    test('logEvent returns correct result', () async {
      expect(
        await InstalogPlatform.instance.logEvent(
          event: 'test_event',
          params: {'param1': 'value1'},
        ),
        equals(true),
      );
    });

    test('showFeedbackModal returns correct result', () async {
      expect(
        await InstalogPlatform.instance.showFeedbackModal(),
        equals(true),
      );
    });

    test('sendCrash returns correct result', () async {
      expect(
        await InstalogPlatform.instance.sendCrash(
          error: 'test_error',
          stack: 'test_stack',
        ),
        equals(true),
      );
    });

    test('identifyUser returns correct result', () async {
      expect(
        await InstalogPlatform.instance.identifyUser(userId: 'test_user_123'),
        equals(true),
      );
    });
  });
}
