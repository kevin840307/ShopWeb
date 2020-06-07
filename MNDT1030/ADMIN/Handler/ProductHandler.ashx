<%@ WebHandler Language="C#" Class="ProductHandler" %>

using System;
using System.Web;
using System.Data;

public class ProductHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    ProductRepository g_productRepository = new ProductRepository();
    ProductM g_productM = new ProductM();
    ProductD g_productD = new ProductD();

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string sMethod = context.Request.QueryString["method"];
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
        string sMaterialId = context.Request.QueryString["material_id"];
        string sCompanyId = context.Request.QueryString["company_id"];
        string sName = context.Request.QueryString["name"];
        string sUnit = context.Request.QueryString["unit"];
        string sCurrency = context.Request.QueryString["currency"];
        string sAmount = PublicApi.fnNullChange(context.Request.QueryString["amount"], "0");
        string sCost = PublicApi.fnNullChange(context.Request.QueryString["cost"], "0");
        string sPrice = PublicApi.fnNullChange(context.Request.QueryString["price"], "0");
        string sShelfLife = PublicApi.fnNullChange(context.Request.QueryString["shelf_life"], "0");
        string sDescription = context.Request.QueryString["description"];
        string sStatus = context.Request.QueryString["status"];
        string sOrder = context.Request.QueryString["order"];

        g_productM.ProductId(sProductId)
                  .CompanyId(sCompanyId)
                  .Name(sName)
                  .Unit(sUnit)
                  .Currency(sCurrency)
                  .Cost(sCost)
                  .Price(sPrice)
                  .ShelfLife(sShelfLife)
                  .Description(sDescription)
                  .Status(sStatus)
                  .CreateId(context.Session["id"].ToString())
                  .Order(sOrder);

        g_productD.ProductId(sProductId)
                  .MaterialId(sMaterialId)
                  .Amount(sAmount)
                  .CreateId(context.Session["id"].ToString());
    }


    #region ProductMaster

    public void fnSelects(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];
        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);
            DataTable dtData = g_productRepository.fnSelects(g_productM, iPage, iPageMaxSize);

            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnSelectPrice(HttpContext context)
    {
        string sMsg = "Y";
        double dPrice = 0.0d;
        double dAmount = 0.0d;
        string sAmount = context.Request.QueryString["amount"];
        if (double.TryParse(sAmount, out dAmount))
        {
            DataTable dtData = g_productRepository.fnSelect(g_productM);
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

    public void fnCount(HttpContext context)
    {
        string sSize = g_productRepository.fnCount(g_productM);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnSelectProductId(HttpContext context)
    {
        string sMsg = "Y";
        string sNUM = context.Request.QueryString["NUM"];
        string sProductId = g_productRepository.fnSelectProductId(g_productM, sNUM);

        if (sProductId == " ")
        {
            sMsg = "訊息：已無下筆資料。";
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"product_id\":\"" + sProductId + "\", \"NUM\":\"" + sNUM + "\"}");

    }

    public void fnSelect(HttpContext context)
    {
        DataTable dtData = g_productRepository.fnSelect(g_productM);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnSelectList(HttpContext context)
    {
        if (context.Session["id"] != null)
        {
            DataTable dtData = g_productRepository.fnSelectList();
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnInsert(HttpContext context)
    {
        string sMsg = fnCheckData(g_productM);

        if (sMsg == "Y")
        {
            sMsg = g_productRepository.fnInsert(g_productM);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"product_id\":\"" + g_productM.product_id + "\"}");
    }

    public void fnUpdate(HttpContext context)
    {
        string sMsg = fnCheckData(g_productM);
        string sIP = PublicApi.fnRetrieveIP(context.Request);

        if (sMsg == "Y")
        {
            sMsg = g_productRepository.fnUpdate(g_productM, sIP);
            sMsg = sMsg.Replace("\r\n", "");
        }

        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    public void fnDelete(HttpContext context)
    {
        string sMsg = "Y";
        string sIP = PublicApi.fnRetrieveIP(context.Request);

        sMsg = g_productRepository.fnDelete(g_productM, sIP);
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    private string fnCheckData(ProductM product)
    {
        string sMsg = "Y";
        if (product.product_id.Length < 1)
        {
            sMsg = "錯誤訊息：ID驗證錯誤。";
        }
        return sMsg;
    }

    #endregion



    #region ProductDetails

    public void fnSelectsD(HttpContext context)
    {
        DataTable dtData = g_productRepository.fnSelects(g_productD);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnCountD(HttpContext context)
    {
        string sSize = g_productRepository.fnCount(g_productD);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnInsertD(HttpContext context)
    {
        string sMsg = fnCheckData(g_productD);

        if (sMsg == "Y")
        {
            sMsg = g_productRepository.fnInsert(g_productD);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    public void fnUpdateD(HttpContext context)
    {
        string sMsg = fnCheckData(g_productD);

        if (sMsg == "Y")
        {
            sMsg = g_productRepository.fnUpdate(g_productD);
            sMsg = sMsg.Replace("\r\n", "");
        }

        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    public void fnDeleteD(HttpContext context)
    {
        string sMsg = "Y";

        sMsg = g_productRepository.fnDelete(g_productD);
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    private string fnCheckData(ProductD product)
    {
        string sMsg = "Y";
        MaterialRepository materialRepository = new MaterialRepository();
        Material materia = new Material();
        materia.MaterialId(g_productD.material_id);
        if (product.product_id.Length < 1 || !g_productRepository.fnIsExist(g_productM))
        {
            sMsg = "錯誤訊息：產品 ID驗證錯誤。";
        }
        else if (product.material_id.Length < 1 || !materialRepository.fnIsExist(materia))
        {
            sMsg = "錯誤訊息：材料 ID驗證錯誤。";
        }
        return sMsg;
    }

    #endregion


    #region ProductMTran

    public void fnSelectsTran(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];
        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);
            ProductMTran productMTran = new ProductMTran();

            productMTran.ProductId(g_productM.product_id);
            DataTable dtData = g_productRepository.fnSelects(productMTran, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCountTran(HttpContext context)
    {
        string sId = context.Request.QueryString["id"];
        ProductMTran productMTran = new ProductMTran();

        productMTran.ProductId(g_productM.product_id);
        string sSize = g_productRepository.fnCount(productMTran);
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