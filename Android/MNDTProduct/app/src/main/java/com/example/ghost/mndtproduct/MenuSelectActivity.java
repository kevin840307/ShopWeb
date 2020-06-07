package com.example.ghost.mndtproduct;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.example.ghost.mndtproduct.Inventory.InventoryMActivity;

/**
 * Created by Ghost on 2017/5/22.
 */
public class MenuSelectActivity extends Activity {
    private String g_sType = "";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.menu_select_activity);
        fnInit();
    }

    private final void fnInit() {
        fnInitData();
        fnInitControl();
    }

    private final void fnInitData() {
        final Intent itData = getIntent();
        g_sType = itData.getStringExtra("sType");
    }

    private final void fnInitControl() {
        fnInitTextView();
        fnInitButton();
    }

    private final void fnInitTextView() {
        final TextView textView = (TextView)findViewById(R.id.text_select_type_name);
        fnSetViewText(textView);
    }

    private final void fnInitButton() {
        final Button btnView = (Button)findViewById(R.id.btn_select_type_view);
        final Button btnQRcode = (Button)findViewById(R.id.btn_select_qrcode);
        fnSetViewButton(btnView);
        btnView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                fnOpenView();
            }
        });
        btnQRcode.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final Intent itStart = new Intent(MenuSelectActivity.this, QRCodeActivity.class);
                itStart.putExtra("sType", g_sType);
                startActivity(itStart);
            }
        });
    }

    private final void fnSetViewText(final TextView textData) {
        switch (g_sType) {
            case "Inventory" :
                textData.setText("盤點");
                break;
        }
    }

    private final void fnSetViewButton(final Button btnData) {
        switch (g_sType) {
            case "Inventory" :
                btnData.setText("庫存顯示");
                break;
        }
    }

    private final void fnOpenView() {
        Intent itStart = null;
        switch (g_sType) {
            case "Inventory" :
                itStart = new Intent(MenuSelectActivity.this, InventoryMActivity.class);
                break;
        }
        startActivity(itStart);
    }

    @Override
    protected void onPause() {
        super.onPause();
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
        overridePendingTransition(android.R.anim.slide_in_left, android.R.anim.slide_out_right);
    }
}
