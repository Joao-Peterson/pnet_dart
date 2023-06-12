import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:isolate';
import 'dart:typed_data';
import 'pnet_matrix.dart';
import 'dylib.dart';
import 'bindings.dart';
import 'pnet_error.dart';

/// callback for the pnet 
typedef PnetCallback<cbData> = void Function(cbData?, int);

/// input events for transitions
abstract class PnetEvt{
    static const int none       = 0;                                                /// No input event, transition will trigger if sensibilized. Same as 0
    static const int posEdge    = 1;                                                /// The input must be 0 then 1 so the transition can trigger
    static const int negEdge    = 2;                                                /// The input must be 1 then 0 so the transition can trigger
    static const int anyEdge    = 3;                                                /// The input must be change state from 1 to 0 or vice versa
}

/// class that represents a petrinet
class Pnet<cbDataT> implements ffi.Finalizable{

    // ------------------------------------------------------------ Members ------------------------------------------------------------

    /// pointer to native type petrinet
    late ffi.Pointer<pnet_t> _pnet;

    //TODO(peterson): reenable this when [https://github.com/dart-lang/sdk/issues/49083] gets merged
    /// finalizer used to call native delete methods on dart GC free
    // static final _finalizer_native = ffi.NativeFinalizer(pnetDylib.native_pnet_delete.cast());

    /// callback to call on event 
    PnetCallback? _callback;

    /// callback data to use on event 
    cbDataT? _callbackData;

    // ------------------------------------------------------------ Native lib stuff ---------------------------------------------------

    /// call dart lib init once
    static bool _libInitFlag = false;

    /// initialize dart native lib
    static bool _libInit(){
        if(!_libInitFlag){
            if(pnetDylib.initDartApiDl(ffi.NativeApi.initializeApiDLData) != 0){
                return false;
            } 
            _libInitFlag = true;
        }

        return true;
    }

    /// port
    late ReceivePort _port;

