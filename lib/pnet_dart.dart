import 'pnet_dart_platform_interface.dart';
export 'package:pnet_dart/src/pnet.dart';
export 'package:pnet_dart/src/pnet_il.dart';
export 'package:pnet_dart/src/pnet_matrix.dart';
export 'package:pnet_dart/src/pnet_error.dart';

class PnetDart {
  Future<String?> getPlatformVersion() {
    return PnetDartPlatform.instance.getPlatformVersion();
  }
}
