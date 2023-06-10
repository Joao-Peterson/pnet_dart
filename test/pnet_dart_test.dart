import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pnet_dart/src/dylib.dart';
import 'package:pnet_dart/src/pnet_error.dart';
import 'package:pnet_dart/src/pnet_matrix.dart';
import 'package:pnet_dart/src/pnet.dart';

void main() {

	test("Simple pnet test", () async {
        Pnet pnet;
        
        try {
            pnet = Pnet(
                negArcsMap: [
                    [-1],
                    [ 0],
                    [-2],
                ],
                posArcsMap: [
                    [ 0],
                    [ 1],
                    [ 0],
                ],
                placesInit: [1, 0, 32],
                transitionsDelay: [200]
            );
        } catch (e) {
            fail(e.toString());
        }

        pnet.fire();
        await new Future.delayed(Duration(milliseconds: 300));        

        expect(pnet.places, [0, 1, 30]);
	});

	test("Matrix test", () {
		final m = PnetMatrix([
            [0,0,0,5,0],
            [0,0,0,0,0],
            [0,0,0,0,0],
            [0,0,0,0,0],
            [0,0,0,0,1],
        ]);
		final PnetMatrix m2;
		try{
			m.set(4, 4, 1);
			m.set(0, 3, 10);
			expect(m.get(0, 3), 10);

			m2 = PnetMatrix.from(m);
			m2.setAll(5);
			expect(m2.get(2, 2), 5);
		}
		on PnetException catch(e){
			fail(e.toString());
		}
	});
}
