import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_rfid_uhf_sts_platform_interface.dart';

/// An implementation of [FlutterRfidUhfStsPlatform] that uses method channels.
class MethodChannelFlutterRfidUhfSts extends FlutterRfidUhfStsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('demo1');
  int keyStatus = 0;
  List<Map<String, dynamic>> tagData = [];
  Map<String, dynamic> data = {};
  StreamController<Map<String, dynamic>> _dataController = StreamController<Map<String, dynamic>>.broadcast();

  // static final StreamController<List<Map<String,dynamic>>> _TagsController = StreamController<List<Map<String,dynamic>>>();

  @override
  Stream<Map<String, dynamic>> get dataStream {
    if ( _dataController.isClosed) {
      _dataController = StreamController<Map<String, dynamic>>.broadcast(); // Use broadcast for multiple listeners
    }
    return _dataController.stream;
  }

  @override
  Future<void> streamInit() async {
    try {
      methodChannel.setMethodCallHandler(_handleMethod);
      await methodChannel.invokeMethod('keyDown');
      await methodChannel.invokeMethod('sendData');
    } catch (e) {
      // print(e.toString());
    }
  }

  @override
  Future<void> streamClose() async {
    try {
      if (!_dataController.isClosed) {
        _dataController.close();
      }
    } catch (e) {
      // Handle exception
    }
  }

  Future<void> _handleMethod(MethodCall call) async {
    // print("handleMethod: ${call.method}");
    if (call.method == 'keyDown') {
      keyStatus = keyStatus + 1;
      data['keyCount'] = keyStatus;
      _dataController.add(data);
    }
    if (call.method == 'sendData') {
      List<dynamic>? result = await getTagData();
      if (result is List<dynamic>) {
        List<Map<String, dynamic>> resultMapList = result
            .map<Map<String, dynamic>>(
                (item) => Map<String, dynamic>.from(item))
            .toList();
        tagData = resultMapList;
        data['tagData'] = tagData;
        _dataController.add(data);
      }
    }
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool?> get connect async {
    return methodChannel.invokeMethod('connect');
  }

  @override
  Future<bool?> get disconnect async {
    return methodChannel.invokeMethod('disConnect');
  }

  @override
  Future<bool?> get close async {
    return methodChannel.invokeMethod('close');
  }

  @override
  Future<bool?> get isConnected async {
    return methodChannel.invokeMethod('isConnected');
  }

  @override
  Future<bool?> get startScan async {
    return methodChannel.invokeMethod('startScaning');
  }

  @override
  Future<bool?> get stopScan async {
    return methodChannel.invokeMethod('stopScaning');
  }

  @override
  Future<bool?> get isScanning async {
    return methodChannel.invokeMethod('isScaning');
  }

  @override
  Future<bool?> get isEmptyTags async {
    return methodChannel.invokeMethod('isEmptyTags');
  }

  @override
  Future<Map<dynamic, dynamic>?> getConfigure() async {
    return methodChannel.invokeMethod('getConfigure');
  }

  @override
  Future<List<dynamic>?> getTagData() async {
    return methodChannel.invokeMethod('readData');
  }

  @override
  int get keyCount {
    return keyStatus;
  }

  @override
  Future<void> clearTags() async {
    return methodChannel.invokeMethod('clearData');
  }

  @override
  Future<bool?> writeData() {
    return methodChannel.invokeMethod('writeData');
  }
}
