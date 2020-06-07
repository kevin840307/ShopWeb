package com.example.ghost.mndtproduct.Inventory;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;

import com.example.ghost.mndtproduct.R;

/**
 * Created by Ghost on 2017/5/22.
 */
public class InventoryDActivity extends Activity {
    private InventoryProductData g_iproData = null;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.inventory_d_activity);
        fnInit();
    }

    private final void fnInit() {
        fnInitData();
        fnInitControl();
    }

    private final void fnInitData() {
        g_iproData = (InventoryProductData)getIntent().getSerializableExtra("IData");
    }

    private final void fnInitControl() {
        fnInitImageButton();
    }

    private final void fnInitImageButton() {
        final ImageButton ibtnBack = (ImageButton)findViewById(R.id.ibtn_back);
        ibtnBack.setVisibility(View.VISIBLE);
        ibtnBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
    }

    @Override
    protected void onPause() {
        super.onPause();
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
        overridePendingTransition(android.R.anim.slide_in_left, android.R.anim.slide_out_right);
    }
}
