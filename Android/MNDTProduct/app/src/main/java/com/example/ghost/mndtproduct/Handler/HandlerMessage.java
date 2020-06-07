package com.example.ghost.mndtproduct.Handler;

import android.os.Handler;
import android.os.Message;

public class HandlerMessage {

    public final static int LOGIN_CHECK = 0x001;
    public final static int QRCODE_COMPUTE = 0x002;
    public final static int GET_QRCODE_DATA = 0x003;
    public final static int UPDATE_ALL_PRODUCT_DATA = 0x004;
    public final void fnSendMessage(final Handler hdMessage, final int iWhat, final int iArg1, final int iArg2, final Object objData) {
        final Message msgData = new Message();
        msgData.what = iWhat;
        msgData.arg1 = iArg1;
        msgData.arg2 = iArg2;
        msgData.obj = objData;
        hdMessage.sendMessage(msgData);
    }


    public final void fnSendMessage(final Handler hdMessage, final int iWhat, final int iArg1, final Object objData) {
        final Message msgData = new Message();
        msgData.what = iWhat;
        msgData.arg1 = iArg1;
        msgData.obj = objData;
        hdMessage.sendMessage(msgData);
    }

    public final void fnSendMessage(final Handler hdMessage, final int iWhat, final int iArg1, final int iArg2) {
        final Message msgData = new Message();
        msgData.what = iWhat;
        msgData.arg1 = iArg1;
        msgData.arg2 = iArg2;
        hdMessage.sendMessage(msgData);
    }

    public final void fnSendMessage(final Handler hdMessage, final int iWhat, final Object objData) {
        final Message msgData = new Message();
        msgData.what = iWhat;
        msgData.obj = objData;
        hdMessage.sendMessage(msgData);
    }

    public final void fnSendMessage(final Handler hdMessage, final int iWhat, final int iArg1) {
        final Message msgData = new Message();
        msgData.what = iWhat;
        msgData.arg1 = iArg1;
        hdMessage.sendMessage(msgData);
    }

    public final void fnSendMessage(final Handler hdMessage, final int iWhat) {
        final Message msgData = new Message();
        msgData.what = iWhat;
        hdMessage.sendMessage(msgData);
    }
}
