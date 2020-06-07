package com.example.ghost.mndtproduct;

import android.os.Environment;

import java.io.File;

/**
 * Created by Ghost on 2017/5/11.
 */
public class Data {
    public static int WIDTH_PIXELS = 0;
    public static int HEIGHT_PIXELS = 0;
    public static final String NAMESPACE = "http://tempuri.org/";
    public final static String SERRVICE_URL = "http://10.22.21.203/";
    public final static String SERRVICE_API = "http://10.22.21.203/DataService.asmx";
    public static String ID = "";
    public static String PASSWORD = "";
    public static String ID_NAME = "";

    public final static void fnMakeDir(final String sDirPath) {
        if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
            final File fileSDPath = android.os.Environment.getExternalStorageDirectory();
            final String sPath = fileSDPath.getPath() + File.separator + sDirPath;
            final File fileDir = new File(sPath);
            if(!fileDir.exists()){
                fileDir.mkdir();
            }
        }
    }
}
