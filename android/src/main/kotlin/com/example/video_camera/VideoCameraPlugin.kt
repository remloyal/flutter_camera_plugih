package com.example.video_camera

import androidx.annotation.NonNull
import com.example.video_camera.lcopen.LCOpenPlugin

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** VideoCameraPlugin */
class VideoCameraPlugin: FlutterPlugin {

  private lateinit var lcopen: LCOpenPlugin

  override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    lcopen = LCOpenPlugin()
    lcopen!!.onAttachedToEngine(binding)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    lcopen!!.onDetachedFromEngine(binding)
  }
}
