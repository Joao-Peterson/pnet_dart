import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pnet_dart/pnet_dart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
	String _message = "Initializing...";
	// final _pnetDartPlugin = PnetDart();
	Pnet? _pnet;

	@override
	void initState() {
		super.initState();
		try {
			_pnet = Pnet(
				negArcsMap: [
					[-1, 0, 0],
					[ 0, -1, 0],
					[0, 0, -1],
				],
				posArcsMap: [
					[ 0, 0, 1],
					[ 1, 0, 0],
					[ 0, 1, 0],
				],
				placesInit: [1, 0, 0],
				transitionsDelay: [3000, 0, 0],
				callback: (p0, transition) {
					setState(() {
						if(_pnet != null){
							var p =_pnet!.places;
							_message = "Places: $p. Last transition: $transition";
						}
					});
				},
			);

			var p =_pnet!.places;
			_message = "Places: [$p]";
		} catch (e) {
			_message = e.toString();
		}
	}

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
		home: Scaffold(
			appBar: AppBar(
				title: const Text('Pnet example'),
			),
			body: Center(
				child: Align(
					alignment: Alignment.center,
					child: Column(
						mainAxisAlignment: MainAxisAlignment.center,
						children: [
						TextButton(onPressed: () {_pnet?.fire();}, child: const Text("Fire pnet!", style: TextStyle(color: Colors.blueAccent, fontSize: 30),)),
						Text(_message, style: const TextStyle(color: Colors.white, fontSize: 30),)
					]),
				),
			),
			backgroundColor: const Color(0xFF292828),
		),
		);
	}

  // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     String platformVersion;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     // We also handle the message potentially returning null.
//     try {
//       platformVersion =
//           await _pnetDartPlugin.getPlatformVersion() ?? 'Unknown platform version';
//     } on PlatformException {
//       platformVersion = 'Failed to get platform version.';
//     }

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;

//     setState(() {
//       _platformVersion = platformVersion;
//     });
//   }

}
