import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dylib.dart';

/// errors return by pnet methods
enum PnetError {
	ok,
	infoNoNegArcsNorInhibitArcsProvidedNoTransitionWillBeSensibilized,
	infoNoWeightedArcsNorResetArcsProvidedNoTokenWillBeMovedOrSet,
	infoInputsWerePassedButNoInputMapWasSetWhenThePetriNetWasCreated,
	infoNoCallbackFunctionWasPassedWhileUsingTimedTransitionsWatchOut,
	errorNoArcsWereGiven,
	errorPlaceInitMustHaveOnlyOneRow,
	errorTransitionsDelayMustHaveOnlyOneRow,
	errorPlacesInitMustNotBeNull,
	errorPosArcsHasIncorrectNumberOfPlaces,
	errorPosArcsHasIncorrectNumberOfTransitions,
	errorInhibitArcsHasIncorrectNumberOfPlaces,
	errorInhibitArcsHasIncorrectNumberOfTransitions,
	errorResetArcsHasIncorrectNumberOfPlaces,
	errorResetArcsHasIncorrectNumberOfTransitions,
	errorPlacesInitHasIncorrectNumberOfPlacesOnItsFirstRow,
	errorTransitionsDelayHasDifferentNumberOfTransitionsInItsFirstRowThanInTheArcs,
	errorInputsHasDifferentNumberOfTransitionsInItsFirstRowThanInTheArcs,
	errorInputsThereAreMoreThanOneInputPerTransition,
	errorOutputsHasDifferentNumberOfPlacesInItsFirstColumnsThanInTheArcs,
	errorPnetStructPointerPassedAsArgumentIsNull,
	errorInputMatrixArgumentSizeDoesntMatchTheInputSizeOnThePnetProvided,
	errorThreadCouldNotBeCreated,
    errorUnknown,
}

/// exception for pnet. Wraps libpnet error handling
class PnetException implements Exception{
    late String message;
    late int code;

    /// new pnet exception. Wraps libpnet error handling 
    PnetException(){
        code = pnetDylib.pnet_get_error();
        // message = "Pnet error: ${ffi.Pointer<Utf8>.fromAddress(pnetDylib.pnet_get_error_msg().address).toDartString()}";
        message = "Pnet error: ${PnetError.values[code].toString()}";
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

