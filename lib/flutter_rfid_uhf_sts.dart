
import 'flutter_rfid_uhf_sts_platform_interface.dart';

class FlutterRfidUhfSts {
  Future<String?> getPlatformVersion() {
    return FlutterRfidUhfStsPlatform.instance.getPlatformVersion();
  }

  Future<bool?> get connect async {
    return FlutterRfidUhfStsPlatform.instance.connect;
  }

  Future<bool?> get disconnect async {
    return FlutterRfidUhfStsPlatform.instance.disconnect;
  }

  Future<bool?> get isConnected async {
    return FlutterRfidUhfStsPlatform.instance.isConnected;
  }

  Future<bool?> get isScanning async {
    return FlutterRfidUhfStsPlatform.instance.isScanning;
  }

  Future<bool?> get startScan async {
    return FlutterRfidUhfStsPlatform.instance.startScan;
  }

  Future<bool?> get stopScan async {
    return FlutterRfidUhfStsPlatform.instance.stopScan;
  }

  Future<bool?> get isEmptyTags async {
    return FlutterRfidUhfStsPlatform.instance.isEmptyTags;
  }

  Future<Map<dynamic, dynamic>?> getConfigure() async {
    var conFile = await FlutterRfidUhfStsPlatform.instance.getConfigure();
    return conFile;
  }

  Future<List<Map<String, dynamic>>?> getTagData() async {
    List<dynamic>? result = await FlutterRfidUhfStsPlatform.instance.getTagData();
    if (result is List<dynamic>) {
      List<Map<String, dynamic>> resultMapList = result
          .map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item))
          .toList();
      return resultMapList;
    }
    return [];
  }

  Future<void> keyDown() async {
    FlutterRfidUhfStsPlatform.instance.keyDownInit();
  }

  int get keyCounts {
    return FlutterRfidUhfStsPlatform.instance.keyCount;
  }

  Stream<int> get dataStream {
    return FlutterRfidUhfStsPlatform.instance.dataStream;
  }

  Future<void> clearData() async {
    FlutterRfidUhfStsPlatform.instance.clearTags();
  }

  Future<bool?> writeData() async {
    return FlutterRfidUhfStsPlatform.instance.writeData();
  }
}
