import 'package:video_camera/ezopen/ezopen_plugin_platform_interface.dart';
import 'package:flutter/services.dart';

class MethodChannelEZOpenPlugin extends EZOpenPluginPlatform {

  final _channel = const MethodChannel('ezopen_plugin_sdk');


  @override
  Future<void> setLogEnabled(bool enabled) async {
    return await _channel.invokeMethod('setLogEnabled', enabled);
  }

  @override
  Future<bool> initLibWithAppKey(String appKey) async {
    return await _channel.invokeMethod('initLibWithAppKey', appKey);
  }

  @override
  Future<void> setAccessToken(String accessToken) async {
    return await _channel.invokeMethod('setAccessToken', accessToken);
  }

  @override
  Future<void> destroyLib() async {
    return await _channel.invokeMethod('destroyLib');
  }

  @override
  Future<bool> initPlayer(String deviceSerial, String verifyCode, int cameraNo) async {
    Map<String, dynamic> args = {
      'deviceSerial': deviceSerial,
      'verifyCode': verifyCode,
      'cameraNo': cameraNo,
    };
    return await _channel.invokeMethod('initPlayer', args);
  }

  @override
  Future<bool> startRealPlay(int viewId) async {
    return await _channel.invokeMethod('startRealPlay', viewId);
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
  Future<bool> setVideoLevel(int value) async {
    return await _channel.invokeMethod('setVideoLevel', value);
  }

  @override
  Future<bool> startPlayback(int startMillis, int endMillis) async {
    Map<String, int> args = {
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
  Future<bool> pausePlayback() async {
    return await _channel.invokeMethod('pausePlayback');
  }

  @override
  Future<bool> resumePlayback() async {
    return await _channel.invokeMethod('resumePlayback');
  }

  @override
  Future<int> getOSDTime() async {
    return await _channel.invokeMethod('getOSDTime');
  }

}