import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'esewa_plugin_platform_interface.dart';

/// An implementation of [EsewaPluginPlatform] that uses method channels.
class MethodChannelEsewaPlugin extends EsewaPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('esewa_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  startEsewa() async {
    await methodChannel.invokeMethod<Object>('startEsewa');
  }
}
