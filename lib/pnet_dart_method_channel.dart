import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'pnet_dart_platform_interface.dart';

/// An implementation of [PnetDartPlatform] that uses method channels.
class MethodChannelPnetDart extends PnetDartPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pnet_dart');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
