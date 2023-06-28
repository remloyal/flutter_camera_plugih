package com.example.video_camera.lcopen

import android.content.Context
import android.view.View
import android.widget.FrameLayout
import io.flutter.plugin.platform.PlatformView

class LCOpenView(context: Context) : PlatformView {
    private val parent: FrameLayout
    val content: FrameLayout

    init {
        parent = FrameLayout(context)
        content = FrameLayout(context)
        parent.addView(content)
    }

    override fun getView(): View {
        return parent
    }

    override fun dispose() {}
}