import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_rfid_uhf_sts_platform_interface.dart';

/// An implementation of [FlutterRfidUhfStsPlatform] that uses method channels.
class MethodChannelFlutterRfidUhfSts extends FlutterRfidUhfStsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('STS_RFID_UHF');
  int keyStatus = 0;
  static final StreamController<int> _keyDownController = StreamController<int>();

  @override
  Stream<int> get dataStream => _keyDownController.stream;

  @override
  Future<void> keyDownInit() async {
    try {
      methodChannel.setMethodCallHandler(_handleMethod);
      await methodChannel.invokeMethod('keyDown');
    } catch (e) {
      // print(e.toString());
    }
  }


  Future<void> _handleMethod(MethodCall call) async {
    if (call.method == 'keyDown') {
      keyStatus = keyStatus + 1;
      _keyDownController.add(keyStatus);
    }
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool?> get connect async {
    return methodChannel.invokeMethod('connect');
  }

  @override
  Future<bool?> get disconnect async {
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
  Future<Map<dynamic,dynamic>?> getConfigure() async {
    return methodChannel.invokeMethod('getConfigure');
  }

  @override
  Future<List<dynamic>?> getTagData() async {
    return methodChannel.invokeMethod('readData');
  }
  @override
  int get keyCount  {
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
