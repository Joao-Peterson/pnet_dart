import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:pnet_dart/src/pnet_matrix.dart';
import 'bindings.dart';
import 'dylib.dart';
import 'pnet_error.dart';

/// class that represents a petrinet
class Pnet implements ffi.Finalizable{

    // ------------------------------------------------------------ Members ------------------------------------------------------------

    /// pointer to native type petrinet
    late ffi.Pointer<pnet_t> _pnet;

    /// finalizer used to call native delete methods on dart GC free
    static final _finalizer = ffi.NativeFinalizer(pnetDylib.native_pnet_delete.cast());

    /// callback to call on event 
    Function(dynamic)? _callback;

    /// callback data to use on event 
    dynamic _callbackData;

    // ------------------------------------------------------------ Constructors -------------------------------------------------------

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
    Pnet({
        List<List<int>>? posArcsMap,
        List<List<int>>? negArcsMap,
        List<List<int>>? inhibitArcsMap,
        List<List<int>>? resetArcsMap,
        required List<int> placesInit,
        List<int>? transitionsDelay,
        List<List<int>>? inputsMap,
        List<List<int>>? outputsMap,
        Function(dynamic)? callback,
        dynamic data
    }){
        // create pnet
        // all optional arguments are checked and exchanged by NULL ptr if necessary
        // callback is NULL by default
        // TODO: scheme for using dart threads to check the pnet for events, then calling a dart callback on this thread, 
        // and in the C implement a function to check for events synchronously, or make a c default callback that sets a global boolean visible to dart.
        // maybe even throw async functionalitty in there somehow    
        _pnet = pnetDylib.m_pnet_new(
            (negArcsMap != null ? PnetMatrix.newNative(negArcsMap) : ffi.nullptr), 
            (posArcsMap != null ? PnetMatrix.newNative(posArcsMap) : ffi.nullptr), 
            (inhibitArcsMap != null ? PnetMatrix.newNative(inhibitArcsMap) : ffi.nullptr), 
            (resetArcsMap != null ? PnetMatrix.newNative(resetArcsMap) : ffi.nullptr), 
            PnetMatrix.newNative([placesInit]), 
            (transitionsDelay != null ? PnetMatrix.newNative([transitionsDelay]) : ffi.nullptr), 
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

        _finalizer.attach(this, _pnet.cast());                                      // call finalizer (native pnet_delete) on pnet before dart GC frees this Pnet instance
    }

    // ------------------------------------------------------------ Geters / Setters ---------------------------------------------------

    /// get number of places
    bool get valid{
        return _pnet.ref.valid;
    }

    /// get number of places
    int get numPlaces{
        return _pnet.ref.num_places;
    }

    /// get number of transitions
    int get numTransitions{
        return _pnet.ref.num_transitions;
    }

    /// get number of inputs
    int get numInputs{
        return _pnet.ref.num_inputs;
    }

    /// get number of outputs
    int get numOutputs{
        return _pnet.ref.num_outputs;
    }

    /// get places from pnet
    List<int> get places{
        var m = PnetMatrix.fromNative(_pnet.ref.places);
        return m[0];
    }

    /// get sensitiveTransitions from pnet
    List<int> get sensitiveTransitions{
        pnetDylib.pnet_sense(_pnet);                                                // sense transitions first
        var m = PnetMatrix.fromNative(_pnet.ref.sensitive_transitions);
        return m[0];
    }

    /// get outputs from pnet
    List<int> get outputs{
        var m = PnetMatrix.fromNative(_pnet.ref.outputs);
        return m[0];
    }

    /// get neg_arcs_map from pnet
    List<List<int>> get negArcsMap{
        var m = PnetMatrix.fromNative(_pnet.ref.neg_arcs_map);
        return m;
    }

    /// get pos_arcs_map from pnet
    List<List<int>> get posArcsMap{
        var m = PnetMatrix.fromNative(_pnet.ref.pos_arcs_map);
        return m;
    }

    /// get inhibit_arcs_map from pnet
    List<List<int>> get inhibitArcsMap{
        var m = PnetMatrix.fromNative(_pnet.ref.inhibit_arcs_map);
        return m;
    }

    /// get reset_arcs_map from pnet
    List<List<int>> get resetArcsMap{
        var m = PnetMatrix.fromNative(_pnet.ref.reset_arcs_map);
        return m;
    }

    /// get places_init from pnet
    List<int> get placesInit{
        var m = PnetMatrix.fromNative(_pnet.ref.places_init);
        return m[0];
    }

    /// get transitions_delay from pnet
    List<int> get transitionsDelay{
        var m = PnetMatrix.fromNative(_pnet.ref.transitions_delay);
        return m[0];
    }

    /// get inputs_map from pnet
    List<List<int>> get inputsMap{
        var m = PnetMatrix.fromNative(_pnet.ref.inputs_map);
        return m;
    }

    /// get outputs_map from pnet
    List<List<int>> get outputsMap{
        var m = PnetMatrix.fromNative(_pnet.ref.outputs_map);
        return m;
    }

    // ------------------------------------------------------------ Methods ------------------------------------------------------------

    /// fire the petri net
    PnetError fire({List<List<int>>? inputs}){
        if(inputs == null){
            pnetDylib.m_pnet_fire(_pnet, ffi.nullptr);
        }
        else{
            // get inputs as pnet_matrix
            ffi.Pointer<pnet_matrix_t> inMatrix = PnetMatrix.newNative(inputs);
            pnetDylib.m_pnet_fire(_pnet, inMatrix);
        }

        return PnetError.values[pnetDylib.pnet_get_error()];
    }

    /// check sensible transitions
    PnetError sense(){
        pnetDylib.pnet_sense(_pnet);
        return PnetError.values[pnetDylib.pnet_get_error()];
    }
}