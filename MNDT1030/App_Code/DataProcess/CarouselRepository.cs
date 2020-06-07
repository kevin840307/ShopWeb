


using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// AccountRepository 的摘要描述
/// </summary>
public class CarouselRepository
{
    public CarouselRepository()
    {
    }

    #region Carousel

    // sNum 排行
    public string fnSelectId(Carousel carousel, string sNum)
    {
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[carousel_id]", carousel.carousel_id);
        sCondition += PublicApi.fnAddCondition("[status]", carousel.status);

        string sSql = "  SELECT [carousel].[carousel_id]  " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + carousel.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTCarousel]   " +
                        "          WHERE  1 = 1" + sCondition + ") AS [carousel]  " +
                        "  WHERE [carousel].[NUM] = '" + sNum + "' ";
        return PublicApi.fnGetValue(sSql, "MNDT");
    }

    public DataTable fnSelect(Carousel carousel)
    {
        string sSql = "  SELECT TOP 1 [carousel].[carousel_id]  " +
                        "        ,[carousel].[name]  " +
                        "        ,[carousel].[remarks]  " +
                        "        ,[carousel].[status]  " +
                        "  FROM   [MNDTCarousel] [carousel]  " +
                        "  WHERE [carousel].[carousel_id] = '" + carousel.carousel_id + "' ";
        return PublicApi.fnGetDt(sSql, "MNDT");
    }

    // iPage 第N頁
    // iSize 最大顯示數量
    public DataTable fnSelects(Carousel carousel, int iPage, int iSize)
    {
        int iStart = (iPage - 1) * iSize + 1;
        int iEnd = iPage * iSize;
        string sCondition = "";

        sCondition += PublicApi.fnAddCondition("[carousel_id]", carousel.carousel_id);
        sCondition += PublicApi.fnAddCondition("[status]", carousel.status);

        string sInquireSql =
                        "  SELECT [carousel].[carousel_id],   " +
                        "         [carousel].[name],   " +
                        "         [carousel].[status],   " +
                        "         CONVERT(CHAR, [carousel].[create_datetime], 111) [create_datetime],   " +
                        "         [carousel].[NUM]   " +
                        "  FROM   (SELECT Row_number() OVER (ORDER BY [" + carousel.order + "] ASC) NUM,   " +
                        "                  *   " +
                        "          FROM   [MNDTCarousel]   " +
                        "          WHERE  1 = 1 " + sCondition + ") AS [carousel]  " +
                        "  WHERE  NUM BETWEEN " + iStart.ToString() + " AND " + iEnd.ToString() + "   ";

        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }

    public DataTable fnSelects(Carousel carousel)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[carousel_id]", carousel.carousel_id);
        sCondition += PublicApi.fnAddCondition("[status]", carousel.status);
        sCondition += " ORDER BY [" + carousel.order + "] ";
        string sInquireSql =
                        "  SELECT [carousel].[carousel_id],   " +
                        "         [carousel].[name],   " +
                        "         [carousel].[status],  " +
                        "         [carousel].[create_datetime]   " +
                        "  FROM MNDTCarousel AS [carousel]  " +
                        "  WHERE 1 = 1 " + sCondition;
        return PublicApi.fnGetDt(sInquireSql, "MNDT");
    }


    //public string fnInsert(Carousel carousel)
    //{
    //    string sSql = "  INSERT INTO [MNDTCarousel]  " +
    //                    "             ([carousel_id]  " +
    //                    "             ,[category]  " +
    //                    "             ,[content]  " +
    //                    "             ,[description]  " +
    //                    "             ,[remarks]  " +
    //                    "             ,[type]  " +
    //                    "             ,[fold]  " +
    //                    "             ,[create_id]  " +
    //                    "             ,[create_datetime]  " +
    //                    "             ,[modify_id]  " +
    //                    "             ,[modify_datetime]  " +
    //                    "             ,[status])  " +
    //                    "       VALUES  " +
    //                    "             ('" + carousel.carousel_id + "'  " +
    //                    "             ,'" + carousel.category + "'  " +
    //                    "             ,'" + carousel.content + "'  " +
    //                    "             ,'" + carousel.description + "' " +
    //                    "             ,'" + carousel.remarks + "'  " +
    //                    "             ,'" + carousel.type + "'  " +
    //                    "             ,'" + carousel.fold + "'  " +
    //                    "             ,'" + carousel.create_id + "'  " +
    //                    "             ,GETDATE() " +
    //                    "             ,'" + carousel.create_id + "'  " +
    //                    "             ,GETDATE()  " +
    //                    "             ,'N')  ";
    //    return PublicApi.fnExecuteSQL(sSql, "MNDT");
    //}

    public string fnUpdate(Carousel carousel, string sIP, string sId)
    {
        string sSql = "  UPDATE [dbo].[MNDTCarousel]  " +
                        "     SET [name] = '" + carousel.name + "'  " +
                        "        ,[remarks] = '" + carousel.remarks + "'  " +
                        "        ,[modify_id] = '" + carousel.create_id + "'  " +
                        "        ,[modify_datetime] = GETDATE()  " +
                        "  WHERE [carousel_id] = '" + carousel.carousel_id + "' ";

        return PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    //public string fnDelete(Carousel carousel, string sIP, string sId)
    //{
    //    string sSql = " UPDATE [dbo].[MNDTCarousel] " +
    //                    "       SET [status] = 'D' " +
    //                    " WHERE [carousel_id] = '" + carousel.carousel_id + "' ";

    //    return PublicApi.fnExecuteSQL(sSql, "MNDT");
    //}

    //public string fnDeletes(Carousel carousel, string sIP, string sId)
    //{
    //    string sSql = " UPDATE [dbo].[MNDTCarousel] " +
    //                    "       SET [status] = 'D' " +
    //                    " WHERE [carousel_id] IN (" + carousel.carousel_id + ")";

    //    return PublicApi.fnExecuteSQL(sSql, "MNDT");
    //}

    public string fnCount(Carousel carousel)
    {
        string sCondition = "";
        sCondition += PublicApi.fnAddCondition("[carousel_id]", carousel.carousel_id);
        sCondition += PublicApi.fnAddCondition("[status]", carousel.status);

        string sCountSql =
                        "          SELECT COUNT(carousel_id)   " +
                        "          FROM   [MNDTCarousel]   " +
                        "          WHERE  1 = 1 " + sCondition;
        string sPageSize = PublicApi.fnGetValue(sCountSql, "MNDT");
        return sPageSize;
    }

    public bool fnIsExist(Carousel carousel)
    {
        string sSql = "  SELECT COUNT([id])   " +
                        "  FROM   [MNDTCarousel]   " +
                        "  WHERE  [status] = 'N' " +
                        "       AND [id] = '" + carousel.carousel_id + "'   ";
        return PublicApi.fnGetValue(sSql, "MNDT") == "1";
    }

    #endregion




    public DataTable fnSelectList()
    {
        string sSql =
                        "  SELECT [account].[id] [value],   " +
                        "         [account].[name]   " +
                        "  FROM MNDTCarousel AS [account]  " +
                        "  WHERE [status] <> 'D' ";

        return PublicApi.fnGetDt(sSql, "MNDT");
    }
}