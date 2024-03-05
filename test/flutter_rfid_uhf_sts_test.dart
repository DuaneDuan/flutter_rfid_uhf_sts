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
    // TODO: implement clearTags
    throw UnimplementedError();
  }

  @override
  // TODO: implement close
  Future<bool?> get close => throw UnimplementedError();

  @override
  // TODO: implement connect
  Future<bool?> get connect => throw UnimplementedError();

  @override
  // TODO: implement dataStream
  Stream<Map<String, dynamic>> get dataStream => throw UnimplementedError();

  @override
  // TODO: implement disconnect
  Future<bool?> get disconnect => throw UnimplementedError();

  @override
  Future<Map?> getConfigure() {
    // TODO: implement getConfigure
    throw UnimplementedError();
  }

  @override
  Future<List?> getTagData() {
    // TODO: implement getTagData
    throw UnimplementedError();
  }

  @override
  // TODO: implement isConnected
  Future<bool?> get isConnected => throw UnimplementedError();

  @override
  // TODO: implement isEmptyTags
  Future<bool?> get isEmptyTags => throw UnimplementedError();

  @override
  // TODO: implement isScanning
  Future<bool?> get isScanning => throw UnimplementedError();

  @override
  // TODO: implement keyCount
  int get keyCount => throw UnimplementedError();

  @override
  // TODO: implement startScan
  Future<bool?> get startScan => throw UnimplementedError();

  @override
  // TODO: implement stopScan
  Future<bool?> get stopScan => throw UnimplementedError();

  @override
  Future<void> streamInit() {
    // TODO: implement streamInit
    throw UnimplementedError();
  }

  @override
  Future<bool?> writeData() {
    // TODO: implement writeData
    throw UnimplementedError();
  }

  @override
  Future<void> streamClose() {
    // TODO: implement streamClose
    throw UnimplementedError();
  }
}

void main() {
  final FlutterRfidUhfStsPlatform initialPlatform = FlutterRfidUhfStsPlatform.instance;

  test('$MethodChannelFlutterRfidUhfSts is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterRfidUhfSts>());
  });

  test('getPlatformVersion', () async {
    FlutterRfidUhfSts flutterRfidUhfStsPlugin = FlutterRfidUhfSts();
    MockFlutterRfidUhfStsPlatform fakePlatform = MockFlutterRfidUhfStsPlatform();
    FlutterRfidUhfStsPlatform.instance = fakePlatform;

    expect(await flutterRfidUhfStsPlugin.getPlatformVersion(), '42');
  });
}
