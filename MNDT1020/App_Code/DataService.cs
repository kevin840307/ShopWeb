using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;

/// <summary>
/// Summary description for DataService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class DataService : System.Web.Services.WebService {

    public DataService () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string fnLogin(string sId, string sPassword)
    {
        string sSql = "  SELECT [account_name]  " +
                        "  FROM [MNDTaccount]  " +
                        "  WHERE [account_id] = '" + sId + "'  " +
                        "  	AND [account_password] = '" + sPassword + "'   ";
        return Functions.fnGetValue(sSql, "MNDT");
    }

    [WebMethod]
    public string[] fnGetQRcodeData(string sKind, string sCode)
    {
        string sSql = "  SELECT [product_m].[product_kind_name]  " +
                        "  	,[product_d].[product_code_name]  " +
                        "  	,(SELECT SUM([stock_amount])  " +
                        "  		FROM [MNDTstock] [stock]  " +
                        "  		WHERE [stock].[product_kind] = [product_d].[product_kind]  " +
                        "  			AND [stock].[product_code] = [product_d].[product_code])  " +
                        "  FROM [MNDTproduct_master] [product_m] LEFT JOIN [MNDTproduct_details] [product_d]  " +
                        "  ON [product_m].[product_kind] = [product_d].[product_kind]  " +
                        "  WHERE [product_m].[product_kind] = '" + sKind + "'  " +
                        "       AND [product_d].[product_code] = '" + sCode + "' ";
        return Functions.fnGetLs(sSql, 3, "MNDT").ToArray();
    }

    [WebMethod]
    public string[] fnGetInventoryMData()
    {
        string sSql = "  SELECT [data].*  " +
                        "  FROM (  " +
                        "  	SELECT  [stock].[product_kind]  " +
                        "  		  , [stock].[product_code]  " +
                        "  		  , [product_d].[product_code_name]  " +
                        "  		  , SUM([stock].[stock_amount]) AS 'stock_amount'  " +
                        "  		  , [product_d].[product_deadline]  " +
                        "         , [product_d].[product_cost]  " +
                        "         , [product_d].[product_pricing]  " +
                        "         , DENSE_RANK() OVER(ORDER BY [product_d].[product_code_name]) AS 'index' " +
                        "  	FROM [MNDTstock] [stock] LEFT JOIN [MNDTproduct_details] [product_d]  " +
                        "  	ON [stock].[product_kind] = [product_d].[product_kind]  " +
                        "  		AND [stock].[product_code] = [product_d].[product_code]  " +
                        "  	GROUP BY [stock].[product_kind]  " +
                        "  			, [stock].[product_code]  " +
                        "  			, [product_d].[product_code_name]  " +
                        "           , [product_d].[product_cost]  " +
                        "           , [product_d].[product_pricing]  " +
                        "  			, [product_d].[product_deadline] ) AS [data]  " +
                        "  WHERE [data].[index] >= 0  " ;
        return Functions.fnGetLs(sSql, 7, "MNDT").ToArray();
    }

    public string[] fnGetInventoryDData(string sKind, string sCode)
    {
        string sSql = "  SELECT [purchase_order]  " +
                        "        ,[stock_amount]  " +
                        "        ,ISNULL(CONVERT(char, [stock_date], 111), '無')  " +
                        "        ,ISNULL(CONVERT(char, [stock_adjustment_date], 111), '無')  " +
                        "        ,ISNULL([warehouse].[warehouse_name], '無')  " +
                        "  FROM [MNDTstock] [stock] LEFT JOIN [MNDTproduct_details] [product_d]  " +
                        "  ON [stock].[product_kind] = [product_d].[product_kind]  " +
                        "  	AND [stock].[product_code] = [product_d].[product_code] LEFT JOIN [MNDTwarehouse] [warehouse]  " +
                        "  ON [stock].[warehouse_id] = [warehouse].[warehouse_id]  " +
                        "  WHERE [stock_amount] > 0  " +
                        "  	AND [stock].[product_kind] = '" + sKind + "'  " +
                        "  	AND [stock].[product_code] = '" + sCode + "'  ";
        return Functions.fnGetLs(sSql, 5, "MNDT").ToArray();
    }
    
}
