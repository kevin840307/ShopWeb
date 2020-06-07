package com.example.ghost.mndtproduct;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.design.widget.NavigationView;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.widget.Toolbar;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.example.ghost.mndtproduct.Handler.SQLHandler;
import com.example.ghost.mndtproduct.SqlDB.MNDTaccount;


/**
 * Created by Ghost on 2017/5/21.
 */
public class MainMenuActivity extends Activity implements NavigationView.OnNavigationItemSelectedListener {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main_menu_activity);
        fnInit();
    }

    private final void fnInit() {
        fnInitControl();
    }

    private final void fnInitControl() {
        fnInitNavigationView();
        fnInitButton();
    }

    private final void fnInitButton() {
        final Button btnInventory = (Button)findViewById(R.id.btn_menu_inventory);
        btnInventory.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                fnOpenMenuSelect("Inventory");
            }
        });
    }

    private final void fnInitNavigationView() {
        final Toolbar toolBar = (Toolbar) findViewById(R.id.toolbar);
        final DrawerLayout drawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
        final ActionBarDrawerToggle actionDrawer = new ActionBarDrawerToggle(this, drawerLayout, toolBar, R.string.open, R.string.close);
        drawerLayout.setDrawerListener(actionDrawer);
        actionDrawer.syncState();
        final NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);
        navigationView.getMenu().findItem(R.id.nav_search_qrcode).setVisible(false);
        final View header = navigationView.inflateHeaderView(R.layout.nav_header_main);
        final TextView textId = (TextView)header.findViewById(R.id.text_id);
        final TextView textIdName = (TextView)header.findViewById(R.id.text_id_name);
        textId.setText(Data.ID);
        textIdName.setText(Data.ID_NAME);
    }

    @Override
    public boolean onNavigationItemSelected(@NonNull MenuItem item) {
        final int id = item.getItemId();
        if (id == R.id.nav_sign_out) {
            fnOpenLogin();
        } else if (id == R.id.nav_search_qrcode) {
            final Intent itStart = new Intent(MainMenuActivity.this, QRCodeActivity.class);
            startActivity(itStart);
        }
        return false;
    }

    private final void fnOpenLogin() {
        final SQLHandler sqlHandler = new SQLHandler(this);
        MNDTaccount.fnDelete(sqlHandler, "1");
        final Intent itStart = new Intent(MainMenuActivity.this, LoginActivity.class);
        itStart.putExtra("sType", "0");
        startActivity(itStart);
        finish();
    }

    private final void fnOpenMenuSelect(final String sType) {
        final Intent itStart = new Intent(MainMenuActivity.this, MenuSelectActivity.class);
        itStart.putExtra("sType", sType);
        startActivity(itStart);
    }

    @Override
    protected void onPause() {
        super.onPause();
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
        overridePendingTransition(android.R.anim.slide_in_left, android.R.anim.slide_out_right);
    }
}
