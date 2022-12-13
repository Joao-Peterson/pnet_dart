#include "include/pnet_dart/pnet_dart_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "pnet_dart_plugin.h"

void PnetDartPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  pnet_dart::PnetDartPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
