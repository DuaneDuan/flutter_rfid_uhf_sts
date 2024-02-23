#ifndef FLUTTER_PLUGIN_FLUTTER_RFID_UHF_STS_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_RFID_UHF_STS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_rfid_uhf_sts {

class FlutterRfidUhfStsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterRfidUhfStsPlugin();

  virtual ~FlutterRfidUhfStsPlugin();

  // Disallow copy and assign.
  FlutterRfidUhfStsPlugin(const FlutterRfidUhfStsPlugin&) = delete;
  FlutterRfidUhfStsPlugin& operator=(const FlutterRfidUhfStsPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_rfid_uhf_sts

#endif  // FLUTTER_PLUGIN_FLUTTER_RFID_UHF_STS_PLUGIN_H_
