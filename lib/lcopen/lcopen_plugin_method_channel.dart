import 'package:video_camera/lcopen/lcopen_plugin_platform_interface.dart';
import 'package:flutter/services.dart';

class MethodChannelLCOpenPlugin extends LCOpenPluginPlatform {

  final _channel = const MethodChannel('lcopen_plugin_sdk');


  @override
  Future<void> setLogEnabled(bool enabled) async {
    return await _channel.invokeMethod('setLogEnabled', enabled);
  }

  @override
  Future<bool> initLibWithAccessToken(String accessToken) async {
    return await _channel.invokeMethod('initLibWithAccessToken', accessToken);
  }

  @override
  Future<void> destroyLib() async {
    return await _channel.invokeMethod('destroyLib');
  }

  @override
  Future<bool> startRealPlay(
    int viewId,
    String accessToken,
    String deviceSerial,
    String verifyCode,
    int channel,
    int bateMode
  ) async {
    Map<String, dynamic> args = {
      'accessToken': accessToken,
      'deviceSerial': deviceSerial,
      'verifyCode': verifyCode,
      'channel': channel,
      'viewId': viewId,
      'bateMode': bateMode
    };
    return await _channel.invokeMethod('startRealPlay', args);
  }

  @override
  Future<bool> stopRealPlay() async {
    return await _channel.invokeMethod('stopRealPlay');
  }

  @override
  Future<void> release() async {
    return await _channel.invokeMethod('release');
  }

  @override
  Future<bool> setSoundEnabled(bool enabled) async {
    return await _channel.invokeMethod('setSoundEnabled', enabled);
  }

  @override
  Future<bool> startPlayback(
    int viewId,
    String accessToken,
    String deviceSerial,
    String verifyCode,
    int channel,
    int bateMode,
    int startMillis,
    int endMillis
  ) async {
    Map<String, dynamic> args = {
      'accessToken': accessToken,
      'deviceSerial': deviceSerial,
      'verifyCode': verifyCode,
      'channel': channel,
      'viewId': viewId,
      'bateMode': bateMode,
      'startMillis': startMillis,
      'endMillis': endMillis
    };
    return await _channel.invokeMethod('startPlayback', args);
  }

  @override
  Future<bool> stopPlayback() async {
    return await _channel.invokeMethod('stopPlayback');
  }

  @override
  Stream<Map<dynamic, dynamic>> videoEvents() {
    return const EventChannel('lcopen_event')
        .receiveBroadcastStream().map((event) => event as Map<dynamic, dynamic>);
  }
}