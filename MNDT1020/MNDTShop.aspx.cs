using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MNDTShop : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string sProductCode = Request.QueryString["ProductCode"];
        string sClient = Request.QueryString["Client"];
        fnInitPostback();
        if (!IsPostBack)
        {
            fnInitTitleRotation();
            fnInitTitle();
        }
        if (sClient != null)
        {
            lt_hot_item_html.Text = "";
            lt_html_bottom_rotation.Text = "";
            lt_html_title_rotation.Text = "";
            fnInitClient();
        }
        else if (sProductCode == null)
        {
            fnInitHotItem();
            fnInitBottomRotation();
        }
        else
        {
            lt_hot_item_html.Text = "";
            lt_html_bottom_rotation.Text = "";
            lt_html_title_rotation.Text = "";
            fnInitItem(sProductCode);
        }
        fnInitCard();
    }

    void fnInitPostback()
    {
        StringBuilder sbScript = new StringBuilder();
        sbScript.Append("<script language='JavaScript' type='text/javascript'>\n");
        sbScript.Append("function Postback() {");
        sbScript.Append("<!--\n");
        sbScript.Append(ClientScript.GetPostBackEventReference(this, "") + ";\n");
        sbScript.Append("// -->\n");
        sbScript.Append("}");
        sbScript.Append("</script>\n");
        ClientScript.RegisterStartupScript(Page.GetType(), "AutoPostBackScript", sbScript.ToString());
    }

    private void fnInitItem(string sProductCode)
    {
        string sSql = "  SELECT [shop_i].[shop_name]  " +
                        "  	  ,[shop_i].[shop_content]  " +
                        "  	  ,[product_d].[product_norm]  " +
                        "  	  ,[code_d].[code_name]  " +
                        "  	  ,CAST([product_d].[product_pricing] AS int) AS 'price'  " +
                        "  	  ,(SELECT SUM([stock_amount])  " +
                        "       FROM [MNDTstock] [stock]  " +
                        "       WHERE [stock].[product_kind] = 'B01'  " +
                        "  	        AND [product_d].[product_code] = [stock].[product_code]  " +
                        "  	        AND [stock_amount] <> 0)  " +
                        "  FROM [MNDTshop_item] [shop_i] LEFT JOIN [MNDTproduct_details] [product_d]  " +
                        "  ON [product_d].[product_kind] = 'B01'  " +
                        "  	AND [shop_i].[product_code] = [product_d].[product_code] LEFT JOIN [MNDTcode_details] [code_d]  " +
                        "  ON [code_d].[code_kind] = 'ProductClass'  " +
                        "  	AND [code_d].[code] = [shop_i].[shop_category]  " +
                        "  WHERE [shop_i].[product_code]= '" + sProductCode + "'  ";
        DataTable dtData = Functions.fnGetDt(sSql, "MNDT");
        fnInitItemTitle(dtData);
        fnInitItemData(dtData, sProductCode);
    }
    private void fnInitTitle()
    {
        lt_html_title.Text = " <div class='title-href-div'> ";
        lt_html_title.Text += "     <spwn class='menu_text'>選單</spwn> ";
        lt_html_title.Text += "     <input type='button' class='menu_botton'> ";
        lt_html_title.Text += " </div> ";
        lt_html_title.Text += " <div class='content-title'> ";
        lt_html_title.Text += "     <ul class='memu-1'> ";
        lt_html_title.Text += "         <li class='menu-down'> ";
        lt_html_title.Text += "             <a class='content-href' href='#none'>熱門商品</a> ";
        lt_html_title.Text += "             <ul class='memu-2 menu-down-hide'> ";
        lt_html_title.Text += "                 <li> <a href='MNDT6020.aspx'>產品1</a> </li> ";
        lt_html_title.Text += "                 <li> <a href='MNDT6030.aspx'>產品2</a> </li> ";
        lt_html_title.Text += "             </ul> ";
        lt_html_title.Text += "         </li> ";
        lt_html_title.Text += "         <li> <a class='content-href' href='#none'>最新商品</a> </li> ";
        lt_html_title.Text += "    </ul> ";
        lt_html_title.Text += " </div> ";
    }
    private void fnInitHotItem()
    {
        lt_hot_item_html.Text = " <h3 class='text-style1'>推薦商品</h3> ";
        string sSql = "  SELECT [shop_i].[product_code]  " +
                        "        ,[shop_i].[shop_name]  " +
                        "        ,[shop_i].[shop_description]  " +
                        "  	  ,CAST([product_d].[product_pricing] AS int)  " +
                        "  FROM [MNDTshop_item] [shop_i] LEFT JOIN [MNDTproduct_details] [product_d]  " +
                        "  ON [product_d].[product_kind] = 'B01'  " +
                        "  	AND [shop_i].[product_code] = [product_d].[product_code]   " +
                        "  WHERE [shop_i].[shop_special] = 'P02'  ";
        DataTable dtData = Functions.fnGetDt(sSql, "MNDT");
        for (int iPos = 0; iPos < dtData.Rows.Count; iPos++)
        {
            fnAddHotItem(lt_hot_item_html, iPos, dtData.Rows[iPos][0].ToString(), dtData.Rows[iPos][1].ToString(),
                                dtData.Rows[iPos][2].ToString(), dtData.Rows[iPos][3].ToString());
        }
    }
    private void fnAddHotItem(Literal ltHtml, int iPos, string sFileName, string sShopName, string sShopDescription, string sPrice)
    {
        ltHtml.Text += " <div class='hot-item-div'> ";
        ltHtml.Text += "      <div class='hot-img-div'> ";
        ltHtml.Text += "          <a href='MNDTShop.aspx?ProductCode=" + sFileName + "'> <img class='hot-item-img hot-item-img-" + iPos + "' src='ShopItem/" + sFileName + "/show_one.png' title='" + sShopName + "' ></a> ";
        ltHtml.Text += "      </div> ";
        ltHtml.Text += "      <div class='hot-content-div'> ";
        ltHtml.Text += "          <a href='MNDTShop.aspx?ProductCode=" + sFileName + "'>" + sShopName + "</a>";
        ltHtml.Text += "          <p>" + sShopDescription + "</p>";
        ltHtml.Text += "          <p class='hot-price'>NT$" + sPrice + "</p>";
        ltHtml.Text += "      </div> ";
        ltHtml.Text += "      <div class='hot-content-button'> ";
        ltHtml.Text += "          <button class='btn-buy fly-shop-item-buy' id='buy" + iPos + "' type='button' title='放入購物車'> ";
        ltHtml.Text += "          </button>";
        ltHtml.Text += "          <button class='btn-like fly-shop-item-like' id='like" + iPos + "' type='button' title='我的最愛'> ";
        ltHtml.Text += "          </button>";
        ltHtml.Text += "      </div> ";
        ltHtml.Text += " </div> ";
    }
    private void fnInitTitleRotation()
    {
        fnInitRotation(lt_html_title_rotation, "title", "wrapper");
    }
    private void fnInitBottomRotation()
    {
        fnInitRotation(lt_html_bottom_rotation, "bottom", "sponsor");
    }
    private void fnInitRotation(Literal ltHtml, string sId, string sClass)
    {
        string sChildDir = sId + "\\";
        string sRootDir = "\\Rotation\\";
        string sAppPath = Request.PhysicalApplicationPath;
        string filePath = sAppPath + sRootDir + sChildDir;
        ltHtml.Text = " <div id='" + sId + "_rotation' class='" + sClass + "'> ";
        ltHtml.Text += "    <h2> <img src='Image/next.png' onmouseover='this.src='/Image/next_1.png'' onmouseout='this.src='/Image/next.png'' /> </h2> ";
        ltHtml.Text += "    <h3> <img src='Image/last.png' onmouseover='this.src='/Image/last_1.png'' onmouseout='this.src='/Image/last.png'' /> </h3> ";
        ltHtml.Text += "    <ul class='pic'> ";
        foreach (string sFilename in System.IO.Directory.GetFiles(filePath))
        {
            string sFileDir = sRootDir + sChildDir;
            fnAddImage(ltHtml, "Rotation\\", sChildDir, sFilename.Replace(filePath, ""));
        }
        ltHtml.Text += "    </ul> ";
        ltHtml.Text += " </div> ";
        ltHtml.Text += " <ul class='page_dot' id='" + sId + "_dot'></ul>";
    }
    private void fnAddImage(Literal ltHtml, string sRootDir, string sChildDir, string sFileName)
    {
        string sPath = sRootDir + sChildDir + sFileName;
        string sImgPath = sPath.Replace('\\', '/').Substring(1, sPath.Length - 1);
        ltHtml.Text += " <li> ";
        ltHtml.Text += "    <div class='img-div'> ";
        ltHtml.Text += "        <img src='" + sPath + "' onclick=\"show_pictrue('" + sImgPath + "')\" /> ";
        ltHtml.Text += "    </div> ";
        ltHtml.Text += " </li> ";
    }
    private void fnInitItemTitle(DataTable dtData)
    {
        lt_item_title_html.Text = " <div class='item-title'> ";
        lt_item_title_html.Text += "     <ul class='item-1'> ";
        lt_item_title_html.Text += "             <li> <a href='MNDTShop.aspx'><img class='home'><img></a> </li> ";
        lt_item_title_html.Text += "             <li> <a class='item-href' href='#none'>最新商品</a> </li> ";
        lt_item_title_html.Text += "     </ul> ";
        lt_item_title_html.Text += " </div> ";
    }
    private void fnInitItemData(DataTable dtData, string sProductCode)
    {
        lt_item_data_html.Text = " <div class='item-data-div'> ";
        lt_item_data_html.Text += "     <div class='item-data-div-left'> ";
        fnInitItemImage(lt_item_data_html, sProductCode);
        fnInitTab(lt_item_data_html, dtData);
        lt_item_data_html.Text += "     </div> ";
        lt_item_data_html.Text += "     <div class='item-data-div-right'> ";
        fnInitRight(lt_item_data_html, dtData, sProductCode);
        lt_item_data_html.Text += "     </div> ";
        lt_item_data_html.Text += " </div> ";
    }
    private void fnInitItemImage(Literal ltHtml, string sProductCode)
    {
        string sChildDir = sProductCode + "\\";
        string sRootDir = "ShopItem\\";
        string sAppPath = Request.PhysicalApplicationPath;
        string filePath = sAppPath + sRootDir + sChildDir;
        ltHtml.Text += " <div> ";
        ltHtml.Text += "    <ul> ";
        ltHtml.Text += "        <li class='item-data-big-img'> <a onclick=\"show_pictrue('ShopItem/" + sProductCode + "/show_one.png')\" > <img class='hot-item-img-0' src='ShopItem\\" + sProductCode + "\\show_one.png'><img></a>  </li> ";

        foreach (string sFileName in System.IO.Directory.GetFiles(filePath))
        {
            string sName = sFileName.Replace(filePath, "");
            if (sName != "show_one.png")
            {
                string sPath = sRootDir + sChildDir + sName;
                string sImgPath = sPath.Replace('\\', '/').Substring(1, sPath.Length - 1);
                lt_item_data_html.Text += " <li class='item-data-small-img'> ";
                lt_item_data_html.Text += "     <a onclick=\"show_pictrue('" + sImgPath + "')\" > <img src='" + sPath + "'></img></a>  ";
                lt_item_data_html.Text += " </li> ";
            }
        }
        ltHtml.Text += "     </ul> ";
        ltHtml.Text += " </div> ";
    }
    private void fnInitTab(Literal ltHtml, DataTable dtData)
    {
        ltHtml.Text += "         <div class='item-tab'> ";
        ltHtml.Text += "             <ul> ";
        ltHtml.Text += "                 <li class='tab select-tab'><a href='#tab1' >商品說明</a></li> ";
        ltHtml.Text += "                 <li class='tab'><a href='#tab2'>評論</a></li> ";
        ltHtml.Text += "             </ul> ";
        ltHtml.Text += "         </div> ";
        ltHtml.Text += "         <div class='item-tab-content'> ";
        ltHtml.Text += "             <div class='tab1-div'> " + dtData.Rows[0][1];
        ltHtml.Text += "             </div> ";
        ltHtml.Text += "             <div class='tab2-div hide'> ";
        ltHtml.Text += "             </div> ";
        ltHtml.Text += "         </div> ";
    }
    private void fnInitRight(Literal ltHtml, DataTable dtData, string sProductCode)
    {
        ltHtml.Text += " <div> ";
        ltHtml.Text += "    <button class='btn-like fly-shop-item-like' id='like0' type='button' title='我的最愛' />";
        ltHtml.Text += " </div> ";
        ltHtml.Text += " <div> ";
        ltHtml.Text += "    <ul> ";
        ltHtml.Text += "        <li> <h1>" + dtData.Rows[0][3] + "</h1> </li>";
        ltHtml.Text += "        <li> <p>規格：" + dtData.Rows[0][2] + "</p> </li>";
        ltHtml.Text += "        <li> <p>庫存數量：" + dtData.Rows[0][5] + "</p> </li>";
        ltHtml.Text += "        <li> <h1>NT" + dtData.Rows[0][4] + "</h1> </li>";
        ltHtml.Text += "        <li> <p>數量：</p> </li>";
        ltHtml.Text += "        <li> <input class='input-buy' type='text' id='cart_amount' value='1' /></li>";
        ltHtml.Text += "        <li> <button type='button' class='btn-item-buy' title='購買' onClick=\"add_cart('" + sProductCode + "')\" >購買</button></li>";
        ltHtml.Text += "    </ul> ";
        ltHtml.Text += " </div> ";
    }
    private void fnInitCard()
    {
        fnInitCardList(lt_html_cart_list);
    }
    private void fnInitCardList(Literal ltHtml)
    {
        if (Session["sCId"] != null)
        {
            string sSql = "  SELECT [cart].[clent_id]  " +
                            "        ,[product_d].[product_code_name]  " +
                            "        ,[cart].[product_code]  " +
                            "        ,[cart].[cart_amount]  " +
                            "        ,CAST([cart].[cart_money] AS int)  " +
                            "  FROM [MNDTshop_cart] [cart] LEFT JOIN [MNDTproduct_details] [product_d]  " +
                            "  ON [product_d].[product_kind] = 'B01'  " +
                            "  	AND [cart].[product_code] = [product_d].[product_code]  " +
                            "  WHERE [cart].[clent_id] = '" + Session["sCId"].ToString() + "' ";
            fnInitCardData(ltHtml, Functions.fnGetDt(sSql, "MNDT"));
        }
        else
        {
            ltHtml.Text = "";
        }
    }
    private void fnInitCardData(Literal ltHtml, DataTable dtData)
    {
        ltHtml.Text = " <div> ";
        ltHtml.Text += "    <ul> ";
        ltHtml.Text += "        <li> ";
        ltHtml.Text += "            <table> ";
        ltHtml.Text += "                <tbody> ";
        for (int iPos = 0; iPos < dtData.Rows.Count; iPos++)
        {
            ltHtml.Text += " <tr> ";
            ltHtml.Text += "    <td class='table-img'> ";
            ltHtml.Text += "        <a href='MNDTShop.aspx?ProductCode=" + dtData.Rows[iPos][2] + "' > ";
            ltHtml.Text += "           <img src='ShopItem\\" + dtData.Rows[iPos][2] + "\\show_one.png' /> ";
            ltHtml.Text += "        </a> ";
            ltHtml.Text += "    </td> ";
            ltHtml.Text += "    <td class='table-str'> ";
            ltHtml.Text += "        <a href='MNDTShop.aspx?ProductCode=" + dtData.Rows[iPos][2] + "' > " + dtData.Rows[iPos][1] + " </a> ";
            ltHtml.Text += "    </td> ";
            ltHtml.Text += "    <td class='table-num'>X" + dtData.Rows[iPos][3] + "</td> ";
            ltHtml.Text += "    <td class='table-num'>NT" + dtData.Rows[iPos][4] + "</td> ";
            ltHtml.Text += "    <td class='table-btn'> ";
            ltHtml.Text += "        <button type='button' onClick=\"delete_cart('" + dtData.Rows[iPos][2] + "')\" ></button> ";
            ltHtml.Text += "    </td> ";
            ltHtml.Text += " </tr> ";
        }
        ltHtml.Text += "                </tbody> ";
        ltHtml.Text += "            </table> ";
        ltHtml.Text += "        </li> ";
        ltHtml.Text += "    </ul> ";
        ltHtml.Text += " </div> ";
    }

    private void fnInitClient()
    {
        fnInitClientView(lt_client_data);
    }

    private void fnInitClientView(Literal ltHtml)
    {
        ltHtml.Text = " <div class='client-login-div'> ";
        ltHtml.Text += "     <div class='client-left-div'> ";
        ltHtml.Text += "     </div> ";
        ltHtml.Text += "     <div class='client-center-div'> ";
        ltHtml.Text += "        <div> ";
        ltHtml.Text += "            <h1>會員登入</h1> ";
        ltHtml.Text += "            <h4>會員由此登入</h4> ";
        ltHtml.Text += "            <h4>帳號</h4> ";
        ltHtml.Text += "            <input type='text' id='text_id' /> ";
        ltHtml.Text += "            <h4>密碼</h4> ";
        ltHtml.Text += "            <input type='text' id='text_password' /> ";
        ltHtml.Text += "            <button title='登入' type='button' id='btn_login' />登入</button> ";
        ltHtml.Text += "        </div> ";
        ltHtml.Text += "     </div> ";
        ltHtml.Text += "     <div class='client-right-div'> ";
        ltHtml.Text += "     </div> ";
        ltHtml.Text += " </div> ";
    }
}