package com.aiportraitapp.jayanthl.bokehfyapp

import android.content.Context
import android.os.AsyncTask
import android.widget.Toast
import io.flutter.plugin.common.MethodChannel
import java.lang.reflect.Method

class AsyncHandler(val handler: () -> Boolean, mContext: Context, pendingIntentResult: MethodChannel.Result): AsyncTask<Context, Void, Boolean>() {

    var mContext: Context
    var pendingIntentResult: MethodChannel.Result
    init {
        this.mContext = mContext
        this.pendingIntentResult = pendingIntentResult
    }

    override fun doInBackground(vararg params: Context?): Boolean {
        return handler()
    }

    override fun onPostExecute(result: Boolean?) {
        super.onPostExecute(result)

        if (result!!) {
            // Toast.makeText(mContext, "BokehFied", Toast.LENGTH_LONG).show()
            pendingIntentResult.success("success")
        } else {
            Toast.makeText(mContext, "The Image doesn't exists", Toast.LENGTH_LONG).show()
            pendingIntentResult.success("failure")
        }
    }
}