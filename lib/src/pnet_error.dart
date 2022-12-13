import 'dylib.dart';

class PnetException implements Exception{
    late String message;
    late int code;

    PnetException(){
        code = pnetDylib.pnet_get_error();
        message = pnetDylib.pnet_get_error_msg().toString();
    }

    PnetException.scratch(this.message, this.code);

    @override
    String toString(){
        return message;
    }
}
