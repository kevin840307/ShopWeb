using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// GroupRepository 的摘要描述
/// </summary>
public class GroupRepository
{
    public GroupRepository()
    {
    }

    #region GroupMaster

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(GroupM groupM, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;

        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[group_id]", groupM.group_id);
        sCondition += PublicApi.fnAddCondition("[name]", groupM.name);

        string sAccountSql = fnGetAccountCondition(groupM.user);
        if (sAccountSql != "")
        {
            sCondition += " AND [group_id] IN " + sAccountSql;
        }

        string sInquireSql =
                        "  SELECT [group_m].[NUM],   " +
                        "         [group_m].[group_id],   " +
                        "         [group_m].[name],   " +
                        "         CONVERT(CHAR, [group_m].[create_datetime], 111) [create_datetime],   " +
                        "         CONVERT(CHAR, [group_m].[modify_datetime], 111) [modify_datetime]   " +
                        "  FROM   (SELECT Row_number() OVER(ORDER BY[" + groupM.order + "] ASC) NUM, " +
                        "                  *   " +
                        "          FROM   [MNDTgroup_master]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [group_m]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString();

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnCount(GroupM groupM)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[group_id]", groupM.group_id);
        sCondition += PublicApi.fnAddCondition("[name]", groupM.name);

        string sAccountSql = fnGetAccountCondition(groupM.user);
        if (sAccountSql != "")
        {
            sCondition += " AND [group_id] IN " + sAccountSql;
        }
        string sCountSql =
                        "          SELECT COUNT([group_id])   " +
                        "          FROM   [MNDTgroup_master]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    // sNum 排行
    public string fnSelectGroupId(GroupM groupM, string sNum)
    {
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[group_id]", groupM.group_id);
        sCondition += PublicApi.fnAddCondition("[name]", groupM.name);

        string sAccountSql = fnGetAccountCondition(groupM.user);
        if (sAccountSql != "")
        {
            sCondition += " AND [group_id] IN " + sAccountSql;
        }

        string sSql = "  SELECT [group_m].[group_id]  " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + groupM.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTgroup_master]   " +
                        "          WHERE  1 = 1" + sCondition + ") AS [group_m]  " +
                        "  WHERE [group_m].[NUM] = '" + sNum + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public DataTable fnSelect(GroupM groupM)
    {
        string sSql = "  SELECT TOP 1 [group_id]  " +
                        "        ,[name]  " +
                        "        ,[description]  " +
                        "        ,[create_id]  " +
                        "        ,CONVERT(char, [create_datetime], 120) [create_datetime]  " +
                        "        ,[modify_id]  " +
                        "        ,CONVERT(char, [modify_datetime], 120) [modify_datetime]  " +
                        "  FROM [MNDTgroup_master]  " +
                        "  WHERE [group_id] = '" + groupM.group_id + "' ";
        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    public string fnInsert(GroupM groupM)
    {
        string sSql = "  INSERT INTO [dbo].[MNDTgroup_master]  " +
                        "             ([group_id]  " +
                        "             ,[name]  " +
                        "             ,[description]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime]  " +
                        "             ,[modify_id]  " +
                        "             ,[modify_datetime])  " +
                        "       VALUES  " +
                        "             ('" + groupM.group_id + "'  " +
                        "             ,'" + groupM.name + "'  " +
                        "             ,'" + groupM.description + "'  " +
                        "             ,'" + groupM.create_id + "'  " +
                        "             ,GETDATE()  " +
                        "             ,'" + groupM.create_id + "'  " +
                        "             ,GETDATE())  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnUpdate(GroupM groupM)
    {
        string sSql = "  UPDATE [dbo].[MNDTgroup_master]  " +
                        "     SET [name] = '" + groupM.name + "'  " +
                        "        ,[description] = '" + groupM.description + "'  " +
                        "        ,[modify_id] = '" + groupM.create_id + "'  " +
                        "        ,[modify_datetime] = GETDATE()  " +
                        "  WHERE [group_id] = '" + groupM.group_id + "' ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDelete(GroupM groupM)
    {
        string sDetailsSql = " SELECT COUNT([group_id]) FROM [MNDTgroup_details] WHERE [group_id] = '" + groupM.group_id + "' ";
        string sCount = PublicApi.fnGetValue(sDetailsSql, "MNDT");
        if (sCount == "0")
        {
            string sSql = " DELETE [MNDTgroup_master] " +
                            " WHERE [group_id] = '" + groupM.group_id + "' ";
            return PublicApi.fnExecuteSQL(sSql, "MNDT");
        }
        return "錯誤訊息：明細資料大於一筆。";
    }

    public bool fnIsExist(GroupM groupM)
    {
        string sSql = "  SELECT COUNT([group_id])   " +
                        "  FROM   [MNDTgroup_master]   " +
                        "  WHERE  [group_id] = '" + groupM.group_id + "'   ";
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }


    private string fnGetAccountCondition(User user)
    {
        string sCondition = "";
        string sSql = "";
        sCondition += PublicApi.fnAddCondition("[user].[id]", user.id);
        sCondition += PublicApi.fnAddCondition("[user].[account]", user.account);
        if (sCondition != "")
        {
            sSql =
                    "  (SELECT [group_d].[group_id]   " +
                    "  FROM   [MNDTgroup_details] [group_d]   " +
                    "         LEFT JOIN [MNDTuser] [user]   " +
                    "                ON [group_d].[id] = [user].[id]   " +
                    "  WHERE  [user].[status] = 'N'   " + sCondition + ") ";
        }
        return sSql;
    }
    #endregion



    #region GroupDetails

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(GroupD groupD, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;

        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[group_id]", groupD.group_id);

        string sInquireSql =
                        "  SELECT [group_d].[id],   " +
                        "         [user].[name],   " +
                        "         [group_d].[create_id],   " +
                        "         CONVERT(CHAR, [group_d].[create_datetime], 111) [create_datetime],   " +
                        "         [group_d].[modify_id],   " +
                        "         CONVERT(CHAR, [group_d].[modify_datetime], 111) [modify_datetime]   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [id] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTgroup_details]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [group_d]  " +
                        "       LEFT JOIN [MNDTUser] [user]  " +
                        "       ON [group_d].[id] = [user].[id]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString();

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnCount(GroupD groupD)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[group_id]", groupD.group_id);

        string sCountSql =
                        "          SELECT COUNT([group_id])   " +
                        "          FROM   [MNDTgroup_details]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    public string fnInsert(GroupD groupD)
    {
        string sSql = "  INSERT INTO [MNDTgroup_details]  " +
                        "             ([group_id]  " +
                        "             ,[id]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime]  " +
                        "             ,[modify_id]  " +
                        "             ,[modify_datetime])  " +
                        "       VALUES  " +
                        "             ('" + groupD.group_id + "'  " +
                        "             ,'" + groupD.id + "'  " +
                        "             ,'" + groupD.create_id + "'  " +
                        "             ,GETDATE()  " +
                        "             ,'" + groupD.create_id + "'  " +
                        "             ,GETDATE())  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDelete(GroupD groupD)
    {
        string sSql =
                        " DELETE [dbo].[MNDTgroup_details] " +
                        " WHERE [group_id] = '" + groupD.group_id + "' " +
                        "   AND [id] = '" + groupD.id + "' ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    #endregion
}