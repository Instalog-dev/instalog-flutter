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

    setUp(() {
      instalogPlatform = MockInstalogPlatform();
      InstalogPlatform.instance = instalogPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name when platform implementation exists',
          () async {
        const platformName = '__test_platform__';
        when(
          () => instalogPlatform.getPlatformName(),
        ).thenAnswer((_) async => platformName);

        final actualPlatformName = await getPlatformName();
        expect(actualPlatformName, equals(platformName));
      });

      test('throws exception when platform implementation is missing',
          () async {
        when(
          () => instalogPlatform.getPlatformName(),
        ).thenAnswer((_) async => null);

        expect(getPlatformName, throwsException);
      });
    });
  });
}
