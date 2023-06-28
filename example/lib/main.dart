import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:video_camera/video_camera.dart';

import 'lcopen_page.dart';

void main() {
  runApp(const MyAppAre());
}

class MyAppAre extends StatelessWidget {
  const MyAppAre({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: IndexPage(),
    );
  }
}
class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('视频播放示例'),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {},
                child: Text('萤石云')
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => const LCOpenPage()));
                },
                child: Text('乐橙云')
            ),
          ],
        ),
      ),
    );
  }
}
