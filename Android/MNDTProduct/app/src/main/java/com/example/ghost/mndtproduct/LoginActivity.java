package com.example.ghost.mndtproduct;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.Toast;

import com.example.ghost.mndtproduct.Handler.HandlerMessage;
import com.example.ghost.mndtproduct.Handler.SQLHandler;
import com.example.ghost.mndtproduct.Handler.WebHandler;
import com.example.ghost.mndtproduct.SoapCall.SoapFunctions;
import com.example.ghost.mndtproduct.SqlDB.MNDTaccount;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;

/**
 * Created by Ghost on 2017/5/10.
 */
public class LoginActivity extends Activity {
    private EditText g_editId = null;
    private EditText g_editPassword = null;
    private CheckBox g_chSave = null;
    private CheckBox g_chAuto = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.login_activity);
        fnInit();
    }

    private final void fnInit() {
        fnInitControl();
        fnInitData();
    }

    private final void fnInitData() {
        final Intent itData = getIntent();
        final String sType = itData.getStringExtra("sType");
        if(sType != null) {
            if(!sType.equals("0")) {
                g_editId.setText(Data.ID);
                g_editPassword.setText(Data.PASSWORD);
                g_chSave.setChecked(true);
            }
            if(sType.equals("2")) {
                g_chAuto.setChecked(true);
            }
        }
    }

    private final void fnInitControl() {
        fnInitEdit();
        fnInitButton();
        fnInitCheckBox();
    }

    private final void fnInitButton() {
        final Button btnLogin = (Button) findViewById(R.id.btn_login);
        btnLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                fnRunLogin();
            }
        });
    }

    private final void fnInitCheckBox() {
        g_chSave = (CheckBox)findViewById(R.id.cb_save);
        g_chAuto = (CheckBox)findViewById(R.id.cb_auto);

        g_chAuto.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                g_chSave.setChecked(isChecked);
            }
        });
    }

    private final void fnInitEdit() {
        g_editId = (EditText) findViewById(R.id.edit_account_id);
        g_editPassword = (EditText) findViewById(R.id.edit_password);
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
        soapRequest.addProperty("sId", g_editId.getText().toString());
        soapRequest.addProperty("sPassword", g_editPassword.getText().toString());
        return soapRequest;
    }

    private final void fnCheckLogin(final Object oapObject) {
        final String sName = String.valueOf(oapObject.toString());
        if (sName.replace(" ", "").length() > 0) {
            Data.ID = g_editId.getText().toString();
            Data.PASSWORD = g_editPassword.getText().toString();
            Data.ID_NAME = sName;
            fnOpenMain();
            Toast.makeText(this, "登入成功", Toast.LENGTH_SHORT).show();
        } else {
            Toast.makeText(this, "登入失敗", Toast.LENGTH_SHORT).show();
        }
    }

    private final void fnOpenMain() {
        fnSetSqlData();
        final Intent itStart = new Intent(LoginActivity.this, MainMenuActivity.class);
        startActivity(itStart);
        finish();
    }

    private final void fnSetSqlData() {
        final SQLHandler sqlHandler = new SQLHandler(this);
        new Thread(new Runnable() {
            @Override
            public void run() {
                final MNDTaccount accData = new MNDTaccount();
                accData.g_sId = g_editId.getText().toString();
                accData.g_sPassword = g_editPassword.getText().toString();
                accData.g_iType = g_chAuto.isChecked() ? 2 : g_chSave.isChecked() ? 1 : 0;
                MNDTaccount.fnInsert(sqlHandler, accData);
            }
        }).start();
    }

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
        overridePendingTransition(android.R.anim.slide_in_left, android.R.anim.slide_out_right);
    }
}
