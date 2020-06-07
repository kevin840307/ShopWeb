package com.example.ghost.mndtproduct;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.util.Log;
import android.widget.ImageView;
import android.widget.ListView;

import com.example.ghost.mndtproduct.Inventory.InventoryProductData;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;


public class ImageAsync {
    private String[] g_sURL = null;
    private ImageLruCache g_iLruSaveBitmap = null;
    private ListView g_lvShowData = null;
    private Set<GetImageAsync> g_setImgAsync = null;

    public ImageAsync(final ListView lvShowData,final ImageLruCache iLruSaveBitmap,  final ArrayList<InventoryProductData> alsData) {
        g_iLruSaveBitmap = iLruSaveBitmap;
        g_lvShowData = lvShowData;
        g_setImgAsync = new HashSet<>();
        g_sURL = new String [alsData.size()];
        for(int iPos = 0 ; iPos < alsData.size(); iPos++) {
            g_sURL[iPos] = alsData.get(iPos).fnGetURL();
        }
    }

    public ImageAsync(final ImageLruCache iLruSaveBitmap, final ImageView imgData, final String sURL) {
        final Bitmap btData = iLruSaveBitmap.fnGetBitmap(sURL);
        if(btData == null) {
            new GetImageAsync(iLruSaveBitmap, imgData, sURL).execute(sURL);
        } else {
            imgData.setImageBitmap(btData);
        }
    }

    public final void fnLoadImage(final int iStart, final int iEnd) {
        for(int iPos = iStart ; iPos < iEnd; iPos++) {
            final Bitmap btData = g_iLruSaveBitmap.fnGetBitmap(g_sURL[iPos]);
            final ImageView imgData = (ImageView)g_lvShowData.findViewWithTag(g_sURL[iPos]);
            if(btData == null) {
                final GetImageAsync imgAsync = new GetImageAsync(g_iLruSaveBitmap, imgData, g_sURL[iPos]);
                imgAsync.execute(g_sURL[iPos]);
                g_setImgAsync.add(imgAsync);
            } else {
                imgData.setImageBitmap(btData);
            }
        }
    }

    public final void fnCancelAsync() {
        for(final GetImageAsync imgAsyn : g_setImgAsync) {
            imgAsyn.cancel(false);
        }
    }

    public final void fnSetImage(final ImageView imgData, final String sURL) {
        final Bitmap btData = g_iLruSaveBitmap.fnGetBitmap(sURL);
        if(btData == null) {
            imgData.setImageResource(R.drawable.ic_cloud_download);
        } else {
            imgData.setImageBitmap(btData);
        }
    }

    public final void fnSetImage(final String sURL) {
        final ImageView imgData = (ImageView)g_lvShowData.findViewWithTag(sURL);
        fnSetImage(imgData, sURL);
    }

    public ImageAsync() {

    }

    public class GetImageAsync extends AsyncTask<String, Void, Bitmap> {
        private final String TAG = "GetImageAsync";
        private ImageView g_imgData = null;
        private ImageLruCache g_iLruSaveBitmap = null;
        private String g_sURL = "";

        public GetImageAsync(final ImageLruCache iLruSaveBitmap, final ImageView imgData, final String sURL) {
            g_iLruSaveBitmap = iLruSaveBitmap;
            g_imgData = imgData;
            g_sURL = sURL;
        }

        public GetImageAsync(final ImageView imgData, final String sURL) {
            g_imgData = imgData;
            g_sURL = sURL;
        }

        @Override
        protected Bitmap doInBackground(String... params) {
            final Bitmap btData = getBitmapFromURL(params[0]);
            if(g_iLruSaveBitmap != null) {
                g_iLruSaveBitmap.fnAddBitmap(params[0], btData);
            }
            return btData;
        }

        @Override
        protected void onPostExecute(Bitmap bitmap) {
            super.onPostExecute(bitmap);
            if (g_imgData.getTag().equals(g_sURL)) {
                g_imgData.setImageBitmap(bitmap);
            }
        }

        private final Bitmap getBitmapFromURL(final String imageUrl) {
            Log.e(TAG, "Loading.....");
            try {
                final URL url = new URL(imageUrl);
                final HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setDoInput(true);
                connection.connect();
                final InputStream input = connection.getInputStream();
                final Bitmap btData = BitmapFactory.decodeStream(input);
                return btData;
            } catch (IOException e) {
                Log.e(TAG, e.getMessage());
                return null;
            }
        }

    }
}