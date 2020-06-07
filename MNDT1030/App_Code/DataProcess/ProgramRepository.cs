using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// ProgramRepository 的摘要描述
/// </summary>
public class ProgramRepository
{
    public ProgramRepository()
    {
        //
        // TODO: 在這裡新增建構函式邏輯
        //
    }

    #region ProgramMaster

    public DataTable fnSelects(ProgramM programM)
    {
        string sSql = "  SELECT [program_id],   " +
                        "         [name],   " +
                        "         [parent],   " +
                        "         [url]   " +
                        "  FROM   [MNDTprogram_master]   " +
                        "  WHERE  [parent] = 'ROOT'   " +
                        "          OR [program_id] IN (SELECT DISTINCT [program_id]   " +
                        "                      FROM   [MNDTprogram_details]   " +
                        "                      WHERE  [group_id] IN (SELECT DISTINCT [group_id]   " +
                        "                                            FROM   [MNDTgroup_details]   " +
                        "                                            WHERE  [id] = '" + programM.id + "'))   ";
        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    public DataTable fnSelectList()
    {
        string sSql =
                        "  SELECT [program_id] [value],   " +
                        "         [name]   " +
                        "  FROM [MNDTprogram_master] " +
                        "  WHERE [parent] <> 'ROOT' ";

        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    public bool fnIsExist(ProgramM programM)
    {
        string sSql = "  SELECT COUNT([program_id])   " +
                        "  FROM   [MNDTprogram_master]   " +
                        "  WHERE  [program_id] = '" + programM.program_id + "'   ";
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }

    #endregion







    #region ProgramDetails

    public DataTable fnSelects(ProgramD programD)
    {
        string sSql = "  SELECT [program_id]  " +
                        "        ,CASE [read] WHEN 'Y' THEN 'checked' ELSE '' END [read] " +
                        "        ,CASE [write] WHEN 'Y' THEN 'checked' ELSE '' END [write] " +
                        "        ,CASE [execute] WHEN 'Y' THEN 'checked' ELSE '' END [execute] " +
                        "  FROM [MNDTprogram_details]  " +
                        "  WHERE [group_id] = '" + programD.group_id + "'  ";
        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    public string fnInsert(ProgramD programD)
    {
        string sSql =
                        "  INSERT INTO [MNDTprogram_details]  " +
                        "             ([program_id]  " +
                        "             ,[group_id]  " +
                        "             ,[read]  " +
                        "             ,[write]  " +
                        "             ,[execute]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime]  " +
                        "             ,[modify_id]  " +
                        "             ,[modify_datetime])  " +
                        "  VALUES  " +
                        "             ('" + programD.program_id + "'  " +
                        "             ,'" + programD.group_id + "'  " +
                        "             ,'" + programD.read + "'  " +
                        "             ,'" + programD.write + "'  " +
                        "             ,'" + programD.execute + "'  " +
                        "             ,'" + programD.create_id + "'  " +
                        "             ,GETDATE()  " +
                        "             ,'" + programD.create_id + "'  " +
                        "             ,GETDATE())  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnUpdate(ProgramD programD)
    {
        string sSql =
                        "  UPDATE [MNDTprogram_details]  " +
                        "     SET [read] = '" + programD.read + "'  " +
                        "        ,[write] = '" + programD.write + "'  " +
                        "        ,[execute] = '" + programD.execute + "'  " +
                        "        ,[modify_id] = '" + programD.create_id + "'  " +
                        "        ,[modify_datetime] = GETDATE()  " +
                        "  WHERE [program_id] = '" + programD.program_id + "'  " +
                        "  	AND [group_id] = '" + programD.group_id + "'  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDelete(ProgramD programD)
    {
        string sSql = "  DELETE [MNDTprogram_details]  " +
                        "  WHERE [group_id] = '" + programD.group_id + "'  " +
                        "       AND [program_id] = '" + programD.program_id + "' ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    #endregion
}