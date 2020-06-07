using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// KindRepository 的摘要描述
/// </summary>
public class KindRepository
{
    public KindRepository()
    {
    }

    #region KindMaster

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(KindM kindM, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;

        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[kind_id]", kindM.kind_id);
        sCondition += PublicApi.fnAddCondition("[name]", kindM.name);

        string sInquireSql =
                        "  SELECT [kind_m].[NUM],   " +
                        "         [kind_m].[kind_id],   " +
                        "         [kind_m].[name],   " +
                        "         CONVERT(CHAR, [kind_m].[create_datetime], 111) [create_datetime],   " +
                        "         CONVERT(CHAR, [kind_m].[modify_datetime], 111) [modify_datetime]   " +
                        "  FROM   (SELECT Row_number() OVER(ORDER BY[" + kindM.order + "] ASC) NUM, " +
                        "                  *   " +
                        "          FROM   [MNDTkind_master]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [kind_m]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString();

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnCount(KindM kindM)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[kind_id]", kindM.kind_id);
        sCondition += PublicApi.fnAddCondition("[name]", kindM.name);

        string sCountSql =
                        "          SELECT COUNT([kind_id])   " +
                        "          FROM   [MNDTkind_master]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    // sNum 排行
    public string fnSelectKindId(KindM kindM, string sNum)
    {
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[kind_id]", kindM.kind_id);
        sCondition += PublicApi.fnAddCondition("[name]", kindM.name);

        string sSql = "  SELECT [kind_m].[kind_id]  " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + kindM.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTkind_master]   " +
                        "          WHERE  1 = 1" + sCondition + ") AS [kind_m]  " +
                        "  WHERE [kind_m].[NUM] = '" + sNum + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public DataTable fnSelect(KindM kindM)
    {
        string sSql = "  SELECT TOP 1 [kind_id]  " +
                        "        ,[name]  " +
                        "        ,[description]  " +
                        "        ,[create_id]  " +
                        "        ,CONVERT(char, [create_datetime], 120) [create_datetime]  " +
                        "        ,[modify_id]  " +
                        "        ,CONVERT(char, [modify_datetime], 120) [modify_datetime]  " +
                        "  FROM [MNDTkind_master]  " +
                        "  WHERE [kind_id] = '" + kindM.kind_id + "' ";
        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    public string fnInsert(KindM kindM)
    {
        string sSql = "  INSERT INTO [dbo].[MNDTkind_master]  " +
                        "             ([kind_id]  " +
                        "             ,[name]  " +
                        "             ,[description]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime]  " +
                        "             ,[modify_id]  " +
                        "             ,[modify_datetime])  " +
                        "       VALUES  " +
                        "             ('" + kindM.kind_id + "'  " +
                        "             ,'" + kindM.name + "'  " +
                        "             ,'" + kindM.description + "'  " +
                        "             ,'" + kindM.create_id + "'  " +
                        "             ,GETDATE()  " +
                        "             ,'" + kindM.create_id + "'  " +
                        "             ,GETDATE())  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnUpdate(KindM kindM)
    {
        string sSql = "  UPDATE [dbo].[MNDTkind_master]  " +
                        "     SET [name] = '" + kindM.name + "'  " +
                        "        ,[description] = '" + kindM.description + "'  " +
                        "        ,[modify_id] = '" + kindM.create_id + "'  " +
                        "        ,[modify_datetime] = GETDATE()  " +
                        "  WHERE [kind_id] = '" + kindM.kind_id + "' ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDelete(KindM kindM)
    {
        string sDetailsSql = " SELECT COUNT([kind_id]) FROM [MNDTkind_details] WHERE [kind_id] = '" + kindM.kind_id + "' ";
        string sCount = PublicApi.fnGetValue(sDetailsSql, "MNDT");
        if (sCount == "0")
        {
            string sSql = " DELETE [MNDTkind_master] " +
                            " WHERE [kind_id] = '" + kindM.kind_id + "' ";
            return PublicApi.fnExecuteSQL(sSql, "MNDT");
        }
        return "錯誤訊息：明細資料大於一筆。";
    }

    public bool fnIsExist(KindM kindM)
    {
        string sSql = "  SELECT COUNT([kind_id])   " +
                        "  FROM   [MNDTkind_master]   " +
                        "  WHERE  [kind_id] = '" + kindM.kind_id + "'   ";
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }

    #endregion



    #region KindDetails

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(KindD kindD, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;

        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[kind_id]", kindD.kind_id);

        string sInquireSql =
                        "  SELECT [kind_d].[code_id],   " +
                        "         [kind_d].[name],   " +
                        "         [kind_d].[parameter],   " +
                        "         [kind_d].[status]   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [code_id] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTkind_details]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [kind_d]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnSelect(KindD kindD)
    { 
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[kind_id]", kindD.kind_id);
        sCondition += PublicApi.fnAddCondition("[code_id]", kindD.code_id);

        string sSql =
                        "  SELECT TOP 1 [kind_d].[parameter]   " + 
                        "  FROM   [MNDTkind_details] AS [kind_d]   " +
                        "          WHERE  1 = 1 " + sCondition;

        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public string fnCount(KindD kindD)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[kind_id]", kindD.kind_id);

        string sCountSql =
                        "          SELECT COUNT([kind_id])   " +
                        "          FROM   [MNDTkind_details]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    public string fnInsert(KindD kindD)
    {
        string sSql = "  INSERT INTO [MNDTkind_details]  " +
                        "             ([kind_id]  " +
                        "             ,[code_id]  " +
                        "             ,[name]  " +
                        "             ,[parameter]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "       VALUES  " +
                        "             ('" + kindD.kind_id + "'  " +
                        "             ,'" + kindD.code_id + "'  " +
                        "             ,'" + kindD.name + "'  " +
                        "             ,'" + kindD.parameter + "'  " +
                        "             ,'" + kindD.create_id + "'  " +
                        "             ,GETDATE())  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnUpdate(KindD kindD, string sIP, string sId)
    {
        string sSql =
                        "  UPDATE [MNDTkind_details]  " +
                        "     SET [name] = '" + kindD.name + "'  " +
                        "        ,[parameter] = '" + kindD.parameter + "'  " +
                        "        ,[status] = '" + kindD.status + "'  " +
                        " WHERE [kind_id] = '" + kindD.kind_id + "' " +
                        "   AND [code_id] = '" + kindD.code_id + "' ";
        KindDTran kindDTran = new KindDTran();

        kindDTran.KindId(kindD.kind_id)
                 .CodeId(kindD.code_id)
                 .IP(sIP)
                 .Status("M")
                 .CreateId(sId);
        sSql += fnInsertSql(kindDTran);

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDelete(KindD kindD, string sIP, string sId)
    {
        string sSql =
                        "  UPDATE [MNDTkind_details]  " +
                        "     SET [status] = 'D'  " +
                        " WHERE [kind_id] = '" + kindD.kind_id + "' " +
                        "   AND [code_id] = '" + kindD.code_id + "' ";
        KindDTran kindDTran = new KindDTran();

        kindDTran.KindId(kindD.kind_id)
                 .CodeId(kindD.code_id)
                 .IP(sIP)
                 .Status("D")
                 .CreateId(sId);
        sSql += fnInsertSql(kindDTran);

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public DataTable fnSelectList(KindD kindD)
    {
        string sSql =
                        "  SELECT [kind_d].[code_id] [value],   " +
                        "         [kind_d].[name],   " +
                        "         [kind_d].[parameter]   " +
                        "  FROM [MNDTkind_details] AS [kind_d]  " +
                        "  WHERE [kind_id] = '" + kindD.kind_id + "' " +
                        "       AND [status] = 'N' ";

        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    public bool fnIsExist(KindD kindD)
    {
        string sSql =
                        "  SELECT COUNT([code_id])   " +
                        "  FROM   [MNDTkind_details]   " +
                        "  WHERE [kind_id] = '" + kindD.kind_id + "' " +
                        "       AND [code_id] = '" + kindD.code_id + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }

    #endregion




    #region KindDetailsTran


    public DataTable fnSelects(KindDTran kindDTran)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[kind_id]", kindDTran.kind_id);
        sCondition += PublicApi.fnAddCondition("[code_id]", kindDTran.code_id);

        string sInquireSql =
                        "  SELECT [kind_d_tran].[ip],   " +
                        "         [kind_d_tran].[status],   " +
                        "         [kind_d_tran].[create_id],   " +
                        "         CONVERT(char, [kind_d_tran].[create_datetime], 120) 'create_datetime'   " +
                        "  FROM   [MNDTkind_details_tran] [kind_d_tran]   " +
                        "  WHERE  1 = 1 " + sCondition + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    private string fnInsertSql(KindDTran kindDTran)
    {
        string sSql =
                        "  INSERT INTO [MNDTkind_details_tran]  " +
                        "             ([kind_id]  " +
                        "             ,[code_id]  " +
                        "             ,[ip]  " +
                        "             ,[status]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "  VALUES  " +
                        "             ('" + kindDTran.kind_id + "'  " +
                        "             ,'" + kindDTran.code_id + "'  " +
                        "             ,'" + kindDTran.ip + "' " +
                        "             ,'" + kindDTran.status + "'  " +
                        "             ,'" + kindDTran.create_id + "'  " +
                        "             ,GETDATE())  ";

        return sSql;
    }

    #endregion
}