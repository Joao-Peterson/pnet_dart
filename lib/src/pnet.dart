import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:pnet_dart/src/pnet_matrix.dart';
import 'bindings.dart';
import 'dylib.dart';
import 'pnet_error.dart';

/// class that represents a petrinet
class Pnet{
    /// pointer to native type petrinet
    late ffi.Pointer<pnet_t> _pnet;

    /// callback to call on event 
    Function(dynamic)? _callback;

    /// callback data to use on event 
    dynamic _callbackData;

    /// creates a new petri net based on places, arcs, inputs and outputs.
    /// [placesInit] must be passed, all other arcs, input and outputs can be null
    /// [posArcsMap]        matrix of arcs weight/direction, where the rows are the places and the columns are the transitions. Represents the number of tokens to be removed from a place. Only negative values
    /// [negArcsMap]        matrix of arcs weight/direction, where the rows are the places and the columns are the transitions. Represents the number of tokens to be moved onto a place. Only positive values
    /// [inhibitArcsMap]    matrix of arcs, where the coluns are the places and the rows are the transitions. Dictates the firing of a transition when a place has zero tokens. Values must be 0 or 1, any non zero number counts as 1
    /// [resetArcsMap]      matrix of arcs, where the coluns are the places and the rows are the transitions. When a transition occurs it zeroes out the place tokens. Values must be 0 or 1, any non zero number counts as 1
    /// [placesInit]        matrix of values, where the columns are the places. The initial values for the places. Values must be a positive value
    /// [transitionsDelay]  matrix of values, were the columns are the transitions. While a place has enough tokens, the transitions will delay it's firing. Values must be positive, given in milli seconds (ms)
    /// [inputsMap]         matrix where the columns are the transitions and the rows are inputs. Represents the type of event that will fire that transistion, given by the enumerator pnet_event_t
    /// [outputsMap]        matrix where the columns are the outputs and the rows are places. An output is true when a place has one or more tokens. Values must be 0 or 1, any non zero number counts as 1
    /// [callback]          callback function of type pnet_callback_t that is called after firing operations asynchronously, useful for timed transitions
    /// [data]              data given by the user to passed on call to the callback function in it's data parameter. A void pointer
    Pnet(
        {
        required List<List<int>> placesInit,
        List<List<int>>? posArcsMap,
        List<List<int>>? negArcsMap,
        List<List<int>>? inhibitArcsMap,
        List<List<int>>? resetArcsMap,
        List<List<int>>? transitionsDelay,
        List<List<int>>? inputsMap,
        List<List<int>>? outputsMap,
        Function(dynamic)? callback,
        dynamic data
        } 
    ){
        // create pnet
        // all optional arguments are checked and exchanged by NULL ptr if necessary
        // callback is NULL by default
        // TODO: scheme for using dart threads to check the pnet for events, then calling a dart callback on this thread, 
        // and in the C implement a function to check for events synchronously, or make a c default callback that sets a global boolean visible to dart.
        // maybe even throw async functionalitty in there somehow    
        _pnet = pnetDylib.m_pnet_new(
            (posArcsMap != null ? PnetMatrix.newNative(posArcsMap) : ffi.nullptr), 
            (negArcsMap != null ? PnetMatrix.newNative(negArcsMap) : ffi.nullptr), 
            (inhibitArcsMap != null ? PnetMatrix.newNative(inhibitArcsMap) : ffi.nullptr), 
            (resetArcsMap != null ? PnetMatrix.newNative(resetArcsMap) : ffi.nullptr), 
            PnetMatrix.newNative(placesInit), 
            (transitionsDelay != null ? PnetMatrix.newNative(transitionsDelay) : ffi.nullptr), 
            (inputsMap != null ? PnetMatrix.newNative(inputsMap) : ffi.nullptr), 
            (outputsMap != null ? PnetMatrix.newNative(outputsMap) : ffi.nullptr), 
            ffi.nullptr, 
            ffi.nullptr
        );

        _callback = callback;
        _callbackData = data;

        if(pnetDylib.pnet_get_error() != pnet_error_t.pnet_info_ok){
            throw PnetException();
        }
    }

    /// destructor, to deallocate native pnet
    void dispose(){
        pnetDylib.pnet_delete(_pnet);
    }

    /// fire the petri net
    void fire({List<List<int>>? inputs}){
        // get inputs as pnet_matrix
        ffi.Pointer<pnet_matrix_t> inMatrix = inputs != null ? PnetMatrix.newNative(inputs) : ffi.nullptr;
        // then allocate a pnet_inputs_t manually
        ffi.Pointer<pnet_inputs_t> pnetIn = malloc.allocate<pnet_inputs_t>(ffi.sizeOf<pnet_inputs_t>());
        // set inputs
        pnetIn.ref.values = inMatrix;
        // call native fire
        pnetDylib.pnet_fire(_pnet, pnetIn);
    }

    /// get places from pnet
    List<int> get places{
        var m = PnetMatrix.fromNative(_pnet.ref.places);
        return m[0];
    }

    /// get sensitiveTransitions from pnet
    List<int> get sensitiveTransitions{
        var m = PnetMatrix.fromNative(_pnet.ref.sensitive_transitions);
        return m[0];
    }

    /// get outputs from pnet
    List<int> get outputs{
        var m = PnetMatrix.fromNative(_pnet.ref.outputs);
        return m[0];
    }
}