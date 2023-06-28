import 'dart:async';
import 'dart:io';

import 'package:video_camera/ezopen/ezopen_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EZOpenPlayerController extends ChangeNotifier {

  EZOpenPlayerController({
    required this.appKey,
    required this.accessToken,
    this.logEnabled = false
  });

  final String appKey;
  //是否开启sdk日志，默认不开启
  final bool? logEnabled;
  String accessToken;

  Future<void> initPlayer(String deviceSerial, String verifyCode, int cameraNo) async {
    EZOpenSDK.setLogEnabled(true);
    await EZOpenSDK.initLibWithAppKey(appKey);
    EZOpenSDK.setAccessToken(accessToken);
    await EZOpenSDK.initPlayer(deviceSerial, verifyCode, cameraNo);
  }

  void startRealPlay(int viewId) {
    EZOpenSDK.startRealPlay(viewId);
  }

  void stopRealPlay() {
    EZOpenSDK.stopRealPlay();
  }
}

class EZOpenPlayer extends StatefulWidget {

  final EZOpenPlayerController controller;

  final String deviceSerial;
  final String verifyCode;
  final int cameraNo;

  const EZOpenPlayer({
    super.key,
    required this.controller,
    required this.deviceSerial,
    required this.verifyCode,
    required this.cameraNo
  });

  @override
  State<StatefulWidget> createState() => _EZOpenPlayerState();
}

class _EZOpenPlayerState extends State<EZOpenPlayer> {

  late EZOpenPlayerController _controller;

  late bool _playing;
  late bool _mute;
  // late bool _landscape;
  late StateSetter _toolbarSetter;

  late Future<void> _initFuture;

  late int? _viewId;
  // late int _portraitId;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _playing = false;
    _mute = false;
    // _landscape = false;
    _initFuture = _controller.initPlayer(
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
                  child: _EZOpenView(
                    onPlatformViewCreated: (int viewId) {
                      // _portraitId = viewId;
                      _viewId = viewId;
                      // _controller.startRealPlay(viewId);
                    },
                  ),
                ),
                _buildToolbar(context)
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext ctx, StateSetter setter) {
        _toolbarSetter = setter;

        Widget content = InkWell(
          onTap: _processPlay,
          child: Container(
            child: !_playing ? _buildIcon(Icons.play_circle_outline, 50) : null,
          ),
        );

        Widget toolbar = Container(
          color: Colors.white54,
          height: kToolbarHeight,
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: _processPlay,
                    child: _playing
                        ? _buildIcon(Icons.pause_circle_outline)
                        : _buildIcon(Icons.play_circle_outline),
                  ),
                  Expanded(child: Container()),
                  // GestureDetector(
                  //   onTap: () {
                  //     _processRotation(context);
                  //   },
                  //   child: _buildIcon(Icons.screen_rotation),
                  // ),
                  GestureDetector(
                    onTap: () {
                      _mute = !_mute;
                      _toolbarSetter((){});
                    },
                    child: _mute
                        ? _buildIcon(Icons.volume_off)
                        : _buildIcon(Icons.volume_up),
                  ),
                  TextButton(onPressed: () {}, child: Text("清晰度")),
                  TextButton(onPressed: () {}, child: Text("模式")),
                ],
              )
            ],
          ),
        );

        return Column(
          children: [
            Expanded(
              child: content,
            ),
            toolbar
          ],
        );
      },
    );
  }

  Widget _buildIcon(IconData data, [double? size]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Icon(data, color: Colors.white, size: size,),
    );
  }

  void _processPlay() {
    if (_viewId == null) return;
    if (_playing) {
      _playing = false;
      _controller.stopRealPlay();
    } else {
      _playing = true;
      _controller.startRealPlay(_viewId!);
    }
    _toolbarSetter((){});
  }

  // void _processRotation(BuildContext context) {
  //   if (_landscape) {
  //     _landscape = false;
  //     Navigator.pop(context);
  //     return;
  //   }
  //
  //   _landscape = true;
  //   // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  //   if (_playing) {
  //     _controller.stopRealPlay();
  //   }
  //   showDialog(
  //     useSafeArea: false,
  //     context: context,
  //     builder: (BuildContext ctx) {
  //       return Container(
  //         width: 200,
  //         height: 200,
  //         child: Text("全屏"),
  //       );
  //     }
  //   ).then((value) {
  //     _landscape = false;
  //     _viewId = _portraitId;
  //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  //     // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //     if (_playing) {
  //       _controller.startRealPlay(_viewId!);
  //     }
  //   });
  // }
}

class _EZOpenView extends StatelessWidget {
  final PlatformViewCreatedCallback? onPlatformViewCreated;

  const _EZOpenView({this.onPlatformViewCreated});

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: 'ezopen_view',
        onPlatformViewCreated: onPlatformViewCreated,
      );
    }
    return ErrorWidget('暂不支持该平台！');
  }
}