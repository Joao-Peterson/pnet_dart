import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'pnet.dart';
import 'dylib.dart';
import 'bindings.dart';
import 'pnet_error.dart';

class PnetCompileIL{
    static String weg_tpw_04(Pnet pnet, int input_offset, int output_offset, int transition_offset, int place_offset, int timer_offset, int timer_min){
        ffi.Pointer<pnet_t> native;
        
        try{
            native = pnet.nativePnet;
        }catch(e){
            rethrow;
        }
        
        var res = pnetDylib.pnet_compile_il_weg_tpw0(native, input_offset, output_offset, transition_offset, place_offset, timer_offset, timer_min);

        if(pnetDylib.pnet_get_error() != pnet_error_t.pnet_info_ok){
            throw PnetException();
        }

        return ffi.Pointer<Utf8>.fromAddress(res.address).toDartString();
    }
}