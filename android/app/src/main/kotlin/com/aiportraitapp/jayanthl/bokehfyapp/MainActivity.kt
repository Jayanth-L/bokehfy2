package com.aiportraitapp.jayanthl.bokehfyapp

import android.app.Activity
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.os.Environment

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.opencv.core.Core
import java.io.File
import java.io.ObjectInput
import java.util.jar.Manifest

class MainActivity: FlutterActivity() {

    val CHANNEL_BOKEHFY = "BokehfyImage"
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        System.loadLibrary(Core.NATIVE_LIBRARY_NAME)
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (checkSelfPermission(android.Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                requestPermissions(arrayOf(android.Manifest.permission.WRITE_EXTERNAL_STORAGE), 1001)
            } else {
                // Check for the directories
                if (!File(Environment.getExternalStorageDirectory().toString() + "/Bokehfy").exists()) {
                    File(Environment.getExternalStorageDirectory().toString() + "/Bokehfy").mkdir()
                }
            }
        }


        // Platform channel starts
        MethodChannel(flutterView, CHANNEL_BOKEHFY).setMethodCallHandler {methodCall, result ->
            val arguments: Map<String, ObjectInput> = methodCall.arguments()
            if(methodCall.method.equals("getBokehImages")) {
                val bokehImagesList:  ArrayList<String> = arrayListOf()
                File(Environment.getExternalStorageDirectory().toString() + "/Bokehfy/").walk().forEach {
                    bokehImagesList.add(it.toString())
                }
                bokehImagesList.removeAt(0)
                result.success(bokehImagesList)
            }
        }

    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>?, grantResults: IntArray?) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if((requestCode == 1001) && (grantResults!!.size > 0)) {
            if(!File(Environment.getExternalStorageDirectory().toString() + "/Bokehfy").exists()) {
                File(Environment.getExternalStorageDirectory().toString() + "'/Bokehfy").mkdir()
            }
        }
    }
}
