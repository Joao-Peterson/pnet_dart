![](https://img.shields.io/github/license/Joao-Peterson/pnet) ![](https://img.shields.io/badge/Version-1.0.0-brightgreen) ![](https://img.shields.io/github/last-commit/Joao-Peterson/pnet_dart)

# pnet_dart

This is a dart library that wraps the [libpnet](https://github.com/Joao-Peterson/pnet) C/C++ library with flutter's build system.

This package provides a petri net implementation where you can define petri net's, define inputs and outputs, and save and read to file. 

This implementation can create high level timed petri nets, with weighted arcs, negated arcs and reset arcs, input events and outputs.

# TOC
- [pnet\_dart](#pnet_dart)
- [TOC](#toc)
- [Usage](#usage)
	- [Arguments](#arguments)
		- [Weighted arcs](#weighted-arcs)
		- [Inhibit arcs](#inhibit-arcs)
		- [Reset arcs](#reset-arcs)
		- [Input events](#input-events)
		- [Delay](#delay)
		- [Outputs](#outputs)
		- [Callback](#callback)
	- [Error handling](#error-handling)
- [TODO](#todo)
	- [Path and variables in dylib](#path-and-variables-in-dylib)

# Usage

```dart
import 'package:pnet_dart/pnet.dart';

var pnet = Pnet(
	posArcsMap: [
        [-1, 0],
        [ 0, 0],
        [ 0, 0],
	],
	negArcsMap: [
        [ 0, 0],
        [ 1, 0],
        [ 0, 1],
	],
	inhibitArcsMap: [
        [ 0, 1],
        [ 0, 0],
        [ 0, 0],
	],
	resetArcsMap: [
        [ 0, 0],
        [ 0, 1],
        [ 0, 0],
	],
	placesInit:
		[1, 0, 0],
	transitionsDelay:
        [0, 0],
	inputsMap: [
        [pnet_event_none, pnet_event_pos_edge],
        [pnet_event_none, pnet_event_none],
	],
	outputsMap: [
        [1,0,0],
        [0,1,0],
        [0,0,1],
	],
	callback: null,
	data: null
); 
```

Note how you can pass weighted arcs, inhibit arcs, reset arcs, the initial tokens for the places, delay for transitions, inputs events and outputs in order, however, only the `placesInit` and **at least one** type of arc are required, so very simple declarations can be made, like this:

```dart 
var pnet = Pnet(
	posArcsMap: [
        [-1],
        [0],
	]
	negArcsMap: [
       [0],
       [1],
	]
    placesInit: [
		[1, 0]
	]
);
```

To execute your petri net just call `pnet.fire`:

```dart
pnet.fire([1,0]);
```

This will execute **one and only transition** at a time, so the execution is made in stepped manner.

## Arguments

### Weighted arcs

Weighted arcs define the amount of token that are consumed and given by some transition. Represented in matrix form by two matrices, it's shape should be like:

```dart
posArcsMap: [
    [-1, 0],
    [ 0, 0],
    [ 0, 0]
],
negArcsMap: [
    [ 0, 0],
    [ 1, 0],
    [ 0, 1]
],
```

The first matrix are the positive weights, the second are the negative weights. Notice how the columns represent the transitions and rows the places. In the example we are telling that for the first transition, 1 token will be consumed from the first place, and 1 token will be given to the second place, and for the second transition, a token will be given to the third place.

When there are no negative weights, a transition can fire at any time, so negative weights act as conditions/restrictions for a transition to fire.

### Inhibit arcs

Inhibit arcs define that a transition shall occur when there are no token in the specified place. Represented in matrix form, values can be only 1 or 0:

```dart
inhibitArcsMap: [
    [0, 1],
    [0, 0],
    [0, 0]
]
```

In the example we are saying that for the second transition to fire, no tokens can be present in the first place. This type of arc doesn't move any tokens like the reset or weighted arcs, it solely represents a condition, like the negative weights in the weighted arcs.


### Reset arcs

Reset arcs express the act of setting the number of tokens in a place to 0 if the transition specified is fired. Represented in matrix form, values can be only 1 or 0:

```dart
resetArcsMap: [
    [0, 0],
    [0, 1],
    [0, 0]
]
```

In the example we are saying that the second transition will reset the tokens in the second place when fired. This type of arc expresses change, like the weighted arcs, but no condition/restriction.

### Input events

Inputs can be passed to `Pnet.fire` and based on the events set by the `inputsMap` argument in `Pnet()` can dictate the triggering of transitions. 

`inputsMap` is given in matrix form, only the values of the enumerator `PnetEvt` are valid.

```dart
inputsMap: [
    [PnetEvt.none, PnetEvt.posEdge],
    [PnetEvt.none, PnetEvt.none]
]
```

The columns are the transitions and the rows are the inputs. 

Only one input event can be assigned to a single transition.

`PnetEvt.none` and 0 are the same.

The events are as follow:

```dart
PnetEvt.none    = 0; /// No input event, transition will trigger if sensibilized. Same as 0
PnetEvt.posEdge = 1; /// The input must be 0 then 1 so the transition can trigger
PnetEvt.negEdge = 2; /// The input must be 1 then 0 so the transition can trigger
PnetEvt.anyEdge = 3; /// The input must be change state from 1 to 0 or vice versa
```

Firing can be called with or without inputs:

```dart
pnet.fire([1,0]);
```

```dart
pnet.fire();
```

### Delay

You can add delay to transitions by mapping the value in milliseconds to every transition, a 0 represents a instant transition. Given in matrix form, one row and the columns are the transitions.

```dart
// 500 ms delay on transition 0
transitionsDelay: [
    [500, 0]                                                      
]
```

Note that when using instant transitions, after the `Pnet.fire` call, the tokens would have moved already, but when using a delay you can only expect the net state after the define time, so to react accordingly you have to provide a callback, see section [Callback](#callback). When a callback is given it will be called after a delayed transition is fired.

### Outputs

Outputs are given in matrix form, values can be only 1 and 0.

```dart
outputsMap: [
    [1,0,0],
    [0,1,0],
    [0,0,1]
]
```

The columns are the outputs and the rows are the places. A output is only 1 when there >0 tokens inside the respective place.

The state of the outputs can be accessed reading the `outputs` member of the `Pnet` class.

```dart
pnet.outputs
```

### Callback

A callback of type `PnetCallback` must be provided as an argument when using timed transitions. **It will** be called after the execution of the delay for a given transition and that transition still is sensible. **It is also called** when a instant transition is fired.

It's form is as follows:

```dart
void cb(cbData? data, int transition){
    // you code here
}
```

The `data` parameter is given to you as passed when creating the petri net with `Pnet<cbData>(data: something)`.

## Error handling

Errors of type `PnetException` are thrown with every call and some function like `Pnet.fire` will return a `PnetError` enumerator error, if you want an error message, just call `.toString()` on the returned enum value;

# TODO

## Path and variables in dylib

In [dylib.dart](lib/src/dylib.dart), set env var adn paths to load dynamic library correctly. see:

* https://github.com/jpnurmi/libserialport.dart/search?q=LIBSERIALPORT_PATH
* https://github.com/jpnurmi/flutter_libserialport/search?q=LIBSERIALPORT_PATH