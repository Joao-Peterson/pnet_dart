import 'dart:ffi' as ffi;
import 'bindings.dart';
import 'dylib.dart';
import 'pnet_error.dart';

class PnetMatrix{
    late ffi.Pointer<pnet_matrix_t> _m;

    // constructor
    PnetMatrix(int x, int y){
        _m = pnetDylib.pnet_matrix_new_zero(x, y);

        if(pnetDylib.pnet_get_error() != pnet_error_t.pnet_info_ok){
            throw PnetException();
        } 
    }

    // constructor
    PnetMatrix.from(PnetMatrix matrix){
        try{
            _m = pnetDylib.pnet_matrix_duplicate(matrix._m);
        }
        catch (e){
            rethrow;
        }
    }

    // copy from a matrix to this one
    void copy(PnetMatrix matrix){
        try{
            pnetDylib.pnet_matrix_copy(_m, matrix._m);
        }
        catch (e){
            rethrow;
        }
    }

    // destructor
    void dispose(){
        pnetDylib.pnet_matrix_delete(_m);
    }

    // how many columns
    int get x{
        return _m.ref.x;
    }

    // how many rows
    int get y{
        return _m.ref.y;
    }

    // get value at position
    int getValueAt(int x, int y){
        if((x >= _m.ref.x) || (y >= _m.ref.y)){
            throw PnetException.scratch("value out of bounds", 50);
        }

        return _m.ref.m.elementAt(y).value.elementAt(x).value;
    }

    // set value at position
    void setValueAt(int x, int y, int value){
        if((x >= _m.ref.x) || (y >= _m.ref.y)){
            throw PnetException.scratch("value out of bounds", 50);
        }

        _m.ref.m.elementAt(y).value.elementAt(x).value = value;
    }

    // multiply by a matrix
    void multiply(PnetMatrix matrix){
        ffi.Pointer<pnet_matrix_t> ret;
        try{
            ret = pnetDylib.pnet_matrix_mul(_m, matrix._m);
        }
        catch (e){
            rethrow;
        }
        
        pnetDylib.pnet_matrix_delete(_m);
        _m = ret;
    }

    // multiply by a matrix, element by element
    void multiplyElementByElement(PnetMatrix matrix){
        ffi.Pointer<pnet_matrix_t> ret;
        try{
            ret = pnetDylib.pnet_matrix_mul_by_element(_m, matrix._m);
        }
        catch (e){
            rethrow;
        }
        
        pnetDylib.pnet_matrix_delete(_m);
        _m = ret;
    }

    // multiply by a scalar
    void multiplyScalar(int scalar){
        ffi.Pointer<pnet_matrix_t> ret;
        try{
            ret = pnetDylib.pnet_matrix_mul_scalar(_m, scalar);
        }
        catch (e){
            rethrow;
        }
        
        pnetDylib.pnet_matrix_delete(_m);
        _m = ret;
    }

    // add two matrices
    void add(PnetMatrix matrix){
        ffi.Pointer<pnet_matrix_t> ret;
        try{
            ret = pnetDylib.pnet_matrix_add(_m, matrix._m);
        }
        catch (e){
            rethrow;
        }
        
        pnetDylib.pnet_matrix_delete(_m);
        _m = ret;
    }

    // logical and two matrices
    void logicalAnd(PnetMatrix matrix){
        ffi.Pointer<pnet_matrix_t> ret;
        try{
            ret = pnetDylib.pnet_matrix_and(_m, matrix._m);
        }
        catch (e){
            rethrow;
        }
        
        pnetDylib.pnet_matrix_delete(_m);
        _m = ret;
    }

    // logical negate the matrix
    void logicalNot(){
        ffi.Pointer<pnet_matrix_t> ret;
        try{
            ret = pnetDylib.pnet_matrix_neg(_m);
        }
        catch (e){
            rethrow;
        }
        
        pnetDylib.pnet_matrix_delete(_m);
        _m = ret;
    }

    // transpose the matrix
    void transpose(){
        ffi.Pointer<pnet_matrix_t> ret;
        try{
            ret = pnetDylib.pnet_matrix_transpose(_m);
        }
        catch (e){
            rethrow;
        }
        
        pnetDylib.pnet_matrix_delete(_m);
        _m = ret;
    }

    // compares to see if two matrices are equal in a element by element manner
    bool ifEqual(PnetMatrix matrix){
        try{
            return pnetDylib.pnet_matrix_cmp_eq(_m, matrix._m) as bool;
        }
        catch (e){
            rethrow;
        }
    }

    // sets all values of a matrix to the specified number 
    void set(int value){
        try{
            pnetDylib.pnet_matrix_set(_m, value);
        }
        catch (e){
            rethrow;
        }
    }
}