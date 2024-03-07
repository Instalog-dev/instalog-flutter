import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instalog_android/instalog_android.dart';
import 'package:instalog_platform_interface/instalog_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('InstalogAndroid', () {
    const kPlatformName = 'Android';
    late InstalogAndroid instalog;
    late List<MethodCall> log;

    setUp(() async {
      instalog = InstalogAndroid();

      log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(instalog.methodChannel, (methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'getPlatformName':
            return kPlatformName;
          default:
            return null;
        }
      });
    });

    test('can be registered', () {
      InstalogAndroid.registerWith();
      expect(InstalogPlatform.instance, isA<InstalogAndroid>());
    });

    test('getPlatformName returns correct name', () async {
      final name = await instalog.getPlatformName();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(name, equals(kPlatformName));
    });
  });
}
