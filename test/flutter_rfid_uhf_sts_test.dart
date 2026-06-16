import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_rfid_uhf_sts/flutter_rfid_uhf_sts.dart';
import 'package:flutter_rfid_uhf_sts/flutter_rfid_uhf_sts_platform_interface.dart';
import 'package:flutter_rfid_uhf_sts/flutter_rfid_uhf_sts_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterRfidUhfStsPlatform
    with MockPlatformInterfaceMixin
    implements FlutterRfidUhfStsPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> clearTags() {
    throw UnimplementedError();
  }

  @override
  Future<bool?> get close => throw UnimplementedError();

  @override
  Future<bool?> get connect => throw UnimplementedError();

  @override
  Stream<Map<String, dynamic>> get dataStream => throw UnimplementedError();

  @override
  Future<bool?> get disconnect => throw UnimplementedError();

  @override
  Future<Map?> getConfigure() {
    throw UnimplementedError();
  }

  @override
  Future<List?> getTagData() {
    throw UnimplementedError();
  }

  @override
  Future<bool?> get isConnected => throw UnimplementedError();

  @override
  Future<bool?> get isEmptyTags => throw UnimplementedError();

  @override
  Future<bool?> get isScanning => throw UnimplementedError();

  @override
  int get keyCount => throw UnimplementedError();

  @override
  Future<bool?> get startScan => throw UnimplementedError();

  @override
  Future<bool?> get stopScan => throw UnimplementedError();

  @override
  Future<void> streamInit() {
    throw UnimplementedError();
  }

  @override
  Future<bool?> writeData({
    required String tagPassword,
    required int ptr,
    required String data,
    required int sourcePtr,
    required String sourceData,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> setScanMode(String mode) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> setPower(String power) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> setBandPosition(int band) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> setScanEpc(bool isScanEpc) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> setScanTid(bool isScanTid) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> setScanUser(bool isScanUser) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> setUserPtr(int userPtr) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> setUserLen(int userLen) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> setScanCount(int scanCount) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> setScanTime(int scanTime) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> setShowAnts(bool isShowAnts) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> setShowRssi(bool isShowRssi) {
    throw UnimplementedError();
  }

  @override
  Future<void> streamClose() {
    throw UnimplementedError();
  }
}

void main() {
  final FlutterRfidUhfStsPlatform initialPlatform =
      FlutterRfidUhfStsPlatform.instance;

  test('$MethodChannelFlutterRfidUhfSts is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterRfidUhfSts>());
  });

  test('getPlatformVersion', () async {
    FlutterRfidUhfSts flutterRfidUhfStsPlugin = FlutterRfidUhfSts();
    MockFlutterRfidUhfStsPlatform fakePlatform =
        MockFlutterRfidUhfStsPlatform();
    FlutterRfidUhfStsPlatform.instance = fakePlatform;

    expect(await flutterRfidUhfStsPlugin.getPlatformVersion(), '42');
  });
}
