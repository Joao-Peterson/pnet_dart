
import 'pnet_dart_platform_interface.dart';

class PnetDart {
  Future<String?> getPlatformVersion() {
    return PnetDartPlatform.instance.getPlatformVersion();
  }
}
