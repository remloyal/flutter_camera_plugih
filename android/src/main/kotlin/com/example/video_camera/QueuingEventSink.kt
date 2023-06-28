package com.example.video_camera

import io.flutter.plugin.common.EventChannel.EventSink

class QueuingEventSink : EventSink {
    private var delegate: EventSink? = null
    private val eventQueue = ArrayList<Any>()
    private var done = false
    fun setDelegate(delegate: EventSink?) {
        this.delegate = delegate
        maybeFlush()
    }

    override fun endOfStream() {
        enqueue(EndOfStreamEvent())
        maybeFlush()
        done = true
    }

    override fun error(code: String, message: String, details: Any) {
        enqueue(ErrorEvent(code, message, details))
        maybeFlush()
    }

    override fun success(event: Any) {
        enqueue(event)
        maybeFlush()
    }

    private fun enqueue(event: Any) {
        if (done) {
            return
        }
        eventQueue.add(event)
    }

    private fun maybeFlush() {
        if (delegate == null) {
            return
        }
        for (event in eventQueue) {
            if (event is EndOfStreamEvent) {
                delegate!!.endOfStream()
            } else if (event is ErrorEvent) {
                delegate!!.error(event.code, event.message, event.details)
            } else {
                delegate!!.success(event)
            }
        }
        eventQueue.clear()
    }

    internal class EndOfStreamEvent
    private class ErrorEvent internal constructor(
        var code: String,
        var message: String,
        var details: Any
    )
}