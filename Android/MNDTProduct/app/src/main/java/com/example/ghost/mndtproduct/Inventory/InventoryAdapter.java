package com.example.ghost.mndtproduct.Inventory;

import android.annotation.TargetApi;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.example.ghost.mndtproduct.ImageAsync;
import com.example.ghost.mndtproduct.ImageLruCache;
import com.example.ghost.mndtproduct.R;

import java.util.ArrayList;

/**
 * Created by Ghost on 2017/5/16.
 */
public class InventoryAdapter extends BaseAdapter {
    private final String TAG = "ShowAllAdapter";
    private Context g_conText = null;
    private LayoutInflater g_InflaterLayout = null;
    private ArrayList<InventoryProductData> g_alsAllData = null;
    private ArrayList<InventoryProductData> g_alsQueryData = null;
    private ImageLruCache g_ilruSaveBitmap = null;
    private ImageAsync g_imgAsyncData = null;
    private ListView g_lvView = null;
    private boolean g_bScrollFoot = true;
    private int g_iStart = 0;
    private int g_iEnd = 0;
    private boolean g_bIntit = true;

    public InventoryAdapter(final Context conText, final ListView lvShowData, final String[][] sData) {
        g_conText = conText;
        g_InflaterLayout = LayoutInflater.from(conText);
        g_alsAllData = new ArrayList<>();
        g_bIntit = true;
        g_lvView = lvShowData;
        fnLoadListView(sData);
        fnInitView();
        g_ilruSaveBitmap = new ImageLruCache();
        g_imgAsyncData = new ImageAsync(lvShowData, g_ilruSaveBitmap, g_alsQueryData);
    }

    private final void fnInitView() {
        g_lvView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                final Intent itStart = new Intent(g_conText, InventoryDActivity.class);
                itStart.putExtra("IData", g_alsQueryData.get(position));
                g_conText.startActivity(itStart);
            }
        });

        g_lvView.setOnScrollListener(new AbsListView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(AbsListView view, int scrollState) {
                if (scrollState == SCROLL_STATE_IDLE) {
                    g_imgAsyncData.fnLoadImage(g_iStart, g_iEnd);
                } else {
                    g_imgAsyncData.fnCancelAsync();
                }

                if (scrollState == AbsListView.OnScrollListener.SCROLL_STATE_IDLE && g_bScrollFoot) {
                }
            }

            @Override
            public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
                g_iStart = firstVisibleItem;
                g_iEnd = firstVisibleItem + visibleItemCount;

                if (g_bIntit && visibleItemCount > 0) {
                    g_imgAsyncData.fnLoadImage(g_iStart, g_iEnd);
                    g_bIntit = false;
                }

                if (firstVisibleItem + visibleItemCount == totalItemCount) {
                    g_bScrollFoot = true;
                } else {
                    g_bScrollFoot = false;
                }
            }
        });
    }

    private final void fnLoadListView(final String[][] sData) {
        fnLoadListView(sData, 0, sData.length);
    }

    private final void fnLoadListView(final String[][] sData, final int iStart, final int iEnd) {
        for (int iPos = iStart; iPos < iEnd; iPos++) {
            final InventoryProductData proData = new InventoryProductData(sData[iPos], "one.png");
            g_alsAllData.add(proData);
            Log.i(TAG, String.valueOf(iEnd));
        }
        g_alsQueryData = new ArrayList<>(g_alsAllData);
    }

    public final void fnQueryText(final String sData) {
        g_alsQueryData = new ArrayList<>(g_alsAllData);
        if (sData.replace(" ", "").length() != 0) {
            g_imgAsyncData = new ImageAsync(g_lvView, g_ilruSaveBitmap, g_alsQueryData);
            for (int iPos = 0; iPos < g_alsQueryData.size(); iPos++) {
                if (g_alsQueryData.get(iPos).fnGetCodeName().indexOf(sData) < 0) {
                    g_alsQueryData.remove(iPos);
                    iPos--;
                }
            }
        }
        g_imgAsyncData = new ImageAsync(g_lvView, g_ilruSaveBitmap, g_alsQueryData);
    }

    @Override
    public int getCount() {
        return g_alsQueryData.size();
    }

    @Override
    public Object getItem(int position) {
        return g_alsQueryData.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        convertView = g_InflaterLayout.inflate(R.layout.inventory_list_item1, null);

        final InventoryProductData prdData = g_alsQueryData.get(position);
        final ImageView imgIcon = (ImageView) convertView.findViewById(R.id.img_list_icon);
        final TextView textName = (TextView) convertView.findViewById(R.id.text_list_name);
        final TextView textAmount = (TextView) convertView.findViewById(R.id.text_list_amount);
        final TextView textMonth = (TextView) convertView.findViewById(R.id.text_list_month);
        final TextView textCost = (TextView) convertView.findViewById(R.id.text_list_cost);
        final TextView textPrincing = (TextView) convertView.findViewById(R.id.text_list_pricing);
        textName.setText(prdData.fnGetCodeName());
        textAmount.setText("數量：" + prdData.fnGetAmount());
        textMonth.setText("保存：" + prdData.fnGetDeadline());
        textCost.setText("成本：" + prdData.fnGetCost());
        textPrincing.setText("單價：" + prdData.fnGetPrincing());
//            final String sDirName = "ProductImage/" + prdData.fnGetKind().toString() + prdData.fnGetCode().toString();
//            final String sDataName = "one.png";
//            final String sURL = Data.SERRVICE_URL + sDirName + "/" + sDataName;
//            final URLImageData urlImageData = new URLImageData(sURL, sDirName, sDataName);
//            final String sURL = Data.SERRVICE_URL + "ProductImage/" + prdData.fnGetKind() + prdData.fnGetCode() + "/one.png";
        //        new ImageAsync(g_ilruSaveBitmap, imgIcon, prdData.fnGetURL());
        imgIcon.setTag(prdData.fnGetURL());
        g_imgAsyncData.fnSetImage(imgIcon, prdData.fnGetURL());
        return convertView;
    }

}
