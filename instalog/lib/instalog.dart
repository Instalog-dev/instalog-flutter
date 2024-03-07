import 'package:instalog_platform_interface/instalog_platform_interface.dart';

InstalogPlatform get _platform => InstalogPlatform.instance;

/// Returns the name of the current platform.
Future<String> getPlatformName() async {
  final platformName = await _platform.getPlatformName();
  if (platformName == null) throw Exception('Unable to get platform name.');
  return platformName;
}
