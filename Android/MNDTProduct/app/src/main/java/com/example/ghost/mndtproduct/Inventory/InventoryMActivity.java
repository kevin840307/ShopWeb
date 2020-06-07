package com.example.ghost.mndtproduct.Inventory;

import android.app.SearchManager;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.NonNull;
import android.support.design.widget.NavigationView;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.SearchView;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.example.ghost.mndtproduct.Data;
import com.example.ghost.mndtproduct.Handler.HandlerMessage;
import com.example.ghost.mndtproduct.Handler.SQLHandler;
import com.example.ghost.mndtproduct.Handler.WebHandler;
import com.example.ghost.mndtproduct.LoginActivity;
import com.example.ghost.mndtproduct.QRCodeActivity;
import com.example.ghost.mndtproduct.R;
import com.example.ghost.mndtproduct.SoapCall.SoapFunctions;
import com.example.ghost.mndtproduct.SqlDB.MNDTaccount;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;

public class InventoryMActivity extends AppCompatActivity  implements NavigationView.OnNavigationItemSelectedListener {

    private String[][] g_sData = null;
    private ArrayList<InventoryProductData> g_alsData = null;
    private InventoryAdapter g_allData = null;
    private ListView g_lvData = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        fnInit();
    }

    private final void fnInit() {
        fnInitData();
        fnInitControl();
    }

    private final void fnInitData() {
        fnRunGetListData();
    }

    private final void fnInitControl() {
        fnInitButton();
        fnInitNavigationView();
    }


    private final void fnInitButton() {

    }

    private final void fnInitListView(final Object soapObject) {
        g_sData = SoapFunctions.fnGetVListData(soapObject, 7);
        g_lvData = (ListView)findViewById(R.id.lv_main_data);
        g_allData = new InventoryAdapter(this, g_lvData, g_sData);
        g_lvData.setAdapter(g_allData);
        fnStopLoding();
    }

//    private final void fnLoadingListView(final int iNum) {
//        fnLoadingListView(g_iAmount, iNum);
//    }
//
//    private final void fnLoadingListView(final int iStart, final int iEnd) {
//        fnStartLoding();
//        for(int i = iStart; i < iEnd; i++) {
//            for (int iPos = 0; iPos < g_sData[0].length; iPos++) {
//                final ProductData proData = new ProductData(g_sData[0][iPos], g_sData[1][iPos], g_sData[2][iPos], g_sData[3][iPos], g_sData[4][iPos], "one.png");
//                g_alsData.add(proData);
//                // g_allData.notifyDataSetChanged();
//            }
//        }
//        fnStopLoding();
//    }
//
    private final void fnStartLoding() {
        final ProgressBar proBar = (ProgressBar)findViewById(R.id.pro_load);
        proBar.setVisibility(View.VISIBLE);
    }

    private final void fnStopLoding() {
       final ProgressBar proBar = (ProgressBar)findViewById(R.id.pro_load);
       proBar.setVisibility(View.GONE);
    }

    private final void fnRunGetListData() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    final SoapObject soapRequest = new SoapObject(Data.NAMESPACE, WebHandler.GET_ALL_PRODUCT_DATA);
                    final Object soapObject = (Object) SoapFunctions.fnGetData(Data.SERRVICE_API, Data.NAMESPACE + WebHandler.GET_ALL_PRODUCT_DATA, soapRequest);
                    new HandlerMessage().fnSendMessage(g_hdMessage, HandlerMessage.UPDATE_ALL_PRODUCT_DATA, soapObject);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }).start();
    }

    final Handler g_hdMessage = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case HandlerMessage.UPDATE_ALL_PRODUCT_DATA:
                    fnInitListView(msg.obj);
                    break;
            }
        }
    };

    private final void fnInitNavigationView() {
        final Toolbar toolBar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolBar);
        final DrawerLayout drawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
        final ActionBarDrawerToggle actionDrawer = new ActionBarDrawerToggle(this, drawerLayout, toolBar, R.string.open, R.string.close);
        drawerLayout.setDrawerListener(actionDrawer);
        actionDrawer.syncState();
        final NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);

        final  View header = navigationView.inflateHeaderView(R.layout.nav_header_main);
        final TextView textId = (TextView)header.findViewById(R.id.text_id);
        final TextView textIdName = (TextView)header.findViewById(R.id.text_id_name);
        textId.setText(Data.ID);
        textIdName.setText(Data.ID_NAME);
    }

    @Override
    protected void onPause() {
        super.onPause();
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
        overridePendingTransition(android.R.anim.slide_in_left, android.R.anim.slide_out_right);
    }

    @Override
    public boolean onNavigationItemSelected(@NonNull MenuItem item) {
        final int id = item.getItemId();
        if (id == R.id.nav_sign_out) {
            fnOpenLogin();
        } else if (id == R.id.nav_search_qrcode) {
            final Intent itStart = new Intent(InventoryMActivity.this, QRCodeActivity.class);
            startActivity(itStart);
        }
        return false;
    }

    private final void fnOpenLogin() {
        final SQLHandler sqlHandler = new SQLHandler(this);
        MNDTaccount.fnDelete(sqlHandler, "1");
        final Intent itStart = new Intent(InventoryMActivity.this, LoginActivity.class);
        itStart.putExtra("sType", "0");
        startActivity(itStart);
        finish();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        final MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.menu_main, menu);
        final MenuItem menuSearchItem = menu.findItem(R.id.search);
        final SearchManager searchManager = (SearchManager) getSystemService(Context.SEARCH_SERVICE);
        final SearchView searchView = (SearchView) menuSearchItem.getActionView();
        searchView.setSearchableInfo(searchManager.getSearchableInfo(getComponentName()));
        searchView.setIconifiedByDefault(true);
        searchView.setQueryHint("請輸入查詢條件");
        searchView.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
            @Override
            public boolean onQueryTextSubmit(String query) {
                return false;
            }

            @Override
            public boolean onQueryTextChange(String newText) {
                fnStartLoding();
                g_allData.fnQueryText(newText);
                fnStopLoding();
                return false;
            }
        });
        return true;
    }
}
