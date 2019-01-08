package com.aiportraitapp.jayanthl.bokehfyapp

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.content.res.AssetFileDescriptor
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import android.support.v4.content.FileProvider
import android.util.Log
import android.widget.Toast

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.opencv.android.Utils
import org.opencv.core.Core
import org.opencv.core.CvType
import org.opencv.core.Mat
import org.opencv.core.Size
import org.opencv.imgcodecs.Imgcodecs
import org.opencv.imgproc.Imgproc
import org.tensorflow.lite.Interpreter
import java.io.*
import java.lang.reflect.Method
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.MappedByteBuffer
import java.nio.channels.FileChannel
import java.security.MessageDigest
import java.text.SimpleDateFormat
import java.util.*
import java.util.jar.Manifest
import javax.crypto.Cipher
import javax.crypto.CipherInputStream
import javax.crypto.spec.SecretKeySpec
import javax.xml.transform.Result
import kotlin.collections.ArrayList
import kotlin.math.max

class MainActivity: FlutterActivity() {

    var mCurrentPhotoPath: String = ""

    val PICK_IMAGE_FOR_PORTRAIT_REQUESTCODE = 101
    val PICK_CAMERA_IMAGE_FOR_PORTRAIT_REQUESTCODE = 102

    val CHANNEL_BOKEHFY = "BokehfyImage"

    lateinit var tensorflowInterpreter: Interpreter

    val RESIZE_SIZE = 720
    val IMAGE_HEIGHT = 720
    val IMAGE_WIDTH = 720

    lateinit var imageByteBuffer: ByteBuffer
    val resultData = ByteBuffer.allocateDirect(4 * IMAGE_WIDTH * IMAGE_HEIGHT)
    val imagePixels = IntArray(IMAGE_HEIGHT * IMAGE_WIDTH)
    var floatArray: FloatArray = FloatArray(IMAGE_HEIGHT * IMAGE_WIDTH * 3)

    var paddingOffset = 0
    lateinit var isPortrait: String

    val initDirectoryPath = Environment.getExternalStorageDirectory().toString() + "/Bokehfy"
    val portraitImageDirectory = initDirectoryPath + "/Portrait"
    val cameraPortraitDirectory = portraitImageDirectory + "/Camera/"
    val imagePortraitDirectory = portraitImageDirectory + "/Images/"

    val colorHighlightDirectory = initDirectoryPath + "/ColorHighlight"
    val cameraColorHighlightDirectory = colorHighlightDirectory + "/Camera/"
    val imageColorHighlightDirectory = colorHighlightDirectory + "/Images/"



    lateinit var pendingIntentnResult: MethodChannel.Result
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        if(!File(this.filesDir, "tflite_model.tflite").exists()) {
            val fileDescriptor: AssetFileDescriptor= assets.openFd("tflite_model_v1.tflite.enc")
            val fileInputStream = fileDescriptor.createInputStream()
            decryptModelFile(fileInputStream, "lkench5@")
        } else {
            Toast.makeText(this, "File already exists", Toast.LENGTH_LONG).show()
        }


        System.loadLibrary(Core.NATIVE_LIBRARY_NAME)
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (checkSelfPermission(android.Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                requestPermissions(arrayOf(android.Manifest.permission.WRITE_EXTERNAL_STORAGE), 1001)
            } else {
                // Check for the directories
                if (!File(initDirectoryPath).exists()) {
                    File(initDirectoryPath).mkdir()
                }
                if(!File(portraitImageDirectory).exists()) {
                    File(portraitImageDirectory).mkdir()
                }

                if(!File(cameraPortraitDirectory).exists()) {
                    File(cameraPortraitDirectory).mkdir()
                }

                if(!File(imagePortraitDirectory).exists()) {
                    File(imagePortraitDirectory).mkdir()
                }

                if(!File(colorHighlightDirectory).exists()) {
                    File(colorHighlightDirectory).mkdir()
                }

                if(!File(imageColorHighlightDirectory).exists()) {
                    File(imageColorHighlightDirectory).mkdir()
                }

                if(!File(cameraColorHighlightDirectory).exists()) {
                    File(cameraColorHighlightDirectory).mkdir()
                }
            }
        }


