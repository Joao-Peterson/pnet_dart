import 'dart:ffi' as ffi;
import 'bindings.dart';
import 'package:dylib/dylib.dart';

libpnet? _pnetDylib;
libpnet get pnetDylib {
    return _pnetDylib ??= libpnet(ffi.DynamicLibrary.open(
        resolveDylibPath(
            'libpnet',
            path: "./build/linux/x64/debug/bundle/lib"
            // path: "./example/build/linux/x64/debug/bundle/lib"
        ),
    ));
}