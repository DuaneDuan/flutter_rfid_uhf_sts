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

  Future<bool?> get close async {
    return FlutterRfidUhfStsPlatform.instance.close;
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
    List<dynamic>? result =
        await FlutterRfidUhfStsPlatform.instance.getTagData();
    if (result is List<dynamic>) {
      List<Map<String, dynamic>> resultMapList = result
          .map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item))
          .toList();
      return resultMapList;
    }
    return [];
  }

  Future<void> streamInit() async {
    FlutterRfidUhfStsPlatform.instance.streamInit();
  }

  Future<void> streamClose() async {
    FlutterRfidUhfStsPlatform.instance.streamClose();
  }

  int get keyCounts {
    return FlutterRfidUhfStsPlatform.instance.keyCount;
  }

  Stream<Map<String, dynamic>> get dataStream {
    return FlutterRfidUhfStsPlatform.instance.dataStream;
  }

  Future<void> clearData() async {
    FlutterRfidUhfStsPlatform.instance.clearTags();
  }

  Future<bool?> writeData({
    required String tagPassword,
    required int ptr,
    required String data,
    required int sourcePtr,
    required String sourceData,
  }) async {
    return FlutterRfidUhfStsPlatform.instance.writeData(
      tagPassword: tagPassword,
      ptr: ptr,
      data: data,
      sourcePtr: sourcePtr,
      sourceData: sourceData,
    );
  }

  Future<bool?> setScanMode(String mode) async {
    return FlutterRfidUhfStsPlatform.instance.setScanMode(mode);
  }

  Future<bool?> setPower(String power) async {
    return FlutterRfidUhfStsPlatform.instance.setPower(power);
  }

  Future<bool?> setBandPosition(int band) async {
    return FlutterRfidUhfStsPlatform.instance.setBandPosition(band);
  }

  Future<bool?> setScanEpc(bool isScanEpc) async {
    return FlutterRfidUhfStsPlatform.instance.setScanEpc(isScanEpc);
  }

  Future<bool?> setScanTid(bool isScanTid) async {
    return FlutterRfidUhfStsPlatform.instance.setScanTid(isScanTid);
  }

  Future<bool?> setScanUser(bool isScanUser) async {
    return FlutterRfidUhfStsPlatform.instance.setScanUser(isScanUser);
  }

  Future<bool?> setUserPtr(int userPtr) async {
    return FlutterRfidUhfStsPlatform.instance.setUserPtr(userPtr);
  }

  Future<bool?> setUserLen(int userLen) async {
    return FlutterRfidUhfStsPlatform.instance.setUserLen(userLen);
  }

  Future<bool?> setScanCount(int scanCount) async {
    return FlutterRfidUhfStsPlatform.instance.setScanCount(scanCount);
  }

  Future<bool?> setScanTime(int scanTime) async {
    return FlutterRfidUhfStsPlatform.instance.setScanTime(scanTime);
  }

  Future<bool?> setShowAnts(bool isShowAnts) async {
    return FlutterRfidUhfStsPlatform.instance.setShowAnts(isShowAnts);
  }

  Future<bool?> setShowRssi(bool isShowRssi) async {
    return FlutterRfidUhfStsPlatform.instance.setShowRssi(isShowRssi);
  }
}