        // Platform channel starts
        MethodChannel(flutterView, CHANNEL_BOKEHFY).setMethodCallHandler {methodCall, result ->
            val arguments: Map<String, ObjectInput> = methodCall.arguments()

            if(methodCall.method.equals("getBokehImages")) {
                val bokehImagesList:  ArrayList<String> = arrayListOf()
                File(Environment.getExternalStorageDirectory().toString() + "/Bokehfy/Portrait/Images/").walk().forEach {
                    bokehImagesList.add(it.toString())
                }
                bokehImagesList.removeAt(0)
                result.success(bokehImagesList)
            }
            else if(methodCall.method.equals("getBokehImagesCamera")) {
                val bokehImagesList:  ArrayList<String> = arrayListOf()
                File(Environment.getExternalStorageDirectory().toString() + "/Bokehfy/Portrait/Camera/").walk().forEach {
                    bokehImagesList.add(it.toString())
                }
                bokehImagesList.removeAt(0)
                result.success(bokehImagesList)
            }
            else if(methodCall.method.equals("getAllPortraitImages")) {
                val bokehImagesList:  ArrayList<String> = arrayListOf()
                val bokehImageList2: ArrayList<String> = arrayListOf()
                File(Environment.getExternalStorageDirectory().toString() + "/Bokehfy/Portrait/Images/").walk().forEach {
                    bokehImagesList.add(it.toString())
                }
                var count = 0
                File(Environment.getExternalStorageDirectory().toString() + "/Bokehfy/Portrait/Camera/").walk().forEach {
                    bokehImageList2.add(it.toString())
                }
                bokehImageList2.removeAt(0)
                bokehImagesList.removeAt(0)


                result.success(bokehImageList2 + bokehImagesList)
            }

            else if(methodCall.method.equals("getImagepathToPortrait")) {
                this.pendingIntentnResult = result
                val pickImageIntent = Intent(Intent.ACTION_GET_CONTENT)
                pickImageIntent.type = "image/*"
                startActivityForResult(pickImageIntent, PICK_IMAGE_FOR_PORTRAIT_REQUESTCODE)

            } else if(methodCall.method.equals("getCameraImagepathToPortraitAndPortrify")) {
                this.pendingIntentnResult = result
                Intent(MediaStore.ACTION_IMAGE_CAPTURE).also { takePictureIntent ->
                    // Ensure that there's a camera activity to handle the intent
                    takePictureIntent.resolveActivity(packageManager)?.also {
                        // Create the File where the photo should go
                        val photoFile: File? = try {
                            createImageFile()
                        } catch (ex: IOException) {
                            // Error occurred while creating the File
                            null
                        }
                        // Continue only if the File was successfully created
                        photoFile?.also {
                            val photoURI: Uri = FileProvider.getUriForFile(
                                    this,
                                    this.applicationContext.packageName + ".com.aiportraitapp.jayanthl.bokehfyapp.provider",
                                    it
                            )
                            takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, photoURI)
                            startActivityForResult(takePictureIntent, PICK_CAMERA_IMAGE_FOR_PORTRAIT_REQUESTCODE)
                        }
                    }
                }
            }



