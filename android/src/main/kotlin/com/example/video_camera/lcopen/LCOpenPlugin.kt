package com.example.video_camera.lcopen

import android.content.Context
import androidx.annotation.NonNull
import com.example.video_camera.QueuingEventSink
import com.lechange.opensdk.api.InitParams
import com.lechange.opensdk.api.LCOpenSDK_Api
import com.lechange.opensdk.media.LCOpenSDK_ParamDeviceRecord
import com.lechange.opensdk.media.LCOpenSDK_ParamReal
import com.lechange.opensdk.media.cloud.listener.LCOpenSDK_PlayBackListener
import com.lechange.opensdk.media.playback.LCOpenSDK_PlayBackWindow
import com.lechange.opensdk.media.realtime.LCOpenSDK_PlayRealWindow
import com.lechange.opensdk.media.realtime.listener.LCOpenSDK_PlayRealListener
import com.lechange.opensdk.utils.LCOpenSDK_Utils
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class LCOpenPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    companion object {
        private const val TAG = "LCOpenSDK-MethodCallHandler"
        lateinit var context: Context
    }

    private lateinit var lcopen: MethodChannel
    private lateinit var lcOpenPlugin: LCOpenPlugin

    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private lateinit var eventSink: QueuingEventSink
    private lateinit var factory: LCOpenViewFactory
    private lateinit var realWindow: LCOpenSDK_PlayRealWindow
    private lateinit var playbackWindow: LCOpenSDK_PlayBackWindow

    private lateinit var initParams: InitParams

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        eventChannel = EventChannel(binding.binaryMessenger, "lcopen_event")
        eventSink = QueuingEventSink()
        setUpEventSink()
        methodChannel = MethodChannel(binding.binaryMessenger, "lcopen_plugin_sdk")
        factory = LCOpenViewFactory()
        methodChannel.setMethodCallHandler(this)
        Log.d(TAG, "创建FrameLayout, viewId: $factory")

        try {

            initParams = InitParams(binding.applicationContext,"openapi.lechange.cn:443","");
        }catch (e: Throwable) {
            Log.e(TAG, "Exception  initParams:$e")
        }

        binding.platformViewRegistry.registerViewFactory("lcopen_view", factory)
        Log.d("lcOpenPlugin", lcOpenPlugin.toString())
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            val method = call.method
            if (realWindow == null){
                realWindow = LCOpenSDK_PlayRealWindow();
            }
            if ("setLogEnabled" == method) {
                val enable = call.arguments<Boolean>()
                if (enable != null) {
                    LCOpenSDK_Utils.enableLogPrint(enable)
                    //level：0:fatal 1:error 2:warning 3:info 4 debug
                    LCOpenSDK_Utils.setLogLevel(4)
                }
            } else if ("initLibWithAccessToken" == method) {
                val token = call.arguments<String>()
                val host = "openapi.lechange.cn:443" //host无需带协议类型
                Log.d(TAG, "创建InitParams, token: $token!");

//                val params = InitParams(context, host, token)
                initParams.token = token;
                LCOpenSDK_Api.initOpenApi(initParams);
                result.success(true)
            } else if ("startRealPlay" == method) {
                startRealPlay(call, result)
                result.success(true)
            } else if ("stopRealPlay" == method) {
                realWindow.stopRtspReal(false)
                result.success(true)
            } else if ("startPlayback" == method) {
                startPlayback(call, result)
                result.success(true)
            } else if ("stopPlayback" == method) {
                playbackWindow.stopRecordStream(false)
                result.success(true)
            } else if ("setSoundEnabled" == method) {
                val enabled = call.arguments<Boolean>()
                val b: Boolean = if (java.lang.Boolean.TRUE == enabled) {
                    realWindow.playAudio()
                } else {
                    realWindow.stopAudio()
                }
                result.success(b)
            } else if ("release" == method) {
                realWindow.uninitPlayWindow()
                playbackWindow.uninitPlayWindow()
                factory.releaseView()
                result.success(null)
            } else {
                result.notImplemented()
            }
        } catch (e: Throwable) {
            Log.e(TAG, "Exception:" + e.message)
            result.error("error", e.message, e)
        }
    }

    override fun onDetachedFromEngine( binding: FlutterPlugin.FlutterPluginBinding) {
        lcopen.setMethodCallHandler(null)
    }

    private fun setUpEventSink() {
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink.setDelegate(events)
            }

            override fun onCancel(arguments: Any?) {
                eventSink.setDelegate(null)
            }
        })
    }

    private fun startRealPlay(call: MethodCall, result: MethodChannel.Result) {

        val viewId = call.argument<Int>("viewId")
        if (viewId == null) result.success(false)

        //初始化直播参数
        val accessToken = call.argument<String>("accessToken")
        val deviceSerial = call.argument<String>("deviceSerial")
        val verifyCode = call.argument<String>("verifyCode")
        val channel = call.argument<Int>("channel")!!
        val bateMode = call.argument<Int>("bateMode")

        accessToken?.let { Log.d("accessToken", it) };
        deviceSerial?.let { Log.d("deviceSerial", it) };
        verifyCode?.let { Log.d("verifyCode", it) }
        val param = LCOpenSDK_ParamReal(
            accessToken,
            deviceSerial,
            0,
            verifyCode,
            "",
            bateMode!!,
            true,
            true,
            1080,
            ""
        )
        //初始化playWindow
        viewId?.let { it ->
            factory.getContent(it)?.let { realWindow.initPlayWindow(context, it, 0, false) }
        }
        //设置监听
        realWindow.setPlayRealListener(object : LCOpenSDK_PlayRealListener() {
            override fun onPlayBegin(winID: Int, context: String) {
                super.onPlayBegin(winID, context)
                val event: MutableMap<String, Any> = HashMap()
                event["event"] = "start"
                Log.d("start 开始播放", winID.toString())
                eventSink.success(event)
            }

            override fun onPlayLoading(winID: Int) {
                super.onPlayLoading(winID)
                val event: MutableMap<String, Any> = HashMap()
                event["event"] = "loading"
                eventSink.success(event)
            }

            override fun onPlayFail(winID: Int, errorCode: String, type: Int) {
                super.onPlayFail(winID, errorCode, type)
                eventSink.error(errorCode, "乐橙云视频播放失败", type)
            }
        })
        realWindow.playRtspReal(param)
    }

    private fun startPlayback(call: MethodCall, result: MethodChannel.Result) {
        val viewId = call.argument<Int>("viewId")
        if (viewId == null) result.success(false)

        //初始化直播参数
        val accessToken = call.argument<String>("accessToken")
        val deviceSerial = call.argument<String>("deviceSerial")
        val verifyCode = call.argument<String>("verifyCode")
        val channel = call.argument<Int>("channel")!!
        val startMillis = call.argument<Long>("startMillis")
        val endMillis = call.argument<Long>("endMillis")
        val bateMode = call.argument<Int>("bateMode")
        val param = LCOpenSDK_ParamDeviceRecord(
            accessToken!!,
            deviceSerial!!,
            channel,
            verifyCode!!,
            "",
            "",
            startMillis!!,
            endMillis!!,
            0,
            bateMode!!,
            true,
            ""
        )
        //初始化playWindow
        viewId?.let { it ->
            factory.getContent(it)?.let { playbackWindow.initPlayWindow(context, it, 0, false) }
        }
        //设置监听
        playbackWindow.setPlayBackListener(object : LCOpenSDK_PlayBackListener() {
            override fun onPlayBegin(winID: Int, context: String) {
                super.onPlayBegin(winID, context)
                val event: MutableMap<String, Any> = HashMap()
                event["event"] = "start"
                eventSink.success(event)
            }

            override fun onPlayLoading(winID: Int) {
                super.onPlayLoading(winID)
                val event: MutableMap<String, Any> = HashMap()
                event["event"] = "loading"
                eventSink.success(event)
            }

            override fun onPlayFail(winID: Int, errorCode: String, type: Int) {
                super.onPlayFail(winID, errorCode, type)
                val event: Map<String, Any> = HashMap()
                //                event.put("event", "start");
//                eventSink.success(event);
                eventSink.error(errorCode, "乐橙云视频播放失败", type)
            }

            override fun onPlayTime(winID: Int, context: String, playTime: Long) {
                super.onPlayTime(winID, context, playTime)
                val event: MutableMap<String, Any> = HashMap()
                event["event"] = "duration"
                event["message"] = playTime
                eventSink.success(event)
            }

            override fun onPlayFinished(winID: Int, context: String) {
                super.onPlayFinished(winID, context)
                val event: MutableMap<String, Any> = HashMap()
                event["event"] = "finished"
                eventSink.success(event)
            }
        })
        playbackWindow.playRecordStream(param)
    }


}