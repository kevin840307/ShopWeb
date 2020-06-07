using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// AccountRepository 的摘要描述
/// </summary>
public class UserRepository
{
    public UserRepository()
    {
    }

    #region User

    // sNum 排行
    public string fnSelectId(User user, string sNum)
    {
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[id]", user.id);
        sCondition += PublicApi.fnAddCondition("[account]", user.account);
        sCondition += PublicApi.fnAddCondition("[name]", user.name);
        sCondition += PublicApi.fnAddCondition("[status]", user.status);

        string sSql = "  SELECT [user].[id]  " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + user.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTuser]   " +
                        "          WHERE  1 = 1" + sCondition + ") AS [user]  " +
                        "  WHERE [user].[NUM] = '" + sNum + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public DataTable fnSelect(User user)
    {
        string sSql = "  SELECT TOP 1 [user].[id]  " +
                        "        ,[user].[account]  " +
                        "        ,[user].[password]  " +
                        "        ,[user].[name]  " +
                        "        ,[user].[address]  " +
                        "        ,[user].[phone]  " +
                        "        ,[user].[status]  " +
                        "  FROM   [MNDTuser] [user]  " +
                        "  WHERE [user].[id] = '" + user.id + "' ";
        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(User user, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[id]", user.id);
        sCondition += PublicApi.fnAddCondition("[account]", user.account);
        sCondition += PublicApi.fnAddCondition("[name]", user.name);
        sCondition += PublicApi.fnAddCondition("[status]", user.status);

        string sInquireSql =
                        "  SELECT [user].[id],   " +
                        "         [user].[account],   " +
                        "         [user].[name],   " +
                        "         [user].[phone],   " +
                        "         CONVERT(CHAR, [user].[create_datetime], 111) [create_datetime],   " +
                        "         [user].[NUM]   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + user.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTuser]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [user]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnSelects(User user)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[id]", user.id);
        sCondition += PublicApi.fnAddCondition("[account]", user.account);
        sCondition += PublicApi.fnAddCondition("[name]", user.name);
        sCondition += PublicApi.fnAddCondition("[status]", user.status);
        sCondition += " ORDER BY [" + user.order + "] ";
        string sInquireSql =
                        "  SELECT [user].[id],   " +
                        "         [user].[account],   " +
                        "         [user].[name],   " +
                        "         [user].[address],  " +
                        "         [user].[phone]   " +
                        "  FROM MNDTuser AS [user]  " +
                        "  WHERE 1 = 1 " + sCondition;
        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnExport(User user)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[id]", user.id);
        sCondition += PublicApi.fnAddCondition("[account]", user.account);
        sCondition += PublicApi.fnAddCondition("[name]", user.name);
        sCondition += PublicApi.fnAddCondition("[status]", user.status);
        sCondition += " ORDER BY [" + user.order + "] ";
        string sInquireSql =
                        "  SELECT [user].[id] '編號',   " +
                        "         [user].[account] '帳號',   " +
                        "         [user].[password] '密碼',   " +
                        "         [user].[name] '名子',   " +
                        "         [user].[address] '地址',  " +
                        "         [user].[phone] '手機'  " +
                        "  FROM MNDTuser AS [user]  " +
                        "  WHERE 1 = 1 " + sCondition;
        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnInsert(User user)
    {
        string sSql = "  INSERT INTO [MNDTuser]  " +
                        "             ([account]  " +
                        "             ,[password]  " +
                        "             ,[name]  " +
                        "             ,[address]  " +
                        "             ,[phone]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "       VALUES  " +
                        "             ('" + user.account + "'  " +
                        "             ,'" + user.encrypt_password + "'  " +
                        "             ,'" + user.name + "'  " +
                        "             ,'" + user.address + "'  " +
                        "             ,'" + user.phone + "'  " +
                        "             ,'" + user.create_id + "'  " +
                        "             ,GETDATE())  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnUpdate(User user, string sIP, string sId)
    {
        string sSql = "  UPDATE [dbo].[MNDTuser]  " +
                        "     SET [account] = '" + user.account + "'  " +
                        "        ,[password] = '" + user.encrypt_password + "'  " +
                        "        ,[name] = '" + user.name + "'  " +
                        "        ,[address] = '" + user.address + "'  " +
                        "        ,[phone] = '" + user.phone + "'  " +
                        "        ,[status] = '" + user.status + "'  " +
                        "  WHERE [id] = '" + user.id + "' ";
        UserTran userTran = new UserTran();

        userTran.Id(user.id)
                .IP(sIP)
                .Status("M")
                .CreateId(sId);
        sSql += fnInsertSql(userTran);

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDelete(User user, string sIP, string sId)
    {
        string sSql = " UPDATE [dbo].[MNDTuser] " +
                        "       SET [status] = 'D' " +
                        " WHERE [id] = '" + user.id + "' ";
        UserTran userTran = new UserTran();

        userTran.Id(user.id)
                .IP(sIP)
                .Status("D")
                .CreateId(sId);
        sSql += fnInsertSql(userTran);

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDeletes(User user, string sIP, string sId)
    {
        string sSql = " UPDATE [dbo].[MNDTuser] " +
                        "       SET [status] = 'D' " +
                        " WHERE [id] IN (" + user.id + ")";
        UserTran userTran = new UserTran();

        userTran.Id(user.id)
                .IP(sIP)
                .Status("D")
                .CreateId(sId);
        sSql += fnInsertsSql(userTran);

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnCount(User user)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[id]", user.id);
        sCondition += PublicApi.fnAddCondition("[account]", user.account);
        sCondition += PublicApi.fnAddCondition("[name]", user.name);
        sCondition += PublicApi.fnAddCondition("[status]", user.status);

        string sCountSql =
                        "          SELECT COUNT(account)   " +
                        "          FROM   [MNDTuser]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    public bool fnIsExist(User user)
    {
        string sSql = "  SELECT COUNT([id])   " +
                        "  FROM   [MNDTuser]   " +
                        "  WHERE  [status] = 'N' " +
                        "       AND [id] = '" + user.id + "'   ";
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }

    public DataTable fnLogin(User user)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[account]", user.account);
        sCondition += PublicApi.fnAddCondition("[password]", user.encrypt_password);
        sCondition += PublicApi.fnAddCondition("[status]", "N");

        string sSql =
                       "          SELECT [id]   " +
                       "                ,[name]   " +
                       "          FROM   [MNDTuser]   " +
                       "          WHERE  1 = 1 " + sCondition;

        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    #endregion



    #region UserTran

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(UserTran userTran, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[id]", userTran.id);
        string sInquireSql =
                        "  SELECT [account_tran].[id],   " +
                        "         [account_tran].[ip],   " +
                        "         [account_tran].[status],   " +
                        "         [account_tran].[create_id],   " +
                        "         CONVERT(char, [account_tran].[create_datetime], 120) 'create_datetime'   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [create_datetime] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTuser_tran]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [account_tran]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    private string fnInsertSql(UserTran userTran)
    {
        string sSql =
                    "  INSERT INTO [MNDTuser_tran]  " +
                    "             ([id]  " +
                    "             ,[ip]  " +
                    "             ,[status]  " +
                    "             ,[create_id]  " +
                    "             ,[create_datetime])  " +
                    "       VALUES  " +
                    "             ('" + userTran.id + "'  " +
                    "             , '" + userTran.ip + "'  " +
                    "             , '" + userTran.status + "'  " +
                    "             , '" + userTran.create_id + "'  " +
                    "             , GETDATE())  ";
        return sSql;
    }

    private string fnInsertsSql(UserTran userTran)
    {
        string sSql =
                        "  INSERT INTO [MNDTuser_tran]  " +
                        "             ([id]  " +
                        "             ,[ip]  " +
                        "             ,[status]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "  SELECT [id]  " +
                        "        , '" + userTran.ip + "'  " +
                        "        , '" + userTran.status + "'  " +
                        "        , '" + userTran.create_id + "'  " +
                        "        , GETDATE()  " +
                        "  FROM [MNDTuser]  " +
                        " WHERE [id] IN (" + userTran.id + ")";
        return sSql;
    }

    public string fnCount(UserTran userTran)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[id]", userTran.id);

        string sCountSql =
                        "          SELECT COUNT(id)   " +
                        "          FROM   [MNDTuser_tran]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    #endregion

    public DataTable fnSelectList()
    {
        string sSql =
                        "  SELECT [account].[id] [value],   " +
                        "         [account].[name]   " +
                        "  FROM MNDTuser AS [account]  " +
                        "  WHERE [status] <> 'D' ";

        return PublicApi.fnGetDt(sSql, "MNDT");
    }
}