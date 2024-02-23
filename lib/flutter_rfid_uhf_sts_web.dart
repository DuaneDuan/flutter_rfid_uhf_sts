// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'flutter_rfid_uhf_sts_platform_interface.dart';

/// A web implementation of the FlutterRfidUhfStsPlatform of the FlutterRfidUhfSts plugin.
class FlutterRfidUhfStsWeb extends FlutterRfidUhfStsPlatform {
  /// Constructs a FlutterRfidUhfStsWeb
  FlutterRfidUhfStsWeb();

  static void registerWith(Registrar registrar) {
    FlutterRfidUhfStsPlatform.instance = FlutterRfidUhfStsWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }

  @override
  // TODO: implement connect
  Future<bool?> get connect => throw UnimplementedError();

  @override
  // TODO: implement dataStream
  Stream<int> get dataStream => throw UnimplementedError();

  @override
  // TODO: implement disconnect
  Future<bool?> get disconnect => throw UnimplementedError();

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
}
