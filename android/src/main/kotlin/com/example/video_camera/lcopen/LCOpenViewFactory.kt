package com.example.video_camera.lcopen

import android.content.Context
import android.widget.FrameLayout
import io.flutter.Log
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class LCOpenViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    private val views: MutableMap<Int, FrameLayout> = HashMap()

    // args是布尔类型，表示是否是横屏
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        Log.d(
            TAG,
            "创建FrameLayout, viewId: $viewId"
        )
        val view = LCOpenView(context)
        views[viewId] = view.content
        return view
    }

    fun getContent(viewId: Int): FrameLayout? {
        return views[viewId]
    }

    fun releaseView() {
        views.clear()
    }

    companion object {
        private const val TAG = "LCOpenSDK-LCOpenViewFactory"
    }
}