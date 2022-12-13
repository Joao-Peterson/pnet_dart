import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pnet_dart_method_channel.dart';

abstract class PnetDartPlatform extends PlatformInterface {
  /// Constructs a PnetDartPlatform.
  PnetDartPlatform() : super(token: _token);

  static final Object _token = Object();

  static PnetDartPlatform _instance = MethodChannelPnetDart();

  /// The default instance of [PnetDartPlatform] to use.
  ///
  /// Defaults to [MethodChannelPnetDart].
  static PnetDartPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PnetDartPlatform] when
  /// they register themselves.
  static set instance(PnetDartPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
