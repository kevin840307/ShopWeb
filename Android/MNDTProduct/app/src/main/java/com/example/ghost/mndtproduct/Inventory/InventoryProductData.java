package com.example.ghost.mndtproduct.Inventory;

import com.example.ghost.mndtproduct.Data;

import java.io.Serializable;

/**
 * Created by Ghost on 2017/5/16.
 */
public class InventoryProductData implements Serializable {
    private String g_sKind = "";
    private String g_sCode = "";
    private String g_sCodeName = "";
    private String g_sAmount = "";
    private String g_sDeadline = "";
    private String g_sCost = "";
    private String g_sPrincing = "";
    private String g_sURL = "";

    public InventoryProductData(final String sKind, final String sCode, final String sCodeName, final String sAmount, final String sDeadline, final String sImageFileName) {
        g_sKind = sKind;
        g_sCode = sCode;
        g_sCodeName = sCodeName;
        g_sAmount = sAmount;
        g_sDeadline = sDeadline;
        g_sURL = Data.SERRVICE_URL + "ProductImage/" + g_sKind + g_sCode + "/" + sImageFileName;
    }

    public InventoryProductData(final String[] sData, final String sImageFileName) {
        g_sKind = sData[0];
        g_sCode = sData[1];
        g_sCodeName = sData[2];
        g_sAmount = sData[3];
        g_sDeadline = sData[4];
        g_sCost = sData[5];
        g_sPrincing = sData[6];
        g_sURL = Data.SERRVICE_URL + "ProductImage/" + g_sKind + g_sCode + "/" + sImageFileName;
    }

    public final String fnGetKind() {
        return g_sKind;
    }

    public final String fnGetCode() {
        return g_sCode;
    }

    public final String fnGetCodeName() {
        return g_sCodeName;
    }

    public final String fnGetAmount() {
        return g_sAmount;
    }

    public final String fnGetDeadline() {
        return g_sDeadline;
    }

    public final String fnGetCost() {
        return g_sCost;
    }

    public final String fnGetPrincing() {
        return g_sPrincing;
    }

    public final String fnGetURL() {
        return g_sURL;
    }
}
