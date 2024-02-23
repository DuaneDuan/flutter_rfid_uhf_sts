#include "include/flutter_rfid_uhf_sts/flutter_rfid_uhf_sts_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_rfid_uhf_sts_plugin.h"

void FlutterRfidUhfStsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_rfid_uhf_sts::FlutterRfidUhfStsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