            else if(methodCall.method.equals("sendImageForBokehfycation")) {



                AsyncHandler({

                    val imagepath = arguments.get("imagepath").toString()

                    aiConvertToPortrait(imagepath, imagePortraitDirectory)
                    return@AsyncHandler true
                }, this, result).execute()
            }

            
        }

    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>?, grantResults: IntArray?) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if((requestCode == 1001) && (grantResults!!.size > 0)) {
            if(!File(initDirectoryPath).exists()) {
                File(initDirectoryPath).mkdir()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if(requestCode == PICK_IMAGE_FOR_PORTRAIT_REQUESTCODE) {
            try {
                val path = FileUtils().getPathFromUri(this, data!!.data)
                pendingIntentnResult.success(path)
            } catch (e: java.lang.Exception) {
                pendingIntentnResult.success("")
            }
        } else if(requestCode == PICK_CAMERA_IMAGE_FOR_PORTRAIT_REQUESTCODE && resultCode == Activity.RESULT_OK) {

            try {
                AsyncHandler({


                    aiConvertToPortrait(mCurrentPhotoPath,  cameraPortraitDirectory)
                    if(File(mCurrentPhotoPath).exists()) {
                        File(mCurrentPhotoPath).delete()
                    }

                    return@AsyncHandler true
                }, this, pendingIntentnResult).execute()
            } catch (e: java.lang.Exception) {
                pendingIntentnResult.success("success")
                e.printStackTrace()
            }

        } else {
            pendingIntentnResult.success("")
        }
    }


    fun decryptModelFile(fileInputStream: FileInputStream, password: String): Boolean {
        try {
            val decryptedFileOutputStream = FileOutputStream(File(filesDir, "tflite_model.tflite"))
            var key = password.toByteArray(charset("UTF-8"))
            val sha1sum = MessageDigest.getInstance("SHA-1")
            key = sha1sum.digest(key)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.GINGERBREAD) {
                key = Arrays.copyOf(key, 16)
            }
            val secretKeySpec = SecretKeySpec(key, "AES")
            val cipher = Cipher.getInstance("AES")
            cipher.init(Cipher.DECRYPT_MODE, secretKeySpec)
            val cipherInputStream = CipherInputStream(fileInputStream, cipher)
            var bytes: Int
            val datasize = ByteArray(64)
            var filevalue = 0
            bytes = cipherInputStream.read(datasize)
            while (bytes != -1) {
                Log.i("Bytes", "size: $bytes")
                filevalue = filevalue + bytes
                decryptedFileOutputStream.write(datasize, 0, bytes)
                bytes = cipherInputStream.read(datasize)
            }
            Log.i("Total read bytes", "" + filevalue)
            decryptedFileOutputStream.flush()
            decryptedFileOutputStream.close()
            cipherInputStream.close()

            Toast.makeText(this, "Model decrypted successfully", Toast.LENGTH_LONG).show()
            //Toasty.success(this, "Successfully Decrypted", Toast.LENGTH_LONG, true).show()
            return true
        } catch (e: Exception) {
            Toast.makeText(this, "Sorry, couldn't decrypt the model, try again!!!", Toast.LENGTH_LONG).show()
            e.printStackTrace()
            return false
        }
    }

    fun resizematrix(image: Mat): Mat {
        val width = image.width()
        val height = image.height()

        val resizeRatio = 1.0 * RESIZE_SIZE / max(height, width)
        val targetSizeheight = (resizeRatio * height).toInt()
        val targetSizeWidth = (resizeRatio * width).toInt()
        val size = Size(targetSizeWidth.toDouble(), targetSizeheight.toDouble())
        Imgproc.resize(image, image, size)
        return image
    }

    fun paddImage(image: Mat, isPortrait: Boolean): Mat {
        val paddedImage = Mat(RESIZE_SIZE, RESIZE_SIZE, CvType.CV_8UC3)
        for (i in 0..(RESIZE_SIZE -1)) {
            for (j in 0..(RESIZE_SIZE -1)) {
                if(isPortrait) {
                    if(j >= image.width()) {
                        paddedImage.put(i, j, 0.0, 0.0, 0.0)
                    } else {
                        paddedImage.put(i, j, image.get(i, j)[0], image.get(i, j)[1], image.get(i, j)[2])
                    }
                } else {
                    if(i >= image.height()) {
                        paddedImage.put(i, j, 0.0, 0.0, 0.0)
                    } else {
                        paddedImage.put(i, j, image.get(i, j)[0], image.get(i, j)[1], image.get(i, j)[2])
                    }
                }
            }
        }
        return paddedImage
    }

    fun removePaddingOfImage(image: Mat, offset: Int, isPotrait: String): Mat {
        if(isPotrait == "true") {
            Log.i("PaddingOffset", "init 1")
            val unpaddedImage = Mat(RESIZE_SIZE, RESIZE_SIZE - offset, CvType.CV_8UC3)
            for (i in 0..(RESIZE_SIZE -1)) {
                for (j in 0..(RESIZE_SIZE - offset -1)) {
                    unpaddedImage.put(i, j, image.get(i, j)[0], image.get(i, j)[1], image.get(i, j)[2])
                }
            }
            return unpaddedImage
        } else {
            Log.i("PaddingOffset", "init 2")
            val unpaddedImage = Mat(RESIZE_SIZE - offset, RESIZE_SIZE, CvType.CV_8UC3)
            for (i in 0..(RESIZE_SIZE -offset -1)) {
                for (j in 0..(RESIZE_SIZE -1)) {
                    unpaddedImage.put(i, j, image.get(i, j)[0], image.get(i, j)[1], image.get(i, j)[2])
                }
            }
            return unpaddedImage
        }
    }

    fun convertBitmapToFloatArray(bitmap: Bitmap) {
        bitmap.getPixels(imagePixels, 0, bitmap.width, 0, 0, bitmap.width, bitmap.height)
        for (i in 0..(imagePixels.size -1)) {
            val value = imagePixels[i]
            floatArray[i * 3 + 0] = (value shr 16 and 0xFF).toFloat()
            floatArray[i * 3 + 1] = (value shr 8 and 0xFF).toFloat()
            floatArray[i * 3 + 2] = (value and 0xFF).toFloat()
        }
    }

    private fun createImageFile(): File {
        // Create an image file name
        val timeStamp: String = SimpleDateFormat("yyyyMMdd_HHmmss").format(Date())
        val storageDir: File = getExternalFilesDir(Environment.DIRECTORY_PICTURES)
        return File.createTempFile(
                "JPEG_${timeStamp}_", /* prefix */
                ".jpg", /* suffix */
                storageDir /* directory */
        ).apply {
            // Save a file: path for use with ACTION_VIEW intents
            mCurrentPhotoPath = absolutePath
        }
    }

    fun aiConvertToPortrait(imagePath: String, saveDirectory: String) {
        var image = Imgcodecs.imread(imagePath)
        image = resizematrix(image)

        Log.i("PaddingOffset", "width: ${image.width()} and height: ${image.height()}")

        if(image.width() < image.height()) {
            this.paddingOffset = image.height() - image.width()
            image = paddImage(image, true)
            isPortrait = "true"
        } else {
            this.paddingOffset = image.width() - image.height()
            image = paddImage(image, false)
            isPortrait = "false"
        }

        val interpreterBitmap: Bitmap = Bitmap.createBitmap(RESIZE_SIZE, RESIZE_SIZE, Bitmap.Config.ARGB_4444)
        Utils.matToBitmap(image, interpreterBitmap)

        imageByteBuffer = ByteBuffer.allocateDirect(IMAGE_HEIGHT * IMAGE_WIDTH * 3)
        imageByteBuffer.order(ByteOrder.nativeOrder())

        try {
            tensorflowInterpreter = Interpreter(File(filesDir, "tflite_model.tflite"))
            Log.i("Tensorflow", "Tensorflow model loaded successfully")
        } catch (e: java.lang.Exception) {
            Log.i("Tensorflow", "Error loading Tflite model")
        }

        convertBitmapToFloatArray(interpreterBitmap)
        tensorflowInterpreter.run(floatArray, resultData)

        resultData.rewind()

        val segmentationmask = Mat(RESIZE_SIZE, RESIZE_SIZE, CvType.CV_8UC3)
        for(i in 0..(RESIZE_SIZE -1)) {
            for(j in 0..(RESIZE_SIZE -1)) {
                val value = resultData.getFloat()
                if(value != 0.toFloat()) {
                    segmentationmask.put(i, j, 1.0, 1.0, 1.0)
                } else {
                    segmentationmask.put(i, j, 0.0, 0.0, 0.0)
                }
            }
        }

        val finalCroppedImage = segmentationmask.mul(image)

        // Apply blur to the original image
        Imgproc.GaussianBlur(image, image, Size(55.0, 55.0), 2.0)

        var finalBokehImageWithoutCrop = Mat(RESIZE_SIZE, RESIZE_SIZE, CvType.CV_8UC3)
        for (i in 0..(finalCroppedImage.height() -1)) {
            for (j in 0..(finalCroppedImage.width() -1)) {
                if((finalCroppedImage.get(i, j)[0] == 0.0) && (finalCroppedImage.get(i, j)[1] == 0.0) && (finalCroppedImage.get(i, j)[2] == 0.0)) {
                    finalBokehImageWithoutCrop.put(i, j, image.get(i, j)[0], image.get(i, j)[1], image.get(i, j)[2])
                } else {
                    finalBokehImageWithoutCrop.put(i, j, finalCroppedImage.get(i, j)[0], finalCroppedImage.get(i, j)[1], finalCroppedImage.get(i, j)[2])
                }
            }
        }

        // Unpadd the Image
        Log.i("PaddingOffset", this.paddingOffset.toString())
        val finalImage = removePaddingOfImage(finalBokehImageWithoutCrop, this.paddingOffset, isPortrait)

        Imgcodecs.imwrite(saveDirectory + Date().time.toString() + ".png", finalImage)
        resultData.rewind()
    }
}
