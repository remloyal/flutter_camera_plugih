import 'package:video_camera/lcopen/lcopen_plugin_platform_interface.dart';
import 'package:video_camera/player_video_event.dart';

//视频清晰度
enum LCOpenVideoLevel {
  //高清
  hd,
  //标准
  sd,
}

extension _LCOpenVideoLevelExtension on LCOpenVideoLevel {
  int get value {
    return index;
  }
}

///乐橙云sdk接口
class LCOpenSDK {
  //是否开启sdk的日志
  static Future<void> setLogEnabled(bool enabled) {
    return LCOpenPluginPlatform.instance.setLogEnabled(enabled);
  }

  //通过accessToken初始化sdk
  static Future<bool> initLibWithAccessToken(String accessToken) {
    return LCOpenPluginPlatform.instance.initLibWithAccessToken(accessToken);
  }

  //释放sdk
  static Future<void> destroyLib() {
    return LCOpenPluginPlatform.instance.destroyLib();
  }

  //开启直播
  static Future<bool> startRealPlay(
    int viewId,
    String accessToken,
    String deviceSerial,
    String verifyCode,
    int channel,
    LCOpenVideoLevel level
  ) {
    return LCOpenPluginPlatform.instance.startRealPlay(
      viewId,
      accessToken,
      deviceSerial,
      verifyCode,
      channel,
      level.value
    );
  }

  //停止直播
  static Future<void> stopRealPlay() {
    return LCOpenPluginPlatform.instance.stopRealPlay();
  }

  //释放播放器资源
  static Future<void> releasePlayer() {
    return LCOpenPluginPlatform.instance.release();
  }

  //开启/关闭声音
  static Future<bool> setSoundEnabled(bool enabled) {
    return LCOpenPluginPlatform.instance.setSoundEnabled(enabled);
  }

  //按时间开始远程sd卡回放
  static Future<bool> startPlayback(
    int viewId,
    String accessToken,
    String deviceSerial,
    String verifyCode,
    int channel,
    LCOpenVideoLevel level,
    int startMillis,
    int endMillis
  ) {
    return LCOpenPluginPlatform.instance.startPlayback(
      viewId,
      accessToken,
      deviceSerial,
      verifyCode,
      channel,
      level.value,
      startMillis,
      endMillis
    );
  }

  //停止远程回放
  static Future<bool> stopPlayback() {
    return LCOpenPluginPlatform.instance.stopPlayback();
  }

  //事件监听
  static Stream<PlayerVideoEvent> videoEvents() {
    return LCOpenPluginPlatform.instance.videoEvents().map((map) {
      PlayerVideoEvent event;
      switch (map['event']) {
        case 'start':
          event = PlayerVideoEvent(type: PlayerVideoEventType.start);
          break;
        case 'loading':
          event = PlayerVideoEvent(type: PlayerVideoEventType.loading);
          break;
        case 'duration':
          event = PlayerVideoEvent<int>(type: PlayerVideoEventType.duration);
          event.message = map['message'];
          break;
        case 'finished':
          event = PlayerVideoEvent(type: PlayerVideoEventType.finished);
          break;
        default:
          event = PlayerVideoEvent(type: PlayerVideoEventType.unknown);
      }
      return event;
    });
  }
}
