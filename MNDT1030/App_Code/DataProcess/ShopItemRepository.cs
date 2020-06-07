using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// AccountRepository 的摘要描述
/// </summary>
public class ShopItemRepository
{
    public ShopItemRepository()
    {
    }

    #region ShopItem

    // sNum 排行
    public string fnSelectId(ShopItem shopItem, string sNum)
    {
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[product_id]", shopItem.product_id);
        sCondition += PublicApi.fnAddCondition("[status]", shopItem.status);

        string sSql = "  SELECT [shopItem].[product_id]  " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + shopItem.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTshop_item]   " +
                        "          WHERE  1 = 1" + sCondition + ") AS [shopItem]  " +
                        "  WHERE [shopItem].[NUM] = '" + sNum + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public DataTable fnSelect(ShopItem shopItem)
    {
        string sSql = "  SELECT TOP 1 [shopItem].[product_id]  " +
                        "        ,[shopItem].[category]  " +
                        "        ,[shopItem].[content]  " +
                        "        ,[shopItem].[description]  " +
                        "        ,[shopItem].[remarks]  " +
                        "        ,[shopItem].[type]  " +
                        "        ,[shopItem].[fold]  " +
                        "        ,[shopItem].[status]  " +
                        "  FROM   [MNDTshop_item] [shopItem]  " +
                        "  WHERE [shopItem].[product_id] = '" + shopItem.product_id + "' ";
        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(ShopItem shopItem, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[product_id]", shopItem.product_id);
        sCondition += PublicApi.fnAddCondition("[status]", shopItem.status);

        string sInquireSql =
                        "  SELECT [shopItem].[product_id],   " +
                        "         [shopItem].[category],   " +
                        "         [shopItem].[type],   " +
                        "         [shopItem].[fold],   " +
                        "         [shopItem].[status],   " +
                        "         CONVERT(CHAR, [shopItem].[create_datetime], 111) [create_datetime],   " +
                        "         [shopItem].[NUM]   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + shopItem.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTshop_item]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [shopItem]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnSelects(ShopItem shopItem)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[product_id]", shopItem.product_id);
        sCondition += PublicApi.fnAddCondition("[status]", shopItem.status);
        sCondition += " ORDER BY [" + shopItem.order + "] ";
        string sInquireSql =
                        "  SELECT [shopItem].[id],   " +
                        "         [shopItem].[account],   " +
                        "         [shopItem].[name],   " +
                        "         [shopItem].[address],  " +
                        "         [shopItem].[phone]   " +
                        "  FROM MNDTshop_item AS [shopItem]  " +
                        "  WHERE 1 = 1 " + sCondition;
        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnSelectShopItem(ShopItem shopItem, string categoryName = "")
    {

        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[shopItem].[product_id]", shopItem.product_id);
        sCondition += PublicApi.fnAddCondition("[shopItem].[category]", shopItem.category);
        sCondition += PublicApi.fnAddCondition("[shopItem].[type]", shopItem.type);
        sCondition += PublicApi.fnAddCondition("[kind_d].[name] ", "%" + categoryName + "%");
        sCondition += PublicApi.fnAddCondition("[shopItem].[status]", "N");

        string sInquireSql =
                            "  SELECT [shopItem].*,   " +
                            "         [product_m].[name], " +
                            "         ISNULL([product_m].[price] * [shopItem].[fold], [product_m].[price]) [price], " +
                            "         ISNULL([stock].[amount], 0) [amount], " +
                            "         [kind_d].[name] [category_name] " +
                            "  FROM   [MNDTshop_item] [shopItem]  " +
                            "  LEFT JOIN [MNDTproduct_master] [product_m]  " +
                            "       ON   [shopItem].[product_id] = [product_m].[product_id]  " +
                            "  LEFT JOIN [MNDTproduct_stock] [stock]  " +
                            "       ON   [stock].[product_id] = [shopItem].[product_id]  " +
                            "       AND   [stock].[warehouse_id] = '01'  " +
                             "  LEFT JOIN [MNDTkind_details] [kind_d]  " +
                            "       ON   [kind_d].[code_id] = [shopItem].[category]  " +
                            "       AND  [kind_d].[kind_id] = 'SIC'  " +
                            "          WHERE  1 = 1 " + sCondition;

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnExport(ShopItem shopItem)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[product_id]", shopItem.product_id);
        sCondition += PublicApi.fnAddCondition("[status]", shopItem.status);
        sCondition += " ORDER BY [" + shopItem.order + "] ";
        string sInquireSql =
                        "  SELECT [shopItem].[id] '編號',   " +
                        "         [shopItem].[account] '帳號',   " +
                        "         [shopItem].[password] '密碼',   " +
                        "         [shopItem].[name] '名子',   " +
                        "         [shopItem].[address] '地址',  " +
                        "         [shopItem].[phone] '手機'  " +
                        "  FROM MNDTshop_item AS [shopItem]  " +
                        "  WHERE 1 = 1 " + sCondition;
        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public string fnInsert(ShopItem shopItem)
    {
        string sSql = "  INSERT INTO [MNDTshop_item]  " +
                        "             ([product_id]  " +
                        "             ,[category]  " +
                        "             ,[content]  " +
                        "             ,[description]  " +
                        "             ,[remarks]  " +
                        "             ,[type]  " +
                        "             ,[fold]  " +
                        "             ,[create_id]  " +
                        "             ,[create_datetime]  " +
                        "             ,[modify_id]  " +
                        "             ,[modify_datetime]  " +
                        "             ,[status])  " +
                        "       VALUES  " +
                        "             ('" + shopItem.product_id + "'  " +
                        "             ,'" + shopItem.category + "'  " +
                        "             ,'" + shopItem.content + "'  " +
                        "             ,'" + shopItem.description + "' " +
                        "             ,'" + shopItem.remarks + "'  " +
                        "             ,'" + shopItem.type + "'  " +
                        "             ,'" + shopItem.fold + "'  " +
                        "             ,'" + shopItem.create_id + "'  " +
                        "             ,GETDATE() " +
                        "             ,'" + shopItem.create_id + "'  " +
                        "             ,GETDATE()  " +
                        "             ,'N')  ";
        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnUpdate(ShopItem shopItem, string sIP, string sId)
    {
        string sSql = "  UPDATE [dbo].[MNDTshop_item]  " +
                        "     SET [category] = '" + shopItem.category + "'  " +
                        "        ,[content] = '" + shopItem.content + "'  " +
                        "        ,[description] = '" + shopItem.description + "'  " +
                        "        ,[remarks] = '" + shopItem.remarks + "'  " +
                        "        ,[type] = '" + shopItem.type + "'  " +
                        "        ,[fold] = '" + shopItem.fold + "'  " +
                        "        ,[modify_id] = '" + shopItem.modify_id + "'  " +
                        "        ,[modify_datetime] = GETDATE()  " +
                        "  WHERE [product_id] = '" + shopItem.product_id + "' ";

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDelete(ShopItem shopItem, string sIP, string sId)
    {
        string sSql = " UPDATE [dbo].[MNDTshop_item] " +
                        "       SET [status] = 'D' " +
                        " WHERE [product_id] = '" + shopItem.product_id + "' ";

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnDeletes(ShopItem shopItem, string sIP, string sId)
    {
        string sSql = " UPDATE [dbo].[MNDTshop_item] " +
                        "       SET [status] = 'D' " +
                        " WHERE [product_id] IN (" + shopItem.product_id + ")";

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    public string fnCount(ShopItem shopItem)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[product_id]", shopItem.product_id);
        sCondition += PublicApi.fnAddCondition("[status]", shopItem.status);

        string sCountSql =
                        "          SELECT COUNT(product_id)   " +
                        "          FROM   [MNDTshop_item]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    public bool fnIsExist(ShopItem shopItem)
    {
        string sSql = "  SELECT COUNT([id])   " +
                        "  FROM   [MNDTshop_item]   " +
                        "  WHERE  [status] = 'N' " +
                        "       AND [id] = '" + shopItem.product_id + "'   ";
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }

    #endregion




    public DataTable fnSelectList()
    {
        string sSql =
                        "  SELECT [account].[id] [value],   " +
                        "         [account].[name]   " +
                        "  FROM MNDTshop_item AS [account]  " +
                        "  WHERE [status] <> 'D' ";

        return PublicApi.fnGetDt(sSql, "MNDT");
    }
}