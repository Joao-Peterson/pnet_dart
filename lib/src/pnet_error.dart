import 'dylib.dart';

/// exception for pnet. Wraps libpnet error handling
class PnetException implements Exception{
    late String message;
    late int code;

    /// new pnet exception. Wraps libpnet error handling 
    PnetException(){
        code = pnetDylib.pnet_get_error();
        message = pnetDylib.pnet_get_error_msg().toString();
    }

    /// throw custom pnet exception
    PnetException.custom(this.message){
        code = 100;                                                                 // default code for custom messages
    }

    /// custom toString for the exception
    @override
    String toString(){
        return message;
    }
}
