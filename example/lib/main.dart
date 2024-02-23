import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_rfid_uhf_sts/flutter_rfid_uhf_sts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterRfidUhfStsPlugin = FlutterRfidUhfSts();
  bool _isConnected = false;
  Map<dynamic, dynamic> _configFile = {};
  List<Map<String, dynamic>> _tagData = [];
  bool _isScanning = false;
  int _keyDownCount = 0;
  StreamSubscription<int>? _dataSubscription;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _flutterRfidUhfStsPlugin.keyDown();
    _dataSubscription = _flutterRfidUhfStsPlugin.dataStream.listen((newValue) async {
      if (newValue % 2 == 0) {
        if (_isConnected) {
          _isScanning = (await _flutterRfidUhfStsPlugin.stopScan)!;
        }
      } else {
        if (_isConnected) {
          _isScanning = (await _flutterRfidUhfStsPlugin.startScan)!;
        }
      }
      setState(() {
        _keyDownCount = newValue;
      });
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.

    try {
      platformVersion =
          await _flutterRfidUhfStsPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> getConfigure() async {
    Map<dynamic, dynamic> configFile;

    try {
      configFile = await _flutterRfidUhfStsPlugin.getConfigure() ?? {};
    } on PlatformException {
      configFile = {"error": 'Get Configure file error!'};
    }

    setState(() {
      _configFile = configFile;
    });
  }

  Future<void> getTagData() async {
    List<Map<String, dynamic>> tagData;
    try {
      tagData = await _flutterRfidUhfStsPlugin.getTagData() ?? [];
    } on PlatformException {
      tagData = [
        {"ERROR": "ERROR GET TAG DATA"}
      ];
    }
    setState(() {
      _tagData = tagData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('STS RFID UHF Plugin example app'),
            ),
            body: SingleChildScrollView(
              child:
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text('Connected Status: $_isConnected\n'),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )),
                    child: const Text(
                      'connect',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    onPressed: () async {
                      bool isConnected = await _flutterRfidUhfStsPlugin.connect ?? false;
                      setState(() {
                        _isConnected = isConnected;
                      });
                    }),
                Text('Configure File: $_configFile\n'),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )),
                    child: const Text(
                      'getConfigure',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    onPressed: () async {
                      await getConfigure();
                    }),
                Text('isConnected Status: $_isConnected\n'),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )),
                    child: const Text(
                      'check Connect Status',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    onPressed: () async {
                      bool isConnected =
                          await _flutterRfidUhfStsPlugin.isConnected ?? false;
                      setState(() {
                        _isConnected = isConnected;
                      });
                    }),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )),
                    child: const Text(
                      'Close',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    onPressed: () async {
                      bool isConnected = await _flutterRfidUhfStsPlugin.disconnect ?? false;
                      setState(() {
                        _isConnected = !isConnected;
                      });
                    }),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )),
                    child: const Text(
                      'Start Scan',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    onPressed: () async {
                      if (_isConnected && !_isScanning) {
                        bool isScanning = await _flutterRfidUhfStsPlugin.startScan ?? false;
                        setState(() {
                          _isScanning = isScanning;
                        });
                      }
                    }),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )),
                  child: const Text(
                    'Stop Scan',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  onPressed: () async {
                    if (_isConnected && _isScanning) {
                      bool isScanning = await _flutterRfidUhfStsPlugin.stopScan ?? false;
                      setState(() {
                        _isScanning = isScanning;
                      });
                    }
                  },
                ),
                Text(
                    'Tag data File: $_tagData'),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )),
                    child: const Text(
                      'read tag data',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    onPressed: () async {
                      await getTagData();
                    }),
                Text('Key Status: ${_keyDownCount.toString()} \n'),
              ]),
            )));
  }
}
