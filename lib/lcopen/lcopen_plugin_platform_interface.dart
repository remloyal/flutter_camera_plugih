import 'package:video_camera/lcopen/lcopen_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class LCOpenPluginPlatform extends PlatformInterface {
  /// Constructs a CameraPluginPlatform.
  LCOpenPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static LCOpenPluginPlatform _instance = MethodChannelLCOpenPlugin();

  /// The default instance of [CameraPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelCameraPlugin].
  static LCOpenPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CameraPluginPlatform] when
  /// they register themselves.
  static set instance(LCOpenPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> setLogEnabled(bool enabled) {
    throw UnimplementedError('setLogEnabled() has not been implemented.');
  }

  Future<bool> initLibWithAccessToken(String accessToken) {
    throw UnimplementedError('initLibWithAccessToken() has not been implemented.');
  }

  Future<void> destroyLib() {
    throw UnimplementedError('destroyLib() has not been implemented.');
  }

  Future<bool> startRealPlay(
    int viewId,
    String accessToken,
    String deviceSerial,
    String verifyCode,
    int channel,
    int bateMode
  ) {
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

  Future<bool> startPlayback(
    int viewId,
    String accessToken,
    String deviceSerial,
    String verifyCode,
    int channel,
    int bateMode,
    int startMillis,
    int endMillis
  ) {
    throw UnimplementedError('startPlayback() has not been implemented.');
  }

  Future<bool> stopPlayback() {
    throw UnimplementedError('stopPlayback() has not been implemented.');
  }

  Stream<Map<dynamic, dynamic>> videoEvents() {
    throw UnimplementedError('videoEvents() has not been implemented.');
  }
}