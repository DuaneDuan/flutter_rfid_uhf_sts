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
  bool _isConnected = false;
  final _demo1Plugin = FlutterRfidUhfSts();
  Map<dynamic, dynamic> _configFile = {};
  List<Map<String, dynamic>> _tagData = [];
  bool _isScanning = false;
  int _keyDownCount = 0;
  int _scanTimes = 0;
  StreamSubscription<Map<String, dynamic>>? _dataSubscription;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _demo1Plugin.streamInit();
    _dataSubscription = _demo1Plugin.dataStream.listen((newValue) async {
      if (newValue['keyCount'] != null) {
        if (newValue['keyCount'] % 2 == 0) {
          if (_isConnected) {
            _isScanning = (await _demo1Plugin.stopScan)!;
          }
        } else {
          if (!_isConnected) {
            _isConnected = (await _demo1Plugin.connect)!;
          }
          if (_isConnected) {
            _isScanning = (await _demo1Plugin.startScan)!;
          }
        }
      }
      setState(() {
        _keyDownCount = newValue['keyCount'] ?? 0;
        _tagData = newValue['tagData'] ?? [];
        _scanTimes = _scanTimes + 1;
        print("扫描到的标签记录：${_tagData.length},扫描次数：${_scanTimes}");
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
          await _demo1Plugin.getPlatformVersion() ?? 'Unknown platform version';
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
      configFile = await _demo1Plugin.getConfigure() ?? {};
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
      tagData = await _demo1Plugin.getTagData() ?? [];
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
              title: const Text('Plugin example app'),
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
                      bool isConnected = await _demo1Plugin.connect ?? false;
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
                          await _demo1Plugin.isConnected ?? false;
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
                      'DisConnect',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    onPressed: () async {
                      bool isConnected = await _demo1Plugin.disconnect ?? false;
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
                      if (!_isConnected) {
                        bool con = await _demo1Plugin.connect ?? false;
                        setState(() {
                          _isConnected = con;
                        });
                        if (con) {
                          bool isScanning =
                              await _demo1Plugin.startScan ?? false;
                          setState(() {
                            _isScanning = isScanning;
                          });
                        }
                      } else {
                        if (!_isScanning) {
                          bool isScanning =
                              await _demo1Plugin.startScan ?? false;
                          setState(() {
                            _isScanning = isScanning;
                          });
                        }
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
                      bool isScanning = await _demo1Plugin.stopScan ?? false;
                      setState(() {
                        _isScanning = isScanning;
                      });
                    }
                  },
                ),
                Text('First Tag data File: ${_tagData}\n'),
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
                Text('Scan Times: ${_scanTimes.toString()} \n'),
              ]),
            )));
  }
}
