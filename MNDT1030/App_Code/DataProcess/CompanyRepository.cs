using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// AccountRepository 的摘要描述
/// </summary>
public class CompanyRepository
{
    public CompanyRepository()
    {
    }

    #region Company

    // sNum 排行
    public string fnSelectCompanyId(Company company, string sNum)
    {
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[company_id]", company.company_id);
        sCondition += PublicApi.fnAddCondition("[name]", company.name);
        sCondition += PublicApi.fnAddCondition("[phone]", company.phone);
        sCondition += PublicApi.fnAddCondition("[status]", company.status);

        string sSql = "  SELECT [company].[company_id]  " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + company.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTcompany]   " +
                        "          WHERE  1 = 1" + sCondition + ") AS [company]  " +
                        "  WHERE [company].[NUM] = '" + sNum + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public DataTable fnSelect(Company company)
    {
        string sSql = "  SELECT TOP 1 [company].[company_id]  " +
                        "        ,[company].[name]  " +
                        "        ,[company].[tax_id]  " +
                        "        ,[company].[email]  " +
                        "        ,[company].[pay]  " +
                        "        ,[company].[address]  " +
                        "        ,[company].[tel]  " +
                        "        ,[company].[phone]  " +
                        "        ,[company].[description]  " +
                        "        ,[company].[status]  " +
                        "  FROM   [MNDTcompany] [company]  " +
                        "  WHERE [company].[company_id] = '" + company.company_id + "' ";
        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(Company company, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[company_id]", company.company_id);
        sCondition += PublicApi.fnAddCondition("[name]", company.name);
        sCondition += PublicApi.fnAddCondition("[phone]", company.phone);
        sCondition += PublicApi.fnAddCondition("[status]", company.status);

        string sInquireSql =
                        "  SELECT [company].[company_id],   " +
                        "         [company].[name],   " +
                        "         [company].[phone],   " +
                        "         CONVERT(CHAR, [company].[create_datetime], 111) [create_datetime],   " +
                        "         [company].[NUM]   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + company.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTcompany]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [company]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnSelects(Company company)
    {
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[company_id]", company.company_id);
        sCondition += PublicApi.fnAddCondition("[name]", company.name);
        sCondition += PublicApi.fnAddCondition("[phone]", company.phone);
        sCondition += PublicApi.fnAddCondition("[status]", company.status);
        sCondition += " ORDER BY [" + company.order + "] ";
        string sInquireSql =
                        "  SELECT [company].[company_id],   " +
                        "         [company].[name],   " +
                        "         [company].[address],  " +
                        "         [company].[phone]   " +
                        "  FROM MNDTcompany AS [company]  " +
                        "  WHERE 1 = 1 " + sCondition;
        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnExport(Company company)
    {
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[company_id]", company.company_id);
        sCondition += PublicApi.fnAddCondition("[name]", company.name);
        sCondition += PublicApi.fnAddCondition("[phone]", company.phone);
        sCondition += PublicApi.fnAddCondition("[status]", company.status);
        sCondition += " ORDER BY [" + company.order + "] ";
        string sInquireSql =
                        "  SELECT [company].[company_id] '帳號',   " +
                        "         [company].[tax_id] '統編',   " +
                        "         [company].[name] '名子',   " +
                        "         [company].[address] '地址',  " +
                        "         [company].[phone] '手機'  " +
                        "  FROM MNDTcompany AS [company]  " +
                        "  WHERE 1 = 1 " + sCondition;
        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnInsert(Company company)
    {
        string sSql =
                        "  INSERT INTO [dbo].[MNDTcompany]  " +
                        "             ([company_id]  " +
                        "             ,[tax_id]  " +
                        "             ,[name]  " +
                        "             ,[email]  " +
                        "             ,[pay]  " +
                        "             ,[address]  " +
                        "             ,[tel]  " +
                        "             ,[phone]  " +
                        "             ,[description]  " +
                        "             ,[status]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "  VALUES  " +
                        "             ('" + company.company_id + "'  " +
                        "             ,'" + company.tax_id + "'  " +
                        "             ,'" + company.name + "' " +
                        "             ,'" + company.email + "'  " +
                        "             ,'" + company.pay + "'  " +
                        "             ,'" + company.address + "'  " +
                        "             ,'" + company.tel + "'  " +
                        "             ,'" + company.phone + "'  " +
                        "             ,'" + company.description + "'  " +
                        "             ,'N' " +
                        "             ,'" + company.create_id + "'  " +
                        "             ,GETDATE())  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnUpdate(Company company, string sIP, string sId)
    {
        string sSql = 
                        "  UPDATE [dbo].[MNDTcompany]  " +
                        "     SET [tax_id] = '" + company.tax_id + "'  " +
                        "        ,[name] = '" + company.name + "'  " +
                        "        ,[email] = '" + company.email + "'  " + 
                        "        ,[address] = '" + company.address + "'  " +
                        "        ,[pay] = '" + company.pay + "'  " +
                        "        ,[phone] = '" + company.phone + "'  " +
                        "        ,[tel] = '" + company.tel + "'  " +
                        "        ,[description] = '" + company.description + "'  " +
                        "        ,[status] = '" + company.status + "'  " +
                        "  WHERE [company_id] = '" + company.company_id + "' ";
        CompanyTran companyTran = new CompanyTran();

        companyTran.CompanyId(company.company_id)
                .IP(sIP)
                .Status("M")
                .CreateId(sId);
        sSql += fnInsertSql(companyTran);

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDelete(Company company, string sIP, string sId)
    {
        string sSql = " UPDATE [dbo].[MNDTcompany] " +
                        "       SET [status] = 'D' " +
                        " WHERE [company_id] = '" + company.company_id + "' ";
        CompanyTran companyTran = new CompanyTran();

        companyTran.CompanyId(company.company_id)
                .IP(sIP)
                .Status("D")
                .CreateId(sId);
        sSql += fnInsertSql(companyTran);

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDeletes(Company company, string sIP, string sId)
    {
        string sSql = " UPDATE [dbo].[MNDTcompany] " +
                        "       SET [status] = 'D' " +
                        " WHERE [company_id] IN (" + company.company_id + ")";
        CompanyTran companyTran = new CompanyTran();

        companyTran.CompanyId(company.company_id)
                .IP(sIP)
                .Status("D")
                .CreateId(sId);
        sSql += fnInsertsSql(companyTran);

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnCount(Company company)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[company_id]", company.company_id);
        sCondition += PublicApi.fnAddCondition("[name]", company.name);
        sCondition += PublicApi.fnAddCondition("[phone]", company.phone);
        sCondition += PublicApi.fnAddCondition("[status]", company.status);

        string sCountSql =
                        "          SELECT COUNT(company_id)   " +
                        "          FROM   [MNDTcompany]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    public bool fnIsExist(Company company)
    {
        string sSql = "  SELECT COUNT([company_id])   " +
                        "  FROM   [MNDTcompany]   " +
                        "  WHERE  [status] = 'N' " +
                        "       AND [company_id] = '" + company.company_id + "'   ";
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }

    #endregion



    #region CompanyTran

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(CompanyTran companyTran, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[company_id]", companyTran.company_id);
        string sInquireSql =
                        "  SELECT [company_tran].[company_id],   " +
                        "         [company_tran].[ip],   " +
                        "         [company_tran].[status],   " +
                        "         [company_tran].[create_id],   " +
                        "         CONVERT(char, [company_tran].[create_datetime], 120) 'create_datetime'   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [create_datetime] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTcompany_tran]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [company_tran]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    private string fnInsertSql(CompanyTran companyTran)
    {
        string sSql =
                    "  INSERT INTO [MNDTcompany_tran]  " +
                    "             ([company_id]  " +
                    "             ,[ip]  " +
                    "             ,[status]  " +
                    "             ,[create_id]  " +
                    "             ,[create_datetime])  " +
                    "       VALUES  " +
                    "             ('" + companyTran.company_id + "'  " +
                    "             , '" + companyTran.ip + "'  " +
                    "             , '" + companyTran.status + "'  " +
                    "             , '" + companyTran.create_id + "'  " +
                    "             , GETDATE())  ";
        return sSql;
    }

    private string fnInsertsSql(CompanyTran companyTran)
    {
        string sSql =
                        "  INSERT INTO [MNDTcompany_tran]  " +
                        "             ([company_id]  " +
                        "             ,[ip]  " +
                        "             ,[status]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "  SELECT [company_id]  " +
                        "        , '" + companyTran.ip + "'  " +
                        "        , '" + companyTran.status + "'  " +
                        "        , '" + companyTran.create_id + "'  " +
                        "        , GETDATE()  " +
                        "  FROM [MNDTcompany]  " +
                        " WHERE [company_id] IN (" + companyTran.company_id + ")";
        return sSql;
    }

    public string fnCount(CompanyTran companyTran)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[company_id]", companyTran.company_id);

        string sCountSql =
                        "          SELECT COUNT(company_id)   " +
                        "          FROM   [MNDTcompany_tran]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    #endregion

    public DataTable fnSelectList()
    {
        string sSql =
                        "  SELECT [company].[company_id] [value],   " +
                        "         [company].[name]   " +
                        "  FROM MNDTcompany AS [company]  " +
                        "  WHERE [status] <> 'D' ";

        return PublicApi.fnGetDt(sSql, "MNDT");
    }
}