import 'package:flutter_test/flutter_test.dart';
import 'package:esewa_plugin/esewa_plugin.dart';
import 'package:esewa_plugin/esewa_plugin_platform_interface.dart';
import 'package:esewa_plugin/esewa_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockEsewaPluginPlatform
    with MockPlatformInterfaceMixin
    implements EsewaPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final EsewaPluginPlatform initialPlatform = EsewaPluginPlatform.instance;

  test('$MethodChannelEsewaPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelEsewaPlugin>());
  });

  test('getPlatformVersion', () async {
    EsewaPlugin esewaPlugin = EsewaPlugin();
    MockEsewaPluginPlatform fakePlatform = MockEsewaPluginPlatform();
    EsewaPluginPlatform.instance = fakePlatform;

    expect(await esewaPlugin.getPlatformVersion(), '42');
  });
}
