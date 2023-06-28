import 'dart:async';
import 'dart:io';

import 'package:video_camera/lcopen/lcopen_plugin.dart';
import 'package:video_camera/player_control_bar.dart';
import 'package:video_camera/player_controller.dart';
import 'package:video_camera/player_date_time_picker.dart';
import 'package:video_camera/player_video_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LCOpenPlayerController extends PlayerController {

  LCOpenPlayerController({required this.accessToken, this.logEnabled = false});

  //是否开启sdk日志，默认不开启
  final bool? logEnabled;
  String accessToken;

  static const int kDefaultViewId = -1;

  int _viewId = kDefaultViewId;

  set viewId(int viewId){
    _viewId = viewId;
  }

  late String _deviceSerial;
  late String _verifyCode;
  late int _channel;

  Future<void> initialize(String deviceSerial, String verifyCode, int channel) async {
    _deviceSerial = deviceSerial;
    _verifyCode = verifyCode;
    _channel = channel;

    LCOpenSDK.videoEvents().listen((e) {
      switch (e.type) {
        case PlayerVideoEventType.loading:
          status = PlayerStatus.loading;
          break;
        case PlayerVideoEventType.start:
          status = PlayerStatus.playing;
          break;
        case PlayerVideoEventType.finished:
          status = PlayerStatus.completed;
          break;
        case PlayerVideoEventType.duration:
          duration = e.message;
          break;
        default:
      }
    }, onError: (e) {
      status = PlayerStatus.error;
    });
    await LCOpenSDK.initLibWithAccessToken(accessToken);
    LCOpenSDK.setLogEnabled(true);

    status = PlayerStatus.initialized;
  }

  LCOpenVideoLevel get level {
    LCOpenVideoLevel level = LCOpenVideoLevel.sd;
    if (definitionIndex == 0) level = LCOpenVideoLevel.hd;
    return level;
  }

  @override
  void startRealPlay() {
    if (_viewId == kDefaultViewId) return;
    LCOpenSDK.startRealPlay(
      _viewId,
      accessToken,
      _deviceSerial,
      _verifyCode,
      _channel,
      level
    );
  }

  @override
  void stopRealPlay() {
    LCOpenSDK.stopRealPlay();
  }

  @override
  void setSoundEnabled(bool enabled) {
    LCOpenSDK.setSoundEnabled(enabled);
  }

  @override
  void startPlayback(DateTime startTime, DateTime endTime) {
    LCOpenSDK.startPlayback(
      _viewId,
      accessToken,
      _deviceSerial,
      _verifyCode,
      _channel,
      level,
      startTime.millisecondsSinceEpoch,
      endTime.millisecondsSinceEpoch
    );
  }

  @override
  void stopPlayback() {
    LCOpenSDK.stopPlayback();
  }

  @override
  void dispose() {
    super.dispose();
    LCOpenSDK.releasePlayer();
  }
}

class LCOpenPlayer extends StatefulWidget {

  final LCOpenPlayerController controller;

  final String deviceSerial;
  final String verifyCode;
  final int cameraNo;

  const LCOpenPlayer({
    super.key,
    required this.controller,
    required this.deviceSerial,
    required this.verifyCode,
    required this.cameraNo
  });

  @override
  State<StatefulWidget> createState() => _LCOpenPlayerState();
}

class _LCOpenPlayerState extends State<LCOpenPlayer> {

  late LCOpenPlayerController _controller;

  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.modeIndex = 1;
    _controller.definitionIndex = 1;
    // _landscape = false;
    _initFuture = _controller.initialize(
        widget.deviceSerial,
        widget.verifyCode,
        widget.cameraNo
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = width * 9 / 16;

    List<MenuItem> definitions = [
      MenuItem(
          onTap: () {
            _processDefinitions(0);
          },
          text: '高清'
      ),
      MenuItem(
          onTap: () {
            _processDefinitions(1);
          },
          text: '流畅'
      ),
    ];

    List<MenuItem> modes = [
      MenuItem(
          onTap: () {
            _controller.modeIndex = 0;
            showPlayerDateTimePicker(context, _controller.startTime, _controller.endTime).then((value) {
              if (value == null) return;
              _controller.stopPlay();
              _controller.isReal = false;
              _controller.startPlay(value[0], value[1]);
            });
          },
          text: '回放'
      ),
      MenuItem(
          onTap: () {
            if (_controller.modeIndex == 1) return;
            _controller.modeIndex = 1;
            _controller.stopPlay();
            _controller.isReal = true;
            _controller.startPlay();
          },
          text: '直播'
      ),
    ];

    return Container(
      color: Colors.black,
      width: width,
      height: height + kToolbarHeight,
      child: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                SizedBox(
                  width: width,
                  height: height,
                  child: _LCOpenView(
                    onPlatformViewCreated: (int viewId) {
                      _controller.viewId = viewId;
                      // _controller.startRealPlay(viewId);
                    },
                  ),
                ),
                PlayerControlBar(
                  controller: _controller,
                  definitions: definitions,
                  modes: modes,
                )
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white,),
            );
          }
        },
      ),
    );
  }

  void _processDefinitions(int index) {
    _controller.definitionIndex = index;
    if (_controller.playing) {
      _controller.stopPlay();
      _controller.startPlay();
    }
  }
}

class _LCOpenView extends StatelessWidget {
  final PlatformViewCreatedCallback? onPlatformViewCreated;

  const _LCOpenView({this.onPlatformViewCreated});

  @override
  Widget build(BuildContext context) {

    if (Platform.isAndroid) {
      return AndroidView(
        viewType: 'lcopen_view',
        onPlatformViewCreated: onPlatformViewCreated,
      );
    }
    return ErrorWidget('暂不支持该平台！');
  }
}