<%@ WebHandler Language="C#" Class="ProductStockHandler" %>

using System;
using System.Web;
using System.Data;

public class ProductStockHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    ProductStockRepository g_productStockRepository = new ProductStockRepository();
    ProductStock g_productStock = new ProductStock();

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string sMethod = context.Request.QueryString["method"];
        sMethod = (sMethod == null) ? context.Request.Form["method"] : sMethod;
        if (sMethod != null)
        {
            System.Reflection.MethodInfo methodInfo = this.GetType().GetMethod(sMethod);
            if (methodInfo != null)
            {
                fnInitData(context);
                methodInfo.Invoke(this, new object[] { context });
            }
        }
    }

    private void fnInitData(HttpContext context)
    {
        string sProductId = context.Request.QueryString["product_id"];
        string sWarehouseId = context.Request.QueryString["warehouse_id"];
        string sAmount = context.Request.QueryString["amount"];
        string sSafeAmount = context.Request.QueryString["safe_amount"];
        //string sDescription = context.Request.QueryString["description"];
        string sOrder = context.Request.QueryString["order"];

        g_productStock.ProductId(sProductId)
                       .WarehouseId(sWarehouseId)
                       .Amount(sAmount)
                       .SafeAmount(sSafeAmount)
                       .CreateId(context.Session["id"].ToString())
                       .Order(sOrder);
    }

    #region ProductStock

    public void fnSelects(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];

        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);
            DataTable dtData = g_productStockRepository.fnSelects(g_productStock, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCount(HttpContext context)
    {
        string sSize = g_productStockRepository.fnCount(g_productStock);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnSelect(HttpContext context)
    {
        DataTable dtData = g_productStockRepository.fnSelect(g_productStock);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnSelectNextId(HttpContext context)
    {
        string sNUM = context.Request.QueryString["NUM"];
        if (sNUM != null && sNUM.Length > 0)
        {
            string sMsg = "Y";
            DataTable dtData = g_productStockRepository.fnSelectStockId(g_productStock, sNUM);
            if (dtData.Rows.Count != 1)
            {
                context.Response.Write("{ \"msg\":\"訊息：已無下筆資料。\"}");
                return;
            }
            context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"warehouse_id\":\"" + dtData.Rows[0]["warehouse_id"] + "\", \"product_id\":\"" + dtData.Rows[0]["product_id"] + "\", \"NUM\":\"" + sNUM + "\"}");
        }
    }

    public void fnUpdate(HttpContext context)
    {
        string sMsg = fnCheckData(g_productStock);

        if (sMsg == "Y")
        {
            string sDescription = context.Request.QueryString["description"];
            string sIP = PublicApi.fnRetrieveIP(context.Request);

            sMsg = g_productStockRepository.fnUpdate(g_productStock, sDescription, sIP);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    //public void fnExport(HttpContext context)
    //{
    //    string sMsg = "Y";
    //    DataTable dtData = g_productStockRepository.fnExport(g_productStock);
    //    bool bCheck = PublicApi.fnExportDataTableToExcel(dtData, 0, "ProductStock", context);

    //    if (!bCheck)
    //    {
    //        sMsg = "錯誤訊息：匯出失敗。";
    //    }
    //    sMsg = sMsg.Replace("\r\n", "");
    //    context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    //}

    //public void fnReport(HttpContext context)
    //{
    //    string sMsg = "Y";
    //    DataTable dtData = g_productStockRepository.fnSelects(g_productStock);
    //    if (dtData.Rows.Count > 0)
    //    {
    //        context.Session["PrintDT"] = dtData;
    //    }
    //    else
    //    {
    //        sMsg = "錯誤訊息：筆數少於一筆。";
    //    }
    //    context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    //}

    //public void fnPrint(HttpContext context)
    //{
    //    DataTable dtData = g_productStockRepository.fnSelects(g_productStock);
    //    if (dtData.Rows.Count > 0)
    //    {
    //        context.Response.Write(PublicApi.fnGetJson(dtData));
    //    }
    //}

    //public void fnSelectList(HttpContext context)
    //{
    //    if (context.Session["id"] != null)
    //    {
    //        DataTable dtData = g_productStockRepository.fnSelectList();
    //        context.Response.Write(PublicApi.fnGetJson(dtData));
    //    }
    //}

    private string fnCheckData(ProductStock productStock)
    {
        string sMsg = "Y";

        return sMsg;
    }

    #endregion


    #region ProductStockTran

    public void fnSelectsTran(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];
        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);
            ProductStockTran productStockTran = new ProductStockTran();

            productStockTran.ProductId(g_productStock.product_id)
                             .WarehouseId(g_productStock.warehouse_id);
            DataTable dtData = g_productStockRepository.fnSelects(productStockTran, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCountTran(HttpContext context)
    {
        ProductStockTran productStockTran = new ProductStockTran();

        productStockTran.ProductId(g_productStock.product_id)
                         .WarehouseId(g_productStock.warehouse_id);
        string sSize = g_productStockRepository.fnCount(productStockTran);
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