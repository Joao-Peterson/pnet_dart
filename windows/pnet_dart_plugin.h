#ifndef FLUTTER_PLUGIN_PNET_DART_PLUGIN_H_
#define FLUTTER_PLUGIN_PNET_DART_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace pnet_dart {

class PnetDartPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  PnetDartPlugin();

  virtual ~PnetDartPlugin();

  // Disallow copy and assign.
  PnetDartPlugin(const PnetDartPlugin&) = delete;
  PnetDartPlugin& operator=(const PnetDartPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace pnet_dart

#endif  // FLUTTER_PLUGIN_PNET_DART_PLUGIN_H_
