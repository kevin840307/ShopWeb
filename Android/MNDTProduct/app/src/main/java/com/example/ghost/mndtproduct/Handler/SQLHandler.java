package com.example.ghost.mndtproduct.Handler;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import com.example.ghost.mndtproduct.SqlDB.MNDTaccount;

/**
 * Created by Ghost on 2017/5/14.
 */
public class SQLHandler extends SQLiteOpenHelper {

    private static final int DATABASE_VERSION = 1;
    private static final String DATABASE_NAME = "mndt.db";

    public SQLHandler(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        final String sAccountSql = MNDTaccount.fnCreateSql();
        db.execSQL(sAccountSql);
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        final String sAccountSql = MNDTaccount.fnUpgradeSql();
        db.execSQL(sAccountSql);
        onCreate(db);
    }
}
