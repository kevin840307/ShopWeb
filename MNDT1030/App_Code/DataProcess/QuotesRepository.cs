using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// QuotesRepository 的摘要描述
/// </summary>
public class QuotesRepository
{
    public QuotesRepository()
    {
    }

    #region QuotesMaster

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(QuotesM quotesM, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;

        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", quotesM.order_id);
        sCondition += PublicApi.fnAddCondition("[id]", quotesM.id);
        sCondition += PublicApi.fnAddCondition("[client_id]", quotesM.client_id);
        sCondition += PublicApi.fnAddCondition("CONVERT(varchar(10), [datetime], 126)", quotesM.datetime);

        string sInquireSql =
                        "  SELECT [quotes_m].[NUM],   " +
                        "         [quotes_m].[order_id],   " +
                        "         [quotes_m].[id],   " +
                        "         [quotes_m].[complete],   " +
                        "         CONVERT(CHAR, [quotes_m].[datetime], 111) [datetime]   " +
                        "  FROM   (SELECT Row_number() OVER(ORDER BY[" + quotesM.order + "] ASC) NUM, " +
                        "                  *   " +
                        "          FROM   [MNDTquotes_master]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [quotes_m]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString();

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnCount(QuotesM quotesM)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", quotesM.order_id);
        sCondition += PublicApi.fnAddCondition("[id]", quotesM.id);
        sCondition += PublicApi.fnAddCondition("[client_id]", quotesM.client_id);
        sCondition += PublicApi.fnAddCondition("CONVERT(varchar(10), [datetime], 126)", quotesM.datetime);

        string sCountSql =
                        "          SELECT COUNT([order_id])   " +
                        "          FROM   [MNDTquotes_master]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    // sNum 排行
    public string fnSelectOrderId(QuotesM quotesM, string sNum)
    {
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[order_id]", quotesM.order_id);
        sCondition += PublicApi.fnAddCondition("[id]", quotesM.id);
        sCondition += PublicApi.fnAddCondition("[client_id]", quotesM.client_id);
        sCondition += PublicApi.fnAddCondition("CONVERT(varchar(10), [datetime], 126)", quotesM.datetime);

        string sSql = "  SELECT [quotes_m].[order_id]  " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + quotesM.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTquotes_master]   " +
                        "          WHERE  1 = 1" + sCondition + ") AS [quotes_m]  " +
                        "  WHERE [quotes_m].[NUM] = '" + sNum + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public DataTable fnSelect(QuotesM quotesM)
    {
        string sSql = "  SELECT TOP 1 [order_id]  " +
                        "        ,[id]  " +
                        "        ,[client_id]  " +
                        "        ,CONVERT(varchar(10), [datetime], 126) [datetime]  " +
                        "        ,[complete]  " +
                        "        ,[status]  " +
                        "        ,[description]  " +
                        "        ,[create_id]  " +
                        "        ,CONVERT(char, [create_datetime], 120) [create_datetime]  " +
                        "  FROM [MNDTquotes_master]  " +
                        "  WHERE [order_id] = '" + quotesM.order_id + "' ";
        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    public string fnInsert(QuotesM quotesM)
    {
        string sSql = "  INSERT INTO [dbo].[MNDTquotes_master]  " +
                        "             ([order_id]  " +
                        "             ,[id]  " +
                        "             ,[client_id]  " +
                        "             ,[datetime]  " +
                        "             ,[complete]  " +
                        "             ,[description]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "       VALUES  " +
                        "             ('" + quotesM.order_id + "'  " +
                        "             ,'" + quotesM.id + "'  " +
                        "             ,'" + quotesM.client_id + "'  " +
                        "             ,'" + quotesM.datetime + "'  " +
                        "             ,'N' " +
                        "             ,'" + quotesM.description + "'  " +
                        "             ,'" + quotesM.create_id + "'  " +
                        "             ,GETDATE())  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnUpdate(QuotesM quotesM, string sIP)
    {
        string sSql = "  UPDATE [dbo].[MNDTquotes_master]  " +
                        "     SET [id] = '" + quotesM.id + "'  " +
                        "        ,[client_id] = '" + quotesM.client_id + "'  " +
                        "        ,[datetime] = '" + quotesM.datetime + "'  " +
                        "        ,[complete] = '" + quotesM.complete + "'  " +
                        "        ,[status] = '" + quotesM.status + "'  " +
                        "        ,[description] = '" + quotesM.description + "'  " +
                        "  WHERE [order_id] = '" + quotesM.order_id + "' ";
        QuotesMTran quotesMTran = new QuotesMTran();

        quotesMTran.OrderId(quotesM.order_id)
                    .IP(sIP)
                    .Status("D")
                    .CreateId(quotesM.create_id);
        sSql += fnInsertSql(quotesMTran);
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDelete(QuotesM quotesM, string sIP)
    {
        string sSql =
                        " UPDATE [MNDTquotes_master] " +
                        " SET [status] = 'D' " +
                        " WHERE [order_id] = '" + quotesM.order_id + "' ";
        QuotesMTran quotesMTran = new QuotesMTran();

        quotesMTran.OrderId(quotesM.order_id)
                    .IP(sIP)
                    .Status("D")
                    .CreateId(quotesM.create_id);
        sSql += fnInsertSql(quotesMTran);
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnChange(QuotesM quotesM, string sIP)
    {
        string sSql = "  UPDATE [dbo].[MNDTquotes_master]  " +
                        "     SET [complete] = 'Y'  " +
                        "  WHERE [order_id] = '" + quotesM.order_id + "' ";
        QuotesMTran quotesMTran = new QuotesMTran();

        quotesMTran.OrderId(quotesM.order_id)
                    .IP(sIP)
                    .Status("M")
                    .CreateId(quotesM.create_id);
        sSql += fnInsertSql(quotesMTran);
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public bool fnIsExist(QuotesM quotesM)
    {
        string sSql = "  SELECT COUNT([order_id])   " +
                        "  FROM   [MNDTquotes_master]   " +
                        "  WHERE  [order_id] = '" + quotesM.order_id + "'   ";
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }

    #endregion



    #region QuotesDetails

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(QuotesD quotesD, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;

        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", quotesD.order_id);

        string sInquireSql =
                        "  SELECT [quotes_d].[product_id],   " +
                        "         [quotes_d].[amount],   " +
                        "         [quotes_d].[price],   " +
                        "         [quotes_d].[modify_amount],   " +
                        "         [quotes_d].[modify_price],   " +
                        "         [quotes_d].[description]   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [product_id] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTquotes_details]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [quotes_d]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnSelectAmount(QuotesD quotesD)
    {
        string sSql = "  SELECT ISNULL(SUM([modify_amount]), '0')  " +
                        "  FROM [MNDTquotes_details]  " +
                        "  WHERE [order_id] = '" + quotesD.order_id + "' " +
                        "   AND [product_id] = '" + quotesD.product_id + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public string fnCount(QuotesD quotesD)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", quotesD.order_id);

        string sCountSql =
                        "          SELECT COUNT([order_id])   " +
                        "          FROM   [MNDTquotes_details]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    public string fnInsert(QuotesD quotesD)
    {
        string sSql = "  INSERT INTO [MNDTquotes_details]  " +
                        "             ([order_id]  " +
                        "             ,[product_id]  " +
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
                        "             ('" + quotesD.order_id + "'  " +
                        "             ,'" + quotesD.product_id + "'  " +
                        "             ,'" + quotesD.amount + "'  " +
                        "             ,'" + quotesD.price + "'  " +
                        "             ,'" + quotesD.amount + "'  " +
                        "             ,'" + quotesD.price + "'  " +
                        "             ,'" + quotesD.description + "'  " +
                        "             ,'" + quotesD.create_id + "'  " +
                        "             ,GETDATE() " +
                        "             ,'" + quotesD.create_id + "'  " +
                        "             ,GETDATE())  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnUpdate(QuotesD quotesD)
    {
        string sSql =
                        "  UPDATE [MNDTquotes_details]  " +
                        "     SET [modify_amount] = '" + quotesD.modify_amount + "'  " +
                        "        ,[modify_price] = '" + quotesD.modify_price + "'  " +
                        "        ,[description] = '" + quotesD.description + "'  " +
                        "        ,[modify_id] = '" + quotesD.create_id + "'  " +
                        "        ,[modify_datetime] = GETDATE()  " +
                        " WHERE [order_id] = '" + quotesD.order_id + "' " +
                        "   AND [product_id] = '" + quotesD.product_id + "' ";

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }


    public string fnDelete(QuotesD quotesD)
    {
        string sSql =
                        "  DELETE [MNDTquotes_details]  " +
                        "  WHERE [order_id] = '" + quotesD.order_id + "' " +
                        "   AND [product_id] = '" + quotesD.product_id + "' ";

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public bool fnIsExist(QuotesD quotesD)
    {
        string sSql =
                        "  SELECT COUNT([product_id])   " +
                        "  FROM   [MNDTquotes_details]   " +
                        "  WHERE [order_id] = '" + quotesD.order_id + "' " +
                        "       AND [product_id] = '" + quotesD.product_id + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }

    #endregion




    #region QuotesMasterTran

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(QuotesMTran quotesMTran, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", quotesMTran.order_id);

        string sInquireSql =
                        "  SELECT [quotes_m_tran].[ip],   " +
                        "         [quotes_m_tran].[status],   " +
                        "         [quotes_m_tran].[create_id],   " +
                        "         CONVERT(char, [quotes_m_tran].[create_datetime], 120) 'create_datetime'   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [create_datetime] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTquotes_master_tran]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [quotes_m_tran]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnCount(QuotesMTran quotesMTran)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[order_id]", quotesMTran.order_id);

        string sCountSql =
                        "          SELECT COUNT(order_id)   " +
                        "          FROM   [MNDTquotes_master_tran]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    private string fnInsertSql(QuotesMTran quotesMTran)
    {
        string sSql =
                        "  INSERT INTO [MNDTquotes_master_tran]  " +
                        "             ([order_id]  " +
                        "             ,[ip]  " +
                        "             ,[status]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "  VALUES  " +
                        "             ('" + quotesMTran.order_id + "'  " +
                        "             ,'" + quotesMTran.ip + "' " +
                        "             ,'" + quotesMTran.status + "'  " +
                        "             ,'" + quotesMTran.create_id + "'  " +
                        "             ,GETDATE())  ";

        return sSql;
    }

    #endregion
}