import 'package:video_camera/player_video_event.dart';
import 'package:flutter/material.dart';

//播放器当前状态
enum PlayerStatus {
  //未初始化
  uninitialized,
  //初始化完成
  initialized,
  //正在加载视频
  loading,
  //正在播放视频
  playing,
  //播放完成
  completed,
  //播放失败
  error
}

abstract class PlayerController extends ChangeNotifier {

  //播放器视频状态
  PlayerStatus _status = PlayerStatus.uninitialized;

  set status(PlayerStatus status) {
    if (_status != status) {
      _status = status;
      notifyListeners();
    }
  }

  bool get playing => status == PlayerStatus.loading || status == PlayerStatus.playing;

  PlayerStatus get status => _status;

  //是否静音
  bool _mute = false;

  bool get mute => _mute;

  //当前清晰度
  int? _definitionIndex;

  set definitionIndex(int? definitionIndex) {
    if (_definitionIndex != definitionIndex) {
      _definitionIndex = definitionIndex;
      notifyListeners();
    }
  }

  int? get definitionIndex => _definitionIndex;

  //当前模式
  int? _modeIndex;

  set modeIndex(int? modeIndex) {
    if (_modeIndex != modeIndex) {
      _modeIndex = modeIndex;
      notifyListeners();
    }
  }

  int? get modeIndex => _modeIndex;

  //是否是直播
  bool _isReal = true;

  set isReal(bool isReal) => _isReal = isReal;

  //回放开始时间
  DateTime? _startTime;

  DateTime? get startTime => _startTime;

  //回放结束时间
  DateTime? _endTime;

  DateTime? get endTime => _endTime;

  //回放视频长度
  int? _duration;

  set duration(int? duration) {
    if (_duration != duration) {
      _duration = duration;
      notifyListeners();
    }
  }

  int? get duration => _duration;

  void handlePlay() {
    if (playing) {
      stopPlay();
    } else {
      startPlay();
    }
  }

  void stopPlay() {
    if (playing || status == PlayerStatus.error) {
      _isReal ? stopRealPlay() : stopPlayback();
      status = PlayerStatus.initialized;
    }
  }

  void startPlay([DateTime? startTime, DateTime? endTime]) {
    status = PlayerStatus.loading;

    if (startTime != null && endTime != null) {
      _startTime = startTime;
      _endTime = endTime;
    }

    if (_isReal) {
      startRealPlay();
    } else {
      startPlayback(_startTime!, _endTime!);
    }
  }

  /*关闭直播*/
  void stopRealPlay();

  /*开启直播*/
  void startRealPlay();

  /*关闭回放*/
  void stopPlayback();

  /*开启回放*/
  void startPlayback(DateTime startTime, DateTime endTime);

  void handleAudio() {
    _mute = !_mute;
    setSoundEnabled(!_mute);
    notifyListeners();
  }

  /*是否静音*/
  void setSoundEnabled(bool enabled);
}