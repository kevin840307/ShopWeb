using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// AccountRepository 的摘要描述
/// </summary>
public class MaterialRepository
{
    public MaterialRepository()
    {
    }

    #region Material

    // sNum 排行
    public string fnSelectMaterialId(Material material, string sNum)
    {
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[material_id]", material.material_id);
        sCondition += PublicApi.fnAddCondition("[name]", material.name);
        sCondition += PublicApi.fnAddCondition("[status]", material.status);

        string sSql = "  SELECT [material].[material_id]  " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + material.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTmaterial]   " +
                        "          WHERE  1 = 1" + sCondition + ") AS [material]  " +
                        "  WHERE [material].[NUM] = '" + sNum + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public DataTable fnSelect(Material material)
    {
        string sSql = "  SELECT TOP 1 * " +
                        "  FROM   [MNDTmaterial] [material]  " +
                        "  WHERE [material].[material_id] = '" + material.material_id + "' ";
        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(Material material, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[material_id]", material.material_id);
        sCondition += PublicApi.fnAddCondition("[name]", material.name);
        sCondition += PublicApi.fnAddCondition("[status]", material.status);

        string sInquireSql =
                        "  SELECT [material].[material_id],   " +
                        "         [material].[company_id],   " +
                        "         [material].[name],   " +
                        "         [material].[status],   " +
                        "         CONVERT(CHAR, [material].[create_datetime], 111) [create_datetime],   " +
                        "         [material].[NUM]   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + material.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTmaterial]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [material]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnSelects(Material material)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[material_id]", material.material_id);
        sCondition += PublicApi.fnAddCondition("[name]", material.name);
        sCondition += PublicApi.fnAddCondition("[status]", material.status);
        sCondition += " ORDER BY [" + material.order + "] ";
        string sInquireSql =
                        "  SELECT *  " +
                        "  FROM MNDTmaterial  " +
                        "  WHERE 1 = 1 " + sCondition;
        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnExport(Material material)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[material_id]", material.material_id);
        sCondition += PublicApi.fnAddCondition("[name]", material.name);
        sCondition += PublicApi.fnAddCondition("[status]", material.status);
        sCondition += " ORDER BY [" + material.order + "] ";
        string sInquireSql =
                        "  SELECT [material].[material_id] '編號',   " +
                        "         [material].[company_id] '公司ID',   " +
                        "         [material].[name] '名子',   " +
                        "         [material].[unit] '單位',   " +
                        "         [material].[currency] '貨幣',  " +
                        "         [material].[price] '價格',  " +
                        "         [material].[shelf_life] '期限',  " +
                        "         [material].[description] '描述',  " +
                        "         [material].[status] '狀態'  " +
                        "  FROM MNDTmaterial AS [material]  " +
                        "  WHERE 1 = 1 " + sCondition;
        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnInsert(Material material)
    {
        string sSql =
                        "  INSERT INTO [dbo].[MNDTmaterial]  " +
                        "             ([material_id]  " +
                        "             ,[company_id]  " +
                        "             ,[name]  " +
                        "             ,[unit]  " +
                        "             ,[currency]  " +
                        "             ,[price]  " +
                        "             ,[shelf_life]  " +
                        "             ,[description]  " +
                        "             ,[status]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "  VALUES  " +
                        "             ('" + material.material_id + "' " +
                        "             ,'" + material.company_id + "' " +
                        "             ,'" + material.name + "' " +
                        "             ,'" + material.unit + "' " +
                        "             ,'" + material.currency + "' " +
                        "             ,'" + material.price + "' " +
                        "             ,'" + material.shelf_life + "' " +
                        "             ,'" + material.description + "' " +
                        "             ,'N'  " +
                        "             ,'" + material.create_id + "' " +
                        "             ,GETDATE())  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnUpdate(Material material, string sIP, string sId)
    {
        string sSql = "  UPDATE [dbo].[MNDTmaterial]  " +
                        "     SET [company_id] = '" + material.company_id + "'  " +
                        "        ,[name] = '" + material.name + "'  " +
                        "        ,[unit] = '" + material.unit + "'  " +
                        "        ,[currency] = '" + material.currency + "'  " +
                        "        ,[price] = '" + material.price + "'  " +
                        "        ,[shelf_life] = '" + material.shelf_life + "'  " +
                        "        ,[description] = '" + material.description + "'  " +
                        "        ,[status] = '" + material.status + "'  " +
                        "  WHERE [material_id] = '" + material.material_id + "' ";
        MaterialTran materialTran = new MaterialTran();

        materialTran.MaterialId(material.material_id)
                    .IP(sIP)
                    .Status("M")
                    .CreateId(sId);
        sSql += fnInsertSql(materialTran);

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDelete(Material material, string sIP, string sId)
    {
        string sSql = " UPDATE [dbo].[MNDTmaterial] " +
                        "       SET [status] = 'D' " +
                        " WHERE [material_id] = '" + material.material_id + "' ";
        MaterialTran materialTran = new MaterialTran();

        materialTran.MaterialId(material.material_id)
                    .IP(sIP)
                    .Status("D")
                    .CreateId(sId);
        sSql += fnInsertSql(materialTran);

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDeletes(Material material, string sIP, string sId)
    {
        string sSql = " UPDATE [dbo].[MNDTmaterial] " +
                        "       SET [status] = 'D' " +
                        " WHERE [material_id] IN (" + material.material_id + ")";
        MaterialTran materialTran = new MaterialTran();

        materialTran.MaterialId(material.material_id)
                    .IP(sIP)
                    .Status("D")
                    .CreateId(sId);
        sSql += fnInsertsSql(materialTran);

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnCount(Material material)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[material_id]", material.material_id);
        sCondition += PublicApi.fnAddCondition("[name]", material.name);
        sCondition += PublicApi.fnAddCondition("[status]", material.status);

        string sCountSql =
                        "          SELECT COUNT(material_id)   " +
                        "          FROM   [MNDTmaterial]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    public bool fnIsExist(Material material)
    {
        string sSql = "  SELECT COUNT([material_id])   " +
                        "  FROM   [MNDTmaterial]   " +
                        "  WHERE  [status] = 'N' " +
                        "       AND [material_id] = '" + material.material_id + "'   ";
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }

    #endregion



    #region MaterialTran

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(MaterialTran materialTran, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[material_id]", materialTran.material_id);
        string sInquireSql =
                        "  SELECT [account_tran].[material_id],   " +
                        "         [account_tran].[ip],   " +
                        "         [account_tran].[status],   " +
                        "         [account_tran].[create_id],   " +
                        "         CONVERT(char, [account_tran].[create_datetime], 120) 'create_datetime'   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [create_datetime] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTmaterial_tran]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [account_tran]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    private string fnInsertSql(MaterialTran materialTran)
    {
        string sSql =
                    "  INSERT INTO [MNDTmaterial_tran]  " +
                    "             ([material_id]  " +
                    "             ,[ip]  " +
                    "             ,[status]  " +
                    "             ,[create_id]  " +
                    "             ,[create_datetime])  " +
                    "       VALUES  " +
                    "             ('" + materialTran.material_id + "'  " +
                    "             , '" + materialTran.ip + "'  " +
                    "             , '" + materialTran.status + "'  " +
                    "             , '" + materialTran.create_id + "'  " +
                    "             , GETDATE())  ";
        return sSql;
    }

    private string fnInsertsSql(MaterialTran materialTran)
    {
        string sSql =
                        "  INSERT INTO [MNDTmaterial_tran]  " +
                        "             ([material_id]  " +
                        "             ,[ip]  " +
                        "             ,[status]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "  SELECT [material_id]  " +
                        "        , '" + materialTran.ip + "'  " +
                        "        , '" + materialTran.status + "'  " +
                        "        , '" + materialTran.create_id + "'  " +
                        "        , GETDATE()  " +
                        "  FROM [MNDTmaterial]  " +
                        " WHERE [material_id] IN (" + materialTran.material_id + ")";
        return sSql;
    }

    public string fnCount(MaterialTran materialTran)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[material_id]", materialTran.material_id);

        string sCountSql =
                        "          SELECT COUNT(material_id)   " +
                        "          FROM   [MNDTmaterial_tran]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    #endregion

    public DataTable fnSelectList()
    {
        string sSql =
                        "  SELECT [material].[material_id] [value],   " +
                        "         [material].[name]   " +
                        "  FROM MNDTmaterial AS [material]  " +
                        "  WHERE [material].[status] <> 'D' ";

        return PublicApi.fnGetDt(sSql, "MNDT");
    }
}