using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// ReturnRepository 的摘要描述
/// </summary>
public class ReturnRepository
{
    public ReturnRepository()
    {
    }

    #region ReturnMaster

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(ReturnM returnM, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;

        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", returnM.order_id);
        sCondition += PublicApi.fnAddCondition("[return_id]", returnM.return_id);
        sCondition += PublicApi.fnAddCondition("[id]", returnM.id);
        sCondition += PublicApi.fnAddCondition("CONVERT(varchar(10), [datetime], 126)", returnM.datetime);

        string sInquireSql =
                        "  SELECT [return_m].[NUM],   " +
                        "         [return_m].[return_id],   " +
                        "         [return_m].[order_id],   " +
                        "         [return_m].[id],   " +
                        "         [return_m].[complete],   " +
                        "         CONVERT(CHAR, [return_m].[datetime], 111) [datetime]   " +
                        "  FROM   (SELECT Row_number() OVER(ORDER BY[" + returnM.order + "] ASC) NUM, " +
                        "                  *   " +
                        "          FROM   [MNDTreturn_master]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [return_m]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString();

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnCount(ReturnM returnM)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", returnM.order_id);
        sCondition += PublicApi.fnAddCondition("[return_id]", returnM.return_id);
        sCondition += PublicApi.fnAddCondition("[id]", returnM.id);
        sCondition += PublicApi.fnAddCondition("CONVERT(varchar(10), [datetime], 126)", returnM.datetime);

        string sCountSql =
                        "          SELECT COUNT([return_id])   " +
                        "          FROM   [MNDTreturn_master]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    // sNum 排行
    public string fnSelectReturnId(ReturnM returnM, string sNum)
    {
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[order_id]", returnM.order_id);
        sCondition += PublicApi.fnAddCondition("[return_id]", returnM.return_id);
        sCondition += PublicApi.fnAddCondition("[id]", returnM.id);
        sCondition += PublicApi.fnAddCondition("CONVERT(varchar(10), [datetime], 126)", returnM.datetime);

        string sSql = "  SELECT [return_m].[return_id]  " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + returnM.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTreturn_master]   " +
                        "          WHERE  1 = 1" + sCondition + ") AS [return_m]  " +
                        "  WHERE [return_m].[NUM] = '" + sNum + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public DataTable fnSelect(ReturnM returnM)
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
                        "  FROM [MNDTreturn_master]  " +
                        "  WHERE [return_id] = '" + returnM.return_id + "' ";
        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    public string fnInsert(ReturnM returnM)
    {
        string sSql = 
                        "  INSERT INTO [dbo].[MNDTreturn_master]  " +
                        "             ([return_id]  " +
                        "             ,[order_id]  " +
                        "             ,[id]  " +
                        "             ,[datetime]  " +
                        "             ,[complete]  " +
                        "             ,[description]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "       VALUES  " +
                        "             ('" + returnM.return_id + "'  " +
                        "             ,'" + returnM.order_id + "'  " +
                        "             ,'" + returnM.id + "'  " +
                        "             ,'" + returnM.datetime + "'  " +
                        "             ,'N' " +
                        "             ,'" + returnM.description + "'  " +
                        "             ,'" + returnM.create_id + "'  " +
                        "             ,GETDATE())  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnUpdate(ReturnM returnM, string sIP)
    {
        string sSql = "  UPDATE [dbo].[MNDTreturn_master]  " +
                        "     SET [id] = '" + returnM.id + "'  " +
                        "        ,[order_id] = '" + returnM.order_id + "'  " +
                        "        ,[datetime] = '" + returnM.datetime + "'  " +
                        "        ,[complete] = '" + returnM.complete + "'  " +
                        "        ,[status] = '" + returnM.status + "'  " +
                        "        ,[description] = '" + returnM.description + "'  " +
                        "  WHERE [return_id] = '" + returnM.return_id + "' ";
        ReturnMTran returnMTran = new ReturnMTran();

        returnMTran.ReturnId(returnM.return_id)
                    .IP(sIP)
                    .Status("M")
                    .CreateId(returnM.create_id);
        sSql += fnInsertSql(returnMTran);
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDelete(ReturnM returnM, string sIP)
    {
        string sSql =
                        " UPDATE [MNDTreturn_master] " +
                        " SET [status] = 'D' " +
                        " WHERE [return_id] = '" + returnM.return_id + "' ";
        ReturnMTran returnMTran = new ReturnMTran();

        returnMTran.ReturnId(returnM.return_id)
                    .IP(sIP)
                    .Status("D")
                    .CreateId(returnM.create_id);
        sSql += fnInsertSql(returnMTran);
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public bool fnIsExist(ReturnM returnM)
    {
        string sSql = "  SELECT COUNT([return_id])   " +
                        "  FROM   [MNDTreturn_master]   " +
                        "  WHERE  [return_id] = '" + returnM.return_id + "'   ";
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }

    public string fnGetReturnId(string sOrderId)
    {
        string sSql = "  SELECT TOP 1 [return_id]   " +
                        "  FROM   [MNDTreturn_master]   " +
                        "  WHERE  [order_id] = '" + sOrderId + "'   ";
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    #endregion



    #region ReturnDetails

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(ReturnD returnD, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;

        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[return_id]", returnD.return_id);

        string sInquireSql =
                        "  SELECT [return_d].[seq],   " +
                        "         [return_d].[material_id],   " +
                        "         [return_d].[warehouse_id],   " +
                        "         [return_d].[amount],   " +
                        "         [return_d].[price],   " +
                        "         CASE [return_d].[complete] WHEN 'Y' THEN 'checked' ELSE '' END [complete],   " +
                        "         CASE [return_d].[pay_complete] WHEN 'Y' THEN 'checked' ELSE '' END [pay_complete],   " +
                        "         [return_d].[description]   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [seq] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTreturn_details]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [return_d]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnSelects(ReturnD returnD)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[return_id]", returnD.return_id);

        string sInquireSql =
                        "  SELECT [return_d].[seq],   " +
                        "         [return_d].[material_id],   " +
                        "         [return_d].[warehouse_id],   " +
                        "         [return_d].[amount],   " +
                        "         [return_d].[price],   " +
                        "         CASE [return_d].[complete] WHEN 'Y' THEN 'checked' ELSE '' END [complete],   " +
                        "         CASE [return_d].[pay_complete] WHEN 'Y' THEN 'checked' ELSE '' END [pay_complete],   " +
                        "         [return_d].[description]   " +
                        "  FROM   [MNDTreturn_details] AS [return_d]  " +
                        "  WHERE 1 = 1 " + sCondition;

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnSelect(ReturnD returnD)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[return_id]", returnD.return_id);
        sCondition += PublicApi.fnAddCondition("[material_id]", returnD.material_id);
        sCondition += PublicApi.fnAddCondition("[warehouse_id]", returnD.warehouse_id);

        string sInquireSql =
                        "  SELECT [return_d].*   " +
                        "  FROM   [MNDTreturn_details] AS [return_d]  " +
                        "          WHERE  1 = 1 " + sCondition;

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnCount(ReturnD returnD)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[return_id]", returnD.return_id);

        string sCountSql =
                        "          SELECT COUNT([return_id])   " +
                        "          FROM   [MNDTreturn_details]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    public string fnInsert(ReturnD returnD)
    {
        string sSql = 
                        "  INSERT INTO [MNDTreturn_details]  " +
                        "             ([seq]  " +
                        "             ,[return_id]  " +
                        "             ,[material_id]  " +
                        "             ,[warehouse_id]  " +
                        "             ,[amount]  " +
                        "             ,[price]  " +
                        "             ,[complete]  " +
                        "             ,[pay_complete]  " +
                        "             ,[description]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime] " +
                        "             ,[modify_id]  " +
                        "             ,[modify_datetime])  " +
                        "       VALUES  " +
                        "             ('" + returnD.seq + "'  " +
                        "             ,'" + returnD.return_id + "'  " +
                        "             ,'" + returnD.material_id + "'  " +
                        "             ,'" + returnD.warehouse_id + "'  " +
                        "             ,'" + returnD.amount + "'  " +
                        "             ,'" + returnD.price + "'  " +
                        "             ,'N'  " +
                        "             ,'N'  " +
                        "             ,'" + returnD.description + "'  " +
                        "             ,'" + returnD.create_id + "'  " +
                        "             ,GETDATE() " +
                        "             ,'" + returnD.create_id + "'  " +
                        "             ,GETDATE())  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnGetSeq(ReturnD returnD)
    {
        return fnGetSeq(returnD.return_id);
    }

    public string fnGetSeq(string sReturnId)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[return_id]", sReturnId);

        string sSql =
                       "  SELECT ISNULL(MAX([seq]), 0) + 1   " +
                       "  FROM   [MNDTreturn_details] AS [return_d]  " +
                       "          WHERE  1 = 1 " + sCondition;
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public string fnUpdate(ReturnD returnD)
    {
        string sSql =
                        "  UPDATE [MNDTreturn_details]  " +
                        "     SET [material_id] = '" + returnD.material_id + "'  " +
                        "        ,[warehouse_id] = '" + returnD.warehouse_id + "'  " +
                        "        ,[amount] = '" + returnD.amount + "'  " +
                        "        ,[price] = '" + returnD.price + "'  " +
                        "        ,[complete] = '" + returnD.complete + "'  " +
                        "        ,[pay_complete] = '" + returnD.pay_complete + "'  " +
                        "        ,[description] = '" + returnD.description + "'  " +
                        "        ,[modify_id] = '" + returnD.create_id + "'  " +
                        "        ,[modify_datetime] = GETDATE()  " +
                        " WHERE [return_id] = '" + returnD.return_id + "' " +
                        "   AND [seq] = '" + returnD.seq + "' ";

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnVerifications(ReturnD returnD)
    {
        string sSql =
                        "  UPDATE [MNDTreturn_details]  " +
                        "     SET [complete] = '" + returnD.complete + "'  " +
                        "        ,[pay_complete] = '" + returnD.pay_complete + "'  " +
                        "        ,[modify_id] = '" + returnD.create_id + "'  " +
                        "        ,[modify_datetime] = GETDATE()  " +
                        " WHERE [return_id] = '" + returnD.return_id + "' " +
                        "   AND [seq] = '" + returnD.seq + "' ";

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnAudits(ReturnD returnD)
    {
        string sSql =
                        "  UPDATE [MNDTreturn_details]  " +
                        "     SET [complete] = '" + returnD.complete + "'  " +
                        "        ,[modify_id] = '" + returnD.create_id + "'  " +
                        "        ,[modify_datetime] = GETDATE()  " +
                        " WHERE [return_id] = '" + returnD.return_id + "' ";

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDelete(ReturnD returnD)
    {
        string sSql =
                        "  DELETE [MNDTreturn_details]  " +
                        "  WHERE [return_id] = '" + returnD.return_id + "' " +
                        "   AND [seq] = '" + returnD.seq + "' ";

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public bool fnIsExist(ReturnD returnD)
    {
        string sSql =
                        "  SELECT COUNT([material_id])   " +
                        "  FROM   [MNDTreturn_details]   " +
                        "  WHERE [return_id] = '" + returnD.return_id + "' " +
                        "       AND [material_id] = '" + returnD.material_id + "' " +
                        "       AND [warehouse_id] = '" + returnD.warehouse_id + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }

    #endregion




    #region ReturnMasterTran

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(ReturnMTran returnMTran, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[return_id]", returnMTran.return_id);

        string sInquireSql =
                        "  SELECT [return_m_tran].[ip],   " +
                        "         [return_m_tran].[status],   " +
                        "         [return_m_tran].[create_id],   " +
                        "         CONVERT(char, [return_m_tran].[create_datetime], 120) 'create_datetime'   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [create_datetime] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTreturn_master_tran]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [return_m_tran]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnCount(ReturnMTran returnMTran)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[return_id]", returnMTran.return_id);

        string sCountSql =
                        "          SELECT COUNT(return_id)   " +
                        "          FROM   [MNDTreturn_master_tran]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    private string fnInsertSql(ReturnMTran returnMTran)
    {
        string sSql =
                        "  INSERT INTO [MNDTreturn_master_tran]  " +
                        "             ([return_id]  " +
                        "             ,[ip]  " +
                        "             ,[status]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "  VALUES  " +
                        "             ('" + returnMTran.return_id + "'  " +
                        "             ,'" + returnMTran.ip + "' " +
                        "             ,'" + returnMTran.status + "'  " +
                        "             ,'" + returnMTran.create_id + "'  " +
                        "             ,GETDATE())  ";

        return sSql;
    }

    #endregion
}