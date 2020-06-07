<%@ WebHandler Language="C#" Class="SalesHandler" %>

using System;
using System.Web;
using System.Data;

public class SalesHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    SalesRepository g_salesRepository = new SalesRepository();
    SalesM g_salesM = new SalesM();
    SalesD g_salesD = new SalesD();

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
        string sPay = context.Request.QueryString["pay"];
        string sOrderStatus = context.Request.QueryString["order_status"];
        string sDatetime = context.Request.QueryString["datetime"];
        string sComplete = fnChangeBool(context.Request.QueryString["complete"]);
        string sStatus = context.Request.QueryString["status"];
        string sDescription = context.Request.QueryString["description"];
        string sOrder = context.Request.QueryString["order"];

        string sSeq = context.Request.QueryString["seq"];
        string sWarehouseId = context.Request.QueryString["warehouse_id"];
        string sProductId = context.Request.QueryString["product_id"];
        string sAmount = PublicApi.fnNullChange(context.Request.QueryString["amount"], "0");
        string sPrice = PublicApi.fnNullChange(context.Request.QueryString["price"], "0");

        g_salesM.OrderId(sOrderId)
                .Id(sId)
                .Pay(sPay)
                .OrderStatus(sOrderStatus)
                .Datetime(sDatetime)
                .Complete(sComplete)
                .Status(sStatus)
                .Description(sDescription)
                .CreateId(context.Session["id"].ToString())
                .Order(sOrder);

        g_salesD.Seq(sSeq)
                .OrderId(sOrderId)
                .ProductId(sProductId)
                .WarehouseId(sWarehouseId)
                .Amount(sAmount)
                .Price(sPrice)
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
            DataTable dtData = g_salesRepository.fnSelect(g_salesD);
            SReturnRepository sreturnRepository = new SReturnRepository();
            SReturnM sreturnM = new SReturnM();
            SReturnD sreturnD = new SReturnD();

            sreturnM.ReturnId(sReturnId);
            sreturnD.Seq(sreturnRepository.fnGetSeq(sReturnId))
                .ReturnId(sReturnId)
                .ProductId(dtData.Rows[0]["product_id"].ToString())
                .WarehouseId(dtData.Rows[0]["warehouse_id"].ToString())
                .Amount(dtData.Rows[0]["amount"].ToString())
                .Price(dtData.Rows[0]["price"].ToString())
                .CreateId(g_salesD.create_id);

            dtMasterData = sreturnRepository.fnSelect(sreturnM);

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

            if (sreturnRepository.fnIsExist(sreturnD))
            {
                context.Response.Write("{ \"msg\":\"錯誤訊息：已有此筆資料存在。\"}");
                return;
            }

            sMsg = sreturnRepository.fnInsert(sreturnD);
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"return_id\":\"" + sReturnId + "\"}");
    }

    private void fnProcessReturn(HttpContext context, ref string sMsg, ref string sReturnId)
    {
        string sIP = PublicApi.fnRetrieveIP(context.Request);
        SReturnRepository sreturnRepository = new SReturnRepository();
        SReturnM sreturnM = new SReturnM();

        // 檢查明細
        DataTable dtData = g_salesRepository.fnSelects(g_salesD);
        for (int iIndex = 0; iIndex < dtData.Rows.Count; iIndex++)
        {
            SalesD salesD = new SalesD();
            salesD.OrderId(g_salesD.order_id)
                  .Seq(dtData.Rows[iIndex]["seq"].ToString())
                  .ProductId(dtData.Rows[iIndex]["product_id"].ToString())
                  .Amount(dtData.Rows[iIndex]["amount"].ToString())
                  .WarehouseId(dtData.Rows[iIndex]["warehouse_id"].ToString());
            sMsg = fnCheckQuotesAmount(salesD);
            if (sMsg != "Y")
            {
                return;
            }
        }

        // 轉換為審核
        string sOriginalComplete = g_salesRepository.fnSelect(g_salesM).Rows[0]["complete"].ToString();

        sMsg = g_salesRepository.fnChange(g_salesM, sIP);
        if (sMsg != "Y")
        {
            return;
        }

        if (sOriginalComplete == "N")
        {
            fnUpdateStock(g_salesD);
        }

        sReturnId = sreturnRepository.fnGetReturnId(g_salesM.order_id);
        if (sReturnId != " ")
        {
            return;
        }

        sReturnId = "R" + PublicApi.fnGetOrderNum(context, "A02");
        sreturnM.ReturnId(sReturnId)
                .OrderId(g_salesD.order_id)
                .Id(g_salesD.create_id)
                .Datetime(DateTime.Now.ToString("yyyy-MM-dd"))
                .CreateId(g_salesD.create_id);
        sMsg = sreturnRepository.fnInsert(sreturnM);
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

    #region SalesMaster

    public void fnSelects(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sOrder = context.Request.QueryString["order"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];

        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);

            DataTable dtData = g_salesRepository.fnSelects(g_salesM, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCount(HttpContext context)
    {
        string sSize = g_salesRepository.fnCount(g_salesM);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnSelectOrderId(HttpContext context)
    {
        string sNUM = context.Request.QueryString["NUM"];
        string sMsg = "Y";
        string sOrderId = g_salesRepository.fnSelectOrderId(g_salesM, sNUM);

        if (sOrderId == " ")
        {
            sMsg = "訊息：已無下筆資料。";
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"order_id\":\"" + sOrderId + "\", \"NUM\":\"" + sNUM + "\"}");
    }

    public void fnSelect(HttpContext context)
    {
        DataTable dtData = g_salesRepository.fnSelect(g_salesM);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnInsert(HttpContext context)
    {
        string sMsg = fnCheckData(g_salesM);

        if (sMsg == "Y")
        {
            g_salesM.OrderId("P" + PublicApi.fnGetOrderNum(context, "A01"));
            sMsg = g_salesRepository.fnInsert(g_salesM);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"order_id\":\"" + g_salesM.order_id + "\"}");
    }

    public void fnUpdate(HttpContext context)
    {
        string sIP = PublicApi.fnRetrieveIP(context.Request);
        string sMsg = fnCheckData(g_salesM);
        string sOriginalComplete = g_salesRepository.fnSelect(g_salesM).Rows[0]["complete"].ToString();

        if (sMsg != "Y")
        {
            context.Response.Write("{ \"msg\":\"" + sMsg.Replace("\r\n", "") + "\" }");
            return;
        }

        sMsg = g_salesRepository.fnUpdate(g_salesM, sIP);
        if (sMsg != "Y")
        {
            context.Response.Write("{ \"msg\":\"" + sMsg.Replace("\r\n", "") + "\" }");
            return;
        }

        if (sOriginalComplete == "N" && g_salesM.complete == "Y")
        {
            fnUpdateStock(g_salesD);
        }

        context.Response.Write("{ \"msg\":\"" + sMsg.Replace("\r\n", "") + "\" }");
    }


    private void fnUpdateStock(SalesD salesD)
    {
        ProductStockRepository productStockRepository = new ProductStockRepository();
        DataTable dtData = g_salesRepository.fnSelects(g_salesD);

        for (int iIndex = 0; iIndex < dtData.Rows.Count; iIndex++)
        {
            ProductStock productStock = new ProductStock();
            productStock.ProductId(dtData.Rows[iIndex]["product_id"].ToString())
                         .WarehouseId(dtData.Rows[iIndex]["warehouse_id"].ToString())
                         .Amount("-" + dtData.Rows[iIndex]["amount"].ToString())
                         .CreateId(salesD.create_id);

            productStockRepository.fnUpdateAmount(productStock);
        }
    }

    public void fnDelete(HttpContext context)
    {
        string sMsg = "Y";
        string sIP = PublicApi.fnRetrieveIP(context.Request);

        sMsg = g_salesRepository.fnDelete(g_salesM, sIP);
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    public void fnSelectList(HttpContext context)
    {
        if (context.Session["id"] != null)
        {
            DataTable dtData = g_salesRepository.fnSelectList();
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    private string fnCheckData(SalesM sales)
    {
        string sMsg = "Y";
        return sMsg;
    }

    #endregion



    #region SalesDetails

    public void fnSelectsD(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];

        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);

            DataTable dtData = g_salesRepository.fnSelects(g_salesD, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCountD(HttpContext context)
    {
        string sSize = g_salesRepository.fnCount(g_salesD);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnInsertD(HttpContext context)
    {
        string sMsg = fnCheckInsert(g_salesD);

        if (sMsg == "Y")
        {
            string sSeq = g_salesRepository.fnGetSeq(g_salesD);
            g_salesD.Seq(sSeq);
            sMsg = g_salesRepository.fnInsert(g_salesD);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\": \"" + sMsg + "\" "
                            + ", \"seq\": \"" + g_salesD.seq + "\" "
                            + ", \"product_id\": \"" + g_salesD.product_id + "\" "
                            + ", \"warehouse_id\": \"" + g_salesD.warehouse_id + "\" "
                            + ", \"amount\": \"" + g_salesD.amount + "\" "
                            + ", \"price\": \"" + g_salesD.price + "\" "
                            + ", \"modify_amount\": \"" + g_salesD.amount + "\" "
                            + ", \"modify_price\": \"" + g_salesD.price + "\" "
                            + ", \"description\": \"" + g_salesD.description + "\" }");
    }

    public void fnInsertsD(HttpContext context)
    {
        string sMsg = "";
        string[] ProductIds = g_salesD.product_id.Split(',');
        string[] WarehouseIds = g_salesD.warehouse_id.Split(',');
        string[] sAmounts = g_salesD.amount.Split(',');
        string[] sPrices = g_salesD.price.Split(',');
        string[] sDescriptions = g_salesD.description.Split(',');

        for (int iIndex = 0; iIndex < ProductIds.Length; iIndex++)
        {
            string sInsertMsg = "Y";
            SalesD salesD = new SalesD();

            salesD.OrderId(g_salesD.order_id)
                    .ProductId(ProductIds[iIndex])
                    .WarehouseId(WarehouseIds[iIndex])
                    .Amount(sAmounts[iIndex])
                    .Price(sPrices[iIndex])
                    .Description(sDescriptions[iIndex])
                    .CreateId(g_salesD.create_id);
            sInsertMsg = fnCheckInsert(salesD);
            if (sInsertMsg == "Y")
            {
                string sSeq = g_salesRepository.fnGetSeq(salesD);
                salesD.Seq(sSeq);
                sInsertMsg = g_salesRepository.fnInsert(salesD);
                if (sInsertMsg != "Y")
                {
                    sMsg += salesD.product_id + "：" + sInsertMsg.Replace("\r\n", "") + "</br>";
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

    private string fnCheckInsert(SalesD salesD)
    {
        if (g_salesRepository.fnIsExist(salesD))
        {
            return "錯誤訊息：已有此筆資料。";
        }
        return fnCheckQuotesAmount(salesD); ;
    }

    public void fnUpdateD(HttpContext context)
    {
        string sMsg = "Y";

        sMsg = fnCheckUpdate(g_salesD);
        if (sMsg == "Y")
        {
            sMsg = g_salesRepository.fnUpdate(g_salesD);
            sMsg = sMsg.Replace("\r\n", "");
        }

        context.Response.Write("{ \"msg\": \"" + sMsg + "\" }");
    }

    public void fnUpdatesD(HttpContext context)
    {
        string sMsg = "";
        string[] sSeqs = g_salesD.seq.Split(',');
        string[] ProductIds = g_salesD.product_id.Split(',');
        string[] WarehouseIds = g_salesD.warehouse_id.Split(',');
        string[] sAmounts = g_salesD.amount.Split(',');
        string[] sPrices = g_salesD.price.Split(',');
        string[] sDescriptions = g_salesD.description.Split(',');

        for (int iIndex = 0; iIndex < ProductIds.Length; iIndex++)
        {
            string sUpdateMsg = "Y";
            SalesD salesD = new SalesD();

            salesD.OrderId(g_salesD.order_id)
                    .Seq(sSeqs[iIndex])
                    .ProductId(ProductIds[iIndex])
                    .WarehouseId(WarehouseIds[iIndex])
                    .Amount(sAmounts[iIndex])
                    .Price(sPrices[iIndex])
                    .Description(sDescriptions[iIndex])
                    .CreateId(g_salesD.create_id);

            sUpdateMsg = fnCheckUpdate(salesD);
            if (sUpdateMsg != "Y")
            {
                sMsg += sUpdateMsg + "</br>";
                continue;
            }

            sUpdateMsg = g_salesRepository.fnUpdate(salesD);
            if (sUpdateMsg != "Y")
            {
                sMsg += salesD.product_id + "：" + sUpdateMsg + "</br>";
            }

        }
        sMsg = sMsg.Length == 0 ? "Y" : sMsg.Replace("\r\n", "");
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    private string fnCheckUpdate(SalesD salesD)
    {
        string sMsg = fnCheckModify(salesD);
        if (sMsg != "Y")
        {
            return sMsg;
        }

        if (g_salesRepository.fnIsExist(salesD))
        {
            return "錯誤訊息：已有此筆資料。";
        }
        return fnCheckQuotesAmount(salesD);
    }


    public void fnDeleteD(HttpContext context)
    {
        string sMsg = "Y";

        sMsg = fnCheckModify(g_salesD);
        if (sMsg == "Y")
        {
            sMsg = g_salesRepository.fnDelete(g_salesD);
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    private string fnCheckModify(SalesD salesD)
    {
        DataTable dtData = g_salesRepository.fnSelect(g_salesM);

        if (dtData.Rows.Count == 1 && dtData.Rows[0]["complete"].ToString() == "Y")
        {
            return "訊息：已出貨不得編輯。";
        }
        return "Y";
    }

    private string fnCheckQuotesAmount(SalesD salesD)
    {

        QuotesRepository quotesRepository = new QuotesRepository();
        QuotesD quotesD = new QuotesD();
        quotesD.OrderId(salesD.order_id)
                 .ProductId(salesD.product_id);

        string sQuotesAmount = quotesRepository.fnSelectAmount(quotesD);
        double dQuotesAmount = double.Parse(sQuotesAmount);
        string sNowAmount = g_salesRepository.fnSelectExcludeAmount(salesD);
        double dNewAmount = (double.Parse(sNowAmount) + double.Parse(salesD.amount));

        if (dNewAmount > dQuotesAmount)
        {
            return "錯誤訊息：出貨數量大於報價數量。";
        }

        ProductStockRepository productStockRepository = new ProductStockRepository();
        ProductStock productStock = new ProductStock();
        productStock.ProductId(salesD.product_id)
                    .WarehouseId(salesD.warehouse_id);

        string sProductAmount = productStockRepository.fnSelectAmount(productStock);
        double dProductAmount = double.Parse(sProductAmount);

        if (dNewAmount > dProductAmount)
        {
            return "錯誤訊息：出貨數量大於庫存數量。";
        }

        return "Y";
    }

    #endregion


    #region SalesTran

    public void fnSelectsTran(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];
        int iPage = Convert.ToInt32(sPage);
        int iPageMaxSize = Convert.ToInt32(sPageMaxSize);
        SalesMTran salesMTran = new SalesMTran();

        salesMTran.OrderId(g_salesD.order_id);
        DataTable dtData = g_salesRepository.fnSelects(salesMTran, iPage, iPageMaxSize);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnCountTran(HttpContext context)
    {
        SalesMTran salesMTran = new SalesMTran();
        salesMTran.OrderId(g_salesD.order_id);
        string sSize = g_salesRepository.fnCount(salesMTran);
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