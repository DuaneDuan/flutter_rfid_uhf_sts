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
