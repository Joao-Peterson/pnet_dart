import 'dart:ffi' as ffi;
import 'bindings.dart';
import 'dylib.dart';
import 'pnet_error.dart';

/// matrix of type int, can be constructed by calling PnetMatrix() or PnetMatrix.from()
class PnetMatrix{
    /// pointer to native type matrix
    late ffi.Pointer<pnet_matrix_t> _m;

    /// creates a native matrix from a dart double list
    static List<List<int>> fromNative(ffi.Pointer<pnet_matrix_t> matrix){
        int x = matrix.ref.x;
        int y = matrix.ref.y;

        List<List<int>> m = [];
        List<int> row = [];

        for(int i = 0; i < y; i++){
            for(int j = 0; j < x; j++){
                row.add(matrix.ref.m.elementAt(i).value.elementAt(j).value);
            }
            m.add(row);
        }

        return m;
    }

    /// creates a native matrix from a dart double list
    static ffi.Pointer<pnet_matrix_t> newNative(List<List<int>> values){
        int x = values[0].length;
        int y = values[0].length;
        ffi.Pointer<pnet_matrix_t> m = pnetDylib.pnet_matrix_new_zero(x, y);

        for(int i = 0; i < y; i++){
            for(int j = 0; j < x; j++){
                m.ref.m.elementAt(i).value.elementAt(j).value = values[i][j];
            }
        }

        return m;
    }

    /// creates a matrix by passing a 2d list of [values]
    PnetMatrix(List<List<int>> values){
        _m = newNative(values);

        if(pnetDylib.pnet_get_error() != pnet_error_t.pnet_info_ok){
            throw PnetException();
        } 
    }

    /// creates a new empty matrix given it's [x] width and [y] height
    PnetMatrix.empty(int x, int y){
        _m = pnetDylib.pnet_matrix_new_zero(x, y);

        if(pnetDylib.pnet_get_error() != pnet_error_t.pnet_info_ok){
            throw PnetException();
        } 
    }

    /// creates a new matrix as a copy from another [matrix] 
    PnetMatrix.from(PnetMatrix matrix){
        try{
            _m = pnetDylib.pnet_matrix_duplicate(matrix._m);
        }
        catch (e){
            rethrow;
        }
    }

    /// copy values from a [matrix] to this one
    void copy(PnetMatrix matrix){
        try{
            pnetDylib.pnet_matrix_copy(_m, matrix._m);
        }
        catch (e){
            rethrow;
        }
    }

    /// destructor, free memory from the library allocations
    void dispose(){
        pnetDylib.pnet_matrix_delete(_m);
    }

    /// get how many columns
    int get x{
        return _m.ref.x;
    }

    /// get how many rows
    int get y{
        return _m.ref.y;
    }

    /// get value at position [x] and [y]
    int getValueAt(int x, int y){
        if((x >= _m.ref.x) || (y >= _m.ref.y)){
            throw PnetException.custom("pnet_matrix_error_value_out_of_bounds");
        }

        return _m.ref.m.elementAt(y).value.elementAt(x).value;
    }

    /// set value at position [x] and [y]
    void setValueAt(int x, int y, int value){
        if((x >= _m.ref.x) || (y >= _m.ref.y)){
            throw PnetException.custom("pnet_matrix_error_value_out_of_bounds");
        }

        _m.ref.m.elementAt(y).value.elementAt(x).value = value;
    }

    /// multiply matrix by another [matrix]
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

    /// multiply by another [matrix], element by element instead of normal matrix multiplication
    /// both must have the same size
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

    /// multiply matrix by a [scalar]
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

    /// add matrix to another [matrix]
    /// both must be of the same size
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

    /// logical and matrix to another [matrix], element by element
    /// both must have the same size
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

    /// logical negate the matrix, truthy values becomes 0 and falsy values becomes 1
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

    /// transpose the matrix
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

    /// compares if matrix is equal to [matrix] in a corresponding element by element manner
    bool ifEqual(PnetMatrix matrix){
        try{
            return pnetDylib.pnet_matrix_cmp_eq(_m, matrix._m) as bool;
        }
        catch (e){
            rethrow;
        }
    }

    /// sets all values of a matrix to the specified [value] 
    void set(int value){
        try{
            pnetDylib.pnet_matrix_set(_m, value);
        }
        catch (e){
            rethrow;
        }
    }
}