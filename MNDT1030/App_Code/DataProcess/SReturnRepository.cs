using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// SReturnRepository 的摘要描述
/// </summary>
public class SReturnRepository
{
    public SReturnRepository()
    {
    }

    #region SReturnMaster

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(SReturnM sreturnM, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;

        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", sreturnM.order_id);
        sCondition += PublicApi.fnAddCondition("[return_id]", sreturnM.return_id);
        sCondition += PublicApi.fnAddCondition("[id]", sreturnM.id);
        sCondition += PublicApi.fnAddCondition("CONVERT(varchar(10), [datetime], 126)", sreturnM.datetime);

        string sInquireSql =
                        "  SELECT [return_m].[NUM],   " +
                        "         [return_m].[return_id],   " +
                        "         [return_m].[order_id],   " +
                        "         [return_m].[id],   " +
                        "         [return_m].[complete],   " +
                        "         CONVERT(CHAR, [return_m].[datetime], 111) [datetime]   " +
                        "  FROM   (SELECT Row_number() OVER(ORDER BY[" + sreturnM.order + "] ASC) NUM, " +
                        "                  *   " +
                        "          FROM   [MNDTSreturn_master]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [return_m]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString();

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnCount(SReturnM sreturnM)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", sreturnM.order_id);
        sCondition += PublicApi.fnAddCondition("[return_id]", sreturnM.return_id);
        sCondition += PublicApi.fnAddCondition("[id]", sreturnM.id);
        sCondition += PublicApi.fnAddCondition("CONVERT(varchar(10), [datetime], 126)", sreturnM.datetime);

        string sCountSql =
                        "          SELECT COUNT([return_id])   " +
                        "          FROM   [MNDTSreturn_master]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    // sNum 排行
    public string fnSelectReturnId(SReturnM sreturnM, string sNum)
    {
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[order_id]", sreturnM.order_id);
        sCondition += PublicApi.fnAddCondition("[return_id]", sreturnM.return_id);
        sCondition += PublicApi.fnAddCondition("[id]", sreturnM.id);
        sCondition += PublicApi.fnAddCondition("CONVERT(varchar(10), [datetime], 126)", sreturnM.datetime);

        string sSql = "  SELECT [return_m].[return_id]  " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + sreturnM.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTSreturn_master]   " +
                        "          WHERE  1 = 1" + sCondition + ") AS [return_m]  " +
                        "  WHERE [return_m].[NUM] = '" + sNum + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public DataTable fnSelect(SReturnM sreturnM)
    {
        string sSql = "  SELECT TOP 1 [return_id]  " +
                        "        ,[order_id]  " +
                        "        ,[id]  " +
                        "        ,CONVERT(varchar(10), [datetime], 126) [datetime]  " +
                        "        ,[complete]  " +
                        "        ,[status]  " +
                        "        ,[description]  " +
                        "        ,[create_id]  " +
                        "        ,CONVERT(char, [create_datetime], 120) [create_datetime]  " +
                        "  FROM [MNDTSreturn_master]  " +
                        "  WHERE [return_id] = '" + sreturnM.return_id + "' ";
        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    public string fnInsert(SReturnM sreturnM)
    {
        string sSql = 
                        "  INSERT INTO [dbo].[MNDTSreturn_master]  " +
                        "             ([return_id]  " +
                        "             ,[order_id]  " +
                        "             ,[id]  " +
                        "             ,[datetime]  " +
                        "             ,[complete]  " +
                        "             ,[description]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "       VALUES  " +
                        "             ('" + sreturnM.return_id + "'  " +
                        "             ,'" + sreturnM.order_id + "'  " +
                        "             ,'" + sreturnM.id + "'  " +
                        "             ,'" + sreturnM.datetime + "'  " +
                        "             ,'N' " +
                        "             ,'" + sreturnM.description + "'  " +
                        "             ,'" + sreturnM.create_id + "'  " +
                        "             ,GETDATE())  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnUpdate(SReturnM sreturnM, string sIP)
    {
        string sSql = "  UPDATE [dbo].[MNDTSreturn_master]  " +
                        "     SET [id] = '" + sreturnM.id + "'  " +
                        "        ,[order_id] = '" + sreturnM.order_id + "'  " +
                        "        ,[datetime] = '" + sreturnM.datetime + "'  " +
                        "        ,[complete] = '" + sreturnM.complete + "'  " +
                        "        ,[status] = '" + sreturnM.status + "'  " +
                        "        ,[description] = '" + sreturnM.description + "'  " +
                        "  WHERE [return_id] = '" + sreturnM.return_id + "' ";
        SReturnMTran sreturnMTran = new SReturnMTran();

        sreturnMTran.ReturnId(sreturnM.return_id)
                    .IP(sIP)
                    .Status("M")
                    .CreateId(sreturnM.create_id);
        sSql += fnInsertSql(sreturnMTran);
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDelete(SReturnM sreturnM, string sIP)
    {
        string sSql =
                        " UPDATE [MNDTSreturn_master] " +
                        " SET [status] = 'D' " +
                        " WHERE [return_id] = '" + sreturnM.return_id + "' ";
        SReturnMTran sreturnMTran = new SReturnMTran();

        sreturnMTran.ReturnId(sreturnM.return_id)
                    .IP(sIP)
                    .Status("D")
                    .CreateId(sreturnM.create_id);
        sSql += fnInsertSql(sreturnMTran);
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public bool fnIsExist(SReturnM sreturnM)
    {
        string sSql = "  SELECT COUNT([return_id])   " +
                        "  FROM   [MNDTSreturn_master]   " +
                        "  WHERE  [return_id] = '" + sreturnM.return_id + "'   ";
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }

    public string fnGetReturnId(string sOrderId)
    {
        string sSql = "  SELECT TOP 1 [return_id]   " +
                        "  FROM   [MNDTSreturn_master]   " +
                        "  WHERE  [order_id] = '" + sOrderId + "'   ";
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    #endregion



    #region SReturnDetails

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(SReturnD sreturnD, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;

        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[return_id]", sreturnD.return_id);

        string sInquireSql =
                        "  SELECT [return_d].[seq],   " +
                        "         [return_d].[product_id],   " +
                        "         [return_d].[warehouse_id],   " +
                        "         [return_d].[amount],   " +
                        "         [return_d].[price],   " +
                        "         [return_d].[description]   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [seq] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTSreturn_details]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [return_d]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnSelects(SReturnD sreturnD)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[return_id]", sreturnD.return_id);

        string sInquireSql =
                        "  SELECT [return_d].[seq],   " +
                        "         [return_d].[product_id],   " +
                        "         [return_d].[warehouse_id],   " +
                        "         [return_d].[amount],   " +
                        "         [return_d].[price],   " +
                        "         [return_d].[description]   " +
                        "  FROM   [MNDTSreturn_details] AS [return_d]  " +
                        "  WHERE 1 = 1 " + sCondition;

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnSelect(SReturnD sreturnD)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[return_id]", sreturnD.return_id);
        sCondition += PublicApi.fnAddCondition("[product_id]", sreturnD.product_id);
        sCondition += PublicApi.fnAddCondition("[warehouse_id]", sreturnD.warehouse_id);

        string sInquireSql =
                        "  SELECT [return_d].*   " +
                        "  FROM   [MNDTSreturn_details] AS [return_d]  " +
                        "          WHERE  1 = 1 " + sCondition;

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnCount(SReturnD sreturnD)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[return_id]", sreturnD.return_id);

        string sCountSql =
                        "          SELECT COUNT([return_id])   " +
                        "          FROM   [MNDTSreturn_details]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    public string fnInsert(SReturnD sreturnD)
    {
        string sSql = 
                        "  INSERT INTO [MNDTSreturn_details]  " +
                        "             ([seq]  " +
                        "             ,[return_id]  " +
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
                        "             ('" + sreturnD.seq + "'  " +
                        "             ,'" + sreturnD.return_id + "'  " +
                        "             ,'" + sreturnD.product_id + "'  " +
                        "             ,'" + sreturnD.warehouse_id + "'  " +
                        "             ,'" + sreturnD.amount + "'  " +
                        "             ,'" + sreturnD.price + "'  " +
                        "             ,'" + sreturnD.description + "'  " +
                        "             ,'" + sreturnD.create_id + "'  " +
                        "             ,GETDATE() " +
                        "             ,'" + sreturnD.create_id + "'  " +
                        "             ,GETDATE())  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnGetSeq(SReturnD sreturnD)
    {
        return fnGetSeq(sreturnD.return_id);
    }

    public string fnGetSeq(string sReturnId)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[return_id]", sReturnId);

        string sSql =
                       "  SELECT ISNULL(MAX([seq]), 0) + 1   " +
                       "  FROM   [MNDTSreturn_details] AS [return_d]  " +
                       "          WHERE  1 = 1 " + sCondition;
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public string fnUpdate(SReturnD sreturnD)
    {
        string sSql =
                        "  UPDATE [MNDTSreturn_details]  " +
                        "     SET [product_id] = '" + sreturnD.product_id + "'  " +
                        "        ,[warehouse_id] = '" + sreturnD.warehouse_id + "'  " +
                        "        ,[amount] = '" + sreturnD.amount + "'  " +
                        "        ,[price] = '" + sreturnD.price + "'  " +
                        "        ,[description] = '" + sreturnD.description + "'  " +
                        "        ,[modify_id] = '" + sreturnD.create_id + "'  " +
                        "        ,[modify_datetime] = GETDATE()  " +
                        " WHERE [return_id] = '" + sreturnD.return_id + "' " +
                        "   AND [seq] = '" + sreturnD.seq + "' ";

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDelete(SReturnD sreturnD)
    {
        string sSql =
                        "  DELETE [MNDTSreturn_details]  " +
                        "  WHERE [return_id] = '" + sreturnD.return_id + "' " +
                        "   AND [seq] = '" + sreturnD.seq + "' ";

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public bool fnIsExist(SReturnD sreturnD)
    {
        string sSql =
                        "  SELECT COUNT([product_id])   " +
                        "  FROM   [MNDTSreturn_details]   " +
                        "  WHERE [return_id] = '" + sreturnD.return_id + "' " +
                        "       AND [product_id] = '" + sreturnD.product_id + "' " +
                        "       AND [warehouse_id] = '" + sreturnD.warehouse_id + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }

    #endregion




    #region SReturnMasterTran

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(SReturnMTran sreturnMTran, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[return_id]", sreturnMTran.return_id);

        string sInquireSql =
                        "  SELECT [return_m_tran].[ip],   " +
                        "         [return_m_tran].[status],   " +
                        "         [return_m_tran].[create_id],   " +
                        "         CONVERT(char, [return_m_tran].[create_datetime], 120) 'create_datetime'   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [create_datetime] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTSreturn_master_tran]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [return_m_tran]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnCount(SReturnMTran sreturnMTran)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[return_id]", sreturnMTran.return_id);

        string sCountSql =
                        "          SELECT COUNT(return_id)   " +
                        "          FROM   [MNDTSreturn_master_tran]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    private string fnInsertSql(SReturnMTran sreturnMTran)
    {
        string sSql =
                        "  INSERT INTO [MNDTSreturn_master_tran]  " +
                        "             ([return_id]  " +
                        "             ,[ip]  " +
                        "             ,[status]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "  VALUES  " +
                        "             ('" + sreturnMTran.return_id + "'  " +
                        "             ,'" + sreturnMTran.ip + "' " +
                        "             ,'" + sreturnMTran.status + "'  " +
                        "             ,'" + sreturnMTran.create_id + "'  " +
                        "             ,GETDATE())  ";

        return sSql;
    }

    #endregion
}