<%@ WebHandler Language="C#" Class="MaterialStockHandler" %>

using System;
using System.Web;
using System.Data;

public class MaterialStockHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    MaterialStockRepository g_materialStockRepository = new MaterialStockRepository();
    MaterialStock g_materialStock = new MaterialStock();

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
        string sMaterialId = context.Request.QueryString["material_id"];
        string sWarehouseId = context.Request.QueryString["warehouse_id"];
        string sAmount = context.Request.QueryString["amount"];
        string sSafeAmount = context.Request.QueryString["safe_amount"];
        //string sDescription = context.Request.QueryString["description"];
        string sOrder = context.Request.QueryString["order"];

        g_materialStock.MaterialId(sMaterialId)
                       .WarehouseId(sWarehouseId)
                       .Amount(sAmount)
                       .SafeAmount(sSafeAmount)
                       .CreateId(context.Session["id"].ToString())
                       .Order(sOrder);
    }

    #region MaterialStock

    public void fnSelects(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];

        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);
            DataTable dtData = g_materialStockRepository.fnSelects(g_materialStock, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCount(HttpContext context)
    {
        string sSize = g_materialStockRepository.fnCount(g_materialStock);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnSelect(HttpContext context)
    {
        DataTable dtData = g_materialStockRepository.fnSelect(g_materialStock);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnSelectNextId(HttpContext context)
    {
        string sNUM = context.Request.QueryString["NUM"];
        if (sNUM != null && sNUM.Length > 0)
        {
            string sMsg = "Y";
            DataTable dtData = g_materialStockRepository.fnSelectStockId(g_materialStock, sNUM);
            if (dtData.Rows.Count != 1)
            {
                context.Response.Write("{ \"msg\":\"訊息：已無下筆資料。\"}");
                return;
            }
            context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"warehouse_id\":\"" + dtData.Rows[0]["warehouse_id"] + "\", \"material_id\":\"" + dtData.Rows[0]["material_id"] + "\", \"NUM\":\"" + sNUM + "\"}");
        }
    }

    public void fnUpdate(HttpContext context)
    {
        string sMsg = fnCheckData(g_materialStock);

        if (sMsg == "Y")
        {
            string sDescription = context.Request.QueryString["description"];
            string sIP = PublicApi.fnRetrieveIP(context.Request);

            sMsg = g_materialStockRepository.fnUpdate(g_materialStock, sDescription, sIP);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    //public void fnExport(HttpContext context)
    //{
    //    string sMsg = "Y";
    //    DataTable dtData = g_materialStockRepository.fnExport(g_materialStock);
    //    bool bCheck = PublicApi.fnExportDataTableToExcel(dtData, 0, "MaterialStock", context);

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
    //    DataTable dtData = g_materialStockRepository.fnSelects(g_materialStock);
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
    //    DataTable dtData = g_materialStockRepository.fnSelects(g_materialStock);
    //    if (dtData.Rows.Count > 0)
    //    {
    //        context.Response.Write(PublicApi.fnGetJson(dtData));
    //    }
    //}

    //public void fnSelectList(HttpContext context)
    //{
    //    if (context.Session["id"] != null)
    //    {
    //        DataTable dtData = g_materialStockRepository.fnSelectList();
    //        context.Response.Write(PublicApi.fnGetJson(dtData));
    //    }
    //}

    private string fnCheckData(MaterialStock materialStock)
    {
        string sMsg = "Y";

        return sMsg;
    }

    #endregion


    #region MaterialStockTran

    public void fnSelectsTran(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];
        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);
            MaterialStockTran materialStockTran = new MaterialStockTran();

            materialStockTran.MaterialId(g_materialStock.material_id)
                             .WarehouseId(g_materialStock.warehouse_id);
            DataTable dtData = g_materialStockRepository.fnSelects(materialStockTran, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCountTran(HttpContext context)
    {
        MaterialStockTran materialStockTran = new MaterialStockTran();

        materialStockTran.MaterialId(g_materialStock.material_id)
                         .WarehouseId(g_materialStock.warehouse_id);
        string sSize = g_materialStockRepository.fnCount(materialStockTran);
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