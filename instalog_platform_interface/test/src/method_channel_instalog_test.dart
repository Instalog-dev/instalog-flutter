import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instalog_platform_interface/src/method_channel_instalog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const kPlatformName = 'platformName';

  group('$MethodChannelInstalog', () {
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
            case 'getPlatformName':
              return kPlatformName;
            default:
              return null;
          }
        },
      );
    });

    tearDown(log.clear);

    test('getPlatformName', () async {
      final platformName = await methodChannelInstalog.getPlatformName();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(platformName, equals(kPlatformName));
    });
  });
}
