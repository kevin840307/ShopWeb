using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// AccountRepository 的摘要描述
/// </summary>
public class ClientRepository
{
    public ClientRepository()
    {
    }

    #region Client

    // sNum 排行
    public string fnSelectClientId(Client client, string sNum)
    {
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[client_id]", client.client_id);
        sCondition += PublicApi.fnAddCondition("[name]", client.name);
        sCondition += PublicApi.fnAddCondition("[phone]", client.phone);
        sCondition += PublicApi.fnAddCondition("[status]", client.status);

        string sSql = "  SELECT [client].[client_id]  " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + client.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTclient]   " +
                        "          WHERE  1 = 1" + sCondition + ") AS [client]  " +
                        "  WHERE [client].[NUM] = '" + sNum + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public DataTable fnSelect(Client client)
    {
        string sSql = "  SELECT TOP 1 [client].[client_id]  " +
                        "        ,[client].[name]  " +
                        "        ,[client].[password]  " +
                        "        ,[client].[email]  " +
                        "        ,[client].[address]  " +
                        "        ,[client].[tel]  " +
                        "        ,[client].[phone]  " +
                        "        ,[client].[description]  " +
                        "        ,[client].[status]  " +
                        "  FROM   [MNDTclient] [client]  " +
                        "  WHERE [client].[client_id] = '" + client.client_id + "' ";
        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(Client client, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[client_id]", client.client_id);
        sCondition += PublicApi.fnAddCondition("[name]", client.name);
        sCondition += PublicApi.fnAddCondition("[phone]", client.phone);
        sCondition += PublicApi.fnAddCondition("[status]", client.status);

        string sInquireSql =
                        "  SELECT [client].[client_id],   " +
                        "         [client].[name],   " +
                        "         [client].[phone],   " +
                        "         CONVERT(CHAR, [client].[create_datetime], 111) [create_datetime],   " +
                        "         [client].[NUM]   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + client.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTclient]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [client]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnSelects(Client client)
    {
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[client_id]", client.client_id);
        sCondition += PublicApi.fnAddCondition("[name]", client.name);
        sCondition += PublicApi.fnAddCondition("[phone]", client.phone);
        sCondition += PublicApi.fnAddCondition("[status]", client.status);
        sCondition += " ORDER BY [" + client.order + "] ";
        string sInquireSql =
                        "  SELECT [client].[client_id],   " +
                        "         [client].[name],   " +
                        "         [client].[address],  " +
                        "         [client].[phone]   " +
                        "  FROM MNDTclient AS [client]  " +
                        "  WHERE 1 = 1 " + sCondition;
        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnExport(Client client)
    {
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[client_id]", client.client_id);
        sCondition += PublicApi.fnAddCondition("[name]", client.name);
        sCondition += PublicApi.fnAddCondition("[phone]", client.phone);
        sCondition += PublicApi.fnAddCondition("[status]", client.status);
        sCondition += " ORDER BY [" + client.order + "] ";
        string sInquireSql =
                        "  SELECT [client].[client_id] '帳號',   " +
                        "         [client].[password] '密碼',   " +
                        "         [client].[name] '名子',   " +
                        "         [client].[address] '地址',  " +
                        "         [client].[phone] '手機'  " +
                        "  FROM MNDTclient AS [client]  " +
                        "  WHERE 1 = 1 " + sCondition;
        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnInsert(Client client)
    {
        string sSql =
                        "  INSERT INTO [dbo].[MNDTclient]  " +
                        "             ([client_id]  " +
                        "             ,[password]  " +
                        "             ,[name]  " +
                        "             ,[email]  " +
                        "             ,[address]  " +
                        "             ,[tel]  " +
                        "             ,[phone]  " +
                        "             ,[description]  " +
                        "             ,[status]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "  VALUES  " +
                        "             ('" + client.client_id + "'  " +
                        "             ,'" + client.encrypt_password + "'  " +
                        "             ,'" + client.name + "' " +
                        "             ,'" + client.email + "'  " +
                        "             ,'" + client.address + "'  " +
                        "             ,'" + client.tel + "'  " +
                        "             ,'" + client.phone + "'  " +
                        "             ,'" + client.description + "'  " +
                        "             ,'N' " +
                        "             ,'" + client.create_id + "'  " +
                        "             ,GETDATE())  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnUpdate(Client client, string sIP, string sId)
    {
        string sSql = 
                        "  UPDATE [dbo].[MNDTclient]  " +
                        "     SET [password] = '" + client.encrypt_password + "'  " +
                        "        ,[name] = '" + client.name + "'  " +
                        "        ,[email] = '" + client.email + "'  " + 
                        "        ,[address] = '" + client.address + "'  " +
                        "        ,[phone] = '" + client.phone + "'  " +
                        "        ,[tel] = '" + client.tel + "'  " +
                        "        ,[description] = '" + client.description + "'  " +
                        "        ,[status] = '" + client.status + "'  " +
                        "  WHERE [client_id] = '" + client.client_id + "' ";
        ClientTran clientTran = new ClientTran();

        clientTran.ClientId(client.client_id)
                .IP(sIP)
                .Status("M")
                .CreateId(sId);
        sSql += fnInsertSql(clientTran);

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDelete(Client client, string sIP, string sId)
    {
        string sSql = " UPDATE [dbo].[MNDTclient] " +
                        "       SET [status] = 'D' " +
                        " WHERE [client_id] = '" + client.client_id + "' ";
        ClientTran clientTran = new ClientTran();

        clientTran.ClientId(client.client_id)
                .IP(sIP)
                .Status("D")
                .CreateId(sId);
        sSql += fnInsertSql(clientTran);

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDeletes(Client client, string sIP, string sId)
    {
        string sSql = " UPDATE [dbo].[MNDTclient] " +
                        "       SET [status] = 'D' " +
                        " WHERE [client_id] IN (" + client.client_id + ")";
        ClientTran clientTran = new ClientTran();

        clientTran.ClientId(client.client_id)
                .IP(sIP)
                .Status("D")
                .CreateId(sId);
        sSql += fnInsertsSql(clientTran);

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnCount(Client client)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[client_id]", client.client_id);
        sCondition += PublicApi.fnAddCondition("[name]", client.name);
        sCondition += PublicApi.fnAddCondition("[phone]", client.phone);
        sCondition += PublicApi.fnAddCondition("[status]", client.status);

        string sCountSql =
                        "          SELECT COUNT(client_id)   " +
                        "          FROM   [MNDTclient]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    public bool fnIsExist(Client client)
    {
        string sSql = "  SELECT COUNT([client_id])   " +
                        "  FROM   [MNDTclient]   " +
                        "  WHERE  [status] = 'N' " +
                        "       AND [client_id] = '" + client.client_id + "'   ";
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }

    public DataTable fnLogin(Client client)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[client_id]", client.client_id);
        sCondition += PublicApi.fnAddCondition("[password]", client.encrypt_password);
        sCondition += PublicApi.fnAddCondition("[status]", client.status);

        string sSql =
                       "          SELECT [client_id]   " +
                       "                ,[name]   " +
                       "          FROM   [MNDTclient]   " +
                       "          WHERE  1 = 1 " + sCondition;

        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    #endregion



    #region ClientTran

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(ClientTran clientTran, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[client_id]", clientTran.client_id);
        string sInquireSql =
                        "  SELECT [client_tran].[client_id],   " +
                        "         [client_tran].[ip],   " +
                        "         [client_tran].[status],   " +
                        "         [client_tran].[create_id],   " +
                        "         CONVERT(char, [client_tran].[create_datetime], 120) 'create_datetime'   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [create_datetime] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTclient_tran]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [client_tran]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    private string fnInsertSql(ClientTran clientTran)
    {
        string sSql =
                    "  INSERT INTO [MNDTclient_tran]  " +
                    "             ([client_id]  " +
                    "             ,[ip]  " +
                    "             ,[status]  " +
                    "             ,[create_id]  " +
                    "             ,[create_datetime])  " +
                    "       VALUES  " +
                    "             ('" + clientTran.client_id + "'  " +
                    "             , '" + clientTran.ip + "'  " +
                    "             , '" + clientTran.status + "'  " +
                    "             , '" + clientTran.create_id + "'  " +
                    "             , GETDATE())  ";
        return sSql;
    }

    private string fnInsertsSql(ClientTran clientTran)
    {
        string sSql =
                        "  INSERT INTO [MNDTclient_tran]  " +
                        "             ([client_id]  " +
                        "             ,[ip]  " +
                        "             ,[status]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "  SELECT [client_id]  " +
                        "        , '" + clientTran.ip + "'  " +
                        "        , '" + clientTran.status + "'  " +
                        "        , '" + clientTran.create_id + "'  " +
                        "        , GETDATE()  " +
                        "  FROM [MNDTclient]  " +
                        " WHERE [client_id] IN (" + clientTran.client_id + ")";
        return sSql;
    }

    public string fnCount(ClientTran clientTran)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[client_id]", clientTran.client_id);

        string sCountSql =
                        "          SELECT COUNT(client_id)   " +
                        "          FROM   [MNDTclient_tran]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    #endregion

    public DataTable fnSelectList()
    {
        string sSql =
                        "  SELECT [client].[client_id] [value],   " +
                        "         [client].[name]   " +
                        "  FROM MNDTclient AS [client]  " +
                        "  WHERE [status] <> 'D' ";

        return PublicApi.fnGetDt(sSql, "MNDT");
    }
}