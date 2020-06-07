<%@ WebHandler Language="C#" Class="MaterialHandler" %>

using System;
using System.Web;
using System.Data;

public class MaterialHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    MaterialRepository g_materialRepository = new MaterialRepository();
    Material g_material = new Material();

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
        string sCompanyId = context.Request.QueryString["company_id"];
        string sName = context.Request.QueryString["name"];
        string sUnit = context.Request.QueryString["unit"];
        string sCurrency = context.Request.QueryString["currency"];
        string sPrice = PublicApi.fnNullChange(context.Request.QueryString["price"], "0");
        string sShelfLife = PublicApi.fnNullChange(context.Request.QueryString["shelf_life"], "0");
        string sDescription = context.Request.QueryString["description"];
        string sStatus = context.Request.QueryString["status"];
        string sOrder = context.Request.QueryString["order"];

        g_material.MaterialId(sMaterialId)
                  .CompanyId(sCompanyId)
                  .Name(sName)
                  .Unit(sUnit)
                  .Currency(sCurrency)
                  .Price(sPrice)
                  .ShelfLife(sShelfLife)
                  .Description(sDescription)
                  .Status(sStatus)
                  .CreateId(context.Session["id"].ToString())
                  .Order(sOrder);
    }

    #region Material

    public void fnSelects(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];

        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);
            DataTable dtData = g_materialRepository.fnSelects(g_material, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCount(HttpContext context)
    {
        string sSize = g_materialRepository.fnCount(g_material);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnSelect(HttpContext context)
    {
        DataTable dtData = g_materialRepository.fnSelect(g_material);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnSelectPrice(HttpContext context)
    {
        string sMsg = "Y";
        double dPrice = 0.0d;
        double dAmount = 0.0d;
        string sAmount = context.Request.QueryString["amount"];
        if (double.TryParse(sAmount, out dAmount))
        {
            DataTable dtData = g_materialRepository.fnSelect(g_material);
            if (dtData.Rows.Count == 1)
            {
                dPrice = double.Parse(dtData.Rows[0]["price"].ToString()) * dAmount;
            }
        }
        else
        {
            sMsg = "錯誤訊息：數值錯誤。";
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"price\":\"" + dPrice + "\"}");
    }

    public void fnSelectMaterialId(HttpContext context)
    {
        string sNUM = context.Request.QueryString["NUM"];
        if (sNUM != null && sNUM.Length > 0)
        {
            string sMsg = "Y";
            string sMaterialId = g_materialRepository.fnSelectMaterialId(g_material, sNUM);
            if (sMaterialId == " ")
            {
                sMsg = "訊息：已無下筆資料。";
            }
            context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"material_id\":\"" + sMaterialId + "\", \"NUM\":\"" + sNUM + "\"}");
        }
    }



    public void fnInsert(HttpContext context)
    {
        string sMsg = fnCheckData(g_material);

        if (sMsg == "Y")
        {
            sMsg = g_materialRepository.fnInsert(g_material);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"material_id\":\"" + g_material.material_id + "\"}");
    }

    public void fnUpdate(HttpContext context)
    {
        string sMsg = fnCheckData(g_material);

        if (sMsg == "Y")
        {
            string sIP = PublicApi.fnRetrieveIP(context.Request);

            sMsg = g_materialRepository.fnUpdate(g_material, sIP, context.Session["id"].ToString());
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    public void fnDelete(HttpContext context)
    {
        string sMsg = "Y";
        string sIP = PublicApi.fnRetrieveIP(context.Request);

        sMsg = g_materialRepository.fnDelete(g_material, sIP, context.Session["id"].ToString());
        sMsg = sMsg.Replace("\r\n", "");
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    public void fnDeletes(HttpContext context)
    {
        string sMsg = "Y";
        string sIP = PublicApi.fnRetrieveIP(context.Request);

        sMsg = g_materialRepository.fnDeletes(g_material, sIP, context.Session["id"].ToString());
        sMsg = sMsg.Replace("\r\n", "");
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    public void fnExport(HttpContext context)
    {
        string sMsg = "Y";
        DataTable dtData = g_materialRepository.fnExport(g_material);
        bool bCheck = PublicApi.fnExportDataTableToExcel(dtData, 0, "Material", context);

        if (!bCheck)
        {
            sMsg = "錯誤訊息：匯出失敗。";
        }
        sMsg = sMsg.Replace("\r\n", "");
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    public void fnReport(HttpContext context)
    {
        string sMsg = "Y";
        DataTable dtData = g_materialRepository.fnSelects(g_material);
        if (dtData.Rows.Count > 0)
        {
            context.Session["PrintDT"] = dtData;
        }
        else
        {
            sMsg = "錯誤訊息：筆數少於一筆。";
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    public void fnPrint(HttpContext context)
    {
        DataTable dtData = g_materialRepository.fnSelects(g_material);
        if (dtData.Rows.Count > 0)
        {
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnSelectList(HttpContext context)
    {
        if (context.Session["id"] != null)
        {
            DataTable dtData = g_materialRepository.fnSelectList();
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    private string fnCheckData(Material material)
    {
        string sMsg = "Y";
        KindRepository kindRepository = new KindRepository();
        KindD kindD = new KindD();
        kindD.KindId("C1")
             .CodeId(material.company_id);
        if (material.material_id.Length < 1)
        {
            sMsg = "錯誤訊息：材料ID驗證錯誤。";
        }
        else if (material.company_id.Length > 5)
        {
            sMsg = "錯誤訊息：公司錯誤。";
        }
        else if (material.name.Length > 15)
        {
            sMsg = "錯誤訊息：名稱長度錯誤。";
        }
        else if (material.unit.Length > 5)
        {
            sMsg = "錯誤訊息：單位長度錯誤。";
        }
        else if (material.currency.Length > 5)
        {
            sMsg = "錯誤訊息：貨幣長度錯誤。";
        }
        else if (material.shelf_life.Length > 3)
        {
            sMsg = "錯誤訊息：期限長度錯誤。";
        }
        else if (material.description.Length > 50)
        {
            sMsg = "錯誤訊息：描述長度錯誤。";
        }
        return sMsg;
    }

    #endregion


    #region MaterialTran

    public void fnSelectsTran(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];
        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);
            MaterialTran materialTran = new MaterialTran();

            materialTran.MaterialId(g_material.material_id);
            DataTable dtData = g_materialRepository.fnSelects(materialTran, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCountTran(HttpContext context)
    {
        MaterialTran materialTran = new MaterialTran();

        materialTran.MaterialId(g_material.material_id);
        string sSize = g_materialRepository.fnCount(materialTran);
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