using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// ProductRepository 的摘要描述
/// </summary>
public class ProductRepository
{
    public ProductRepository()
    {
    }

    #region ProductMaster

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(ProductM productM, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;

        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[product_id]", productM.product_id);
        sCondition += PublicApi.fnAddCondition("[company_id]", productM.company_id);
        sCondition += PublicApi.fnAddCondition("[name]", productM.name);


        string sInquireSql =
                        "  SELECT [product_m].[NUM],   " +
                        "         [product_m].[product_id],   " +
                        "         [product_m].[company_id],   " +
                        "         [product_m].[name],   " +
                        "         CONVERT(CHAR, [product_m].[create_datetime], 111) [create_datetime]   " +
                        "  FROM   (SELECT Row_number() OVER(ORDER BY[" + productM.order + "] ASC) NUM, " +
                        "                  *   " +
                        "          FROM   [MNDTproduct_master]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [product_m] " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString();

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnCount(ProductM productM)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[product_id]", productM.product_id);
        sCondition += PublicApi.fnAddCondition("[company_id]", productM.company_id);
        sCondition += PublicApi.fnAddCondition("[name]", productM.name);

        string sCountSql =
                        "          SELECT COUNT([product_id])   " +
                        "          FROM   [MNDTproduct_master]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    // sNum 排行
    public string fnSelectProductId(ProductM productM, string sNum)
    {
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[product_id]", productM.product_id);
        sCondition += PublicApi.fnAddCondition("[company_id]", productM.company_id);
        sCondition += PublicApi.fnAddCondition("[name]", productM.name);

        

        string sSql = "  SELECT [product_m].[product_id]  " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + productM.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTproduct_master]   " +
                        "          WHERE  1 = 1" + sCondition + ") AS [product_m]  " +
                        "  WHERE [product_m].[NUM] = '" + sNum + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public DataTable fnSelect(ProductM productM)
    {
        string sSql = 
                        "  SELECT TOP 1 [product_m].*,   " +
                        "               ISNULL((SELECT Sum([product_d].[amount] * [material].[price])   " +
                        "                       FROM   [MNDTproduct_details] [product_d]   " +
                        "                               LEFT JOIN [MNDTmaterial] [material]   " +
                        "                                   ON [product_d].[material_id] =   " +
                        "                                       [material].[material_id]   " +
                        "                       WHERE  [product_m].[product_id] = [product_d].[product_id]), 0) [suggest_cost]   " +
                        "  FROM   [MNDTproduct_master] [product_m]   " +
                        "  WHERE  [product_m].[product_id] = '" + productM.product_id + "'   ";

        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    public string fnInsert(ProductM productM)
    {
        string sSql =
                        "  INSERT INTO [dbo].[MNDTproduct_master]  " +
                        "             ([product_id]  " +
                        "             ,[company_id]  " +
                        "             ,[name]  " +
                        "             ,[unit]  " +
                        "             ,[currency]  " +
                        "             ,[cost]  " +
                        "             ,[price]  " +
                        "             ,[shelf_life]  " +
                        "             ,[description]  " +
                        "             ,[status]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "  VALUES  " +
                        "             ('" + productM.product_id + "' " +
                        "             ,'" + productM.company_id + "' " +
                        "             ,'" + productM.name + "' " +
                        "             ,'" + productM.unit + "' " +
                        "             ,'" + productM.currency + "' " +
                        "             ,'" + productM.cost + "' " +
                        "             ,'" + productM.price + "' " +
                        "             ,'" + productM.shelf_life + "' " +
                        "             ,'" + productM.description + "' " +
                        "             ,'N'  " +
                        "             ,'" + productM.create_id + "' " +
                        "             ,GETDATE())  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnUpdate(ProductM productM, string sIP)
    {
        string sSql = "  UPDATE [dbo].[MNDTproduct_master]  " +
                        "     SET [company_id] = '" + productM.company_id + "'  " +
                        "        ,[name] = '" + productM.name + "'  " +
                        "        ,[unit] = '" + productM.unit + "'  " +
                        "        ,[currency] = '" + productM.currency + "'  " +
                        "        ,[cost] = '" + productM.cost + "'  " +
                        "        ,[price] = '" + productM.price + "'  " +
                        "        ,[shelf_life] = '" + productM.shelf_life + "'  " +
                        "        ,[description] = '" + productM.description + "'  " +
                        "        ,[status] = '" + productM.status + "'  " +
                        "  WHERE [product_id] = '" + productM.product_id + "' ";
        ProductMTran productMTran = new ProductMTran();

        productMTran.ProductId(productM.product_id)
                    .IP(sIP)
                    .Status("M")
                    .CreateId(productM.create_id);
        sSql += fnInsertSql(productMTran);
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDelete(ProductM productM, string sIP)
    {
        string sDetailsSql = " SELECT COUNT([product_id]) FROM [MNDTproduct_details] WHERE [product_id] = '" + productM.product_id + "' ";
        string sCount = PublicApi.fnGetValue(sDetailsSql, "MNDT");
        if (sCount == "0")
        {
            string sSql = " DELETE [MNDTproduct_master] " +
                            " WHERE [product_id] = '" + productM.product_id + "' ";
            ProductMTran productMTran = new ProductMTran();

            productMTran.ProductId(productM.product_id)
                        .IP(sIP)
                        .Status("D")
                        .CreateId(productM.create_id);
            sSql += fnInsertSql(productMTran);
            return PublicApi.fnExecuteSQL(sSql, "MNDT");
        }
        return "錯誤訊息：明細資料大於一筆。";
    }

    public bool fnIsExist(ProductM productM)
    {
        string sSql = "  SELECT COUNT([product_id])   " +
                        "  FROM   [MNDTproduct_master]   " +
                        "  WHERE  [product_id] = '" + productM.product_id + "'   ";
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }

    #endregion

    #region ProductDetails

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(ProductD productD)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[product_id]", productD.product_id);

        string sInquireSql =
                        "  SELECT [product_d].[material_id],   " +
                        "         [product_d].[amount],   " +
                        "         ([material].[price] * [product_d].[amount]) [price],   " +
                        "         [product_d].[create_id],   " +
                        "         CONVERT(CHAR, [product_d].[create_datetime], 111) [create_datetime],   " +
                        "         [product_d].[modify_id],   " +
                        "         CONVERT(CHAR, [product_d].[modify_datetime], 111) [modify_datetime]   " +
                        "  FROM   [MNDTproduct_details] [product_d]  " +
                        "       LEFT JOIN [MNDTmaterial] [material]" +
                        "       ON [product_d].[material_id] = [material].[material_id] " +
                        "  WHERE 1 = 1 " + sCondition;
        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnSelectMaterial(ProductD productD, string sAmount)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[product_id]", productD.product_id);

        string sInquireSql =
                            "  SELECT [product_d].[material_id],  " +
                            "         [product_d].[amount] * " + sAmount + " [amount],  " +
                            "         [material].[name]  " +
                            "  FROM   [MNDTproduct_details] [product_d]  " +
                            "       LEFT JOIN [MNDTmaterial] [material]" +
                            "       ON [product_d].[material_id] = [material].[material_id] " +
                            "  WHERE 1 = 1 " + sCondition;
        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnCount(ProductD productD)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[product_id]", productD.product_id);

        string sCountSql =
                        "          SELECT COUNT([product_id])   " +
                        "          FROM   [MNDTproduct_details]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    public string fnInsert(ProductD productD)
    {
        string sSql = "  INSERT INTO [MNDTproduct_details]  " +
                        "             ([product_id]  " +
                        "             ,[material_id]  " +
                        "             ,[amount]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime]  " +
                        "             ,[modify_id]  " +
                        "             ,[modify_datetime])  " +
                        "       VALUES  " +
                        "             ('" + productD.product_id + "'  " +
                        "             ,'" + productD.material_id + "'  " +
                        "             ,'" + productD.amount + "'  " +
                        "             ,'" + productD.create_id + "'  " +
                        "             ,GETDATE()  " +
                        "             ,'" + productD.create_id + "'  " +
                        "             ,GETDATE())  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }


    public string fnUpdate(ProductD productD)
    {
        string sSql = "  UPDATE [dbo].[MNDTproduct_details]  " +
                        "     SET [amount] = '" + productD.amount + "'  " +
                        "        ,[modify_id] = '" + productD.create_id + "'  " +
                        "        ,[modify_datetime] = GETDATE()  " +
                        "  WHERE [product_id] = '" + productD.product_id + "' " +
                        "       AND [material_id] = '"+ productD.material_id+ "' ";

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDelete(ProductD productD)
    {
        string sSql =
                        " DELETE [dbo].[MNDTproduct_details] " +
                        " WHERE [product_id] = '" + productD.product_id + "' " +
                        "   AND [material_id] = '" + productD.material_id + "' ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    #endregion

    #region ProductMTran

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(ProductMTran productMTran, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[product_id]", productMTran.product_id);
        string sInquireSql =
                        "  SELECT [product_m_t].[product_id],   " +
                        "         [product_m_t].[ip],   " +
                        "         [product_m_t].[status],   " +
                        "         [product_m_t].[create_id],   " +
                        "         CONVERT(char, [product_m_t].[create_datetime], 120) 'create_datetime'   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [create_datetime] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTproduct_master_tran]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [product_m_t]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    private string fnInsertSql(ProductMTran productMTran)
    {
        string sSql =
                    "  INSERT INTO [MNDTproduct_master_tran]  " +
                    "             ([product_id]  " +
                    "             ,[ip]  " +
                    "             ,[status]  " +
                    "             ,[create_id]  " +
                    "             ,[create_datetime])  " +
                    "       VALUES  " +
                    "             ('" + productMTran.product_id + "'  " +
                    "             , '" + productMTran.ip + "'  " +
                    "             , '" + productMTran.status + "'  " +
                    "             , '" + productMTran.create_id + "'  " +
                    "             , GETDATE())  ";
        return sSql;
    }

    private string fnInsertsSql(ProductMTran productMTran)
    {
        string sSql =
                        "  INSERT INTO [MNDTproduct_master_tran]  " +
                        "             ([product_id]  " +
                        "             ,[ip]  " +
                        "             ,[status]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime])  " +
                        "  SELECT [product_id]  " +
                        "        , '" + productMTran.ip + "'  " +
                        "        , '" + productMTran.status + "'  " +
                        "        , '" + productMTran.create_id + "'  " +
                        "        , GETDATE()  " +
                        "  FROM [MNDTmaterial]  " +
                        " WHERE [product_id] IN (" + productMTran.product_id + ")";
        return sSql;
    }

    public string fnCount(ProductMTran productMTran)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[product_id]", productMTran.product_id);

        string sCountSql =
                        "          SELECT COUNT(product_id)   " +
                        "          FROM   [MNDTproduct_master_tran]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    #endregion

    public DataTable fnSelectList()
    {
        string sSql =
                        "  SELECT [product_m].[product_id] [value],   " +
                        "         [product_m].[name]   " +
                        "  FROM MNDTproduct_master AS [product_m]  " +
                        "  WHERE [product_m].[status] <> 'D' ";

        return PublicApi.fnGetDt(sSql, "MNDT");
    }
}