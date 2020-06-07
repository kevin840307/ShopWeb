package com.example.ghost.mndtproduct.Inventory;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.example.ghost.mndtproduct.Data;
import com.example.ghost.mndtproduct.Handler.HandlerMessage;
import com.example.ghost.mndtproduct.Handler.WebHandler;
import com.example.ghost.mndtproduct.ImageAsync;
import com.example.ghost.mndtproduct.QRCodeActivity;
import com.example.ghost.mndtproduct.R;
import com.example.ghost.mndtproduct.SoapCall.SoapFunctions;

import org.ksoap2.serialization.SoapObject;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.concurrent.ExecutionException;

/**
 * Created by Ghost on 2017/5/11.
 */
public class ProductDialog {
    private final String TAG = "ProductDialog";
    private Dialog g_diaProduct = null;
    private Activity g_objContext = null;
    private TextView g_textKindName = null;
    private TextView g_textCodeName = null;
    private TextView g_textStock = null;
    private ImageView g_imgShow = null;
    private EditText g_editInventory = null;
    private String g_sKind = "";
    private String g_sCode = "";

    public ProductDialog(final Activity objContext) {
        g_objContext = objContext;
        fnInit();
    }

    private final void fnInit() {
        fnInitUIControl();
    }

    private final void fnInitData(final String sKind, final String sCode) {
        g_sKind = sKind;
        g_sCode = sCode;
        fnRunGetQRcodeData();
    }

    private final void fnRunGetQRcodeData() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    final SoapObject soapRequest = fnGetSoapMapData(g_sKind, g_sCode);
                    final Object soapObject = (Object) SoapFunctions.fnGetData(Data.SERRVICE_API, Data.NAMESPACE + WebHandler.GET_QRCODE_DATA_FUNTION, soapRequest);
                    new HandlerMessage().fnSendMessage(g_hdMessage, HandlerMessage.GET_QRCODE_DATA, soapObject);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }).start();
    }

    private final SoapObject fnGetSoapMapData(final String sKind, final String sCode) {
        final SoapObject soapRequest = new SoapObject(Data.NAMESPACE, WebHandler.GET_QRCODE_DATA_FUNTION);
        soapRequest.addProperty("sKind", sKind);
        soapRequest.addProperty("sCode", sCode);
        return soapRequest;
    }

    private final void fnInitUIControl() {
        fnInitDiaLog();
        fnInitButton();
        fnInitTextView();
        fnInitEdit();
    }

    private final void fnInitDiaLog() {
        g_diaProduct = new Dialog(g_objContext, R.style.Dialog);
        g_diaProduct.setContentView(R.layout.product_dialog);
        final Window dialogWindow = g_diaProduct.getWindow();
        final WindowManager.LayoutParams layParams = dialogWindow.getAttributes();
        dialogWindow.setGravity(Gravity.CENTER);
        layParams.width = (int) ((double) Data.WIDTH_PIXELS / 1.1); // 寬度
        layParams.height = (int) ((double) Data.HEIGHT_PIXELS / 1.3); // 高度
        layParams.alpha = 1f; // 透明度
        g_diaProduct.setOnCancelListener(new DialogInterface.OnCancelListener() {
            @Override
            public void onCancel(DialogInterface dialog) {
                ((QRCodeActivity) g_objContext).fnRestart();
            }
        });
    }

    private final void fnInitButton() {
        final Button btnFalse = (Button) g_diaProduct.findViewById(R.id.text_product_false);
        btnFalse.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                g_diaProduct.cancel();
            }
        });

        final Button btnTrue = (Button) g_diaProduct.findViewById(R.id.text_product_true);
        btnTrue.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                g_diaProduct.cancel();
            }
        });
    }

    private final void fnInitTextView() {
        g_textKindName = (TextView) g_diaProduct.findViewById(R.id.text_product_kind_name);
        g_textCodeName = (TextView) g_diaProduct.findViewById(R.id.text_product_code_name);
        g_textStock = (TextView) g_diaProduct.findViewById(R.id.text_product_stock);
    }

    private final void fnInitEdit() {
        g_editInventory = (EditText) g_diaProduct.findViewById(R.id.edit_product_inventory);
    }

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    private final void fnInitImage() {
        g_imgShow = (ImageView) g_diaProduct.findViewById(R.id.img_product_show);

        final String sURL = Data.SERRVICE_URL + "ProductImage/" + g_sKind + g_sCode + "/one.png";
        g_imgShow.setTag(sURL);
        new ImageAsync().new GetImageAsync(g_imgShow, sURL).execute(sURL);
    }

    private final void fnEndLoad() {
        final ProgressBar probBar = (ProgressBar) g_diaProduct.findViewById(R.id.prob_product_load);
        probBar.setVisibility(View.GONE);
    }

    private final void fnStartLoad() {
        final ProgressBar probBar = (ProgressBar) g_diaProduct.findViewById(R.id.prob_product_load);
        probBar.setVisibility(View.VISIBLE);
    }

    public final void fnShow(final String sKind, final String sCode) {
        fnInitData(sKind, sCode);
        g_diaProduct.show();
    }

    private final void fnSetData(final Object soapObject) {
        final String[][] sData = SoapFunctions.fnGetListData(soapObject, 3);
        if (sData != null) {
            g_textKindName.setText(sData[0][0]);
            g_textCodeName.setText(sData[1][0]);
            g_textStock.setText(sData[2][0]);
            fnEndLoad();
            fnInitImage();
        }
    }

    final Handler g_hdMessage = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case HandlerMessage.GET_QRCODE_DATA:
                    fnSetData(msg.obj);
                    break;
            }
        }
    };

    private class GetImageAsyn extends AsyncTask<String, Void, Bitmap> {
        @Override
        protected Bitmap doInBackground(String... params) {
            String url = params[0];
            return getBitmapFromURL(url);
        }

        @TargetApi(Build.VERSION_CODES.LOLLIPOP)
        @Override
        protected void onPostExecute(Bitmap result) {
            if (result != null) {
                g_imgShow.setBackground(g_objContext.getResources().getDrawable(R.drawable.none));
                g_imgShow.setImageBitmap(result);
            }
            super.onPostExecute(result);
        }

        private final Bitmap getBitmapFromURL(String imageUrl) {
            try {
                final URL url = new URL(imageUrl);
                final HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setDoInput(true);
                connection.connect();
                final InputStream input = connection.getInputStream();
                final Bitmap bitmap = BitmapFactory.decodeStream(input);
                return bitmap;
            } catch (IOException e) {
                Log.e(TAG, e.getMessage());
                return null;
            }
        }
    }

}
