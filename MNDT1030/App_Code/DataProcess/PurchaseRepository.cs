using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// PurchaseRepository 的摘要描述
/// </summary>
public class PurchaseRepository
{
    public PurchaseRepository()
    {
    }

    #region PurchaseMaster

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(PurchaseM purchaseM, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;

        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", purchaseM.order_id);
        sCondition += PublicApi.fnAddCondition("[id]", purchaseM.id);
        sCondition += PublicApi.fnAddCondition("CONVERT(varchar(10), [datetime], 126)", purchaseM.datetime);

        string sInquireSql =
                        "  SELECT [purchase_m].[NUM],   " +
                        "         [purchase_m].[order_id],   " +
                        "         [purchase_m].[id],   " +
                        "         [purchase_m].[complete],   " +
                        "         CONVERT(CHAR, [purchase_m].[datetime], 111) [datetime]   " +
                        "  FROM   (SELECT Row_number() OVER(ORDER BY[" + purchaseM.order + "] ASC) NUM, " +
                        "                  *   " +
                        "          FROM   [MNDTpurchase_master]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [purchase_m]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString();

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnCount(PurchaseM purchaseM)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", purchaseM.order_id);
        sCondition += PublicApi.fnAddCondition("[id]", purchaseM.id);
        sCondition += PublicApi.fnAddCondition("CONVERT(varchar(10), [datetime], 126)", purchaseM.datetime);

        string sCountSql =
                        "          SELECT COUNT([order_id])   " +
                        "          FROM   [MNDTpurchase_master]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    // sNum 排行
    public string fnSelectOrderId(PurchaseM purchaseM, string sNum)
    {
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[order_id]", purchaseM.order_id);
        sCondition += PublicApi.fnAddCondition("[id]", purchaseM.id);
        sCondition += PublicApi.fnAddCondition("CONVERT(varchar(10), [datetime], 126)", purchaseM.datetime);

        string sSql = "  SELECT [purchase_m].[order_id]  " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + purchaseM.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTpurchase_master]   " +
                        "          WHERE  1 = 1" + sCondition + ") AS [purchase_m]  " +
                        "  WHERE [purchase_m].[NUM] = '" + sNum + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public DataTable fnSelect(PurchaseM purchaseM)
    {
        string sSql = "  SELECT TOP 1 [order_id]  " +
                        "        ,[id]  " +
                        "        ,CONVERT(varchar(10), [datetime], 126) [datetime]  " +
                        "        ,[complete]  " +
                        "        ,[status]  " +
                        "        ,[description]  " +
                        "        ,[create_id]  " +
                        "        ,CONVERT(char, [create_datetime], 120) [create_datetime]  " +
                        "  FROM [MNDTpurchase_master]  " +
                        "  WHERE [order_id] = '" + purchaseM.order_id + "' ";
        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    public string fnInsert(PurchaseM purchaseM)
    {
        string sSql = "  INSERT INTO [dbo].[MNDTpurchase_master]  " +
                        "             ([order_id]  " +
                        "             ,[id]  " +
                        "             ,[datetime]  " +
                        "             ,[complete]  " +
                        "             ,[description]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "       VALUES  " +
                        "             ('" + purchaseM.order_id + "'  " +
                        "             ,'" + purchaseM.id + "'  " +
                        "             ,'" + purchaseM.datetime + "'  " +
                        "             ,'N' " +
                        "             ,'" + purchaseM.description + "'  " +
                        "             ,'" + purchaseM.create_id + "'  " +
                        "             ,GETDATE())  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnUpdate(PurchaseM purchaseM, string sIP)
    {
        string sSql = "  UPDATE [dbo].[MNDTpurchase_master]  " +
                        "     SET [id] = '" + purchaseM.id + "'  " +
                        "        ,[datetime] = '" + purchaseM.datetime + "'  " +
                        "        ,[complete] = '" + purchaseM.complete + "'  " +
                        "        ,[status] = '" + purchaseM.status + "'  " +
                        "        ,[description] = '" + purchaseM.description + "'  " +
                        "  WHERE [order_id] = '" + purchaseM.order_id + "' ";
        PurchaseMTran purchaseMTran = new PurchaseMTran();

        purchaseMTran.OrderId(purchaseM.order_id)
                    .IP(sIP)
                    .Status("D")
                    .CreateId(purchaseM.create_id);
        sSql += fnInsertSql(purchaseMTran);
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDelete(PurchaseM purchaseM, string sIP)
    {
        string sSql =
                        " UPDATE [MNDTpurchase_master] " +
                        " SET [status] = 'D' " +
                        " WHERE [order_id] = '" + purchaseM.order_id + "' ";
        PurchaseMTran purchaseMTran = new PurchaseMTran();

        purchaseMTran.OrderId(purchaseM.order_id)
                    .IP(sIP)
                    .Status("D")
                    .CreateId(purchaseM.create_id);
        sSql += fnInsertSql(purchaseMTran);
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnChange(PurchaseM purchaseM, string sIP)
    {
        string sSql = "  UPDATE [dbo].[MNDTpurchase_master]  " +
                        "     SET [complete] = 'Y'  " +
                        "  WHERE [order_id] = '" + purchaseM.order_id + "' ";
        PurchaseMTran purchaseMTran = new PurchaseMTran();

        purchaseMTran.OrderId(purchaseM.order_id)
                    .IP(sIP)
                    .Status("M")
                    .CreateId(purchaseM.create_id);
        sSql += fnInsertSql(purchaseMTran);
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public bool fnIsExist(PurchaseM purchaseM)
    {
        string sSql = "  SELECT COUNT([order_id])   " +
                        "  FROM   [MNDTpurchase_master]   " +
                        "  WHERE  [order_id] = '" + purchaseM.order_id + "'   ";
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }

    #endregion



    #region PurchaseDetails

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(PurchaseD purchaseD, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;

        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", purchaseD.order_id);

        string sInquireSql =
                        "  SELECT [purchase_d].[material_id],   " +
                        "         [purchase_d].[amount],   " +
                        "         [purchase_d].[price],   " +
                        "         [purchase_d].[modify_amount],   " +
                        "         [purchase_d].[modify_price],   " +
                        "         [purchase_d].[description]   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [material_id] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTpurchase_details]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [purchase_d]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnSelectAmount(PurchaseD purchaseD)
    {
        string sSql = "  SELECT ISNULL(SUM([modify_amount]), '0')  " +
                        "  FROM [MNDTpurchase_details]  " +
                        "  WHERE [order_id] = '" + purchaseD.order_id + "' " +
                        "   AND [material_id] = '" + purchaseD.material_id + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public string fnCount(PurchaseD purchaseD)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", purchaseD.order_id);

        string sCountSql =
                        "          SELECT COUNT([order_id])   " +
                        "          FROM   [MNDTpurchase_details]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    public string fnInsert(PurchaseD purchaseD)
    {
        return PublicApi.fnExecuteSQL(fnInsertSql(purchaseD), "MNDT");
    }

    public string fnInsertSql(PurchaseD purchaseD)
    {
        string sSql = "  INSERT INTO [MNDTpurchase_details]  " +
                        "             ([order_id]  " +
                        "             ,[material_id]  " +
                        "             ,[amount]  " +
                        "             ,[price]  " +
                        "             ,[modify_amount]  " +
                        "             ,[modify_price]  " +
                        "             ,[description]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime] " +
                        "             ,[modify_id]  " +
                        "             ,[modify_datetime])  " +
                        "       VALUES  " +
                        "             ('" + purchaseD.order_id + "'  " +
                        "             ,'" + purchaseD.material_id + "'  " +
                        "             ,'" + purchaseD.amount + "'  " +
                        "             ,'" + purchaseD.price + "'  " +
                        "             ,'" + purchaseD.amount + "'  " +
                        "             ,'" + purchaseD.price + "'  " +
                        "             ,'" + purchaseD.description + "'  " +
                        "             ,'" + purchaseD.create_id + "'  " +
                        "             ,GETDATE() " +
                        "             ,'" + purchaseD.create_id + "'  " +
                        "             ,GETDATE())  ";
        return sSql;
    }

    public string fnUpdate(PurchaseD purchaseD)
    {
        string sSql =
                        "  UPDATE [MNDTpurchase_details]  " +
                        "     SET [modify_amount] = '" + purchaseD.modify_amount + "'  " +
                        "        ,[modify_price] = '" + purchaseD.modify_price + "'  " +
                        "        ,[description] = '" + purchaseD.description + "'  " +
                        "        ,[modify_id] = '" + purchaseD.create_id + "'  " +
                        "        ,[modify_datetime] = GETDATE()  " +
                        " WHERE [order_id] = '" + purchaseD.order_id + "' " +
                        "   AND [material_id] = '" + purchaseD.material_id + "' ";

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnAccumulateUpdateSql(PurchaseD purchaseD)
    {
        string sSql =
                        "  UPDATE [MNDTpurchase_details]  " +
                        "     SET [modify_amount] = modify_amount + '" + purchaseD.modify_amount + "'  " +
                        "        ,[modify_price] = modify_price + '" + purchaseD.modify_price + "'  " +
                        "        ,[modify_id] = '" + purchaseD.create_id + "'  " +
                        "        ,[modify_datetime] = GETDATE()  " +
                        " WHERE [order_id] = '" + purchaseD.order_id + "' " +
                        "   AND [material_id] = '" + purchaseD.material_id + "' ";

        return sSql;
    }

    public string fnDelete(PurchaseD purchaseD)
    {
        string sSql =
                        "  DELETE [MNDTpurchase_details]  " +
                        "  WHERE [order_id] = '" + purchaseD.order_id + "' " +
                        "   AND [material_id] = '" + purchaseD.material_id + "' ";

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public bool fnIsExist(PurchaseD purchaseD)
    {
        string sSql =
                        "  SELECT COUNT([material_id])   " +
                        "  FROM   [MNDTpurchase_details]   " +
                        "  WHERE [order_id] = '" + purchaseD.order_id + "' " +
                        "       AND [material_id] = '" + purchaseD.material_id + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }

    #endregion




    #region PurchaseMasterTran

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(PurchaseMTran purchaseMTran, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", purchaseMTran.order_id);

        string sInquireSql =
                        "  SELECT [purchase_m_tran].[ip],   " +
                        "         [purchase_m_tran].[status],   " +
                        "         [purchase_m_tran].[create_id],   " +
                        "         CONVERT(char, [purchase_m_tran].[create_datetime], 120) 'create_datetime'   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [create_datetime] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTpurchase_master_tran]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [purchase_m_tran]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnCount(PurchaseMTran purchaseMTran)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", purchaseMTran.order_id);

        string sCountSql =
                        "          SELECT COUNT(order_id)   " +
                        "          FROM   [MNDTpurchase_master_tran]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    private string fnInsertSql(PurchaseMTran purchaseMTran)
    {
        string sSql =
                        "  INSERT INTO [MNDTpurchase_master_tran]  " +
                        "             ([order_id]  " +
                        "             ,[ip]  " +
                        "             ,[status]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "  VALUES  " +
                        "             ('" + purchaseMTran.order_id + "'  " +
                        "             ,'" + purchaseMTran.ip + "' " +
                        "             ,'" + purchaseMTran.status + "'  " +
                        "             ,'" + purchaseMTran.create_id + "'  " +
                        "             ,GETDATE())  ";

        return sSql;
    }

    #endregion
}