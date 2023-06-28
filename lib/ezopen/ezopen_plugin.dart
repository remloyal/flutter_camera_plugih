import 'package:video_camera/ezopen/ezopen_plugin_platform_interface.dart';

//视频清晰度
enum EZOpenVideoLevel {
  //流畅
  smooth,
  //均衡
  balanced,
  //高品质
  highQuality
}

extension _EZOpenVideoLevelExtension on EZOpenVideoLevel {
  int get value {
    return index;
  }
}

///萤石云sdk接口
class EZOpenSDK {

  //是否开启sdk的日志
  static Future<void> setLogEnabled(bool enabled) {
    return EZOpenPluginPlatform.instance.setLogEnabled(enabled);
  }

  //通过appKey初始化sdk
  static Future<bool> initLibWithAppKey(String appKey) {
    return EZOpenPluginPlatform.instance.initLibWithAppKey(appKey);
  }

  //设置accessToken
  static Future<void> setAccessToken(String accessToken) {
    return EZOpenPluginPlatform.instance.setAccessToken(accessToken);
  }

  //释放sdk
  static Future<void> destroyLib() {
    return EZOpenPluginPlatform.instance.destroyLib();
  }

  //创建并初始化播放器
  static Future<bool> initPlayer(String deviceSerial, String verifyCode, int cameraNo) {
    return EZOpenPluginPlatform.instance.initPlayer(deviceSerial, verifyCode, cameraNo);
  }

  //开启直播
  static Future<bool> startRealPlay(int viewId) {
    return EZOpenPluginPlatform.instance.startRealPlay(viewId);
  }

  //停止直播
  static Future<void> stopRealPlay() {
    return EZOpenPluginPlatform.instance.stopRealPlay();
  }

  //释放播放器资源
  static Future<void> releasePlayer() {
    return EZOpenPluginPlatform.instance.release();
  }

  //开启/关闭声音
  static Future<bool> setSoundEnabled(bool enabled) {
    return EZOpenPluginPlatform.instance.setSoundEnabled(enabled);
  }

  //设置视频清晰度。
  //必须在initPlayer(创建并初始化播放器)之后设置！！！
  //可以在视频播放前设置，也可以在视频播放成功后设置，
  //视频播放成功后设置了清晰度需要先停止播放stopRealPlay然后重新开启播放startRealPlay才能生效；
  static Future<bool> setVideoLevel(EZOpenVideoLevel level) {
    return EZOpenPluginPlatform.instance.setVideoLevel(level.value);
  }

  //按时间开始远程sd卡回放
  static Future<bool> startPlayback(int startMillis, int endMillis) {
    return EZOpenPluginPlatform.instance.startPlayback(startMillis, endMillis);
  }

  //停止远程回放
  static Future<bool> stopPlayback() {
    return EZOpenPluginPlatform.instance.stopPlayback();
  }

  //暂停远程回放播放
  static Future<bool> pausePlayback() {
    return EZOpenPluginPlatform.instance.pausePlayback();
  }

  //恢复远程回放播放
  static Future<bool> resumePlayback() {
    return EZOpenPluginPlatform.instance.resumePlayback();
  }

  //获取当前回放时间点，如果回放开始时间8:00，结束时间9:00，getOSDTime时间为8:30，那么播放进度为50%
  static Future<int> getOSDTime() {
    return EZOpenPluginPlatform.instance.getOSDTime();
  }

}