import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_rfid_uhf_sts_method_channel.dart';

abstract class FlutterRfidUhfStsPlatform extends PlatformInterface {
  /// Constructs a FlutterRfidUhfStsPlatform.
  FlutterRfidUhfStsPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterRfidUhfStsPlatform _instance = MethodChannelFlutterRfidUhfSts();

  /// The default instance of [FlutterRfidUhfStsPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterRfidUhfSts].
  static FlutterRfidUhfStsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterRfidUhfStsPlatform] when
  /// they register themselves.
  static set instance(FlutterRfidUhfStsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Map<dynamic, dynamic>?> getConfigure() {
    throw UnimplementedError('getConfigure() has not been implemented.');
  }

  Future<List<dynamic>?> getTagData() {
    throw UnimplementedError('getTagData() has not been implemented.');
  }

  Future<bool?> writeData({
    required String tagPassword,
    required int ptr,
    required String data,
    required int sourcePtr,
    required String sourceData,
  }) {
    throw UnimplementedError('writeData() has not been implemented.');
  }

  Future<bool?> setScanMode(String mode) {
    throw UnimplementedError('setScanMode() has not been implemented.');
  }

  Future<bool?> setPower(String power) {
    throw UnimplementedError('setPower() has not been implemented.');
  }

  Future<bool?> setBandPosition(int band) {
    throw UnimplementedError('setBandPosition() has not been implemented.');
  }

  Future<bool?> setScanEpc(bool isScanEpc) {
    throw UnimplementedError('setScanEpc() has not been implemented.');
  }

  Future<bool?> setScanTid(bool isScanTid) {
    throw UnimplementedError('setScanTid() has not been implemented.');
  }

  Future<bool?> setScanUser(bool isScanUser) {
    throw UnimplementedError('setScanUser() has not been implemented.');
  }

  Future<bool?> setUserPtr(int userPtr) {
    throw UnimplementedError('setUserPtr() has not been implemented.');
  }

  Future<bool?> setUserLen(int userLen) {
    throw UnimplementedError('setUserLen() has not been implemented.');
  }

  Future<bool?> setScanCount(int scanCount) {
    throw UnimplementedError('setScanCount() has not been implemented.');
  }

  Future<bool?> setScanTime(int scanTime) {
    throw UnimplementedError('setScanTime() has not been implemented.');
  }

  Future<bool?> setShowAnts(bool isShowAnts) {
    throw UnimplementedError('setShowAnts() has not been implemented.');
  }

  Future<bool?> setShowRssi(bool isShowRssi) {
    throw UnimplementedError('setShowRssi() has not been implemented.');
  }

  Future<bool?> get connect;

  Future<bool?> get disconnect;

  Future<bool?> get close;

  Future<bool?> get isConnected;

  Future<bool?> get isScanning;

  Future<bool?> get startScan;

  Future<bool?> get stopScan;

  Future<bool?> get isEmptyTags;

  int get keyCount;

  Stream<Map<String, dynamic>> get dataStream;

  Future<void> clearTags() async {}

  Future<void> streamInit() async {}
  Future<void> streamClose() async {}
}
