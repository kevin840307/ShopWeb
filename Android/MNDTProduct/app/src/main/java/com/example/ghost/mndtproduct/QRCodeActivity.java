package com.example.ghost.mndtproduct;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.app.ActivityCompat;
import android.util.Log;
import android.view.View;
import android.widget.ImageButton;
import android.widget.Toast;

import com.example.ghost.mndtproduct.Handler.HandlerMessage;
import com.example.ghost.mndtproduct.Inventory.ProductDialog;
import com.google.zxing.Result;

import me.dm7.barcodescanner.zxing.ZXingScannerView;

/**
 * Created by user on 2017/2/17.
 */
public class QRCodeActivity extends Activity implements ZXingScannerView.ResultHandler {
    private String g_sType = "";
    private int g_iSize = 0;
    private ZXingScannerView g_mScannerView;
    private final String TAG = "QRCodeActivity";

    @Override
    public void onCreate(Bundle state) {
        super.onCreate(state);
        setContentView(R.layout.qrcode_activity);
        fnInit();
    }

    private final void fnInit() {
        fnInitData();
        if(fnCheckAPI()) {
            fnInitQRCodeView();
            fnInitBar();
        } else {
            Toast.makeText(this, "請開啟權限", Toast.LENGTH_SHORT).show();
            finish();
        }
    }

    private final void fnInitData() {
        g_sType = getIntent().getStringExtra("sType");
        fnSetSize();
    }

    private final void fnSetSize() {
        switch (g_sType) {
            case "Inventory":
                g_iSize = 2;
                break;
        }
    }

    private final boolean fnCheckAPI() {
        if (Build.VERSION.SDK_INT >= 23) {
            final int iCamera = ActivityCompat.checkSelfPermission(this, Manifest.permission.CAMERA);
            if (iCamera != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(QRCodeActivity.this, new String[] {Manifest.permission.CAMERA}, 1);
                return false;
            }
            return true;
        } else {
            return true;
        }
    }

    private final void fnInitBar() {
        final ImageButton imgbBack = (ImageButton) findViewById(R.id.ibtn_back);
        imgbBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        imgbBack.setVisibility(View.VISIBLE);
    }

    private final void fnInitQRCodeView() {
        g_mScannerView = (ZXingScannerView)findViewById(R.id.qrcode_view);
    }

    @Override
    public void handleResult(Result result) {
        Log.i(TAG, result.getText().toString());
        new HandlerMessage().fnSendMessage(g_hdMessage, HandlerMessage.QRCODE_COMPUTE, result.getText().toString() );
    }

    @Override
    public void onResume() {
        super.onResume();
        g_mScannerView.setResultHandler(this); // Register ourselves as a handler for scan results.
        g_mScannerView.startCamera();          // Start camera on resume
    }

    @Override
    public void onPause() {
        super.onPause();
        g_mScannerView.stopCamera();           // Stop camera on pause
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
        overridePendingTransition(android.R.anim.slide_in_left, android.R.anim.slide_out_right);
    }

    private final void fnComputeData(final String sData) {
        int iOffset = 0;
        final String[] sSpliteData = new String[g_iSize];
        int iPos = 0;
        try {
            while (iPos < sData.length()) {
                String sSave = "";
                while (iPos < sData.length() && sData.charAt(iPos) != ' ') {
                    sSave += sData.charAt(iPos);
                    iPos++;
                }
                sSpliteData[iOffset] = sSave;
                iPos++;
                iOffset++;
            }
            if(fnCheckQRCode(sSpliteData)) {
                fnOpenData(sSpliteData);
            } else {
                Toast.makeText(this, "格式錯誤", Toast.LENGTH_SHORT).show();
                fnRestart();
            }
        } catch (IndexOutOfBoundsException ex) {
            Toast.makeText(this, "格式錯誤", Toast.LENGTH_SHORT).show();
            fnRestart();
            Log.e(TAG, "格式錯誤");
        }
    }

    private final boolean fnCheckQRCode(final String[] sSpliteData) {
        if(sSpliteData.length != g_iSize) return false;
        for(int iPos = 0; iPos < sSpliteData.length; iPos++) {
            if(sSpliteData[iPos].length() < 1) {
                return false;
            }
        }
        return true;
    }

    private final void fnOpenData(final String[] sData) {
        switch (g_sType) {
            case "Inventory":
                fnOpenProductDialog(sData);
                break;
        }
    }

    private final void fnOpenProductDialog(final String[] sData) {
        new ProductDialog(this).fnShow(sData[0], sData[1]);
    }

    public final void fnRestart() {
        g_mScannerView.stopCamera();
        g_mScannerView.setResultHandler(this);
        g_mScannerView.startCamera();
    }

    private final void fnFinish() {
        g_mScannerView.stopCamera();
        finish();
    }

    final Handler g_hdMessage = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case HandlerMessage.QRCODE_COMPUTE:
                    fnComputeData((String)msg.obj);
                    break;
            }
        }
    };

}
