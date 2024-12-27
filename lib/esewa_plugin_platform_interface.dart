import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'esewa_plugin_method_channel.dart';

abstract class EsewaPluginPlatform extends PlatformInterface {
  /// Constructs a EsewaPluginPlatform.
  EsewaPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static EsewaPluginPlatform _instance = MethodChannelEsewaPlugin();

  /// The default instance of [EsewaPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelEsewaPlugin].
  static EsewaPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [EsewaPluginPlatform] when
  /// they register themselves.
  static set instance(EsewaPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  startEsewa() {
    throw UnimplementedError('startEsewa() has not been implemented.');
  }
}
