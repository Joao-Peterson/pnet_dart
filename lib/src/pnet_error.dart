import 'dart:ffi' as ffi;
import 'dylib.dart';

/// errors return by pnet methods
enum PnetError {
    pnetInfoOk,
    pnetInfoNoNegArcsNorInhibitArcsProvidedNoTransitionWillBeSensibilized,
    pnetInfoNoWeightedArcsNorResetArcsProvidedNoTokenWillBeMovedOrSet,
    pnetInfoInputsWerePassedButNoInputMapWasSetWhenThePetriNetWasCreated,
    pnetInfoNoCallbackFunctionWasPassedWhileUsingTimedTransitionsWatchOut,
    pnetErrorNoArcsWereGiven,
    pnetErrorPlaceInitMustHaveOnlyOneRow,
    pnetErrorTransitionsDelayMustHaveOnlyOneRow,
    pnetErrorPlacesInitMustNotBeNull,
    pnetErrorPosArcsHasIncorrectNumberOfPlaces,
    pnetErrorPosArcsHasIncorrectNumberOfTransitions,
    pnetErrorInhibitArcsHasIncorrectNumberOfPlaces,
    pnetErrorInhibitArcsHasIncorrectNumberOfTransitions,
    pnetErrorResetArcsHasIncorrectNumberOfPlaces,
    pnetErrorResetArcsHasIncorrectNumberOfTransitions,
    pnetErrorPlacesInitHasIncorrectNumberOfPlacesOnItsFirstRow,
    pnetErrorTransitionsDelayHasDifferentNumberOfTransitionsInItsFirstRowThanInTheArcs,
    pnetErrorInputsHasDifferentNumberOfTransitionsInItsFirstRowThanInTheArcs,
    pnetErrorInputsThereAreMoreThanOneInputPerTransition,
    pnetErrorOutputsHasDifferentNumberOfPlacesInItsFirstColumnsThanInTheArcs,
    pnetErrorPnetStructPointerPassedAsArgumentIsNull,
    pnetErrorInputMatrixArgumentSizeDoesntMatchTheInputSizeOnThePnetProvided,
    pnetErrorThreadCouldNotBeCreated,
    pnetErrorMatrixPassedIsNull,
    pnetErrorMatrixMinimalSizeIs1By1,
    pnetErrorMatrixIndexXYOutOfRange,
    pnetErrorMatricesShouldBeOfTheSameSize,
    pnetErrorMatricesShouldBeSquareMatrices,
    pnetErrorMatricesShouldBeTranposedEquivalents,
    pnetErrorMatrixTooBigToSerialize,
    pnetInfoPnetNotValidToSerialize,
    pnetErrorFileInvalidFiletype,
    pnetErrorFileInvalidChecksum,
    pnetErrorFileCorruptedData,
    
    errorCouldNotIniializeNativeLib
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
    PnetException.custom(PnetError code, {String? message}){
        this.code = code as int;
        this.message = message ?? "Pnet error: ${PnetError.values[this.code].toString()}";
    }

    /// custom toString for the exception
    @override
    String toString(){
        return message;
    }
}

