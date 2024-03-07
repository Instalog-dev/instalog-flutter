import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instalog_ios/instalog_ios.dart';
import 'package:instalog_platform_interface/instalog_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('InstalogIOS', () {
    const kPlatformName = 'iOS';
    late InstalogIOS instalog;
    late List<MethodCall> log;

    setUp(() async {
      instalog = InstalogIOS();

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
      InstalogIOS.registerWith();
      expect(InstalogPlatform.instance, isA<InstalogIOS>());
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
