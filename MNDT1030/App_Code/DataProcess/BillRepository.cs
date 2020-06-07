using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// BillRepository 的摘要描述
/// </summary>
public class BillRepository
{
    public BillRepository()
    {
        //
        // TODO: 在這裡新增建構函式邏輯
        //
    }

    public DataTable fnReport(string sCompanyId, string sDateS, string sDateE)
    {
        string sCondition1 = "";
        string sCondition2 = "";

        sCondition1 += PublicApi.fnAddCondition("[material].[company_id]", sCompanyId);
        sCondition2 = sCondition1;
        if (sDateS.Length > 0)
        {
            sCondition2 += " AND CONVERT(varchar(10), [receive_m].[datetime], 126) >= '" + sDateS + "' ";
        }

        if (sDateS.Length > 0)
        {
            sCondition2 += " AND CONVERT(varchar(10), [receive_m].[datetime], 126) <= '" + sDateE + "' ";
        }

        string sSql =
                        "  SELECT [data].*   " +
                        "  FROM   (SELECT [material].[company_id],   " +
                        "                 [receive_d].[material_id],   " +
                        "                 [material].[name],   " +
                        "                 [kind_d].[name]           [unit_name],   " +
                        "                 [company].[name]          [company_name],   " +
                        "                 [company].[email],   " +
                        "                 [company].[address],   " +
                        "                 [company].[tax_id],   " +
                        "                 [company].[tel],   " +
                        "                 [company].[phone],   " +
                        "                 Sum([receive_d].[amount]) [amount],   " +
                        "                 Sum([receive_d].[price])  [price],   " +
                        "                 '進貨'                  [type]   " +
                        "          FROM   [mndtreceive_master] [receive_m]   " +
                        "                 LEFT JOIN [mndtreceive_details] [receive_d]   " +
                        "                        ON [receive_m].[order_id] = [receive_d].[order_id]   " +
                        "                 LEFT JOIN [mndtmaterial] [material]   " +
                        "                        ON [receive_d].[material_id] = [material].[material_id]   " +
                        "                 LEFT JOIN [mndtkind_details] [kind_d]   " +
                        "                        ON [kind_d].[kind_id] = 'U1'   " +
                        "                           AND [material].[unit] = [kind_d].[code_id]   " +
                        "                 LEFT JOIN [mndtcompany] [company]   " +
                        "                        ON [material].[company_id] = [company].[company_id]   " +
                        "          WHERE  [receive_m].[status] <> 'D'   " +
                        "                 AND [receive_m].[complete] = 'Y'   " +
                        "                 AND [receive_d].[pay_complete] <> 'Y'   " + sCondition2 +
                        "          GROUP  BY [material].[company_id],   " +
                        "                    [material].[name],   " +
                        "                    [kind_d].[name],   " +
                        "                    [company].[name],   " +
                        "                    [company].[email],   " +
                        "                    [company].[address],   " +
                        "                    [company].[tax_id],   " +
                        "                    [company].[tel],   " +
                        "                    [company].[phone],   " +
                        "                    [receive_d].[material_id]   " +
                        "          UNION   " +
                        "          SELECT [material].[company_id],   " +
                        "                 [return_d].[material_id],   " +
                        "                 [material].[name],   " +
                        "                 [kind_d].[name]          [unit_name],   " +
                        "                 [company].[name]         [company_name],   " +
                        "                 [company].[email],   " +
                        "                 [company].[address],   " +
                        "                 [company].[tax_id],   " +
                        "                 [company].[tel],   " +
                        "                 [company].[phone],   " +
                        "                 -Sum([return_d].[amount]) [amount],   " +
                        "                 -Sum([return_d].[price])  [price],   " +
                        "                 '退貨'                 [type]  " +
                        "          FROM   [mndtreturn_master] [return_m]   " +
                        "                 LEFT JOIN [mndtreturn_details] [return_d]   " +
                        "                        ON [return_m].[return_id] = [return_d].[return_id]   " +
                        "                 LEFT JOIN [mndtmaterial] [material]   " +
                        "                        ON [return_d].[material_id] = [material].[material_id]   " +
                        "                 LEFT JOIN [mndtkind_details] [kind_d]   " +
                        "                        ON [kind_d].[kind_id] = 'U1'   " +
                        "                           AND [material].[unit] = [kind_d].[code_id]   " +
                        "                 LEFT JOIN [mndtcompany] [company]   " +
                        "                        ON [material].[company_id] = [company].[company_id]   " +
                        "          WHERE  [return_m].[status] <> 'D'   " +
                        "                 AND [return_m].[complete] = 'Y'   " +
                        "                 AND [return_d].[pay_complete] <> 'Y'   " + sCondition1 +
                        "          GROUP  BY [material].[company_id],   " +
                        "                    [material].[name],   " +
                        "                    [kind_d].[name],   " +
                        "                    [company].[name],   " +
                        "                    [company].[email],   " +
                        "                    [company].[address],   " +
                        "                    [company].[tax_id],   " +
                        "                    [company].[tel],   " +
                        "                    [company].[phone],   " +
                        "                    [return_d].[material_id]) [data]   " +
                        "  ORDER  BY [data].[type] DESC   ";
        return PublicApi.fnGetDt(sSql, "MNDT");
    }
}