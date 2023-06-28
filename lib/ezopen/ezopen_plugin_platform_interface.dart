import 'package:video_camera/ezopen/ezopen_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class EZOpenPluginPlatform extends PlatformInterface {
  /// Constructs a CameraPluginPlatform.
  EZOpenPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static EZOpenPluginPlatform _instance = MethodChannelEZOpenPlugin();

  /// The default instance of [CameraPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelCameraPlugin].
  static EZOpenPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CameraPluginPlatform] when
  /// they register themselves.
  static set instance(EZOpenPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> setLogEnabled(bool enabled) {
    throw UnimplementedError('setLogEnabled() has not been implemented.');
  }

  Future<bool> initLibWithAppKey(String appKey) {
    throw UnimplementedError('initLibWithAppKey() has not been implemented.');
  }

  Future<void> setAccessToken(String accessToken) {
    throw UnimplementedError('setAccessToken() has not been implemented.');
  }

  Future<void> destroyLib() {
    throw UnimplementedError('destroyLib() has not been implemented.');
  }

  Future<bool> initPlayer(String deviceSerial, String verifyCode, int cameraNo) {
    throw UnimplementedError('initPlayer() has not been implemented.');
  }

  Future<bool> startRealPlay(int viewId) {
    throw UnimplementedError('startRealPlay() has not been implemented.');
  }

  Future<bool> stopRealPlay() {
    throw UnimplementedError('stopRealPlay() has not been implemented.');
  }

  Future<void> release() {
    throw UnimplementedError('release() has not been implemented.');
  }

  Future<bool> setSoundEnabled(bool enabled) {
    throw UnimplementedError('setSoundEnabled() has not been implemented.');
  }

  Future<bool> setVideoLevel(int value) {
    throw UnimplementedError('setVideoLevel() has not been implemented.');
  }

  Future<bool> startPlayback(int startMillis, int endMillis) {
    throw UnimplementedError('startPlayback() has not been implemented.');
  }

  Future<bool> stopPlayback() {
    throw UnimplementedError('stopPlayback() has not been implemented.');
  }

  Future<bool> pausePlayback() {
    throw UnimplementedError('pausePlayback() has not been implemented.');
  }

  Future<bool> resumePlayback() {
    throw UnimplementedError('resumePlayback() has not been implemented.');
  }

  Future<int> getOSDTime() {
    throw UnimplementedError('getOSDTime() has not been implemented.');
  }

}