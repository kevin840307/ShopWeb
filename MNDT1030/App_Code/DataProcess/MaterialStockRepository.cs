using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// AccountRepository 的摘要描述
/// </summary>
public class MaterialStockRepository
{
    public MaterialStockRepository()
    {
    }

    #region MaterialStock

    // sNum 排行
    public DataTable fnSelectStockId(MaterialStock materialStock, string sNum)
    {
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[material_id]", materialStock.material_id);
        sCondition += PublicApi.fnAddCondition("[warehouse_id]", materialStock.warehouse_id);

        string sSql = "  SELECT [materialStock].[material_id]  " +
                        "       ,[materialStock].[warehouse_id]  " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + materialStock.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTmaterial_stock]   " +
                        "          WHERE  1 = 1" + sCondition + ") AS [materialStock]  " +
                        "  WHERE [materialStock].[NUM] = '" + sNum + "' ";
        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    public DataTable fnSelect(MaterialStock materialStock)
    {
        string sSql = "  SELECT TOP 1 * " +
                        "  FROM   [MNDTmaterial_stock] [materialStock]  " +
                        "  WHERE [materialStock].[material_id] = '" + materialStock.material_id + "' " +
                        "       AND [materialStock].[warehouse_id] = '" + materialStock.warehouse_id + "' ";
        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(MaterialStock materialStock, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[material_id]", materialStock.material_id);
        sCondition += PublicApi.fnAddCondition("[warehouse_id]", materialStock.warehouse_id);

        string sInquireSql =
                        "  SELECT [materialStock].[material_id],   " +
                        "         [materialStock].[warehouse_id],   " +
                        "         [materialStock].[amount],   " +
                        "         [materialStock].[safe_amount],   " +
                        "         [materialStock].[NUM]   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + materialStock.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTmaterial_stock]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [materialStock]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnSelects(MaterialStock materialStock)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[material_id]", materialStock.material_id);
        sCondition += PublicApi.fnAddCondition("[warehouse_id]", materialStock.warehouse_id);
        sCondition += " ORDER BY [" + materialStock.order + "] ";
        string sInquireSql =
                        "  SELECT *  " +
                        "  FROM MNDTmaterial_stock  " +
                        "  WHERE 1 = 1 " + sCondition;
        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnSelectStocks(MaterialStock materialStock)
    {
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[material_id]", materialStock.material_id);
        sCondition += " AND [material_s].[amount] <> 0 ";
        sCondition += " ORDER BY [parameter] ";

        string sInquireSql =
                        "  SELECT [material_s].[warehouse_id],   " +
                        "         [material_s].[amount]   " +
                        "  FROM   [mndtmaterial_stock] [material_s]   " +
                        "         LEFT JOIN [mndtkind_details] [kind_d]   " +
                        "                ON [kind_d].[kind_id] = 'WAR'   " +
                        "                AND [material_s].[warehouse_id] = [kind_d].[code_id]   " +
                        "  WHERE  1 = 1   " + sCondition;
        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnExport(MaterialStock materialStock)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[material_id]", materialStock.material_id);
        sCondition += " ORDER BY [" + materialStock.order + "] ";
        string sSql =
                        "  select [materialstock].[material_id] '編號',   " +
                        "         [materialstock].[company_id] '公司id',   " +
                        "         [materialstock].[name] '名子',   " +
                        "         [materialstock].[unit] '單位',   " +
                        "         [materialstock].[currency] '貨幣',  " +
                        "         [materialstock].[price] '價格',  " +
                        "         [materialstock].[shelf_life] '期限',  " +
                        "         [materialstock].[description] '描述',  " +
                        "         [materialstock].[status] '狀態'  " +
                        "  FROM MNDTmaterial_stock as [materialstock]  " +
                        "  WHERE 1 = 1 " + sCondition;
        return PublicApi.fnGetDt(sSql, "mndt");
    }

    public string fnInsert(MaterialStock materialStock)
    {
        string sSql =
                        "  INSERT INTO [dbo].[MNDTmaterial_stock]  " +
                        "             ([material_id]  " +
                        "             ,[warehouse_id]  " +
                        "             ,[amount]  " +
                        "             ,[safe_amount]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "  VALUES  " +
                        "             ('" + materialStock.material_id + "' " +
                        "             ,'" + materialStock.warehouse_id + "' " +
                        "             ,'0' " +
                        "             ,'0' " +
                        "             ,'" + materialStock.create_id + "' " +
                        "             ,GETDATE())  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnUpdateAmount(MaterialStock materialStock)
    {
        string sSql = fnUpdateAmountSql(materialStock);
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnUpdateAmountSql(MaterialStock materialStock)
    {
        MaterialStockTran materialStockTran = new MaterialStockTran();
        materialStockTran.WarehouseId(materialStock.warehouse_id)
                         .MaterialId(materialStock.material_id)
                         .Description("系統進出貨正常變更")
                         .CreateId(materialStock.create_id);

        string sSql = fnInsertSql(materialStockTran);
        sSql +=
                "  UPDATE [dbo].[MNDTmaterial_stock]  " +
                "     SET [amount] = [amount] + " + materialStock.amount + "  " +
                "  WHERE [material_id] = '" + materialStock.material_id + "' " +
                "        AND [warehouse_id] = '" + materialStock.warehouse_id + "'  ";

        return sSql;
    }

    public string fnUpdate(MaterialStock materialStock, string sDescription, string sIP)
    {
        MaterialStockTran materialStockTran = new MaterialStockTran();
        materialStockTran.WarehouseId(materialStock.warehouse_id)
                         .MaterialId(materialStock.material_id)
                         .Description(sDescription)
                         .CreateId(materialStock.create_id);

        string sSql = fnInsertSql(materialStockTran);

        sSql +=
               "  UPDATE [dbo].[MNDTmaterial_stock]  " +
               "     SET [amount] = '" + materialStock.amount + "'  " +
               "        ,[safe_amount] =  '" + materialStock.safe_amount + "'  " +
               "  WHERE [material_id] = '" + materialStock.material_id + "' " +
               "        AND [warehouse_id] = '" + materialStock.warehouse_id + "'  ";

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    //public string fnDelete(MaterialStock materialStock, string sIP, string sId)
    //{
    //    string sSql = " UPDATE [dbo].[MNDTmaterial_stock] " +
    //                    "       SET [status] = 'D' " +
    //                    " WHERE [material_id] = '" + materialStock.material_id + "' ";
    //    MaterialStockTran materialStockTran = new MaterialStockTran();

    //    materialStockTran.MaterialStockId(materialStock.material_id)
    //                .IP(sIP)
    //                .Status("D")
    //                .CreateId(sId);
    //    sSql += fnInsertSql(materialStockTran);

    //    return PublicApi.fnExecuteSQL(sSql, "MNDT");
    //}

    //public string fnDeletes(MaterialStock materialStock, string sIP, string sId)
    //{
    //    string sSql = " UPDATE [dbo].[MNDTmaterial_stock] " +
    //                    "       SET [status] = 'D' " +
    //                    " WHERE [material_id] IN (" + materialStock.material_id + ")";
    //    MaterialStockTran materialStockTran = new MaterialStockTran();

    //    materialStockTran.MaterialStockId(materialStock.material_id)
    //                .IP(sIP)
    //                .Status("D")
    //                .CreateId(sId);
    //    sSql += fnInsertsSql(materialStockTran);

    //    return PublicApi.fnExecuteSQL(sSql, "MNDT");
    //}

    public string fnCount(MaterialStock materialStock)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[material_id]", materialStock.material_id);
        sCondition += PublicApi.fnAddCondition("[warehouse_id]", materialStock.warehouse_id);

        string sCountSql =
                        "          SELECT COUNT(material_id)   " +
                        "          FROM   [MNDTmaterial_stock]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    public bool fnIsExist(MaterialStock materialStock)
    {
        string sSql = "  SELECT COUNT([material_id])   " +
                        "  FROM   [MNDTmaterial_stock]   " +
                        "  WHERE  [material_id] = '" + materialStock.material_id + "'   " +
                        "       AND [warehouse_id] = '" + materialStock.warehouse_id + "'   ";
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }

    #endregion



    #region MaterialStockTran

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(MaterialStockTran materialStockTran, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[material_id]", materialStockTran.material_id);
        sCondition += PublicApi.fnAddCondition("[warehouse_id]", materialStockTran.warehouse_id);
        string sInquireSql =
                        "  SELECT [material_s].[tran_amount],   " +
                        "         [material_s].[description],   " +
                        "         [material_s].[create_id],   " +
                        "         CONVERT(char, [material_s].[create_datetime], 120) 'create_datetime'   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [create_datetime] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTmaterial_stock_tran]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [material_s]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    private string fnInsertSql(MaterialStockTran materialStockTran)
    {
        string sSql =
                    "  INSERT INTO [mndtmaterial_stock_tran]   " +
                    "              ([warehouse_id],   " +
                    "               [material_id],   " +
                    "               [tran_amount],   " +
                    "               [description],   " +
                    "               [create_id],   " +
                    "               [create_datetime])   " +
                    "  SELECT [warehouse_id],   " +
                    "         [material_id],   " +
                    "         [amount],   " +
                    "         '" + materialStockTran.description + "',   " +
                    "         '" + materialStockTran.create_id + "',   " +
                    "         GETDATE()  " +
                    "  FROM   [mndtmaterial_stock]   " +
                    "  WHERE  [warehouse_id] = '" + materialStockTran.warehouse_id + "'   " +
                    "         AND [material_id] = '" + materialStockTran.material_id + "'   ";
        return sSql;
    }

    //private string fnInsertsSql(MaterialStockTran materialStockTran)
    //{
    //    string sSql =
    //                    "  INSERT INTO [MNDTmaterial_stock_tran]  " +
    //                    "             ([material_id]  " +
    //                    "             ,[ip]  " +
    //                    "             ,[status]  " +
    //                    "             ,[create_id]  " +
    //                    "             ,[create_datetime])  " +
    //                    "  SELECT [material_id]  " +
    //                    "        , '" + materialStockTran + "'  " +
    //                    "        , '" + materialStockTran.status + "'  " +
    //                    "        , '" + materialStockTran.create_id + "'  " +
    //                    "        , GETDATE()  " +
    //                    "  FROM [MNDTmaterial_stock]  " +
    //                    " WHERE [material_id] IN (" + materialStockTran.material_id + ")";
    //    return sSql;
    //}

    public string fnCount(MaterialStockTran materialStockTran)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[material_id]", materialStockTran.material_id);
        sCondition += PublicApi.fnAddCondition("[warehouse_id]", materialStockTran.warehouse_id);
        string sCountSql =
                        "          SELECT COUNT(material_id)   " +
                        "          FROM   [MNDTmaterial_stock_tran]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    #endregion

    //public DataTable fnSelectList()
    //{
    //    string sSql =
    //                    "  SELECT [materialStock].[material_id] [value],   " +
    //                    "         [materialStock].[name]   " +
    //                    "  FROM MNDTmaterial_stock AS [materialStock]  " +
    //                    "  WHERE [materialStock].[status] <> 'D' ";

    //    return PublicApi.fnGetDt(sSql, "MNDT");
    //}
}