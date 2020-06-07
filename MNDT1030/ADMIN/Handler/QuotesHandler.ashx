<%@ WebHandler Language="C#" Class="QuotesHandler" %>

using System;
using System.Web;
using System.Data;

public class QuotesHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    QuotesRepository g_quotesRepository = new QuotesRepository();
    QuotesM g_quotesM = new QuotesM();
    QuotesD g_quotesD = new QuotesD();

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
        string sClientId = context.Request.QueryString["client_id"];
        string sDatetime = context.Request.QueryString["datetime"];
        string sComplete = context.Request.QueryString["complete"];
        string sStatus = context.Request.QueryString["status"];
        string sDescription = context.Request.QueryString["description"];
        string sOrder = context.Request.QueryString["order"];

        string sProductId = context.Request.QueryString["product_id"];
        string sAmount = context.Request.QueryString["amount"];
        string sPrice = context.Request.QueryString["price"];
        string sModifyAmount = context.Request.QueryString["modify_amount"];
        string sModifyPrice = context.Request.QueryString["modify_price"];

        g_quotesM.OrderId(sOrderId)
                .Id(sId)
                .ClientId(sClientId)
                .Datetime(sDatetime)
                .Complete(sComplete)
                .Status(sStatus)
                .Description(sDescription)
                .CreateId(context.Session["id"].ToString())
                .Order(sOrder);

        g_quotesD.OrderId(sOrderId)
                .ProductId(sProductId)
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

        sMsg = g_quotesRepository.fnChange(g_quotesM, sIP);
        if (sMsg == "Y")
        {
            SalesRepository salseRepository = new SalesRepository();
            SalesM salseM = new SalesM();
            salseM.OrderId(g_quotesM.order_id)
                    .CreateId(g_quotesM.create_id);
            if (!salseRepository.fnIsExist(salseM))
            {
                sMsg = salseRepository.fnChangeInsert(salseM);
            }
        }
        context.Response.Write("{ \"msg\":\"" + sMsg.Replace("\r\n", "") + "\"}");
    }

    #region QuotesMaster

    public void fnSelects(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sOrder = context.Request.QueryString["order"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];
        int iPage = Convert.ToInt32(sPage);
        int iPageMaxSize = Convert.ToInt32(sPageMaxSize);

        DataTable dtData = g_quotesRepository.fnSelects(g_quotesM, iPage, iPageMaxSize);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnCount(HttpContext context)
    {
        string sSize = g_quotesRepository.fnCount(g_quotesM);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnSelectOrderId(HttpContext context)
    {
        string sNUM = context.Request.QueryString["NUM"];
        string sMsg = "Y";
        string sOrderId = g_quotesRepository.fnSelectOrderId(g_quotesM, sNUM);

        if (sOrderId == " ")
        {
            sMsg = "訊息：已無下筆資料。";
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"order_id\":\"" + sOrderId + "\", \"NUM\":\"" + sNUM + "\"}");
    }

    public void fnSelect(HttpContext context)
    {
        DataTable dtData = g_quotesRepository.fnSelect(g_quotesM);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnInsert(HttpContext context)
    {
        string sMsg = fnCheckData(g_quotesM);

        if (sMsg == "Y")
        {
            g_quotesM.OrderId("P" + PublicApi.fnGetOrderNum(context, "B01"));
            sMsg = g_quotesRepository.fnInsert(g_quotesM);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"order_id\":\"" + g_quotesM.order_id + "\"}");
    }

    public void fnUpdate(HttpContext context)
    {
        string sMsg = fnCheckData(g_quotesM);
        string sIP = PublicApi.fnRetrieveIP(context.Request);

        if (sMsg == "Y")
        {
            sMsg = g_quotesRepository.fnUpdate(g_quotesM, sIP);
            sMsg = sMsg.Replace("\r\n", "");
        }

        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    public void fnDelete(HttpContext context)
    {
        string sMsg = "Y";
        string sIP = PublicApi.fnRetrieveIP(context.Request);

        sMsg = g_quotesRepository.fnDelete(g_quotesM, sIP);
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    private string fnCheckData(QuotesM quotes)
    {
        string sMsg = "Y";


        return sMsg;
    }

    #endregion



    #region QuotesDetails

    public void fnSelectsD(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];
        int iPage = Convert.ToInt32(sPage);
        int iPageMaxSize = Convert.ToInt32(sPageMaxSize);

        DataTable dtData = g_quotesRepository.fnSelects(g_quotesD, iPage, iPageMaxSize);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnCountD(HttpContext context)
    {
        string sSize = g_quotesRepository.fnCount(g_quotesD);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnInsertD(HttpContext context)
    {
        string sMsg = fnCheckData(g_quotesD);

        if (sMsg == "Y")
        {
            sMsg = g_quotesRepository.fnInsert(g_quotesD);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\": \"" + sMsg + "\" "
                            + ", \"product_id\": \"" + g_quotesD.product_id + "\" "
                            + ", \"amount\": \"" + g_quotesD.amount + "\" "
                            + ", \"price\": \"" + g_quotesD.price + "\" "
                            + ", \"modify_amount\": \"" + g_quotesD.amount + "\" "
                            + ", \"modify_price\": \"" + g_quotesD.price + "\" "
                            + ", \"description\": \"" + g_quotesD.description + "\" }");
    }

    public void fnInsertsD(HttpContext context)
    {
        string sMsg = "";
        string[] ProductIds = g_quotesD.product_id.Split(',');
        string[] sAmounts = g_quotesD.amount.Split(',');
        string[] sPrices = g_quotesD.price.Split(',');
        string[] sDescriptions = g_quotesD.description.Split(',');

        for (int iIndex = 0; iIndex < ProductIds.Length; iIndex++)
        {
            string sInsertMsg = "Y";
            QuotesD quotesD = new QuotesD();

            quotesD.OrderId(g_quotesD.order_id)
                    .ProductId(ProductIds[iIndex])
                    .Amount(sAmounts[iIndex])
                    .Price(sPrices[iIndex])
                    .Description(sDescriptions[iIndex])
                    .CreateId(g_quotesD.create_id);

            sInsertMsg = fnCheckData(quotesD);
            if (sInsertMsg == "Y")
            {
                sInsertMsg = g_quotesRepository.fnInsert(quotesD);
                if (sInsertMsg != "Y")
                {
                    sMsg += quotesD.product_id + "：" + sInsertMsg.Replace("\r\n", "") + "</br>";
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

        sMsg = fnCheckData(g_quotesD);
        if (sMsg == "Y")
        {
            sMsg = g_quotesRepository.fnUpdate(g_quotesD);
            sMsg = sMsg.Replace("\r\n", "");
        }

        context.Response.Write("{ \"msg\": \"" + sMsg + "\" }");
    }

    public void fnUpdatesD(HttpContext context)
    {
        string sMsg = "";
        string[] ProductIds = g_quotesD.product_id.Split(',');
        string[] sAmounts = g_quotesD.modify_amount.Split(',');
        string[] sPrices = g_quotesD.modify_price.Split(',');
        string[] sDescriptions = g_quotesD.description.Split(',');

        for (int iIndex = 0; iIndex < ProductIds.Length; iIndex++)
        {
            string sUpdateMsg = "Y";
            QuotesD quotesD = new QuotesD();

            quotesD.OrderId(g_quotesD.order_id)
                    .ProductId(ProductIds[iIndex])
                    .ModifyAmount(sAmounts[iIndex])
                    .ModifyPrice(sPrices[iIndex])
                    .Description(sDescriptions[iIndex])
                    .CreateId(g_quotesD.create_id);
            sUpdateMsg = fnCheckData(quotesD);
            if (sUpdateMsg == "Y")
            {
                sUpdateMsg = g_quotesRepository.fnUpdate(quotesD);
                if (sUpdateMsg != "Y")
                {
                    sMsg += quotesD.product_id + "：" + sUpdateMsg.Replace("\r\n", "") + "</br>";
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

        sMsg = g_quotesRepository.fnDelete(g_quotesD);
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    private string fnCheckData(QuotesD quotesD)
    {
        if (!g_quotesRepository.fnIsExist(g_quotesM))
        {
            return "錯誤訊息：類別ID驗證錯誤。";
        }

        if (quotesD.order_id.Length < 1)
        {
            return "錯誤訊息：群組ID驗證錯誤。";
        }

        if (quotesD.product_id.Length < 1)
        {
            return "錯誤訊息：代碼不得為空。";
        }
        return "Y";
    }

    #endregion


    #region QuotesTran

    public void fnSelectsTran(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];
        int iPage = Convert.ToInt32(sPage);
        int iPageMaxSize = Convert.ToInt32(sPageMaxSize);
        QuotesMTran quotesMTran = new QuotesMTran();

        quotesMTran.OrderId(g_quotesD.order_id);
        DataTable dtData = g_quotesRepository.fnSelects(quotesMTran, iPage, iPageMaxSize);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnCountTran(HttpContext context)
    {
        QuotesMTran quotesMTran = new QuotesMTran();
        quotesMTran.OrderId(g_quotesD.order_id);
        string sSize = g_quotesRepository.fnCount(quotesMTran);
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