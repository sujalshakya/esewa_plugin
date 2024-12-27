import 'esewa_plugin_platform_interface.dart';

class EsewaPlugin {
  Future<String?> getPlatformVersion() {
    return EsewaPluginPlatform.instance.getPlatformVersion();
  }

  startEsewa() {
    return EsewaPluginPlatform.instance.startEsewa();
  }
}
