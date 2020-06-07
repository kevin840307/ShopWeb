using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// ReceiveRepository 的摘要描述
/// </summary>
public class ReceiveRepository
{
    public ReceiveRepository()
    {
    }

    public string fnChangeInsert(ReceiveM receiveM)
    {
        string sSql = "  INSERT INTO [dbo].[MNDTreceive_master]  " +
                        "             ([order_id]  " +
                        "             ,[id]  " +
                        "             ,[datetime]  " +
                        "             ,[complete]  " +
                        "             ,[description]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "       VALUES  " +
                        "             ('" + receiveM.order_id + "'  " +
                        "             ,'" + receiveM.create_id + "'  " +
                        "             ,GETDATE()  " +
                        "             ,'N' " +
                        "             ,''  " +
                        "             ,'" + receiveM.create_id + "'  " +
                        "             ,GETDATE())  ";
        sSql += 
                        "  INSERT INTO [MNDTreceive_details]  " +
                        "             ([seq]  " +
                        "             ,[order_id]  " +
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
                        "  SELECT Row_number() OVER(ORDER BY[material_id] ASC) NUM  " +
                        "        ,[order_id]  " +
                        "        ,[material_id]  " +
                        "        ,''  " +
                        "        ,[modify_amount]  " +
                        "        ,[modify_price]  " +
                        "        ,'N'  " +
                        "        ,'N'  " +
                        "        ,''  " +
                        "        ,'" + receiveM.create_id + "'  " +
                        "        ,GETDATE()  " +
                        "        ,'" + receiveM.create_id + "'  " + 
                        "        ,GETDATE()  " +
                        "  FROM [MNDTpurchase_details]  " +
                        "  WHERE order_id = '" + receiveM.order_id + "'  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    #region ReceiveMaster

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(ReceiveM receiveM, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;

        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", receiveM.order_id);
        sCondition += PublicApi.fnAddCondition("[id]", receiveM.id);
        sCondition += PublicApi.fnAddCondition("CONVERT(varchar(10), [datetime], 126)", receiveM.datetime);

        string sSql =
                        "  SELECT [receive_m].[NUM],   " +
                        "         [receive_m].[order_id],   " +
                        "         [receive_m].[id],   " +
                        "         [receive_m].[complete],   " +
                        "         CONVERT(CHAR, [receive_m].[datetime], 111) [datetime]   " +
                        "  FROM   (SELECT Row_number() OVER(ORDER BY[" + receiveM.order + "] ASC) NUM, " +
                        "                  *   " +
                        "          FROM   [MNDTreceive_master]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [receive_m]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString();

        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    public string fnCount(ReceiveM receiveM)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", receiveM.order_id);
        sCondition += PublicApi.fnAddCondition("[id]", receiveM.id);
        sCondition += PublicApi.fnAddCondition("CONVERT(varchar(10), [datetime], 126)", receiveM.datetime);

        string sCountSql =
                        "          SELECT COUNT([order_id])   " +
                        "          FROM   [MNDTreceive_master]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(string sCompanyId, string sDateS, string sDateE, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;

        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[material].[company_id]", sCompanyId);

        if(sDateS.Length > 0)
        {
            sCondition += " AND CONVERT(varchar(10), [receive_m].[datetime], 126) >= '" + sDateS + "' ";
        }

        if (sDateS.Length > 0)
        {
            sCondition += " AND CONVERT(varchar(10), [receive_m].[datetime], 126) <= '" + sDateE + "' ";
        }

        string sSql =
                        "  SELECT [data].*   " +
                        "  FROM   (SELECT Row_number() OVER(ORDER BY [material].[company_id] ASC) NUM, " +
                        "                 [material].[company_id],   " +
                        "                 [receive_d].[material_id],   " +
                        "                 Sum([receive_d].[amount]) [amount],   " +
                        "                 Sum([receive_d].[price]) [price]   " +
                        "          FROM   [MNDTreceive_master] [receive_m]   " +
                        "                 LEFT JOIN [MNDTreceive_details] [receive_d]   " +
                        "                        ON [receive_m].[order_id] = [receive_d].[order_id]   " +
                        "                 LEFT JOIN [MNDTmaterial] [material]   " +
                        "                        ON [receive_d].[material_id] = [material].[material_id]   " +
                        "          WHERE  [receive_m].[status] <> 'D'   " +
                        "                 AND [receive_d].[pay_complete] <> 'Y' " + sCondition +
                        "          GROUP  BY [material].[company_id],   " +
                        "                    [receive_d].[material_id]) AS [data]   " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString();

        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    public string fnCount(string sCompanyId, string sDateS, string sDateE)
    {
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[material].[company_id]", sCompanyId);

        if (sDateS.Length > 0)
        {
            sCondition += " AND CONVERT(varchar(10), [receive_m].[datetime], 126) >= '" + sDateS + "' ";
        }

        if (sDateS.Length > 0)
        {
            sCondition += " AND CONVERT(varchar(10), [receive_m].[datetime], 126) <= '" + sDateE + "' ";
        }

        string sCountSql =
                        "  SELECT COUNT([material].[company_id])   " +
                        "  FROM   [MNDTreceive_master] [receive_m]   " +
                        "         LEFT JOIN [MNDTreceive_details] [receive_d]   " +
                        "                ON [receive_m].[order_id] = [receive_d].[order_id]   " +
                        "         LEFT JOIN [MNDTmaterial] [material]   " +
                        "                ON [receive_d].[material_id] = [material].[material_id]   " +
                        "  WHERE  [receive_m].[status] <> 'D'   " +
                        "         AND [receive_d].[pay_complete] <> 'Y' " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    // sNum 排行
    public string fnSelectOrderId(ReceiveM receiveM, string sNum)
    {
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[order_id]", receiveM.order_id);
        sCondition += PublicApi.fnAddCondition("[id]", receiveM.id);
        sCondition += PublicApi.fnAddCondition("CONVERT(varchar(10), [datetime], 126)", receiveM.datetime);

        string sSql = "  SELECT [receive_m].[order_id]  " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + receiveM.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTreceive_master]   " +
                        "          WHERE  1 = 1" + sCondition + ") AS [receive_m]  " +
                        "  WHERE [receive_m].[NUM] = '" + sNum + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public DataTable fnSelect(ReceiveM receiveM)
    {
        string sSql = "  SELECT TOP 1 [order_id]  " +
                        "        ,[id]  " +
                        "        ,CONVERT(varchar(10), [datetime], 126) [datetime]  " +
                        "        ,[complete]  " +
                        "        ,[status]  " +
                        "        ,[description]  " +
                        "        ,[create_id]  " +
                        "        ,CONVERT(char, [create_datetime], 120) [create_datetime]  " +
                        "  FROM [MNDTreceive_master]  " +
                        "  WHERE [order_id] = '" + receiveM.order_id + "' ";
        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    public string fnInsert(ReceiveM receiveM)
    {
        string sSql = "  INSERT INTO [dbo].[MNDTreceive_master]  " +
                        "             ([order_id]  " +
                        "             ,[id]  " +
                        "             ,[datetime]  " +
                        "             ,[complete]  " +
                        "             ,[description]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "       VALUES  " +
                        "             ('" + receiveM.order_id + "'  " +
                        "             ,'" + receiveM.id + "'  " +
                        "             ,'" + receiveM.datetime + "'  " +
                        "             ,'N' " +
                        "             ,'" + receiveM.description + "'  " +
                        "             ,'" + receiveM.create_id + "'  " +
                        "             ,GETDATE())  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnUpdate(ReceiveM receiveM, string sIP)
    {
        string sSql = "  UPDATE [dbo].[MNDTreceive_master]  " +
                        "     SET [id] = '" + receiveM.id + "'  " +
                        "        ,[datetime] = '" + receiveM.datetime + "'  " +
                        "        ,[complete] = '" + receiveM.complete + "'  " +
                        "        ,[status] = '" + receiveM.status + "'  " +
                        "        ,[description] = '" + receiveM.description + "'  " +
                        "  WHERE [order_id] = '" + receiveM.order_id + "' ";
        ReceiveMTran receiveMTran = new ReceiveMTran();

        receiveMTran.OrderId(receiveM.order_id)
                    .IP(sIP)
                    .Status("M")
                    .CreateId(receiveM.create_id);
        sSql += fnInsertSql(receiveMTran);
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnChange(ReceiveM receiveM, string sIP)
    {
        string sSql = 
                        "  UPDATE [dbo].[MNDTreceive_master]  " +
                        "     SET [complete] = 'Y'  " +
                        "  WHERE [order_id] = '" + receiveM.order_id + "' " +
                        "  UPDATE [dbo].[MNDTreceive_details]  " +
                        "     SET [complete] = 'Y'  " +
                        "  WHERE [order_id] = '" + receiveM.order_id + "' ";

        ReceiveMTran receiveMTran = new ReceiveMTran();

        receiveMTran.OrderId(receiveM.order_id)
                    .IP(sIP)
                    .Status("M")
                    .CreateId(receiveM.create_id);
        sSql += fnInsertSql(receiveMTran);
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDelete(ReceiveM receiveM, string sIP)
    {
        string sSql =
                        " UPDATE [MNDTreceive_master] " +
                        " SET [status] = 'D' " +
                        " WHERE [order_id] = '" + receiveM.order_id + "' ";
        ReceiveMTran receiveMTran = new ReceiveMTran();

        receiveMTran.OrderId(receiveM.order_id)
                    .IP(sIP)
                    .Status("D")
                    .CreateId(receiveM.create_id);
        sSql += fnInsertSql(receiveMTran);
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public bool fnIsExist(ReceiveM receiveM)
    {
        string sSql = "  SELECT COUNT([order_id])   " +
                        "  FROM   [MNDTreceive_master]   " +
                        "  WHERE  [order_id] = '" + receiveM.order_id + "'   ";
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }

    #endregion



    #region ReceiveDetails

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(ReceiveD receiveD, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;

        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", receiveD.order_id);

        string sInquireSql =
                        "  SELECT [receive_d].[seq],   " +
                        "         [receive_d].[material_id],   " +
                        "         [receive_d].[warehouse_id],   " +
                        "         [receive_d].[amount],   " +
                        "         [receive_d].[price],   " +
                        "         CASE [receive_d].[complete] WHEN 'Y' THEN 'checked' ELSE '' END [complete],   " +
                        "         CASE [receive_d].[pay_complete] WHEN 'Y' THEN 'checked' ELSE '' END [pay_complete],   " +
                        "         [receive_d].[description]   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [seq] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTreceive_details]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [receive_d]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnSelects(ReceiveD receiveD)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", receiveD.order_id);

        string sInquireSql =
                        "  SELECT [receive_d].[seq],   " +
                        "         [receive_d].[material_id],   " +
                        "         [receive_d].[warehouse_id],   " +
                        "         [receive_d].[amount],   " +
                        "         [receive_d].[price],   " +
                        "         CASE [receive_d].[complete] WHEN 'Y' THEN 'checked' ELSE '' END [complete],   " +
                        "         CASE [receive_d].[pay_complete] WHEN 'Y' THEN 'checked' ELSE '' END [pay_complete],   " +
                        "         [receive_d].[description]   " +
                        "  FROM   [MNDTreceive_details] AS [receive_d]  " +
                        "  WHERE 1 = 1 " + sCondition;

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnSelect(ReceiveD receiveD)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", receiveD.order_id);
        sCondition += PublicApi.fnAddCondition("[seq]", receiveD.seq);

        string sInquireSql =
                        "  SELECT [receive_d].*   " +
                        "  FROM   [MNDTreceive_details] AS [receive_d]  " +
                        "          WHERE  1 = 1 " + sCondition;

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnSelectAllAmount(ReceiveD receiveD)
    {
        string sSql = "  SELECT ISNULL(SUM([amount]), '0')  " +
                       "  FROM [MNDTreceive_details]  " +
                       "  WHERE [order_id] = '" + receiveD.order_id + "' " +
                       "   AND [material_id] = '" + receiveD.material_id + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public string fnSelectAmount(ReceiveD receiveD)
    {
        string sSql = "  SELECT ISNULL(SUM([amount]), '0')  " +
                       "  FROM [MNDTreceive_details]  " +
                       "  WHERE [order_id] = '" + receiveD.order_id + "' " +
                       "   AND [material_id] = '" + receiveD.material_id + "' " +
                       "   AND [warehouse_id] = '" + receiveD.warehouse_id + "' "; ;
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public string fnSelectExcludeAmount(ReceiveD receiveD)
    {
        string sSql = "  SELECT ISNULL(SUM([amount]), '0')  " +
                       "  FROM [MNDTreceive_details]  " +
                       "  WHERE [order_id] = '" + receiveD.order_id + "' " +
                       "   AND [material_id] = '" + receiveD.material_id + "' " +
                       "   AND [seq] <> '" + receiveD.seq + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public string fnCount(ReceiveD receiveD)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", receiveD.order_id);

        string sCountSql =
                        "          SELECT COUNT([order_id])   " +
                        "          FROM   [MNDTreceive_details]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    public string fnInsert(ReceiveD receiveD)
    {
        string sSql = "  INSERT INTO [MNDTreceive_details]  " +
                        "             ([seq]  " +
                        "             ,[order_id]  " +
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
                        "             ('" + receiveD.seq + "'  " +
                        "             ,'" + receiveD.order_id + "'  " +
                        "             ,'" + receiveD.material_id + "'  " +
                        "             ,'" + receiveD.warehouse_id + "'  " +
                        "             ,'" + receiveD.amount + "'  " +
                        "             ,'" + receiveD.price + "'  " +
                        "             ,'N'  " +
                        "             ,'N'  " +
                        "             ,'" + receiveD.description + "'  " +
                        "             ,'" + receiveD.create_id + "'  " +
                        "             ,GETDATE() " +
                        "             ,'" + receiveD.create_id + "'  " +
                        "             ,GETDATE())  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnGetSeq(ReceiveD receiveD)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", receiveD.order_id);

        string sSql =
                       "  SELECT ISNULL(MAX([seq]), 0) + 1   " +
                       "  FROM   [MNDTreceive_details] AS [receive_d]  " +
                       "          WHERE  1 = 1 " + sCondition;
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public string fnUpdate(ReceiveD receiveD)
    {
        string sSql =
                        "  UPDATE [MNDTreceive_details]  " +
                        "     SET [material_id] = '" + receiveD.material_id + "'  " +
                        "        ,[warehouse_id] = '" + receiveD.warehouse_id + "'  " +
                        "        ,[amount] = '" + receiveD.amount + "'  " +
                        "        ,[price] = '" + receiveD.price + "'  " +
                        "        ,[complete] = '" + receiveD.complete + "'  " +
                        "        ,[pay_complete] = '" + receiveD.pay_complete + "'  " +
                        "        ,[description] = '" + receiveD.description + "'  " +
                        "        ,[modify_id] = '" + receiveD.create_id + "'  " +
                        "        ,[modify_datetime] = GETDATE()  " +
                        " WHERE [order_id] = '" + receiveD.order_id + "' " +
                        "   AND [seq] = '" + receiveD.seq + "' ";

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnVerifications(ReceiveD receiveD)
    {
        string sSql =
                        "  UPDATE [MNDTreceive_details]  " +
                        "     SET [complete] = '" + receiveD.complete + "'  " +
                        "        ,[pay_complete] = '" + receiveD.pay_complete + "'  " +
                        "        ,[modify_id] = '" + receiveD.create_id + "'  " +
                        "        ,[modify_datetime] = GETDATE()  " +
                        " WHERE [order_id] = '" + receiveD.order_id + "' " +
                        "   AND [seq] = '" + receiveD.seq + "' ";

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnAudits(ReceiveD receiveD)
    {
        string sSql =
                        "  UPDATE [MNDTreceive_details]  " +
                        "     SET [complete] = '" + receiveD.complete + "'  " +
                        "        ,[modify_id] = '" + receiveD.create_id + "'  " +
                        "        ,[modify_datetime] = GETDATE()  " +
                        " WHERE [order_id] = '" + receiveD.order_id + "' ";

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDelete(ReceiveD receiveD)
    {
        string sSql =
                        "  DELETE [MNDTreceive_details]  " +
                        "  WHERE [order_id] = '" + receiveD.order_id + "' " +
                        "       AND [seq] = '" + receiveD.seq + "' ";

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public bool fnIsExist(ReceiveD receiveD)
    {
        string sCondition = "";

        if(receiveD.seq != null && receiveD.seq.Length > 0)
        {
            sCondition += " AND [seq] <> " + receiveD.seq;
        }

        string sSql =
                        "  SELECT COUNT([material_id])   " +
                        "  FROM   [MNDTreceive_details]   " +
                        "  WHERE [order_id] = '" + receiveD.order_id + "' " +
                        "       AND [material_id] = '" + receiveD.material_id + "' " +
                        "       AND [warehouse_id] = '" + receiveD.warehouse_id + "' " + sCondition;
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }

    #endregion




    #region ReceiveMasterTran

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(ReceiveMTran receiveMTran, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", receiveMTran.order_id);

        string sInquireSql =
                        "  SELECT [receive_m_tran].[ip],   " +
                        "         [receive_m_tran].[status],   " +
                        "         [receive_m_tran].[create_id],   " +
                        "         CONVERT(char, [receive_m_tran].[create_datetime], 120) 'create_datetime'   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [create_datetime] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTreceive_master_tran]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [receive_m_tran]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnCount(ReceiveMTran receiveMTran)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", receiveMTran.order_id);

        string sCountSql =
                        "          SELECT COUNT(order_id)   " +
                        "          FROM   [MNDTreceive_master_tran]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    private string fnInsertSql(ReceiveMTran receiveMTran)
    {
        string sSql =
                        "  INSERT INTO [MNDTreceive_master_tran]  " +
                        "             ([order_id]  " +
                        "             ,[ip]  " +
                        "             ,[status]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "  VALUES  " +
                        "             ('" + receiveMTran.order_id + "'  " +
                        "             ,'" + receiveMTran.ip + "' " +
                        "             ,'" + receiveMTran.status + "'  " +
                        "             ,'" + receiveMTran.create_id + "'  " +
                        "             ,GETDATE())  ";

        return sSql;
    }

    #endregion


    public DataTable fnSelectList()
    {
        string sSql =
                        "  SELECT [receive_m].[order_id] [value],   " +
                        "         [receive_m].[order_id] [name]  " +
                        "  FROM [MNDTreceive_master] AS [receive_m]  " +
                        "  WHERE [status] <> 'D' " +
                        "       AND [complete] = 'Y' ";

        return PublicApi.fnGetDt(sSql, "MNDT");
    }
}