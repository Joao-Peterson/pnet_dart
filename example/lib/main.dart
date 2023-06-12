import 'package:flutter/material.dart';
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
	String _lasterror = "";
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
						TextButton(
                            onPressed: () {
                                var code = _pnet?.fire();
                                _lasterror = code.toString();                                
                            }, 
                            child: const Text("Fire pnet!", 
                            style: TextStyle(color: Colors.blueAccent, fontSize: 30),)
                        ),
						Text(_message, style: const TextStyle(color: Colors.white, fontSize: 30),),
						Text(_lasterror, style: const TextStyle(color: Colors.red, fontSize: 30),),
					]),
				),
			),
			backgroundColor: const Color(0xFF292828),
		),
		);
	}
}
