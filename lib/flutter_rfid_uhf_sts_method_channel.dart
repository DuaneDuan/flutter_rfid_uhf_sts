import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_rfid_uhf_sts_platform_interface.dart';

/// An implementation of [FlutterRfidUhfStsPlatform] that uses method channels.
class MethodChannelFlutterRfidUhfSts extends FlutterRfidUhfStsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('CH_flutter_rfid_uhf_sts');
  int keyStatus = 0;
  List<Map<String, dynamic>> tagData = [];
  Map<String, dynamic> data = {};
  StreamController<Map<String, dynamic>> _dataController = StreamController<Map<String, dynamic>>.broadcast();

  @override
  Stream<Map<String, dynamic>> get dataStream {
    if (_dataController.isClosed) {
      _dataController = StreamController<Map<String, dynamic>>.broadcast(); // Use broadcast for multiple listeners
    }
    return _dataController.stream;
  }

  @override
  Future<void> streamInit() async {
    try {
      methodChannel.setMethodCallHandler(_handleMethod);
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

  Map<String, dynamic> _normalizeTag(Map<dynamic, dynamic> rawTag) {
    final Map<String, dynamic> normalized = {};
    rawTag.forEach((key, value) {
      normalized[key.toString()] = value;
    });
    if (rawTag.containsKey('sEPC') && !normalized.containsKey('epc')) {
      normalized['epc'] = rawTag['sEPC'];
    }
    if (rawTag.containsKey('sTID') && !normalized.containsKey('tid')) {
      normalized['tid'] = rawTag['sTID'];
    }
    if (rawTag.containsKey('sRssi') && !normalized.containsKey('rssi')) {
      normalized['rssi'] = rawTag['sRssi'];
    }
    if (rawTag.containsKey('sANT') && !normalized.containsKey('ant')) {
      normalized['ant'] = rawTag['sANT'];
    }
    if (rawTag.containsKey('sUser') && !normalized.containsKey('user')) {
      normalized['user'] = rawTag['sUser'];
    }
    if (rawTag.containsKey('sTagType') && !normalized.containsKey('tagType')) {
      normalized['tagType'] = rawTag['sTagType'];
    }
    return normalized;
  }

  Future<void> _handleMethod(MethodCall call) async {
    if (call.method == 'keyDown') {
      keyStatus = keyStatus + 1;
      data['keyCount'] = keyStatus;
      _dataController.add(Map<String, dynamic>.from(data));
    }
    if (call.method == 'scanStateChanged') {
      // 物理按键直接触发扫描状态变更，通过 stream 推送给 Flutter UI
      bool isScanning = call.arguments as bool? ?? false;
      data['scanState'] = isScanning;
      _dataController.add(Map<String, dynamic>.from(data));
    }
    if (call.method == 'sendData') {
      if (call.arguments != null) {
        final newTag = _normalizeTag(Map<dynamic, dynamic>.from(call.arguments));
        tagData.add(newTag);
        data['tagData'] = List<Map<String, dynamic>>.from(tagData);
        _dataController.add(Map<String, dynamic>.from(data));
      }
    }
    if (call.method == 'tagListUpdate') {
      // 轮询定时器推送的完整标签列表，直接替换（非追加）
      if (call.arguments != null) {
        final args = Map<dynamic, dynamic>.from(call.arguments);
        final rawList = (args['tagData'] as List<dynamic>?) ?? [];
        tagData = rawList
            .whereType<Map>()
            .map<Map<String, dynamic>>((item) => _normalizeTag(item))
            .toList();
        data['tagData'] = List<Map<String, dynamic>>.from(tagData);
        _dataController.add(Map<String, dynamic>.from(data));
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
    return methodChannel.invokeMethod<bool>('connect');
  }

  @override
  Future<bool?> get disconnect async {
    return methodChannel.invokeMethod<bool>('disConnect');
  }

  @override
  Future<bool?> get close async {
    return methodChannel.invokeMethod<bool>('close');
  }

  @override
  Future<bool?> get isConnected async {
    return methodChannel.invokeMethod<bool>('isConnected');
  }

  @override
  Future<bool?> get startScan async {
    return methodChannel.invokeMethod<bool>('startScaning');
  }

  @override
  Future<bool?> get stopScan async {
    return methodChannel.invokeMethod<bool>('stopScaning');
  }

  @override
  Future<bool?> get isScanning async {
    return methodChannel.invokeMethod<bool>('isScaning');
  }

  @override
  Future<bool?> get isEmptyTags async {
    return methodChannel.invokeMethod<bool>('isEmptyTags');
  }

  @override
  Future<Map<dynamic, dynamic>?> getConfigure() async {
    return methodChannel.invokeMethod<Map<dynamic, dynamic>>('getConfigure');
  }

  @override
  Future<List<dynamic>?> getTagData() async {
    final List<dynamic>? rawList = await methodChannel.invokeMethod<List<dynamic>>('readData');
    if (rawList != null) {
      return rawList.map((item) {
        if (item is Map) {
          return _normalizeTag(item);
        }
        return item;
      }).toList();
    }
    return rawList;
  }

  @override
  int get keyCount {
    return keyStatus;
  }

  @override
  Future<void> clearTags() async {
    tagData.clear();
    data['tagData'] = <Map<String, dynamic>>[];
    await methodChannel.invokeMethod('clearData');
  }

  @override
  Future<bool?> writeData({
    required String tagPassword,
    required int ptr,
    required String data,
    required int sourcePtr,
    required String sourceData,
  }) {
    return methodChannel.invokeMethod<bool>('writeData', {
      'tagPassword': tagPassword,
      'ptr': ptr,
      'data': data,
      'sourcePtr': sourcePtr,
      'sourceData': sourceData,
    });
  }

  @override
  Future<bool?> setScanMode(String mode) {
    return methodChannel.invokeMethod<bool>('setScanMode', {'mode': mode});
  }

  @override
  Future<bool?> setPower(String power) {
    return methodChannel.invokeMethod<bool>('setPower', {'power': power});
  }

  @override
  Future<bool?> setBandPosition(int band) {
    return methodChannel.invokeMethod<bool>('SetBandPosition', {'band': band});
  }

  @override
  Future<bool?> setScanEpc(bool isScanEpc) {
    return methodChannel.invokeMethod<bool>('SetScanEpc', {'isScanEpc': isScanEpc});
  }

  @override
  Future<bool?> setScanTid(bool isScanTid) {
    return methodChannel.invokeMethod<bool>('SetScanTid', {'isScanTid': isScanTid});
  }

  @override
  Future<bool?> setScanUser(bool isScanUser) {
    return methodChannel.invokeMethod<bool>('SetScanUser', {'isScanUser': isScanUser});
  }

  @override
  Future<bool?> setUserPtr(int userPtr) {
    return methodChannel.invokeMethod<bool>('SetUserPtr', {'userPtr': userPtr});
  }

  @override
  Future<bool?> setUserLen(int userLen) {
    return methodChannel.invokeMethod<bool>('SetUserLen', {'userLen': userLen});
  }

  @override
  Future<bool?> setScanCount(int scanCount) {
    return methodChannel.invokeMethod<bool>('SetScanCount', {'scanCount': scanCount});
  }

  @override
  Future<bool?> setScanTime(int scanTime) {
    return methodChannel.invokeMethod<bool>('SetScanTime', {'scanTime': scanTime});
  }

  @override
  Future<bool?> setShowAnts(bool isShowAnts) {
    return methodChannel.invokeMethod<bool>('SetShowAnts', {'isShowAnts': isShowAnts});
  }

  @override
  Future<bool?> setShowRssi(bool isShowRssi) {
    return methodChannel.invokeMethod<bool>('SetShowRssi', {'isShowRssi': isShowRssi});
  }
}
