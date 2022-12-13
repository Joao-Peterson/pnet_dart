# pnet_dart

# TOC
- [pnet\_dart](#pnet_dart)
- [TOC](#toc)
- [ffigen for libpnet](#ffigen-for-libpnet)
- [TODO](#todo)
	- [Path and variables in dylib](#path-and-variables-in-dylib)

# ffigen for libpnet

Execute:

```console
$ dart run ffigen
```

A new file [lib/src/bindingsGenerated.dart](lib/src/bindingsGenerated.dart) should be created. Edits should be made manually because of incorrect type mapping. See this issue: 

* [dart-lang/ffigen/issues/494](https://github.com/dart-lang/ffigen/issues/494) 

# TODO

## Path and variables in dylib

In [dylib.dart](lib/src/dylib.dart), set env var adn paths to load dynamic library correctly. see:

* https://github.com/jpnurmi/libserialport.dart/search?q=LIBSERIALPORT_PATH
* https://github.com/jpnurmi/flutter_libserialport/search?q=LIBSERIALPORT_PATH