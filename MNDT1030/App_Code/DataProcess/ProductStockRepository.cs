using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// AccountRepository 的摘要描述
/// </summary>
public class ProductStockRepository
{
    public ProductStockRepository()
    {
    }

    #region ProductStock

    // sNum 排行
    public DataTable fnSelectStockId(ProductStock productStock, string sNum)
    {
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[product_id]", productStock.product_id);
        sCondition += PublicApi.fnAddCondition("[warehouse_id]", productStock.warehouse_id);

        string sSql = "  SELECT [productStock].[product_id]  " +
                        "       ,[productStock].[warehouse_id]  " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + productStock.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTproduct_stock]   " +
                        "          WHERE  1 = 1" + sCondition + ") AS [productStock]  " +
                        "  WHERE [productStock].[NUM] = '" + sNum + "' ";
        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    public DataTable fnSelect(ProductStock productStock)
    {
        string sSql = "  SELECT TOP 1 * " +
                        "  FROM   [MNDTproduct_stock] [productStock]  " +
                        "  WHERE [productStock].[product_id] = '" + productStock.product_id + "' ";
        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(ProductStock productStock, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[product_id]", productStock.product_id);
        sCondition += PublicApi.fnAddCondition("[warehouse_id]", productStock.warehouse_id);

        string sInquireSql =
                        "  SELECT [productStock].[product_id],   " +
                        "         [productStock].[warehouse_id],   " +
                        "         [productStock].[amount],   " +
                        "         [productStock].[safe_amount],   " +
                        "         [productStock].[NUM]   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + productStock.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTproduct_stock]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [productStock]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnSelects(ProductStock productStock)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[product_id]", productStock.product_id);
        sCondition += PublicApi.fnAddCondition("[warehouse_id]", productStock.warehouse_id);
        sCondition += " ORDER BY [" + productStock.order + "] ";
        string sInquireSql =
                        "  SELECT *  " +
                        "  FROM MNDTproduct_stock  " +
                        "  WHERE 1 = 1 " + sCondition;
        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnSelectAmount(ProductStock productStock)
    {
        string sSql = "  SELECT ISNULL(SUM([amount]), '0')  " +
                        "  FROM [MNDTproduct_stock]  " +
                        "  WHERE [warehouse_id] = '" + productStock.warehouse_id + "' " +
                        "   AND [product_id] = '" + productStock.product_id + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    //public DataTable fnExport(ProductStock productStock)
    //{
    //    string sCondition = "";
    //    sCondition += PublicApi.fnAddCondition("[product_id]", productStock.product_id);
    //    sCondition += PublicApi.fnAddCondition("[name]", productStock.name);
    //    sCondition += PublicApi.fnAddCondition("[status]", productStock.status);
    //    sCondition += " ORDER BY [" + productStock.order + "] ";
    //    string sInquireSql =
    //                    "  SELECT [productStock].[product_id] '編號',   " +
    //                    "         [productStock].[company_id] '公司ID',   " +
    //                    "         [productStock].[name] '名子',   " +
    //                    "         [productStock].[unit] '單位',   " +
    //                    "         [productStock].[currency] '貨幣',  " +
    //                    "         [productStock].[price] '價格',  " +
    //                    "         [productStock].[shelf_life] '期限',  " +
    //                    "         [productStock].[description] '描述',  " +
    //                    "         [productStock].[status] '狀態'  " +
    //                    "  FROM MNDTproduct_stock AS [productStock]  " +
    //                    "  WHERE 1 = 1 " + sCondition;
    //    return PublicApi.fnGetDt(sInquireSql, "MNDT");
    //}

    public string fnInsert(ProductStock productStock)
    {
        string sSql =
                        "  INSERT INTO [dbo].[MNDTproduct_stock]  " +
                        "             ([product_id]  " +
                        "             ,[warehouse_id]  " +
                        "             ,[amount]  " +
                        "             ,[safe_amount]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "  VALUES  " +
                        "             ('" + productStock.product_id + "' " +
                        "             ,'" + productStock.warehouse_id + "' " +
                        "             ,'0' " +
                        "             ,'0' " +
                        "             ,'" + productStock.create_id + "' " +
                        "             ,GETDATE())  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnUpdateAmount(ProductStock productStock)
    {
        string sSql = fnUpdateAmountSql(productStock);
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnUpdateAmountSql(ProductStock productStock)
    {
        ProductStockTran productStockTran = new ProductStockTran();
        productStockTran.WarehouseId(productStock.warehouse_id)
                         .ProductId(productStock.product_id)
                         .Description("系統進出貨正常變更")
                         .CreateId(productStock.create_id);

        string sSql = fnInsertSql(productStockTran);
        sSql +=
                "  UPDATE [dbo].[MNDTproduct_stock]  " +
                "     SET [amount] = [amount] + " + productStock.amount + "  " +
                "  WHERE [product_id] = '" + productStock.product_id + "' " +
                "        AND [warehouse_id] = '" + productStock.warehouse_id + "'  ";

        return sSql;
    }

    public string fnUpdate(ProductStock productStock, string sDescription, string sIP)
    {
        ProductStockTran productStockTran = new ProductStockTran();
        productStockTran.WarehouseId(productStock.warehouse_id)
                         .ProductId(productStock.product_id)
                         .Description(sDescription)
                         .CreateId(productStock.create_id);

        string sSql = fnInsertSql(productStockTran);

        sSql +=
               "  UPDATE [dbo].[MNDTproduct_stock]  " +
               "     SET [amount] = '" + productStock.amount + "'  " +
               "        ,[safe_amount] =  '" + productStock.safe_amount + "'  " +
               "  WHERE [product_id] = '" + productStock.product_id + "' " +
               "        AND [warehouse_id] = '" + productStock.warehouse_id + "'  ";

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    //public string fnDelete(ProductStock productStock, string sIP, string sId)
    //{
    //    string sSql = " UPDATE [dbo].[MNDTproduct_stock] " +
    //                    "       SET [status] = 'D' " +
    //                    " WHERE [product_id] = '" + productStock.product_id + "' ";
    //    ProductStockTran productStockTran = new ProductStockTran();

    //    productStockTran.ProductStockId(productStock.product_id)
    //                .IP(sIP)
    //                .Status("D")
    //                .CreateId(sId);
    //    sSql += fnInsertSql(productStockTran);

    //    return PublicApi.fnExecuteSQL(sSql, "MNDT");
    //}

    //public string fnDeletes(ProductStock productStock, string sIP, string sId)
    //{
    //    string sSql = " UPDATE [dbo].[MNDTproduct_stock] " +
    //                    "       SET [status] = 'D' " +
    //                    " WHERE [product_id] IN (" + productStock.product_id + ")";
    //    ProductStockTran productStockTran = new ProductStockTran();

    //    productStockTran.ProductStockId(productStock.product_id)
    //                .IP(sIP)
    //                .Status("D")
    //                .CreateId(sId);
    //    sSql += fnInsertsSql(productStockTran);

    //    return PublicApi.fnExecuteSQL(sSql, "MNDT");
    //}

    public string fnCount(ProductStock productStock)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[product_id]", productStock.product_id);
        sCondition += PublicApi.fnAddCondition("[warehouse_id]", productStock.warehouse_id);

        string sCountSql =
                        "          SELECT COUNT(product_id)   " +
                        "          FROM   [MNDTproduct_stock]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    public bool fnIsExist(ProductStock productStock)
    {
        string sSql = "  SELECT COUNT([product_id])   " +
                        "  FROM   [MNDTproduct_stock]   " +
                        "  WHERE  [product_id] = '" + productStock.product_id + "'   " +
                        "       AND [warehouse_id] = '" + productStock.warehouse_id + "'   ";
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }

    #endregion



    #region ProductStockTran

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(ProductStockTran productStockTran, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[product_id]", productStockTran.product_id);
        sCondition += PublicApi.fnAddCondition("[warehouse_id]", productStockTran.warehouse_id);
        string sInquireSql =
                        "  SELECT [product_s].[tran_amount],   " +
                        "         [product_s].[description],   " +
                        "         [product_s].[create_id],   " +
                        "         CONVERT(char, [product_s].[create_datetime], 120) 'create_datetime'   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [create_datetime] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTproduct_stock_tran]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [product_s]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    private string fnInsertSql(ProductStockTran productStockTran)
    {
        string sSql =
                    "  INSERT INTO [MNDTproduct_stock_tran]   " +
                    "              ([warehouse_id],   " +
                    "               [product_id],   " +
                    "               [tran_amount],   " +
                    "               [description],   " +
                    "               [create_id],   " +
                    "               [create_datetime])   " +
                    "  SELECT [warehouse_id],   " +
                    "         [product_id],   " +
                    "         [amount],   " +
                    "         '" + productStockTran.description + "',   " +
                    "         '" + productStockTran.create_id + "',   " +
                    "         GETDATE()  " +
                    "  FROM   [MNDTproduct_stock]   " +
                    "  WHERE  [warehouse_id] = '"+ productStockTran.warehouse_id + "'   " +
                    "         AND [product_id] = '" + productStockTran.product_id + "'   ";
        return sSql;
    }

    //private string fnInsertsSql(ProductStockTran productStockTran)
    //{
    //    string sSql =
    //                    "  INSERT INTO [MNDTproduct_stock_tran]  " +
    //                    "             ([product_id]  " +
    //                    "             ,[ip]  " +
    //                    "             ,[status]  " +
    //                    "             ,[create_id]  " +
    //                    "             ,[create_datetime])  " +
    //                    "  SELECT [product_id]  " +
    //                    "        , '" + productStockTran + "'  " +
    //                    "        , '" + productStockTran.status + "'  " +
    //                    "        , '" + productStockTran.create_id + "'  " +
    //                    "        , GETDATE()  " +
    //                    "  FROM [MNDTproduct_stock]  " +
    //                    " WHERE [product_id] IN (" + productStockTran.product_id + ")";
    //    return sSql;
    //}

    public string fnCount(ProductStockTran productStockTran)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[product_id]", productStockTran.product_id);
        sCondition += PublicApi.fnAddCondition("[warehouse_id]", productStockTran.warehouse_id);
        string sCountSql =
                        "          SELECT COUNT(product_id)   " +
                        "          FROM   [MNDTproduct_stock_tran]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    #endregion

    //public DataTable fnSelectList()
    //{
    //    string sSql =
    //                    "  SELECT [productStock].[product_id] [value],   " +
    //                    "         [productStock].[name]   " +
    //                    "  FROM MNDTproduct_stock AS [productStock]  " +
    //                    "  WHERE [productStock].[status] <> 'D' ";

    //    return PublicApi.fnGetDt(sSql, "MNDT");
    //}
}