    /// callback for port receiving
    void _portOnData(dynamic message){
        int transition = message as int;
        _callback!(_callbackData, transition);                                      // call dart callback. This _callback is called inside _portOnData that is called inside .listen on the Receive port, all in the event loop, or so i'm told XD         
    } 

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
        PnetCallback? callback,
        cbDataT? data
    }){
        if(!_libInit()){                                                            // init lib
            throw PnetException.custom(PnetError.errorCouldNotIniializeNativeLib);
        }
        
        _port = ReceivePort()..listen(_portOnData);                                 // create a receiveport and add handler onData

        // create pnet
        // all optional arguments are checked and exchanged by NULL ptr if necessary
        _pnet = pnetDylib.m_pnet_new_fromdart(
            (negArcsMap != null ? PnetMatrix.newNative(negArcsMap) : ffi.nullptr), 
            (posArcsMap != null ? PnetMatrix.newNative(posArcsMap) : ffi.nullptr), 
            (inhibitArcsMap != null ? PnetMatrix.newNative(inhibitArcsMap) : ffi.nullptr), 
            (resetArcsMap != null ? PnetMatrix.newNative(resetArcsMap) : ffi.nullptr), 
            PnetMatrix.newNative([placesInit]), 
            (transitionsDelay != null ? PnetMatrix.newNative([transitionsDelay]) : ffi.nullptr), 
            (inputsMap != null ? PnetMatrix.newNative(inputsMap) : ffi.nullptr), 
            (outputsMap != null ? PnetMatrix.newNative(outputsMap) : ffi.nullptr), 
            _port.sendPort.nativePort
        );

        _callback = callback;
        _callbackData = data;

        if(pnetDylib.pnet_get_error() != pnet_error_t.pnet_info_ok){                // check for errors
            if(_pnet != ffi.nullptr){
                pnetDylib.pnet_delete(_pnet);
            }
            throw PnetException();
        }
        
        //TODO(peterson): reenable this when [https://github.com/dart-lang/sdk/issues/49083] gets merged
        // _finalizer_native.attach(this, _pnet.cast(), detach: this);                 // call finalizer (native pnet_delete) on pnet before dart GC frees this Pnet instance
    }

    /// deserializes data into a new petri net
    /// [data]          array of bytes from the file format .pnet
    /// [callback]      callback function of type pnet_callback_t that is called after firing operations asynchronously, useful for timed transitions
    /// [callbackData]  data given by the user to passed on call to the callback function in it's data parameter. A void pointer
    Pnet.deserialize(Uint8List data, PnetCallback callback, cbDataT callbackData){
        var nativedata = malloc<ffi.Uint8>(data.length);

        for(var i = 0; i < data.length; i++)                                        // create native data array
            nativedata.elementAt(i).value = data[i];

        if(!_libInit()){                                                            // init lib
            throw PnetException.custom(PnetError.errorCouldNotIniializeNativeLib);
        }
        
        this._port = ReceivePort()..listen(_portOnData);                            // create a receiveport and add handler onData

        this._pnet = pnetDylib.pnet_deserialize_fromdart(nativedata.cast<ffi.Void>(), data.length, this._port.sendPort.nativePort);
        malloc.free(nativedata);

        if(pnetDylib.pnet_get_error() != pnet_error_t.pnet_info_ok){                // check for errors
            if(_pnet != ffi.nullptr){
                pnetDylib.pnet_delete(_pnet);
            }
            throw PnetException();
        }       

        this._callback = callback;
        this._callbackData = callbackData;
    }

    /// loads from file into a new petri net
    /// [data]          array of bytes from the file format .pnet
    /// [callback]      callback function of type pnet_callback_t that is called after firing operations asynchronously, useful for timed transitions
    /// [callbackData]  data given by the user to passed on call to the callback function in it's data parameter. A void pointer
    Pnet.load(String filename, PnetCallback callback, cbDataT callbackData){
        if(!_libInit()){                                                            // init lib
            throw PnetException.custom(PnetError.errorCouldNotIniializeNativeLib);
        }
        
        this._port = ReceivePort()..listen(_portOnData);                            // create a receiveport and add handler onData

        var fname = filename.toNativeUtf8();

        this._pnet = pnetDylib.pnet_load_fromdart(fname.cast<ffi.Char>(), this._port.sendPort.nativePort);
        malloc.free(fname);

        if(pnetDylib.pnet_get_error() != pnet_error_t.pnet_info_ok){                // check for errors
            if(_pnet != ffi.nullptr){
                pnetDylib.pnet_delete(_pnet);
            }
            throw PnetException();
        }       

        this._callback = callback;
        this._callbackData = callbackData;
    }

    //TODO(peterson): remove this when [https://github.com/dart-lang/sdk/issues/49083] gets merged
    /// destroy instance, needed cause it free native memory and receivePort
    void destroy(){
        pnetDylib.pnet_delete(_pnet);
        _port.close();
    }

    // ------------------------------------------------------------ Geters / Setters ---------------------------------------------------

    /// get native pnet pointer
    ffi.Pointer<pnet_t> get nativePnet{
        if(_pnet == ffi.nullptr)
            Exception("Native pnet is NULL");

        return _pnet;
    }

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
    PnetError fire({List<int>? inputs}){
        if(inputs == null){
            pnetDylib.m_pnet_fire(_pnet, ffi.nullptr);
        }
        else{
            // get inputs as pnet_matrix
            ffi.Pointer<pnet_matrix_t> inMatrix = PnetMatrix.newNative([inputs]);
            pnetDylib.m_pnet_fire(_pnet, inMatrix);
        }

        return PnetError.values[pnetDylib.pnet_get_error()];
    }

    /// check sensible transitions
    PnetError sense(){
        pnetDylib.pnet_sense(_pnet);
        return PnetError.values[pnetDylib.pnet_get_error()];
    }

    /// serializes a petri net to a file format, including internal state!
    Uint8List serialize(){
        var size = malloc<ffi.Size>(2);
        var data = pnetDylib.pnet_serialize(this._pnet, size).cast<ffi.Uint8>();

        if(pnetDylib.pnet_get_error() != pnet_error_t.pnet_info_ok){
            malloc.free(size);
            malloc.free(data);
            throw PnetException();
        }

        var list = Uint8List(size.value);
        for(var i = 0; i < size.value; i++){
            list[i] = data.elementAt(i).value;
        }
        
        malloc.free(size);
        malloc.free(data);

        return list;
    } 
    
    /// serializes a petri net and save it to a file
    void save(String filename){
        var fname = filename.toNativeUtf8();
        pnetDylib.pnet_save(this._pnet, fname.cast<ffi.Char>());

        malloc.free(fname);

        if(pnetDylib.pnet_get_error() != pnet_error_t.pnet_info_ok){
            throw PnetException();
        }
    }
}