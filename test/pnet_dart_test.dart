import 'package:flutter_test/flutter_test.dart';
import 'package:pnet_dart/pnet_dart.dart';
import 'package:pnet_dart/pnet_dart_platform_interface.dart';
import 'package:pnet_dart/pnet_dart_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:pnet_dart/src/pnet_error.dart';
import 'dart:ffi';
import 'package:pnet_dart/src/pnet_matrix.dart';

class MockPnetDartPlatform
    with MockPlatformInterfaceMixin
    implements PnetDartPlatform {

	@override
	Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
	final PnetDartPlatform initialPlatform = PnetDartPlatform.instance;

	test('$MethodChannelPnetDart is the default instance', () {
		expect(initialPlatform, isInstanceOf<MethodChannelPnetDart>());
	});

	test('getPlatformVersion', () async {
		PnetDart pnetDartPlugin = PnetDart();
		MockPnetDartPlatform fakePlatform = MockPnetDartPlatform();
		PnetDartPlatform.instance = fakePlatform;

		expect(await pnetDartPlugin.getPlatformVersion(), '42');
	});

	test("Matrix test", () {
		final m = PnetMatrix(5, 5);
		final PnetMatrix m2;
		try{
			m.setValueAt(4, 4, 1);
			m2 = PnetMatrix.from(m);
			m2.set(5);
			expect(m2.getValueAt(2, 2), 5);
		}
		on PnetException catch(e){
			fail(e.toString());
		}
		
		m.dispose();
		m2.dispose();
	});
}
