import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pnet_dart/pnet_dart_method_channel.dart';

void main() {
  MethodChannelPnetDart platform = MethodChannelPnetDart();
  const MethodChannel channel = MethodChannel('pnet_dart');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
