<%@ WebHandler Language="C#" Class="PurchaseHandler" %>

using System;
using System.Web;
using System.Data;

public class PurchaseHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    PurchaseRepository g_purchaseRepository = new PurchaseRepository();
    PurchaseM g_purchaseM = new PurchaseM();
    PurchaseD g_purchaseD = new PurchaseD();

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        string sMethod = context.Request.QueryString["method"];
        if (sMethod == null)
        {
            return;
        }

        System.Reflection.MethodInfo methodInfo = this.GetType().GetMethod(sMethod);
        if (methodInfo == null)
        {
            return;
        }

        fnInitData(context);
        methodInfo.Invoke(this, new object[] { context });
    }

    private void fnInitData(HttpContext context)
    {
        string sOrderId = context.Request.QueryString["order_id"];
        string sId = context.Request.QueryString["id"];
        string sDatetime = context.Request.QueryString["datetime"];
        string sComplete = context.Request.QueryString["complete"];
        string sStatus = context.Request.QueryString["status"];
        string sDescription = context.Request.QueryString["description"];
        string sOrder = context.Request.QueryString["order"];

        string sMaterialId = context.Request.QueryString["material_id"];
        string sAmount = context.Request.QueryString["amount"];
        string sPrice = context.Request.QueryString["price"];
        string sModifyAmount = context.Request.QueryString["modify_amount"];
        string sModifyPrice = context.Request.QueryString["modify_price"];

        g_purchaseM.OrderId(sOrderId)
                .Id(sId)
                .Datetime(sDatetime)
                .Complete(sComplete)
                .Status(sStatus)
                .Description(sDescription)
                .CreateId(context.Session["id"].ToString())
                .Order(sOrder);

        g_purchaseD.OrderId(sOrderId)
                .MaterialId(sMaterialId)
                .Amount(sAmount)
                .Price(sPrice)
                .ModifyAmount(sModifyAmount)
                .ModifyPrice(sModifyPrice)
                .Description(sDescription)
                .CreateId(context.Session["id"].ToString());
    }

    public void fnChange(HttpContext context)
    {
        string sMsg = "Y";
        string sIP = PublicApi.fnRetrieveIP(context.Request);

        sMsg = g_purchaseRepository.fnChange(g_purchaseM, sIP);
        if (sMsg == "Y")
        {
            ReceiveRepository receiveRepository = new ReceiveRepository();
            ReceiveM receiveM = new ReceiveM();
            receiveM.OrderId(g_purchaseM.order_id)
                    .CreateId(g_purchaseM.create_id);
            if (!receiveRepository.fnIsExist(receiveM))
            {
                sMsg = receiveRepository.fnChangeInsert(receiveM);
            }
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    #region PurchaseMaster

    public void fnSelects(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sOrder = context.Request.QueryString["order"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];
        int iPage = Convert.ToInt32(sPage);
        int iPageMaxSize = Convert.ToInt32(sPageMaxSize);

        DataTable dtData = g_purchaseRepository.fnSelects(g_purchaseM, iPage, iPageMaxSize);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnCount(HttpContext context)
    {
        string sSize = g_purchaseRepository.fnCount(g_purchaseM);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnSelectOrderId(HttpContext context)
    {
        string sNUM = context.Request.QueryString["NUM"];
        string sMsg = "Y";
        string sOrderId = g_purchaseRepository.fnSelectOrderId(g_purchaseM, sNUM);

        if (sOrderId == " ")
        {
            sMsg = "訊息：已無下筆資料。";
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"order_id\":\"" + sOrderId + "\", \"NUM\":\"" + sNUM + "\"}");
    }

    public void fnSelect(HttpContext context)
    {
        DataTable dtData = g_purchaseRepository.fnSelect(g_purchaseM);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnInsert(HttpContext context)
    {
        string sMsg = fnCheckData(g_purchaseM);

        if (sMsg == "Y")
        {
            g_purchaseM.OrderId("P" + PublicApi.fnGetOrderNum(context, "A01"));
            sMsg = g_purchaseRepository.fnInsert(g_purchaseM);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"order_id\":\"" + g_purchaseM.order_id + "\"}");
    }

    public void fnUpdate(HttpContext context)
    {
        string sMsg = fnCheckData(g_purchaseM);
        string sIP = PublicApi.fnRetrieveIP(context.Request);

        if (sMsg == "Y")
        {
            sMsg = g_purchaseRepository.fnUpdate(g_purchaseM, sIP);
            sMsg = sMsg.Replace("\r\n", "");
        }

        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    public void fnDelete(HttpContext context)
    {
        string sMsg = "Y";
        string sIP = PublicApi.fnRetrieveIP(context.Request);

        sMsg = g_purchaseRepository.fnDelete(g_purchaseM, sIP);
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    private string fnCheckData(PurchaseM purchase)
    {
        string sMsg = "Y";


        return sMsg;
    }

    #endregion



    #region PurchaseDetails

    public void fnSelectsD(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];
        int iPage = Convert.ToInt32(sPage);
        int iPageMaxSize = Convert.ToInt32(sPageMaxSize);

        DataTable dtData = g_purchaseRepository.fnSelects(g_purchaseD, iPage, iPageMaxSize);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnCountD(HttpContext context)
    {
        string sSize = g_purchaseRepository.fnCount(g_purchaseD);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnInsertD(HttpContext context)
    {
        string sMsg = fnCheckData(g_purchaseD);

        if (sMsg == "Y")
        {
            sMsg = g_purchaseRepository.fnInsert(g_purchaseD);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\": \"" + sMsg + "\" "
                            + ", \"material_id\": \"" + g_purchaseD.material_id + "\" "
                            + ", \"amount\": \"" + g_purchaseD.amount + "\" "
                            + ", \"price\": \"" + g_purchaseD.price + "\" "
                            + ", \"modify_amount\": \"" + g_purchaseD.amount + "\" "
                            + ", \"modify_price\": \"" + g_purchaseD.price + "\" "
                            + ", \"description\": \"" + g_purchaseD.description + "\" }");
    }

    public void fnProductInsertD(HttpContext context)
    {
        string sMsg = "Y";
        string sSql = "";
        string sProductId = context.Request.QueryString["product_id"];
        string sAmount = context.Request.QueryString["amount"];
        ProductRepository productRepository = new ProductRepository();
        ProductD productD = new ProductD();
        productD.ProductId(sProductId);
        DataTable dtData = productRepository.fnSelects(productD);
        for (int iIndex = 0; iIndex < dtData.Rows.Count; iIndex++)
        {
            double dAmount = double.Parse(sAmount) * double.Parse(dtData.Rows[iIndex]["amount"].ToString());
            double dPrice = double.Parse(sAmount) * double.Parse(dtData.Rows[iIndex]["price"].ToString());
            g_purchaseD.MaterialId(dtData.Rows[iIndex]["material_id"].ToString());
            if (g_purchaseRepository.fnIsExist(g_purchaseD))
            {
                g_purchaseD.ModifyAmount(dAmount.ToString())
                           .ModifyPrice(dPrice.ToString());
                sSql += g_purchaseRepository.fnAccumulateUpdateSql(g_purchaseD);
            }
            else
            {
                g_purchaseD.Amount(dAmount.ToString())
                           .Price(dPrice.ToString());
                sSql += g_purchaseRepository.fnInsertSql(g_purchaseD);
            }
        }
        sMsg = PublicApi.fnExecuteSQL(sSql, "MNDT");
        sMsg = sMsg.Replace("\r\n", "");
        context.Response.Write("{ \"msg\": \"" + sMsg + "\" }");
    }

    public void fnInsertsD(HttpContext context)
    {
        string sMsg = "";
        string[] MaterialIds = g_purchaseD.material_id.Split(',');
        string[] sAmounts = g_purchaseD.amount.Split(',');
        string[] sPrices = g_purchaseD.price.Split(',');
        string[] sDescriptions = g_purchaseD.description.Split(',');

        for (int iIndex = 0; iIndex < MaterialIds.Length; iIndex++)
        {
            string sInsertMsg = "Y";
            PurchaseD purchaseD = new PurchaseD();

            purchaseD.OrderId(g_purchaseD.order_id)
                    .MaterialId(MaterialIds[iIndex])
                    .Amount(sAmounts[iIndex])
                    .Price(sPrices[iIndex])
                    .Description(sDescriptions[iIndex])
                    .CreateId(g_purchaseD.create_id);

            sInsertMsg = fnCheckData(purchaseD);
            if (sInsertMsg == "Y")
            {
                sInsertMsg = g_purchaseRepository.fnInsert(purchaseD);
                if (sInsertMsg != "Y")
                {
                    sMsg += purchaseD.material_id + "：" + sInsertMsg.Replace("\r\n", "") + "</br>";
                }
            }
            else
            {
                sMsg += sInsertMsg.Replace("\r\n", "") + "</br>";
            }
        }
        sMsg = sMsg.Length == 0 ? "Y" : sMsg;
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    public void fnUpdateD(HttpContext context)
    {
        string sMsg = "";

        sMsg = fnCheckData(g_purchaseD);
        if (sMsg == "Y")
        {
            sMsg = g_purchaseRepository.fnUpdate(g_purchaseD);
            sMsg = sMsg.Replace("\r\n", "");
        }

        context.Response.Write("{ \"msg\": \"" + sMsg + "\" }");
    }

    public void fnUpdatesD(HttpContext context)
    {
        string sMsg = "";
        string[] MaterialIds = g_purchaseD.material_id.Split(',');
        string[] sAmounts = g_purchaseD.modify_amount.Split(',');
        string[] sPrices = g_purchaseD.modify_price.Split(',');
        string[] sDescriptions = g_purchaseD.description.Split(',');

        for (int iIndex = 0; iIndex < MaterialIds.Length; iIndex++)
        {
            string sUpdateMsg = "Y";
            PurchaseD purchaseD = new PurchaseD();

            purchaseD.OrderId(g_purchaseD.order_id)
                    .MaterialId(MaterialIds[iIndex])
                    .ModifyAmount(sAmounts[iIndex])
                    .ModifyPrice(sPrices[iIndex])
                    .Description(sDescriptions[iIndex])
                    .CreateId(g_purchaseD.create_id);
            sUpdateMsg = fnCheckData(purchaseD);
            if (sUpdateMsg == "Y")
            {
                sUpdateMsg = g_purchaseRepository.fnUpdate(purchaseD);
                if (sUpdateMsg != "Y")
                {
                    sMsg += purchaseD.material_id + "：" + sUpdateMsg.Replace("\r\n", "") + "</br>";
                }
            }
            else
            {
                sMsg += sUpdateMsg.Replace("\r\n", "") + "</br>";
            }
        }
        sMsg = sMsg.Length == 0 ? "Y" : sMsg;
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }


    public void fnDeleteD(HttpContext context)
    {
        string sMsg = "Y";

        sMsg = g_purchaseRepository.fnDelete(g_purchaseD);
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    private string fnCheckData(PurchaseD purchaseD)
    {
        if (!g_purchaseRepository.fnIsExist(g_purchaseM))
        {
            return "錯誤訊息：類別ID驗證錯誤。";
        }

        if (purchaseD.order_id.Length < 1)
        {
            return "錯誤訊息：群組ID驗證錯誤。";
        }

        if (purchaseD.material_id.Length < 1)
        {
            return "錯誤訊息：代碼不得為空。";
        }
        return "Y";
    }

    #endregion


    #region PurchaseTran

    public void fnSelectsTran(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];
        int iPage = Convert.ToInt32(sPage);
        int iPageMaxSize = Convert.ToInt32(sPageMaxSize);
        PurchaseMTran purchaseMTran = new PurchaseMTran();

        purchaseMTran.OrderId(g_purchaseD.order_id);
        DataTable dtData = g_purchaseRepository.fnSelects(purchaseMTran, iPage, iPageMaxSize);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnCountTran(HttpContext context)
    {
        PurchaseMTran purchaseMTran = new PurchaseMTran();
        purchaseMTran.OrderId(g_purchaseD.order_id);
        string sSize = g_purchaseRepository.fnCount(purchaseMTran);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    #endregion

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}