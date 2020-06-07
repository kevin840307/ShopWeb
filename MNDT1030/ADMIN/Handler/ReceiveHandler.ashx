<%@ WebHandler Language="C#" Class="ReceiveHandler" %>

using System;
using System.Web;
using System.Data;

public class ReceiveHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    ReceiveRepository g_receiveRepository = new ReceiveRepository();
    ReceiveM g_receiveM = new ReceiveM();
    ReceiveD g_receiveD = new ReceiveD();

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
        string sComplete = fnChangeBool(context.Request.QueryString["complete"]);
        string sStatus = context.Request.QueryString["status"];
        string sDescription = context.Request.QueryString["description"];
        string sOrder = context.Request.QueryString["order"];

        string sSeq = context.Request.QueryString["seq"];
        string sWarehouseId = context.Request.QueryString["warehouse_id"];
        string sMaterialId = context.Request.QueryString["material_id"];
        string sAmount = PublicApi.fnNullChange(context.Request.QueryString["amount"], "0");
        string sPrice = PublicApi.fnNullChange(context.Request.QueryString["price"], "0");
        string sPayComplete = fnChangeBool(context.Request.QueryString["pay_complete"]);

        g_receiveM.OrderId(sOrderId)
                .Id(sId)
                .Datetime(sDatetime)
                .Complete(sComplete)
                .Status(sStatus)
                .Description(sDescription)
                .CreateId(context.Session["id"].ToString())
                .Order(sOrder);

        g_receiveD.Seq(sSeq)
                .OrderId(sOrderId)
                .MaterialId(sMaterialId)
                .WarehouseId(sWarehouseId)
                .Amount(sAmount)
                .Price(sPrice)
                .Complete(sComplete)
                .PayComplete(sPayComplete)
                .Description(sDescription)
                .CreateId(context.Session["id"].ToString());
    }

    public void fnJumpReturn(HttpContext context)
    {
        string sMsg = "Y";
        string sReturnId = "";

        fnProcessReturn(context, ref sMsg, ref sReturnId);
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"return_id\":\"" + sReturnId + "\"}");
    }

    public void fnChange(HttpContext context)
    {
        string sMsg = "Y";
        string sReturnId = "";

        fnProcessReturn(context, ref sMsg, ref sReturnId);
        if (sMsg == "Y")
        {
            DataTable dtMasterData = null;
            DataTable dtData = g_receiveRepository.fnSelect(g_receiveD);
            ReturnRepository returnRepository = new ReturnRepository();
            ReturnM returnM = new ReturnM();
            ReturnD returnD = new ReturnD();

            returnM.ReturnId(sReturnId);
            returnD.Seq(returnRepository.fnGetSeq(sReturnId))
                .ReturnId(sReturnId)
                .MaterialId(dtData.Rows[0]["material_id"].ToString())
                .WarehouseId(dtData.Rows[0]["warehouse_id"].ToString())
                .Amount(dtData.Rows[0]["amount"].ToString())
                .Price(dtData.Rows[0]["price"].ToString())
                .CreateId(g_receiveD.create_id);

            dtMasterData = returnRepository.fnSelect(returnM);

            if (dtMasterData.Rows.Count != 1)
            {
                context.Response.Write("{ \"msg\":\"錯誤訊息：資料驗證錯誤。\"}");
                return;
            }

            if (dtMasterData.Rows[0]["complete"].ToString() == "Y")
            {
                context.Response.Write("{ \"msg\":\"錯誤訊息：退貨資料已審核。\"}");
                return;
            }

            if (returnRepository.fnIsExist(returnD))
            {
                context.Response.Write("{ \"msg\":\"錯誤訊息：已有此筆資料存在。\"}");
                return;
            }

            sMsg = returnRepository.fnInsert(returnD);
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"return_id\":\"" + sReturnId + "\"}");
    }

    private void fnProcessReturn(HttpContext context, ref string sMsg, ref string sReturnId)
    {
        string sIP = PublicApi.fnRetrieveIP(context.Request);
        ReturnRepository returnRepository = new ReturnRepository();
        ReturnM returnM = new ReturnM();
        string sOriginalComplete = g_receiveRepository.fnSelect(g_receiveM).Rows[0]["complete"].ToString();

        sMsg = g_receiveRepository.fnChange(g_receiveM, sIP);
        if (sMsg != "Y")
        {
            return;
        }

        if (sOriginalComplete == "N")
        {
            fnUpdateStock(g_receiveD);
        }

        sReturnId = returnRepository.fnGetReturnId(g_receiveM.order_id);
        if (sReturnId != " ")
        {
            return;
        }

        sReturnId = "R" + PublicApi.fnGetOrderNum(context, "A02");
        returnM.ReturnId(sReturnId)
                .OrderId(g_receiveD.order_id)
                .Id(g_receiveD.create_id)
                .Datetime(DateTime.Now.ToString("yyyy-MM-dd"))
                .CreateId(g_receiveD.create_id);
        sMsg = returnRepository.fnInsert(returnM);
    }

    private string fnChangeBool(object obj)
    {
        if (obj == null)
        {
            return "";
        }

        if (obj.ToString().IndexOf(",") > -1)
        {
            return obj.ToString();
        }

        if (obj.ToString() == "true" || obj.ToString() == "checked" || obj.ToString() == "Y")
        {
            return "Y";
        }
        return "N";
    }

    #region ReceiveMaster

    public void fnSelects(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sOrder = context.Request.QueryString["order"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];

        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);

            DataTable dtData = g_receiveRepository.fnSelects(g_receiveM, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCount(HttpContext context)
    {
        string sSize = g_receiveRepository.fnCount(g_receiveM);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnSelectOrderId(HttpContext context)
    {
        string sNUM = context.Request.QueryString["NUM"];
        string sMsg = "Y";
        string sOrderId = g_receiveRepository.fnSelectOrderId(g_receiveM, sNUM);

        if (sOrderId == " ")
        {
            sMsg = "訊息：已無下筆資料。";
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"order_id\":\"" + sOrderId + "\", \"NUM\":\"" + sNUM + "\"}");
    }

    public void fnSelect(HttpContext context)
    {
        DataTable dtData = g_receiveRepository.fnSelect(g_receiveM);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnInsert(HttpContext context)
    {
        string sMsg = fnCheckData(g_receiveM);

        if (sMsg == "Y")
        {
            g_receiveM.OrderId("P" + PublicApi.fnGetOrderNum(context, "A01"));
            sMsg = g_receiveRepository.fnInsert(g_receiveM);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"order_id\":\"" + g_receiveM.order_id + "\"}");
    }

    public void fnUpdate(HttpContext context)
    {
        string sIP = PublicApi.fnRetrieveIP(context.Request);
        string sMsg = fnCheckData(g_receiveM);

        if (sMsg == "Y")
        {
            string sOriginalComplete = g_receiveRepository.fnSelect(g_receiveM).Rows[0]["complete"].ToString();

            sMsg = g_receiveRepository.fnUpdate(g_receiveM, sIP);
            if (sMsg == "Y" && sOriginalComplete == "N" && g_receiveM.complete == "Y")
            {
                g_receiveRepository.fnAudits(g_receiveD);
                fnUpdateStock(g_receiveD);
            }
            sMsg = sMsg.Replace("\r\n", "");
        }

        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    private void fnUpdateStock(ReceiveD receiveD)
    {
        MaterialStockRepository materialStockRepository = new MaterialStockRepository();
        DataTable dtData = g_receiveRepository.fnSelects(g_receiveD);

        for (int iIndex = 0; iIndex < dtData.Rows.Count; iIndex++)
        {
            MaterialStock materialStock = new MaterialStock();
            materialStock.MaterialId(dtData.Rows[iIndex]["material_id"].ToString())
                         .WarehouseId(dtData.Rows[iIndex]["warehouse_id"].ToString())
                         .Amount(dtData.Rows[iIndex]["amount"].ToString())
                         .CreateId(receiveD.create_id);
            if (!materialStockRepository.fnIsExist(materialStock))
            {
                materialStockRepository.fnInsert(materialStock);
            }

            materialStockRepository.fnUpdateAmount(materialStock);
        }
    }

    public void fnDelete(HttpContext context)
    {
        string sMsg = "Y";
        string sIP = PublicApi.fnRetrieveIP(context.Request);

        sMsg = g_receiveRepository.fnDelete(g_receiveM, sIP);
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    public void fnSelectList(HttpContext context)
    {
        if (context.Session["id"] != null)
        {
            DataTable dtData = g_receiveRepository.fnSelectList();
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    private string fnCheckData(ReceiveM receive)
    {
        string sMsg = "Y";
        return sMsg;
    }

    #endregion



    #region ReceiveDetails

    public void fnSelectsD(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];

        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);

            DataTable dtData = g_receiveRepository.fnSelects(g_receiveD, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCountD(HttpContext context)
    {
        string sSize = g_receiveRepository.fnCount(g_receiveD);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnInsertD(HttpContext context)
    {
        string sMsg = fnCheckInsert(g_receiveD);

        if (sMsg == "Y")
        {
            string sSeq = g_receiveRepository.fnGetSeq(g_receiveD);
            g_receiveD.Seq(sSeq);
            sMsg = g_receiveRepository.fnInsert(g_receiveD);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\": \"" + sMsg + "\" "
                            + ", \"seq\": \"" + g_receiveD.seq + "\" "
                            + ", \"material_id\": \"" + g_receiveD.material_id + "\" "
                            + ", \"warehouse_id\": \"" + g_receiveD.warehouse_id + "\" "
                            + ", \"amount\": \"" + g_receiveD.amount + "\" "
                            + ", \"price\": \"" + g_receiveD.price + "\" "
                            + ", \"description\": \"" + g_receiveD.description + "\" }");
    }

    public void fnInsertsD(HttpContext context)
    {
        string sMsg = "";
        string[] MaterialIds = g_receiveD.material_id.Split(',');
        string[] WarehouseIds = g_receiveD.warehouse_id.Split(',');
        string[] sAmounts = g_receiveD.amount.Split(',');
        string[] sPrices = g_receiveD.price.Split(',');
        string[] sDescriptions = g_receiveD.description.Split(',');

        for (int iIndex = 0; iIndex < MaterialIds.Length; iIndex++)
        {
            string sInsertMsg = "Y";
            ReceiveD receiveD = new ReceiveD();

            receiveD.OrderId(g_receiveD.order_id)
                    .MaterialId(MaterialIds[iIndex])
                    .WarehouseId(WarehouseIds[iIndex])
                    .Amount(sAmounts[iIndex])
                    .Price(sPrices[iIndex])
                    .Description(sDescriptions[iIndex])
                    .CreateId(g_receiveD.create_id);
            sInsertMsg = fnCheckInsert(receiveD);
            if (sInsertMsg == "Y")
            {
                string sSeq = g_receiveRepository.fnGetSeq(receiveD);
                receiveD.Seq(sSeq);
                sInsertMsg = g_receiveRepository.fnInsert(receiveD);
                if (sInsertMsg != "Y")
                {
                    sMsg += receiveD.material_id + "：" + sInsertMsg.Replace("\r\n", "") + "</br>";
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

    private string fnCheckInsert(ReceiveD receiveD)
    {
        if (g_receiveRepository.fnIsExist(receiveD))
        {
            return "錯誤訊息：已有此筆資料。";
        }
        return fnCheckPurchaseAmount(receiveD); ;
    }

    public void fnUpdateD(HttpContext context)
    {
        string sMsg = "Y";

        sMsg = fnCheckUpdate(g_receiveD);
        if (sMsg == "Y")
        {
            sMsg = g_receiveRepository.fnUpdate(g_receiveD);
            sMsg = sMsg.Replace("\r\n", "");
        }

        context.Response.Write("{ \"msg\": \"" + sMsg + "\" }");
    }

    private string fnCheckUpdate(ReceiveD receiveD)
    {
        string sMsg = fnCheckModify(receiveD);
        if (sMsg != "Y")
        {
            return sMsg;
        }

        if (g_receiveRepository.fnIsExist(receiveD))
        {
            return "錯誤訊息：已有此筆資料。";
        }

        return fnCheckPurchaseAmount(receiveD);
    }

    public void fnVerificationsD(HttpContext context)
    {
        string sMsg = "";
        string[] Completes = g_receiveD.complete.Split(',');
        string[] PayCompletes = g_receiveD.pay_complete.Split(',');
        string[] Seqs = g_receiveD.seq.Split(',');

        sMsg = fnCheckModify(g_receiveD);
        if (sMsg == "Y")
        {
            for (int iIndex = 0; iIndex < Seqs.Length; iIndex++)
            {
                string sUpdateMsg = "Y";
                ReceiveD receiveD = new ReceiveD();

                receiveD.Seq(Seqs[iIndex])
                        .OrderId(g_receiveD.order_id)
                        .Complete(fnChangeBool(Completes[iIndex]))
                        .PayComplete(fnChangeBool(PayCompletes[iIndex]))
                        .CreateId(g_receiveD.create_id);

                sUpdateMsg = g_receiveRepository.fnVerifications(receiveD);
                if (sUpdateMsg != "Y")
                {
                    sMsg += receiveD.material_id + "：" + sUpdateMsg.Replace("\r\n", "") + "</br>";
                }
            }
            sMsg = sMsg.Length == 0 ? "Y" : sMsg;
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    public void fnDeleteD(HttpContext context)
    {
        string sMsg = "Y";

        sMsg = fnCheckModify(g_receiveD);
        if (sMsg == "Y")
        {
            sMsg = g_receiveRepository.fnDelete(g_receiveD);
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    private string fnCheckModify(ReceiveD receiveD)
    {
        DataTable dtData = g_receiveRepository.fnSelect(receiveD);

        if (dtData.Rows.Count == 1 && dtData.Rows[0]["complete"].ToString() == "Y")
        {
            return "訊息：已進貨不得編輯。";
        }
        return "Y";
    }

    private string fnCheckPurchaseAmount(ReceiveD receiveD)
    {
        PurchaseRepository purchaseRepository = new PurchaseRepository();
        PurchaseD purchaseD = new PurchaseD();
        purchaseD.OrderId(receiveD.order_id)
                 .MaterialId(receiveD.material_id);

        string sPurchaseAmount = purchaseRepository.fnSelectAmount(purchaseD);
        string sNowAmount = g_receiveRepository.fnSelectExcludeAmount(receiveD);
        double dPurchaseAmount = double.Parse(sPurchaseAmount);
        double dNewAmount = (double.Parse(sNowAmount) + double.Parse(receiveD.amount));

        if (dNewAmount > dPurchaseAmount)
        {
            return "錯誤訊息：進貨數量大於採購數量。";
        }
        return "Y";
    }

    #endregion


    #region ReceiveTran

    public void fnSelectsTran(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];
        int iPage = Convert.ToInt32(sPage);
        int iPageMaxSize = Convert.ToInt32(sPageMaxSize);
        ReceiveMTran receiveMTran = new ReceiveMTran();

        receiveMTran.OrderId(g_receiveD.order_id);
        DataTable dtData = g_receiveRepository.fnSelects(receiveMTran, iPage, iPageMaxSize);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnCountTran(HttpContext context)
    {
        ReceiveMTran receiveMTran = new ReceiveMTran();
        receiveMTran.OrderId(g_receiveD.order_id);
        string sSize = g_receiveRepository.fnCount(receiveMTran);
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