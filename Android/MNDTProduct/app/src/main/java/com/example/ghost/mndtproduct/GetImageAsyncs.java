package com.example.ghost.mndtproduct;

import android.annotation.TargetApi;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Build;
import android.util.Log;
import android.widget.ImageView;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Created by Ghost on 2017/5/16.
 */
public class GetImageAsyncs extends AsyncTask<URLImageData, Void, Bitmap> {
    private final String TAG = "GetImageAsync";
    private ImageView g_imgData = null;
    private String g_sURL = "";

    public GetImageAsyncs(final String sURL, final ImageView imgData) {
        g_imgData = imgData;
        g_sURL = sURL;
    }

    @Override
    protected Bitmap doInBackground(URLImageData... params) {
        return getBitmapFromURL(params[0]);
    }

    @Override
    protected void onPostExecute(Bitmap bitmap) {
        super.onPostExecute(bitmap);
        g_imgData.setImageBitmap(bitmap);
    }

    private final Bitmap getBitmapFromURL(final URLImageData imageData) {
        if (!fnSDExist(imageData)) {
            Log.e(TAG, "Loading.....");
            try {
                final String imageUrl = imageData.fnGetURL();
                final URL url = new URL(imageUrl);
                final HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setDoInput(true);
                connection.connect();
                final InputStream input = connection.getInputStream();
                final Bitmap btData = BitmapFactory.decodeStream(input);
                fnSaveSD(imageData, btData);
                return btData;
            } catch (IOException e) {
                Log.e(TAG, e.getMessage());
                return null;
            }
        } else {
            final Bitmap btData = BitmapFactory.decodeFile(imageData.fnGetSDDataPath());
            return btData;
        }
    }

    private final void fnSaveSD(final URLImageData imageData, final Bitmap btData) {
        FileOutputStream foutStream;
        try {
            final File fileDir = new File(imageData.fnGetSDDirPath());

            if (!fileDir.exists()) {
                fileDir.mkdir();
            }

            foutStream = new FileOutputStream(imageData.fnGetSDDataPath());
            btData.compress(Bitmap.CompressFormat.PNG, 60, foutStream);
            foutStream.flush();
            foutStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private final boolean fnSDExist(final URLImageData imageData) {
        final File fileData = new File(imageData.fnGetSDDataPath());
        return fileData.exists();
    }
}
