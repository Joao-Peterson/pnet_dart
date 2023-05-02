import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pnet_dart/src/dylib.dart';
import 'package:pnet_dart/src/pnet_error.dart';
import 'package:pnet_dart/src/pnet_matrix.dart';
import 'package:pnet_dart/src/pnet.dart';

void main() {

	test("Simple pnet test", () {
        Pnet pnet;
        
        try {
            pnet = Pnet(
                negArcsMap: [
                    [-1],
                    [ 0],
                ],
                posArcsMap: [
                    [ 0],
                    [ 1],
                ],
                placesInit: [
                    [ 1, 0]
                ],
            );
        } catch (e) {
            fail(e.toString());
        }

        // var code = pnet.sense();
        // print(ffi.Pointer<Utf8>.fromAddress(pnetDylib.pnet_get_error_msg().address).toDartString());

        print(pnet.places);

        pnet.fire();

        print(pnet.places);
        expect(pnet.places, [0, 1]);
	});

	test("Matrix test", () {
		final m = PnetMatrix([
            [0,0,0,0,0],
            [0,0,0,0,0],
            [0,0,0,0,0],
            [0,0,0,0,0],
            [0,0,0,0,1],
        ]);
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
	});
}
