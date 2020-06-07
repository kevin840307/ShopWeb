package com.example.ghost.mndtproduct.SqlDB;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.icu.text.MessagePattern;

import static android.provider.BaseColumns._ID;

import com.example.ghost.mndtproduct.Handler.SQLHandler;

import java.util.ArrayList;

/**
 * Created by Ghost on 2017/5/14.
 */
public class MNDTaccount {
    public final static String TABLE_NAME = "MNDTaccount";
    public final static String ID = "ID";
    public final static String PASSWORD = "PASSWORD";
    public final static String SAVE_TYPE = "SAVE_TYPE";

    public String g_sId = "";
    public String g_sPassword = "";
    public Integer g_iType = -1;

    public final static String fnCreateSql() {
        final String sSql = "CREATE TABLE " + TABLE_NAME + "("
                + _ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                + ID + " TEXT, "
                + PASSWORD + " TEXT, "
                + SAVE_TYPE + " INTEGER) ";
        return sSql;
    }

    public final static String fnUpgradeSql() {
        final String sSql = "DROP TABLE IF EXISTS " + TABLE_NAME;
        return sSql;
    }

    public final static void fnInsert(final SQLHandler sqlHandler, final MNDTaccount accData) {
        final String sID = fnGet_ID(sqlHandler);
        if (sID == "-1") {
            final SQLiteDatabase sqlDB = sqlHandler.getWritableDatabase();
            final ContentValues cvalueData = new ContentValues();
            cvalueData.put(ID, accData.g_sId);
            cvalueData.put(PASSWORD, accData.g_sPassword);
            cvalueData.put(SAVE_TYPE, accData.g_iType);
            sqlDB.insert(TABLE_NAME, null, cvalueData);
            sqlDB.close(); // Closing database connection
        } else {
            fnUpdate(sqlHandler, accData, sID);
        }
    }

    public final static void fnUpdate(final SQLHandler sqlHandler, final MNDTaccount accData, final String sIndex) {
        final ContentValues cvalueData = new ContentValues();
        cvalueData.put(ID, accData.g_sId);
        cvalueData.put(PASSWORD, accData.g_sPassword);
        cvalueData.put(SAVE_TYPE, accData.g_iType);
        final SQLiteDatabase sqlDB = sqlHandler.getWritableDatabase();
        sqlDB.update(TABLE_NAME, cvalueData, _ID + "=" + sIndex, null);

    }

    public final static void fnDelete(final SQLHandler sqlHandler, final String sIndex) {
        final SQLiteDatabase sqlDB = sqlHandler.getWritableDatabase();
        final ContentValues cvalueData = new ContentValues();
        cvalueData.put("seq", "0");
        sqlDB.update("sqlite_sequence", cvalueData ,"name = '" + TABLE_NAME + "' ", null);
        sqlDB.delete(TABLE_NAME, _ID + "=" + sIndex, null);
    }

    public final static ArrayList<ArrayList<String>> fnSelect(final SQLHandler sqlHandler) {
        final SQLiteDatabase sqlDB = sqlHandler.getReadableDatabase();
        final String selectQuery = " SELECT  " + _ID +
                "," + ID +
                "," + PASSWORD +
                "," + SAVE_TYPE +
                " FROM " + TABLE_NAME;
        final ArrayList<ArrayList<String>> alDataList = new ArrayList<>();
        final Cursor cursorData = sqlDB.rawQuery(selectQuery, null);
        if (cursorData.moveToFirst()) {
            do {
                final ArrayList<String> alData = new ArrayList<>();
                alData.add(cursorData.getString(cursorData.getColumnIndex(_ID)));
                alData.add(cursorData.getString(cursorData.getColumnIndex(ID)));
                alData.add(cursorData.getString(cursorData.getColumnIndex(PASSWORD)));
                alData.add(cursorData.getString(cursorData.getColumnIndex(SAVE_TYPE)));
                alDataList.add(alData);
            } while (cursorData.moveToNext());
        }
        cursorData.close();
        sqlDB.close();
        return alDataList;
    }

    public final static String fnGet_ID(final SQLHandler sqlHandler) {
        final SQLiteDatabase sqlDB = sqlHandler.getReadableDatabase();
        final String sSql = " SELECT  " + _ID +
                            " FROM " + TABLE_NAME +
                            " LIMIT 1 ";
        String s_Id = "-1";
        final Cursor cursorData = sqlDB.rawQuery(sSql, null);
        if (cursorData.moveToFirst()) {
            s_Id = cursorData.getString(cursorData.getColumnIndex(_ID));
        }
        cursorData.close();
        sqlDB.close();
        return s_Id;
    }
}
