# contributing

- [contributing](#contributing)
- [running](#running)
	- [compiling the native code](#compiling-the-native-code)
	- [ffigen for libpnet](#ffigen-for-libpnet)

# running

## compiling the native code

libpnet is the core of this project and is inserted as a git submodule, compiled by the flutter build system using [linux/libpnet/CMakeLists.txt](linux/libpnet/CMakeLists.txt). The submodule is fixed on a version via a pulled git tag, each version of dart_pnet should have matching version for libpnet to mantain functionality, so changes to the submodule must be manual.

To compile the underlying native libpnet code, we must compile the example project, so we can test it. Example for a linux build:

Release:

```console
$ cd example
$ flutter build linux
```

Debug (important if you want to use IDE visual debug):

```console
$ cd example
$ flutter build linux --debug
```

## ffigen for libpnet

The bindings for the library were generated a single time and edited manually after that, generated file: [bindings.dart](lib/src/bindings.dart). To regenerate again:

Execute:

```console
$ dart run ffigen
```

A new file [lib/src/bindingsGenerated.dart](lib/src/bindingsGenerated.dart) should be created. Edits should be made manually because of incorrect type mapping. See this issue: 

* [C size_t is being mapped to ffi.Int instead of ffi.Size](https://github.com/dart-lang/ffigen/issues/494) 
