using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;

/// <summary>
/// Summary description for ActionService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ActionService : System.Web.Services.WebService
{

    public ActionService()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod(EnableSession = true)]
    public bool fnDeleteProductImage(string sFileName)
    {
        string appPath = Server.MapPath(".");
        string sPath = appPath + "//ProductImage//" + sFileName;
        if (File.Exists(sPath))
        {
            try
            {
                File.Delete(sPath);
            }
            catch
            {
                return false;
            }
            return true;
        }
        return false;
    }

    [WebMethod(EnableSession = true)]
    public bool fnDeleteRotationImage(string sFileName)
    {
        string appPath = Server.MapPath(".");
        string sPath = appPath + "//Rotation//" + sFileName;
        if (File.Exists(sPath))
        {
            try
            {
                File.Delete(sPath);
            }
            catch
            {
                return false;
            }
            return true;
        }
        return false;
    }

    [WebMethod(EnableSession = true)]
    public bool fnDeleteShopImage(string sFileName)
    {
        string appPath = Server.MapPath(".");
        string sPath = appPath + "//ShopItem//" + sFileName;
        if (File.Exists(sPath))
        {
            try
            {
                File.Delete(sPath);
            }
            catch
            {
                return false;
            }
            return true;
        }
        return false;
    }



    [WebMethod(EnableSession = true)]
    public string fnInsertShopItem(string sProductCode, string sShopName, string sShopCategory,
        string sShopRemarks, string sShopContent, string sShopDescription, string sShopSpecial)
    {
        sShopContent = sShopContent.Replace("SSS0", "<").Replace("SSS1", ">");
        string sSql = "  INSERT INTO [MNDTshop_item]  " +
                        "             ([product_code]  " +
                        "             ,[shop_name]  " +
                        "             ,[shop_category]  " +
                        "             ,[shop_content]  " +
                        "             ,[shop_description] " +
                        "             ,[shop_remarks]  " +
                        "             ,[shop_special] " +
                        "             ,[create_user_id]  " +
                        "             ,[create_datetime]  " +
                        "             ,[modify_user_id]  " +
                        "             ,[modify_datetime])  " +
                        "       VALUES  " +
                        "             ('" + sProductCode + "'  " +
                        "             ,'" + sShopName + "' " +
                        "             ,'" + sShopCategory + "'  " +
                        "             ,'" + sShopContent + "' " +
                        "             ,'" + sShopDescription + "' " +
                        "             ,'" + sShopRemarks + "' " +
                        "             ,'" + sShopSpecial + "' " +
                        "             ,'" + Session["sId"] + "'  " +
                        "             ,GETDATE() " +
                        "             ,'" + Session["sId"] + "' " +
                        "             ,GETDATE())  ";
        string sResult = Functions.fnExecuteSQL(sSql, "MNDT");
        if (sResult == null || sResult == "") sResult = "新增成功";
        return sResult;
    }

    [WebMethod(EnableSession = true)]
    public string fnUpdateShopItem(string sProductCode, string sShopName, string sShopCategory,
        string sShopRemarks, string sShopContent, string sShopDescription, string sShopSpecial)
    {
        sShopContent = sShopContent.Replace("SSS0", "<").Replace("SSS1", ">");
        string sSql = "  UPDATE [MNDTshop_item]  " +
                    "     SET [shop_name] = '" + sShopName + "' " +
                    "        ,[shop_category] = '" + sShopCategory + "' " +
                    "        ,[shop_content] = '" + sShopContent + "' " +
                    "        ,[shop_description] = '" + sShopDescription + "' " +
                    "        ,[shop_remarks] = '" + sShopRemarks + "' " +
                    "        ,[shop_special] = '" + sShopSpecial + "' " + 
                    "        ,[modify_user_id] = '" + Session["sId"] + "' " +
                    "        ,[modify_datetime] = GETDATE()  " +
                    "  WHERE [product_code] = '"+sProductCode+"' " ;
        string sResult = Functions.fnExecuteSQL(sSql, "MNDT");
        if (sResult == null || sResult == "") sResult = "更新成功";
        return sResult;
    }

    [WebMethod(EnableSession = true)]
    public string fnAddCartShop(string sProductCode, string sAmount)
    {
        string sResult = "";
        string sCheckSql = "  SELECT [cart_amount]  " +
                            "  FROM [MNDTshop_cart]  " +
                            "  WHERE [clent_id] = '" + Session["sCId"] + "'  " +
                            "  	AND [product_code] =  '" + sProductCode + "' ";
        string sNAmount = Functions.fnGetValue(sCheckSql, "MNDT");
        if (Session["sCId"] == null || Session["sCId"].ToString().Length < 1)
        {
            return "Login";
        }
        if (sNAmount.Length > 0)
        {
            int sIAmount = int.Parse(sNAmount) + int.Parse(sAmount);
            string sUpdate = "  UPDATE [MNDTshop_cart]  " +
                            "     SET [cart_amount] = '" + sIAmount + "' " +
                            "        ,[cart_money] = ([product_d].[product_pricing] * " + sIAmount + ") " +
                            "  FROM [MNDTproduct_details] [product_d]  " +
                            "  WHERE [product_d].[product_kind] = 'B01'  " +
                            "  	AND [product_d].[product_code] = '" + sProductCode + "'  " +
                            "   AND [MNDTshop_cart].[clent_id] = '" + Session["sCId"] + "'  ";
            sResult = Functions.fnExecuteSQL(sUpdate, "MNDT");
        }
        else
        {
            int sIAmount = int.Parse(sAmount);
            string sInsert = "  INSERT INTO [MNDTshop_cart]    " +
                                "             ([clent_id]    " +
                                "             ,[product_code]    " +
                                "             ,[cart_amount]    " +
                                "             ,[cart_money]    " +
                                "             ,[create_user_id]    " +
                                "             ,[create_datetime]    " +
                                "             ,[modify_user_id]    " +
                                "             ,[modify_datetime])    " +
                                "  SELECT '" + Session["sCId"] + "' " +
                                "         , '" + sProductCode + "' " +
                                "         , '" + sIAmount + "' " +
                                "         , [product_pricing] * " + sIAmount +
                                "         , '" + Session["sCId"] + "' " + 
                                "         ,GETDATE() " +
                                "         , '" + Session["sCId"] + "' " + 
                                "         ,GETDATE() " +
                                "  FROM [MNDTproduct_details]    " +
                                "  WHERE [product_kind] = 'B01'    " +
                                "  	AND [product_code] = '" + sProductCode + "'    ";
            sResult = Functions.fnExecuteSQL(sInsert, "MNDT");
        }
      
        sResult = sResult == "" ? "Y" : sResult;
        return sResult;
    }

    [WebMethod(EnableSession = true)]
    public string fnDeleteCartShop(string sProductCode)
    {
        if (Session["sCId"] == null || Session["sCId"].ToString().Length < 1)
        {
            return "Login";
        }
        string sSql = "  DELETE FROM[MNDTshop_cart]  " +
                        "  WHERE  [clent_id] = '" + Session["sCId"] + "'  " +
                        "  	AND [product_code] =  '" + sProductCode + "' ";
        string sResult = Functions.fnExecuteSQL(sSql, "MNDT");
        sResult = sResult == "" ? "Y" : sResult;
        return sResult;
    }

    [WebMethod(EnableSession = true)]
    public bool fnClientLogin(string sAccount, string sPassword)
    {
        string sSql = "  SELECT TOP 1 [client_id]  " +
                        "  FROM [MNDTclient]  " +
                        "  WHERE [client_id] = '" + sAccount + "'  " +
                        "  	AND [client_password] = '" + sPassword + "'  ";
        if (Functions.fnGetDt(sSql, "MNDT").Rows.Count > 0)
        {
            Session["sCId"] = sAccount;
            return true;
        }
        Session["sCId"] = "";
        return false;
    }

}
