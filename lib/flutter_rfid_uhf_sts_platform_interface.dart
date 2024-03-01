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
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<List<dynamic>?> getTagData() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> writeData() {
    throw UnimplementedError('platformVersion() has not been implemented.');
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

  Stream<Map<String,dynamic>> get dataStream;
  // Stream<List<Map<String,dynamic>>> get tagStream;

  Future<void> clearTags() async {}

  Future<void> streamInit() async {}

}
