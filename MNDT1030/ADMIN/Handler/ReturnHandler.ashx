﻿<%@ WebHandler Language="C#" Class="ReturnHandler" %>

using System;
using System.Web;
using System.Data;

public class ReturnHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    ReturnRepository g_returnRepository = new ReturnRepository();
    ReturnM g_returnM = new ReturnM();
    ReturnD g_returnD = new ReturnD();

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
        string sReturnId = context.Request.QueryString["return_id"];
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

        g_returnM.ReturnId(sReturnId)
                .OrderId(sOrderId)
                .Id(sId)
                .Datetime(sDatetime)
                .Complete(sComplete)
                .Status(sStatus)
                .Description(sDescription)
                .CreateId(context.Session["id"].ToString())
                .Order(sOrder);

        g_returnD.Seq(sSeq)
                .ReturnId(sReturnId)
                .MaterialId(sMaterialId)
                .WarehouseId(sWarehouseId)
                .Amount(sAmount)
                .Price(sPrice)
                .Complete(sComplete)
                .PayComplete(sPayComplete)
                .Description(sDescription)
                .CreateId(context.Session["id"].ToString());
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

    #region ReturnMaster

    public void fnSelects(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sOrder = context.Request.QueryString["order"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];
        int iPage = Convert.ToInt32(sPage);
        int iPageMaxSize = Convert.ToInt32(sPageMaxSize);

        DataTable dtData = g_returnRepository.fnSelects(g_returnM, iPage, iPageMaxSize);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnCount(HttpContext context)
    {
        string sSize = g_returnRepository.fnCount(g_returnM);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnSelectReturnId(HttpContext context)
    {
        string sNUM = context.Request.QueryString["NUM"];
        string sMsg = "Y";
        string sReturnId = g_returnRepository.fnSelectReturnId(g_returnM, sNUM);

        if (sReturnId == " ")
        {
            sMsg = "訊息：已無下筆資料。";
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"return_id\":\"" + sReturnId + "\", \"NUM\":\"" + sNUM + "\"}");
    }

    public void fnSelect(HttpContext context)
    {
        DataTable dtData = g_returnRepository.fnSelect(g_returnM);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnInsert(HttpContext context)
    {
        string sMsg = fnCheckData(g_returnM);

        if (sMsg == "Y")
        {
            g_returnM.ReturnId("R" + PublicApi.fnGetOrderNum(context, "A02"));
            sMsg = g_returnRepository.fnInsert(g_returnM);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"return_id\":\"" + g_returnM.return_id + "\"}");
    }

    public void fnUpdate(HttpContext context)
    {
        string sMsg = fnCheckData(g_returnM);
        string sIP = PublicApi.fnRetrieveIP(context.Request);

        if (sMsg == "Y")
        {
            string sOriginalComplete = g_returnRepository.fnSelect(g_returnM).Rows[0]["complete"].ToString();

            sMsg = g_returnRepository.fnUpdate(g_returnM, sIP);
            if (sMsg == "Y" && sOriginalComplete == "N" && g_returnM.complete == "Y")
            {
                g_returnRepository.fnAudits(g_returnD);
                fnUpdateStock(g_returnD);
            }
            sMsg = sMsg.Replace("\r\n", "");
        }

        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    private void fnUpdateStock(ReturnD returnD)
    {
        MaterialStockRepository materialStockRepository = new MaterialStockRepository();
        DataTable dtData = g_returnRepository.fnSelects(g_returnD);

        for (int iIndex = 0; iIndex < dtData.Rows.Count; iIndex++)
        {
            MaterialStock materialStock = new MaterialStock();
            materialStock.MaterialId(dtData.Rows[iIndex]["material_id"].ToString())
                         .WarehouseId(dtData.Rows[iIndex]["warehouse_id"].ToString())
                         .Amount("-" + dtData.Rows[iIndex]["amount"].ToString())
                         .CreateId(returnD.create_id);

            materialStockRepository.fnUpdateAmount(materialStock);
        }
    }

    public void fnDelete(HttpContext context)
    {
        string sMsg = "Y";
        string sIP = PublicApi.fnRetrieveIP(context.Request);

        sMsg = g_returnRepository.fnDelete(g_returnM, sIP);
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    private string fnCheckData(ReturnM returnM)
    {
        string sMsg = "Y";


        return sMsg;
    }

    #endregion



    #region ReturnDetails

    public void fnSelectsD(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];

        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);

            DataTable dtData = g_returnRepository.fnSelects(g_returnD, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCountD(HttpContext context)
    {
        string sSize = g_returnRepository.fnCount(g_returnD);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnInsertD(HttpContext context)
    {
        string sMsg = fnCheckData(g_returnD);

        if (sMsg == "Y")
        {
            string sSeq = g_returnRepository.fnGetSeq(g_returnD);
            g_returnD.Seq(sSeq);
            sMsg = g_returnRepository.fnInsert(g_returnD);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\": \"" + sMsg + "\" "
                            + ", \"seq\": \"" + g_returnD.seq + "\" "
                            + ", \"material_id\": \"" + g_returnD.material_id + "\" "
                            + ", \"warehouse_id\": \"" + g_returnD.warehouse_id + "\" "
                            + ", \"amount\": \"" + g_returnD.amount + "\" "
                            + ", \"price\": \"" + g_returnD.price + "\" "
                            + ", \"description\": \"" + g_returnD.description + "\" }");
    }

    public void fnInsertsD(HttpContext context)
    {
        string sMsg = "";
        string[] MaterialIds = g_returnD.material_id.Split(',');
        string[] WarehouseIds = g_returnD.warehouse_id.Split(',');
        string[] sAmounts = g_returnD.amount.Split(',');
        string[] sPrices = g_returnD.price.Split(',');
        string[] sDescriptions = g_returnD.description.Split(',');

        for (int iIndex = 0; iIndex < MaterialIds.Length; iIndex++)
        {
            string sInsertMsg = "Y";
            ReturnD returnD = new ReturnD();

            returnD.ReturnId(g_returnD.return_id)
                    .MaterialId(MaterialIds[iIndex])
                    .WarehouseId(WarehouseIds[iIndex])
                    .Amount(sAmounts[iIndex])
                    .Price(sPrices[iIndex])
                    .Description(sDescriptions[iIndex])
                    .CreateId(g_returnD.create_id);
            sInsertMsg = fnCheckData(returnD);
            if (sInsertMsg == "Y")
            {
                string sSeq = g_returnRepository.fnGetSeq(returnD);
                returnD.Seq(sSeq);
                sInsertMsg = g_returnRepository.fnInsert(returnD);
                if (sInsertMsg != "Y")
                {
                    sMsg += returnD.material_id + "：" + sInsertMsg.Replace("\r\n", "") + "</br>";
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

        sMsg = fnCheckData(g_returnD);
        if (sMsg == "Y")
        {
            sMsg = g_returnRepository.fnUpdate(g_returnD);
            sMsg = sMsg.Replace("\r\n", "");
        }

        context.Response.Write("{ \"msg\": \"" + sMsg + "\" }");
    }

    public void fnVerificationsD(HttpContext context)
    {
        string sMsg = "";
        string[] Completes = g_returnD.complete.Split(',');
        string[] PayCompletes = g_returnD.pay_complete.Split(',');
        string[] Seqs = g_returnD.seq.Split(',');

        for (int iIndex = 0; iIndex < Seqs.Length; iIndex++)
        {
            string sUpdateMsg = "Y";
            ReturnD returnD = new ReturnD();

            returnD.Seq(Seqs[iIndex])
                    .ReturnId(g_returnD.return_id)
                    .Complete(fnChangeBool(Completes[iIndex]))
                    .PayComplete(fnChangeBool(PayCompletes[iIndex]))
                    .CreateId(g_returnD.create_id);

            sUpdateMsg = g_returnRepository.fnVerifications(returnD);
            if (sUpdateMsg != "Y")
            {
                sMsg += returnD.material_id + "：" + sUpdateMsg.Replace("\r\n", "") + "</br>";
            }
        }
        sMsg = sMsg.Length == 0 ? "Y" : sMsg;
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }


    public void fnDeleteD(HttpContext context)
    {
        string sMsg = "Y";

        sMsg = g_returnRepository.fnDelete(g_returnD);
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    private string fnCheckData(ReturnD returnD)
    {
        string sMsg = "Y";
        DataTable dtData = g_returnRepository.fnSelect(returnD);
        if (!g_returnRepository.fnIsExist(g_returnM))
        {
            sMsg = "錯誤訊息：類別ID驗證錯誤。";
        }
        else if (returnD.return_id.Length < 1)
        {
            sMsg = "錯誤訊息：群組ID驗證錯誤。";
        }
        else if (returnD.material_id.Length < 1)
        {
            sMsg = "錯誤訊息：代碼不得為空。";
        }
        else if (dtData.Rows.Count == 1)
        {
            if (dtData.Rows[0]["complete"].ToString() == "Y")
            {
                sMsg = "訊息：已進貨不得編輯。";
            }
        }
        return sMsg;
    }

    #endregion


    #region ReturnTran

    public void fnSelectsTran(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];
        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);
            ReturnMTran returnMTran = new ReturnMTran();
            returnMTran.ReturnId(g_returnD.return_id);
            DataTable dtData = g_returnRepository.fnSelects(returnMTran, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCountTran(HttpContext context)
    {
        ReturnMTran returnMTran = new ReturnMTran();
        returnMTran.ReturnId(g_returnD.return_id);
        string sSize = g_returnRepository.fnCount(returnMTran);
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