package com.aiportraitapp.jayanthl.bokehfyapp;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;

import org.opencv.android.Utils;
import org.opencv.core.Mat;
import org.opencv.core.Point;

public class HelperFunctions {

    public Mat applyWatermarkToImage(Mat image) {
        Bitmap sourceBitmap = Bitmap.createBitmap(image.width(), image.height(), Bitmap.Config.ARGB_4444);
        Utils.matToBitmap(image, sourceBitmap);
        int width = image.width();
        int height = image.height();
        Bitmap resultImage = Bitmap.createBitmap(width, height, sourceBitmap.getConfig());
        Point point = new Point(width/2, height/2);
        Canvas canvas = new Canvas(resultImage);
        canvas.drawBitmap(sourceBitmap, 0, 0, null);
        Paint paint = new Paint();
        paint.setFakeBoldText(true);
        paint.setColor(Color.WHITE);
        paint.setAlpha(180);
        paint.setTextSize(17.0f);
        paint.setAntiAlias(true);
        paint.setUnderlineText(true);
        canvas.drawText("BOKEHFY", width -90, height-20, paint);
        Utils.bitmapToMat(resultImage, image);
        return image;
    }
}
