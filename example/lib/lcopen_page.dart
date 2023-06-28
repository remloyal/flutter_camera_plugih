import 'package:video_camera/video_camera.dart';
import './popup.dart';
import 'package:flutter/material.dart';

class LCOpenPage extends StatefulWidget {
  const LCOpenPage({super.key});

  @override
  State<StatefulWidget> createState() => _LCOpenPageState();
}

class _LCOpenPageState extends State<LCOpenPage> {
  late LCOpenPlayerController _controller;

  late String accessToken = '';
  late TextEditingController? accessToken_controller = null;

  late String deviceSerial = '';
  late TextEditingController? deviceSerial_controller = null;

  late String verifyCode = '';
  late TextEditingController? verifyCode_controller = null;

  @override
  void initState() {
    super.initState();
    accessToken = 'Kt_hz15da62015e824099af9842d62d2d46';
    deviceSerial = '6J0E43DPAGFDAF7';
    verifyCode = 'jsca2020';
    accessToken_controller =
        TextEditingController(text: accessToken);
    deviceSerial_controller = TextEditingController(text: deviceSerial);
    verifyCode_controller = TextEditingController(text: verifyCode);
    _controller = LCOpenPlayerController(
        accessToken: accessToken);

  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('开始播放');
    return Scaffold(
        appBar: AppBar(
          title: const Text('乐橙云播放器'),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: accessToken_controller,
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: 'accessToken',
                  ),
                  onChanged: (value) {
                    print(value);
                    accessToken = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: deviceSerial_controller,
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: 'deviceSerial',
                  ),
                  onChanged: (value) {
                    print(value);
                    deviceSerial = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: verifyCode_controller,
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: 'verifyCode',
                  ),
                  onChanged: (value) {
                    print(value);
                    verifyCode = value;
                  },
                ),
              ),
              TextButton(
                  onPressed: () {

                    Navigator.push(
                        context,
                        Popup(
                            child: PopupDjando(
                                top: MediaQuery.of(context).size.height / 4,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  // height: MediaQuery.of(context).size.height,
                                  child: play(),
                                ))));
                  },
                  child: const Text('播放视频'))
            ],
          ),
        ));
  }

  Widget play() {

    return LCOpenPlayer(
        controller: _controller,
        deviceSerial: deviceSerial,
        verifyCode: verifyCode,
        cameraNo: 0);
  }
}
