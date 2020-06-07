package com.example.ghost.mndtproduct;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.DisplayMetrics;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.Toast;

import com.example.ghost.mndtproduct.Handler.HandlerMessage;
import com.example.ghost.mndtproduct.Handler.SQLHandler;
import com.example.ghost.mndtproduct.Handler.WebHandler;
import com.example.ghost.mndtproduct.SoapCall.SoapFunctions;
import com.example.ghost.mndtproduct.SqlDB.MNDTaccount;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;

/**
 * Created by Ghost on 2017/5/10.
 */
public class LoginWaitActivity extends Activity {
    private static boolean g_bFinish = false;
    private static boolean g_bInit = true;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.login_wait_layout);
        fnInit();
    }

    private final void fnInit() {
        g_bFinish = false;
        g_bInit = true;
        fnInitControl();
        Data.fnMakeDir("ProductImage");
    }

    private final void fnInitData() {
        final DisplayMetrics displayMetrics = this.getResources().getDisplayMetrics();
        Data.WIDTH_PIXELS = displayMetrics.widthPixels;
        Data.HEIGHT_PIXELS = displayMetrics.heightPixels;
        fnLogin();
    }

    private final void fnInitControl() {
        fnInitImageView();
        final Timer timerWait = new Timer();
        timerWait.schedule(TimerTasks, 2000, 500);
    }

    private final void fnInitImageView() {
        final ImageView imgLogo = (ImageView) findViewById(R.id.img_wait_logo);
        final Animation anAction = AnimationUtils.loadAnimation(LoginWaitActivity.this, R.anim.wait_anim);
        imgLogo.setAnimation(anAction);
        anAction.start();
    }

    private final void fnLogin() {
        final SQLHandler sqlHandler = new SQLHandler(this);
        final ArrayList<ArrayList<String>> alAllData = MNDTaccount.fnSelect(sqlHandler);
        if(alAllData.size() > 0) {
            final ArrayList<String> alData =  alAllData.get(0);
            if(!alData.get(3).toString().equals("0")) {
                Data.ID = alData.get(1).toString();
                Data.PASSWORD = alData.get(2).toString();
            }

            if(alData.get(3).toString().equals("2")) {
                fnRunLogin();
            } else {
                fnOpenLogin(alData.get(3).toString());
            }
        } else {
            fnOpenLogin("0");
        }
    }

    private final void fnRunLogin() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    final SoapObject soapRequest = fnGetSoapMapData();
                    final Object soapObject = (Object) SoapFunctions.fnGetData(Data.SERRVICE_API, Data.NAMESPACE + WebHandler.LOGIN_FUNTION, soapRequest);
                    new HandlerMessage().fnSendMessage(g_hdMessage, HandlerMessage.LOGIN_CHECK, soapObject);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }).start();
    }

    private final SoapObject fnGetSoapMapData() {
        final SoapObject soapRequest = new SoapObject(Data.NAMESPACE, WebHandler.LOGIN_FUNTION);
        soapRequest.addProperty("sId", Data.ID);
        soapRequest.addProperty("sPassword", Data.PASSWORD);
        return soapRequest;
    }

    private final void fnCheckLogin(final Object oapObject) {
        final String sName = String.valueOf(oapObject.toString());
        if (sName.replace(" ", "").length() > 0) {
            Data.ID_NAME = sName;
            Toast.makeText(this, "登入成功", Toast.LENGTH_SHORT).show();
            fnOpenMain();
        } else {
            Toast.makeText(this, "登入失敗", Toast.LENGTH_SHORT).show();
            fnOpenLogin("2");
        }
    }

    private final void fnOpenMain() {
        final Intent itStart = new Intent(LoginWaitActivity.this, MainMenuActivity.class);
        startActivity(itStart);
        finish();
    }

    private final void fnOpenLogin(final String sType) {
        final Intent itStart = new Intent(LoginWaitActivity.this, LoginActivity.class);
        itStart.putExtra("sType", sType);
        startActivity(itStart);
        finish();
    }

    final TimerTask TimerTasks = new TimerTask() {
        public void run() {
            if(g_bInit) {
                fnInitData();
                g_bInit = false;
            }
            if(!g_bFinish) {
                this.cancel();
            }
        }
    };

    final Handler g_hdMessage = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case HandlerMessage.LOGIN_CHECK:
                    fnCheckLogin(msg.obj);
                    break;
            }
        }
    };

    @Override
    protected void onPause() {
        super.onPause();
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
        overridePendingTransition(android.R.anim.slide_out_right, android.R.anim.slide_in_left);
    }
}
