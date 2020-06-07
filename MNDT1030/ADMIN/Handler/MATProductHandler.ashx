<%@ WebHandler Language="C#" Class="MATProductHandler" %>

using System;
using System.Web;
using System.Data;

public class MATProductHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        string sMethod = context.Request.QueryString["method"];
        sMethod = (sMethod == null) ? context.Request.Form["method"] : sMethod;

        if (sMethod == null)
        {
            return;
        }

        System.Reflection.MethodInfo methodInfo = this.GetType().GetMethod(sMethod);
        if (methodInfo == null)
        {
            return;
        }

        methodInfo.Invoke(this, new object[] { context });
    }


    #region Material

    public void fnSelect(HttpContext context)
    {
        string sProductId = context.Request.QueryString["product_id"];
        string sAmount = context.Request.QueryString["amount"];
        DataTable dtAllMaterialData = null;
        DataTable dtData = fnGetEmptyTable();
        ProductRepository productRepository = new ProductRepository();
        ProductD productD = new ProductD();
        MaterialStockRepository materialStockRepository = new MaterialStockRepository();
        MaterialStock materialStock = new MaterialStock();

        productD.ProductId(sProductId);
        dtAllMaterialData = productRepository.fnSelectMaterial(productD, sAmount);

        for (int iMATIndex = 0; iMATIndex < dtAllMaterialData.Rows.Count; iMATIndex++)
        {
            string sMaterialId = dtAllMaterialData.Rows[iMATIndex]["material_id"].ToString();
            double dMaxAmount = 0;
            DataTable stockData = null;

            materialStock.MaterialId(sMaterialId);
            stockData = materialStockRepository.fnSelectStocks(materialStock);
            dMaxAmount = double.Parse(dtAllMaterialData.Rows[iMATIndex]["amount"].ToString());

            for (int iStockIndex = 0; dMaxAmount > 0 && iStockIndex < stockData.Rows.Count; iStockIndex++)
            {
                DataRow drData = dtData.NewRow();
                double dAmount = double.Parse(stockData.Rows[iStockIndex]["amount"].ToString());

                drData["material_id"] = sMaterialId;
                drData["warehouse_id"] = stockData.Rows[iStockIndex]["warehouse_id"].ToString();

                if (dAmount >= dMaxAmount)
                {
                    drData["amount"] = dMaxAmount.ToString();
                    dMaxAmount = 0;
                }
                else
                {
                    drData["amount"] = dAmount.ToString();
                    dMaxAmount -= dAmount;
                }

                dtData.Rows.Add(drData);
            }

            if (dMaxAmount != 0)
            {
                return;
            }
        }
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnSelectTotal(HttpContext context)
    {
        string sProductId = context.Request.QueryString["product_id"];
        string sAmount = context.Request.QueryString["amount"];
        DataTable dtAllMaterialData = fnGetAllMaterialData(sProductId, sAmount);

        context.Response.Write(PublicApi.fnGetJson(dtAllMaterialData));
    }

    public void fnChange(HttpContext context)
    {
        PublicApi.fnReadLoginCookie(context);
        string sId = context.Session["id"].ToString();
        string sProductId = context.Request.Form["product_id"];
        string sWarehouseId = context.Request.Form["warehouse_id"];
        string sAmount = context.Request.Form["amount"];
        string[] sMaterialIds = context.Request.Form["material_ids"].Split(',');
        string[] sWarehouseIds = context.Request.Form["warehouse_ids"].Split(',');
        string[] sAmounts = context.Request.Form["amounts"].Split(',');
        string sSql = "";
        DataTable dtAllMaterialData = fnGetAllMaterialData(sProductId, sAmount);
        DataColumn dcData = new System.Data.DataColumn("now_amount");

        dcData.DefaultValue = 0;
        dtAllMaterialData.Columns.Add(dcData);
        dtAllMaterialData.PrimaryKey = new DataColumn[] { dtAllMaterialData.Columns["material_id"] };

        for (int iIndex = 0; iIndex < sMaterialIds.Length; iIndex++)
        {
            DataRow drData = dtAllMaterialData.Rows.Find(sMaterialIds[iIndex]);
            int iPos = dtAllMaterialData.Rows.IndexOf(drData);

            dtAllMaterialData.Rows[iPos]["now_amount"] = Convert.ToDouble(dtAllMaterialData.Rows[iPos]["now_amount"])
                                                        + Convert.ToDouble(sAmounts[iIndex]);

            MaterialStockRepository materialStockRepository = new MaterialStockRepository();
            MaterialStock materialStock = new MaterialStock();
            materialStock.MaterialId(sMaterialIds[iIndex])
                         .WarehouseId(sWarehouseIds[iIndex])
                         .Amount("-" + sAmounts[iIndex])
                         .CreateId(sId);

            sSql += materialStockRepository.fnUpdateAmountSql(materialStock);
        }

        for (int iIndex = 0; iIndex < dtAllMaterialData.Rows.Count; iIndex++)
        {
            double dAmount = Convert.ToDouble(dtAllMaterialData.Rows[iIndex]["amount"].ToString());
            double dNowAmount = Convert.ToDouble(dtAllMaterialData.Rows[iIndex]["now_amount"].ToString());

            if (dAmount != dNowAmount)
            {
                context.Response.Write("{ \"msg\":\"錯誤訊息：材料ID " + dtAllMaterialData.Rows[iIndex]["material_id"].ToString() + " 數量有問題。\"}");
                return;
            }
        }

        ProductStockRepository productStockRepository = new ProductStockRepository();
        ProductStock productStock = new ProductStock();
        productStock.ProductId(sProductId)
                     .WarehouseId(sWarehouseId)
                     .Amount(sAmount)
                     .CreateId(sId);
        if (!productStockRepository.fnIsExist(productStock))
        {
            productStockRepository.fnInsert(productStock);
        }

        sSql += productStockRepository.fnUpdateAmountSql(productStock);

        context.Response.Write("{ \"msg\":\"" + PublicApi.fnExecuteSQL(sSql, "MNDT") + "\"}");

    }


    private DataTable fnGetAllMaterialData(string sProductId, string sAmount)
    {
        DataTable dtData = new DataTable();
        ProductRepository productRepository = new ProductRepository();
        ProductD productD = new ProductD();

        productD.ProductId(sProductId);
        return productRepository.fnSelectMaterial(productD, sAmount);
    }

    private DataTable fnGetEmptyTable()
    {
        DataTable dtData = new DataTable();

        dtData.Columns.Add("material_id");
        dtData.Columns.Add("warehouse_id");
        dtData.Columns.Add("amount");

        return dtData;
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