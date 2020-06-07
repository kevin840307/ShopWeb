using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// SalesRepository 的摘要描述
/// </summary>
public class SalesRepository
{
    public SalesRepository()
    {
    }

    public string fnChangeInsert(SalesM salesM)
    {
        string sSql = "  INSERT INTO [dbo].[MNDTsales_master]  " +
                        "             ([order_id]  " +
                        "             ,[id]  " +
                        "             ,[pay]  " +
                        "             ,[order_status]  " +
                        "             ,[datetime]  " +
                        "             ,[complete]  " +
                        "             ,[description]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "  SELECT TOP 1 [order_id]  " +
                        "             ,'" + salesM.create_id + "'  " +
                        "             ,''  " +
                        "             ,''  " +
                        "             ,GETDATE()  " +
                        "             ,'N' " +
                        "             ,''  " +
                        "             ,'" + salesM.create_id + "'  " +
                        "             ,GETDATE()  " +
                        "  FROM [MNDTquotes_master]  " +
                        "  WHERE order_id = '" + salesM.order_id + "'  ";
        sSql += 
                        "  INSERT INTO [MNDTsales_details]  " +
                        "             ([seq]  " +
                        "             ,[order_id]  " +
                        "             ,[product_id]  " +
                        "             ,[warehouse_id]  " +
                        "             ,[amount]  " +
                        "             ,[price]  " +
                        "             ,[description]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime] " +
                        "             ,[modify_id]  " +
                        "             ,[modify_datetime])  " +
                        "  SELECT Row_number() OVER(ORDER BY[product_id] ASC) NUM  " +
                        "        ,[order_id]  " +
                        "        ,[product_id]  " +
                        "        ,''  " +
                        "        ,[modify_amount]  " +
                        "        ,[modify_price]  " +
                        "        ,''  " +
                        "        ,'" + salesM.create_id + "'  " +
                        "        ,GETDATE()  " +
                        "        ,'" + salesM.create_id + "'  " + 
                        "        ,GETDATE()  " +
                        "  FROM [MNDTquotes_details]  " +
                        "  WHERE order_id = '" + salesM.order_id + "'  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    #region SalesMaster

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(SalesM salesM, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;

        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", salesM.order_id);
        sCondition += PublicApi.fnAddCondition("[id]", salesM.id);
        sCondition += PublicApi.fnAddCondition("CONVERT(varchar(10), [datetime], 126)", salesM.datetime);

        string sSql =
                        "  SELECT [sales_m].[NUM],   " +
                        "         [sales_m].[order_id],   " +
                        "         [sales_m].[id],   " +
                        "         [sales_m].[complete],   " +
                        "         CONVERT(CHAR, [sales_m].[datetime], 111) [datetime]   " +
                        "  FROM   (SELECT Row_number() OVER(ORDER BY[" + salesM.order + "] ASC) NUM, " +
                        "                  *   " +
                        "          FROM   [MNDTsales_master]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [sales_m]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString();

        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    public string fnCount(SalesM salesM)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", salesM.order_id);
        sCondition += PublicApi.fnAddCondition("[id]", salesM.id);
        sCondition += PublicApi.fnAddCondition("CONVERT(varchar(10), [datetime], 126)", salesM.datetime);

        string sCountSql =
                        "          SELECT COUNT([order_id])   " +
                        "          FROM   [MNDTsales_master]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    // sNum 排行
    public string fnSelectOrderId(SalesM salesM, string sNum)
    {
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[order_id]", salesM.order_id);
        sCondition += PublicApi.fnAddCondition("[id]", salesM.id);
        sCondition += PublicApi.fnAddCondition("CONVERT(varchar(10), [datetime], 126)", salesM.datetime);

        string sSql = "  SELECT [sales_m].[order_id]  " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + salesM.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTsales_master]   " +
                        "          WHERE  1 = 1" + sCondition + ") AS [sales_m]  " +
                        "  WHERE [sales_m].[NUM] = '" + sNum + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public DataTable fnSelect(SalesM salesM)
    {
        string sSql = "  SELECT TOP 1 [order_id]  " +
                        "        ,[id]  " +
                        "        ,[pay]  " +
                        "        ,[order_status]  " +
                        "        ,CONVERT(varchar(10), [datetime], 126) [datetime]  " +
                        "        ,[complete]  " +
                        "        ,[status]  " +
                        "        ,[description]  " +
                        "        ,[create_id]  " +
                        "        ,CONVERT(char, [create_datetime], 120) [create_datetime]  " +
                        "  FROM [MNDTsales_master]  " +
                        "  WHERE [order_id] = '" + salesM.order_id + "' ";
        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    public string fnInsert(SalesM salesM)
    {
        string sSql = "  INSERT INTO [dbo].[MNDTsales_master]  " +
                        "             ([order_id]  " +
                        "             ,[id]  " +
                        "             ,[pay]  " +
                        "             ,[order_status]  " +
                        "             ,[datetime]  " +
                        "             ,[complete]  " +
                        "             ,[description]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "       VALUES  " +
                        "             ('" + salesM.order_id + "'  " +
                        "             ,'" + salesM.id + "'  " +
                        "             ,'" + salesM.pay + "'  " +
                        "             ,'" + salesM.order_status + "'  " +
                        "             ,'" + salesM.datetime + "'  " +
                        "             ,'N' " +
                        "             ,'" + salesM.description + "'  " +
                        "             ,'" + salesM.create_id + "'  " +
                        "             ,GETDATE())  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnUpdate(SalesM salesM, string sIP)
    {
        string sSql = "  UPDATE [dbo].[MNDTsales_master]  " +
                        "     SET [id] = '" + salesM.id + "'  " +
                        "        ,[pay] = '" + salesM.pay + "'  " +
                        "        ,[order_status] = '" + salesM.order_status + "'  " +
                        "        ,[datetime] = '" + salesM.datetime + "'  " +
                        "        ,[complete] = '" + salesM.complete + "'  " +
                        "        ,[status] = '" + salesM.status + "'  " +
                        "        ,[description] = '" + salesM.description + "'  " +
                        "  WHERE [order_id] = '" + salesM.order_id + "' ";
        SalesMTran salesMTran = new SalesMTran();

        salesMTran.OrderId(salesM.order_id)
                    .IP(sIP)
                    .Status("M")
                    .CreateId(salesM.create_id);
        sSql += fnInsertSql(salesMTran);
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnChange(SalesM salesM, string sIP)
    {
        string sSql = 
                        "  UPDATE [dbo].[MNDTsales_master]  " +
                        "     SET [complete] = 'Y',  " +
                        "       [order_status] = '02' " +
                        "  WHERE [order_id] = '" + salesM.order_id + "' ";

        SalesMTran salesMTran = new SalesMTran();

        salesMTran.OrderId(salesM.order_id)
                    .IP(sIP)
                    .Status("M")
                    .CreateId(salesM.create_id);
        sSql += fnInsertSql(salesMTran);
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDelete(SalesM salesM, string sIP)
    {
        string sSql =
                        " UPDATE [MNDTsales_master] " +
                        " SET [status] = 'D' " +
                        " WHERE [order_id] = '" + salesM.order_id + "' ";
        SalesMTran salesMTran = new SalesMTran();

        salesMTran.OrderId(salesM.order_id)
                    .IP(sIP)
                    .Status("D")
                    .CreateId(salesM.create_id);
        sSql += fnInsertSql(salesMTran);
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public bool fnIsExist(SalesM salesM)
    {
        string sSql = "  SELECT COUNT([order_id])   " +
                        "  FROM   [MNDTsales_master]   " +
                        "  WHERE  [order_id] = '" + salesM.order_id + "'   ";
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }

    #endregion



    #region SalesDetails

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(SalesD salesD, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;

        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", salesD.order_id);

        string sInquireSql =
                        "  SELECT [sales_d].[seq],   " +
                        "         [sales_d].[product_id],   " +
                        "         [sales_d].[warehouse_id],   " +
                        "         [sales_d].[amount],   " +
                        "         [sales_d].[price],   " +
                        "         [sales_d].[description]   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [seq] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTsales_details]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [sales_d]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnSelects(SalesD salesD)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", salesD.order_id);

        string sInquireSql =
                        "  SELECT [sales_d].[seq],   " +
                        "         [sales_d].[product_id],   " +
                        "         [sales_d].[warehouse_id],   " +
                        "         [sales_d].[amount],   " +
                        "         [sales_d].[price],   " +
                        "         [sales_d].[description]   " +
                        "  FROM   [MNDTsales_details] AS [sales_d]  " +
                        "  WHERE 1 = 1 " + sCondition;

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnSelect(SalesD salesD)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", salesD.order_id);
        sCondition += PublicApi.fnAddCondition("[seq]", salesD.seq);

        string sInquireSql =
                        "  SELECT [sales_d].*   " +
                        "  FROM   [MNDTsales_details] AS [sales_d]  " +
                        "          WHERE  1 = 1 " + sCondition;

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnSelectAllAmount(SalesD salesD)
    {
        string sSql = "  SELECT ISNULL(SUM([amount]), '0')  " +
                       "  FROM [MNDTsales_details]  " +
                       "  WHERE [order_id] = '" + salesD.order_id + "' " +
                       "   AND [product_id] = '" + salesD.product_id + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public string fnSelectAmount(SalesD salesD)
    {
        string sSql = "  SELECT ISNULL(SUM([amount]), '0')  " +
                       "  FROM [MNDTsales_details]  " +
                       "  WHERE [order_id] = '" + salesD.order_id + "' " +
                       "   AND [product_id] = '" + salesD.product_id + "' " +
                       "   AND [warehouse_id] = '" + salesD.warehouse_id + "' "; ;
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public string fnSelectExcludeAmount(SalesD salesD)
    {
        string sSql = "  SELECT ISNULL(SUM([amount]), '0')  " +
                       "  FROM [MNDTsales_details]  " +
                       "  WHERE [order_id] = '" + salesD.order_id + "' " +
                       "   AND [product_id] = '" + salesD.product_id + "' " +
                       "   AND [seq] <> '" + salesD.seq + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public string fnCount(SalesD salesD)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", salesD.order_id);

        string sCountSql =
                        "          SELECT COUNT([order_id])   " +
                        "          FROM   [MNDTsales_details]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    public string fnInsert(SalesD salesD)
    {
        string sSql = "  INSERT INTO [MNDTsales_details]  " +
                        "             ([seq]  " +
                        "             ,[order_id]  " +
                        "             ,[product_id]  " +
                        "             ,[warehouse_id]  " +
                        "             ,[amount]  " +
                        "             ,[price]  " +
                        "             ,[description]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime] " +
                        "             ,[modify_id]  " +
                        "             ,[modify_datetime])  " +
                        "       VALUES  " +
                        "             ('" + salesD.seq + "'  " +
                        "             ,'" + salesD.order_id + "'  " +
                        "             ,'" + salesD.product_id + "'  " +
                        "             ,'" + salesD.warehouse_id + "'  " +
                        "             ,'" + salesD.amount + "'  " +
                        "             ,'" + salesD.price + "'  " +
                        "             ,'" + salesD.description + "'  " +
                        "             ,'" + salesD.create_id + "'  " +
                        "             ,GETDATE() " +
                        "             ,'" + salesD.create_id + "'  " +
                        "             ,GETDATE())  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnGetSeq(SalesD salesD)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", salesD.order_id);

        string sSql =
                       "  SELECT ISNULL(MAX([seq]), 0) + 1   " +
                       "  FROM   [MNDTsales_details] AS [sales_d]  " +
                       "          WHERE  1 = 1 " + sCondition;
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public string fnUpdate(SalesD salesD)
    {
        string sSql =
                        "  UPDATE [MNDTsales_details]  " +
                        "     SET [product_id] = '" + salesD.product_id + "'  " +
                        "        ,[warehouse_id] = '" + salesD.warehouse_id + "'  " +
                        "        ,[amount] = '" + salesD.amount + "'  " +
                        "        ,[price] = '" + salesD.price + "'  " +
                        "        ,[description] = '" + salesD.description + "'  " +
                        "        ,[modify_id] = '" + salesD.create_id + "'  " +
                        "        ,[modify_datetime] = GETDATE()  " +
                        " WHERE [order_id] = '" + salesD.order_id + "' " +
                        "   AND [seq] = '" + salesD.seq + "' ";

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }


    public string fnDelete(SalesD salesD)
    {
        string sSql =
                        "  DELETE [MNDTsales_details]  " +
                        "  WHERE [order_id] = '" + salesD.order_id + "' " +
                        "       AND [seq] = '" + salesD.seq + "' ";

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public bool fnIsExist(SalesD salesD)
    {
        string sCondition = "";

        if(salesD.seq != null && salesD.seq.Length > 0)
        {
            sCondition += " AND [seq] <> " + salesD.seq;
        }

        string sSql =
                        "  SELECT COUNT([product_id])   " +
                        "  FROM   [MNDTsales_details]   " +
                        "  WHERE [order_id] = '" + salesD.order_id + "' " +
                        "       AND [product_id] = '" + salesD.product_id + "' " +
                        "       AND [warehouse_id] = '" + salesD.warehouse_id + "' " + sCondition;
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }

    #endregion




    #region SalesMasterTran

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(SalesMTran salesMTran, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", salesMTran.order_id);

        string sInquireSql =
                        "  SELECT [sales_m_tran].[ip],   " +
                        "         [sales_m_tran].[status],   " +
                        "         [sales_m_tran].[create_id],   " +
                        "         CONVERT(char, [sales_m_tran].[create_datetime], 120) 'create_datetime'   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [create_datetime] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTsales_master_tran]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [sales_m_tran]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnCount(SalesMTran salesMTran)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", salesMTran.order_id);

        string sCountSql =
                        "          SELECT COUNT(order_id)   " +
                        "          FROM   [MNDTsales_master_tran]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    private string fnInsertSql(SalesMTran salesMTran)
    {
        string sSql =
                        "  INSERT INTO [MNDTsales_master_tran]  " +
                        "             ([order_id]  " +
                        "             ,[ip]  " +
                        "             ,[status]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "  VALUES  " +
                        "             ('" + salesMTran.order_id + "'  " +
                        "             ,'" + salesMTran.ip + "' " +
                        "             ,'" + salesMTran.status + "'  " +
                        "             ,'" + salesMTran.create_id + "'  " +
                        "             ,GETDATE())  ";

        return sSql;
    }

    #endregion


    public DataTable fnSelectList()
    {
        string sSql =
                        "  SELECT [sales_m].[order_id] [value],   " +
                        "         [sales_m].[order_id] [name]  " +
                        "  FROM [MNDTsales_master] AS [sales_m]  " +
                        "  WHERE [status] <> 'D' " +
                        "       AND [complete] = 'Y' ";

        return PublicApi.fnGetDt(sSql, "MNDT");
    }
}