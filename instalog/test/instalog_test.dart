import 'package:flutter_test/flutter_test.dart';
import 'package:instalog/instalog.dart';
import 'package:instalog_platform_interface/instalog_platform_interface.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockInstalogPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements InstalogPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Instalog', () {
    late InstalogPlatform instalogPlatform;
    late String apiKey;

    setUp(() {
      instalogPlatform = MockInstalogPlatform();
      InstalogPlatform.instance = instalogPlatform;
      apiKey = 'test_key';
    });

    group('getPlatformName', () {
      test('returns correct name when platform implementation exists',
          () async {
        const platformName = true;
        when(
          () => instalogPlatform.initialize(apiKey: apiKey),
        ).thenAnswer((_) async => platformName);

        final actualPlatformName = await Instalog.instance.initialize(
          apiKey: apiKey,
        );
        expect(actualPlatformName, equals(platformName));
      });

      test('throws exception when platform implementation is missing',
          () async {
        when(
          () => instalogPlatform.initialize(
            apiKey: apiKey,
          ),
        ).thenAnswer((_) async => null);

        expect(Instalog.instance.initialize, throwsException);
      });
    });
  });
}
