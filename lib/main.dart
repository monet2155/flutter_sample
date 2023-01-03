import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = const MethodChannel('samples.flutter.dev/battery');
  static const event = const MethodChannel('com.example.foo');

  String _batteryLevel = 'Unknown battery level.';

  String eventText = "";

  Future<void> invokeMethod() async {
    try {
      final String result = await platform.invokeMethod('eventTest');
    } on PlatformException catch (e) {}
  }

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<void> _didRecieveTranscript(MethodCall call) async {
    // type inference will work here avoiding an explicit cast
    // final String utterance = call.arguments;
    // switch(call.method) {
    //   case "didRecieveTranscript":
    //     processUtterance(utterance);
    // }
    if (call.method == "test") {
      setState(() {
        eventText = "test";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    event.setMethodCallHandler(_didRecieveTranscript);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _getBatteryLevel,
              child: const Text('Get Battery Level'),
            ),
            Text(_batteryLevel),
            ElevatedButton(
              onPressed: invokeMethod,
              child: const Text('Get Battery Level'),
            ),
            Text("test : " + eventText),
          ],
        ),
      ),
    );
  }
}
