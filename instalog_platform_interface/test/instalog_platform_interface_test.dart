import 'package:flutter_test/flutter_test.dart';
import 'package:instalog_platform_interface/instalog_platform_interface.dart';

class InstalogMock extends InstalogPlatform {
  static const mockPlatformName = 'Mock';

  @override
  Future<String?> getPlatformName() async => mockPlatformName;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('InstalogPlatformInterface', () {
    late InstalogPlatform instalogPlatform;

    setUp(() {
      instalogPlatform = InstalogMock();
      InstalogPlatform.instance = instalogPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name', () async {
        expect(
          await InstalogPlatform.instance.getPlatformName(),
          equals(InstalogMock.mockPlatformName),
        );
      });
    });
  });
}
