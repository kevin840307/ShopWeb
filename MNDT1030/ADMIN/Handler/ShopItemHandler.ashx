<%@ WebHandler Language="C#" Class="ShopItemHandler" %>

using System;
using System.Web;
using System.Data;

public class ShopItemHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    private ShopItemRepository g_shopItemRepository = new ShopItemRepository();
    private ShopItem g_shopItem = new ShopItem();

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string sMethod = context.Request.QueryString["method"];
        sMethod = (sMethod == null) ? context.Request.Form["method"] : sMethod;
        if (sMethod != null)
        {
            PublicApi.fnReadLoginCookie(context);
            if (context.Session["id"] != null)
            {
                System.Reflection.MethodInfo methodInfo = this.GetType().GetMethod(sMethod);
                if (methodInfo != null)
                {
                    fnInitData(context);
                    methodInfo.Invoke(this, new object[] { context });
                }
            }
        }
    }

    private void fnInitData(HttpContext context)
    {
        string sProductId = context.Request.QueryString["product_id"];
        string sCategory = context.Request.QueryString["category"];
        string sContent = context.Request.QueryString["content"];
        string sDescription = context.Request.QueryString["description"];
        string sRemarks = context.Request.QueryString["remarks"];
        string sType = context.Request.QueryString["type"];
        string sFold = context.Request.QueryString["fold"];
        string sStatus = context.Request.QueryString["status"];
        string sOrder = context.Request.QueryString["order"];

        g_shopItem.ProductId(sProductId)
                .Category(sCategory)
                .Content(sContent)
                .Description(sDescription)
                .Remarks(sRemarks)
                .Type(sType)
                .Fold(sFold)
                .Status(sStatus)
                .CreateId(PublicApi.fnNullChange(context.Session["id"], ""))
                .ModifyId(PublicApi.fnNullChange(context.Session["id"], ""))
                .Order(sOrder);
    }

    #region ShopItem

    public void fnSelects(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sOrder = context.Request.QueryString["order"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];

        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);

            DataTable dtData = g_shopItemRepository.fnSelects(g_shopItem, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCount(HttpContext context)
    {
        string sSize = g_shopItemRepository.fnCount(g_shopItem);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnSelect(HttpContext context)
    {
        DataTable dtData = g_shopItemRepository.fnSelect(g_shopItem);

        if (dtData.Rows.Count == 1)
        {
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnSelectShopItem(HttpContext context)
    {
        string sCategoryName = context.Request.QueryString["category_name"];
        sCategoryName = sCategoryName == null ? "" : sCategoryName;
        DataTable dtData = g_shopItemRepository.fnSelectShopItem(g_shopItem, sCategoryName);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }


    public void fnSelectId(HttpContext context)
    {
        string sMsg = "Y";
        string sNUM = context.Request.QueryString["NUM"];
        string sProductId = g_shopItemRepository.fnSelectId(g_shopItem, sNUM);

        if (sProductId == " ")
        {
            sMsg = "訊息：已無下筆資料。";
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"product_id\":\"" + sProductId + "\", \"NUM\":\"" + sNUM + "\"}");
    }


    public void fnInsert(HttpContext context)
    {
        string sMsg = fnCheckData(g_shopItem);

        if (sMsg == "Y")
        {
            sMsg = g_shopItemRepository.fnInsert(g_shopItem);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"product_id\":\"" + g_shopItem.product_id + "\"}");
    }

    public void fnUpdate(HttpContext context)
    {
        string sMsg = fnCheckData(g_shopItem);

        if (sMsg == "Y")
        {
            string sIP = PublicApi.fnRetrieveIP(context.Request);
            sMsg = g_shopItemRepository.fnUpdate(g_shopItem, sIP, g_shopItem.create_id);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    public void fnDelete(HttpContext context)
    {
        string sMsg = "Y";
        string sIP = PublicApi.fnRetrieveIP(context.Request);

        sMsg = g_shopItemRepository.fnDelete(g_shopItem, sIP, g_shopItem.create_id);
        sMsg = sMsg.Replace("\r\n", "");
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    public void fnDeletes(HttpContext context)
    {
        string sMsg = "Y";
        string sIP = PublicApi.fnRetrieveIP(context.Request);

        sMsg = g_shopItemRepository.fnDeletes(g_shopItem, sIP, g_shopItem.create_id);
        sMsg = sMsg.Replace("\r\n", "");
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    public void fnExport(HttpContext context)
    {
        string sMsg = "Y";
        DataTable dtData = g_shopItemRepository.fnExport(g_shopItem);
        bool bCheck = PublicApi.fnExportDataTableToExcel(dtData, 0, "ShopItem", context);

        if (!bCheck)
        {
            sMsg = "錯誤訊息：匯出失敗。";
        }
        sMsg = sMsg.Replace("\r\n", "");
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    public void fnReport(HttpContext context)
    {
        string sMsg = "Y";
        DataTable dtData = g_shopItemRepository.fnSelects(g_shopItem);

        if (dtData.Rows.Count > 0)
        {
            context.Session["PrintDT"] = dtData;
        }
        else
        {
            sMsg = "錯誤訊息：筆數少於一筆。";
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    public void fnPrint(HttpContext context)
    {
        DataTable dtData = g_shopItemRepository.fnSelects(g_shopItem);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnSelectList(HttpContext context)
    {
        if (context.Session["id"] != null)
        {
            ShopItemRepository shopItemRepository = new ShopItemRepository();
            DataTable dtData = shopItemRepository.fnSelectList();
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    private string fnCheckData(ShopItem shopItem)
    {
        string sMsg = "Y";
        if (shopItem.product_id.Length > 15)
        {
            sMsg = "錯誤訊息：產品長度錯誤。";
        }
        return sMsg;
    }

    public void fnImport(HttpContext context)
    {
        string sMsg = "Y";
        var fileData = context.Request.Files["FileUpload"];

        fileData.SaveAs(context.Server.MapPath("/\\Import\\ShopItem.xls"));

        string[] sColumns = { "帳號", "密碼", "名子", "地址", "手機" };
        string sSql = "  INSERT INTO [MNDTshopItem]  " +
               "             ([account]  " +
               "             ,[password]  " +
               "             ,[name]  " +
               "             ,[address]  " +
               "             ,[phone]  " +
               "             ,[create_id]  " +
               "             ,[create_datetime])  " +
               "       VALUES  " +
               "             ('{" + sColumns[0] + "}'  " +
               "             ,'{" + sColumns[1] + "}'  " +
               "             ,'{" + sColumns[2] + "}'  " +
               "             ,'{" + sColumns[3] + "}'  " +
               "             ,'{" + sColumns[4] + "}'  " +
               "             ,'" + context.Session["id"] + "'  " +
               "             ,GETDATE())  ";

        sMsg = PublicApi.fnImportExcel("ShopItem.xls", sSql, sColumns, context);
        sMsg = sMsg.Replace("\r\n", "");
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    public void fnSelectImage(HttpContext context)
    {
        string sRootDir = "\\ShopItem\\";
        string appPath = context.Request.PhysicalApplicationPath;
        string filePath = appPath + sRootDir + g_shopItem.product_id + "\\";
        DataTable data = new DataTable();
        data.Columns.Add("filename");
        foreach (string sFilename in System.IO.Directory.GetFiles(filePath))
        {
            var row = data.NewRow();
            var fileName = sFilename.Replace(filePath, "");
            if (fileName != "first.png")
            {
                row[0] = fileName;
                data.Rows.Add(row);
            }
        }
        context.Response.Write(PublicApi.fnGetJson(data));
    }

    public void fnDeleteImage(HttpContext context)
    {
        string sProductId = context.Request.QueryString["product_id"];
        string sFilename = context.Request.QueryString["filename"];
        string sRootDir = "\\ShopItem\\";
        string appPath = context.Request.PhysicalApplicationPath;
        string filePath = appPath + sRootDir + sProductId + "\\" + sFilename;
        string sMsg = "N";

        if (System.IO.File.Exists(filePath))
        {
            try
            {
                System.IO.File.Delete(filePath);
                sMsg = "Y";
            }
            catch
            {
            }
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    public void fnUploadFirstImage(HttpContext context)
    {
        string sMsg = "Y";
        var fileData = context.Request.Files["FileUpload"];
        var ProductId = context.Request.Form["product_id"];
        string sRootDir = "\\ShopItem\\";

        if (System.IO.Directory.Exists(context.Server.MapPath("~" + sRootDir + ProductId + "\\")) == false)
        {
            System.IO.Directory.CreateDirectory(context.Server.MapPath("~" + sRootDir + "/" + ProductId + "/"));
        }
        string appPath = context.Request.PhysicalApplicationPath;
        string filePath = appPath + sRootDir + ProductId + "\\";

        //string sPath = filePath + fileData.FileName;
        string sPath = filePath + "first.png";
        try
        {
            string sFile = fileData.FileName.Substring(fileData.FileName.Length - 3);
            if (sFile != "png" && sFile != "jpg" && sFile != "peg" && sFile != "bmp")
            {
                sMsg = fileData.FileName + "不是圖片檔案！<br>";
            }
            else
            {
                fileData.SaveAs(sPath);
            }
        }
        catch (Exception ex)
        {
            sMsg = ex.Message;
        }

        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    public void fnUploadImage(HttpContext context)
    {
        string sMsg = "Y";

        var fileData = context.Request.Files;
        var ProductId = context.Request.Form["product_id"];
        //fileData.SaveAs(context.Server.MapPath("/\\Import\\ShopItem.xls"));
        string sRootDir = "\\ShopItem\\";


        if (System.IO.Directory.Exists(context.Server.MapPath("~" + sRootDir + ProductId + "\\")) == false)
        {
            System.IO.Directory.CreateDirectory(context.Server.MapPath("~" + sRootDir + "/" + ProductId + "/"));
        }
        string appPath = context.Request.PhysicalApplicationPath;
        string filePath = appPath + sRootDir + ProductId + "\\";

        for (int index = 0; index < fileData.Count; index++)
        {
            string sPath = filePath + fileData[index].FileName;
            try
            {
                string sFile = fileData[index].FileName.Substring(fileData[index].FileName.Length - 3);
                if (sFile != "png" && sFile != "jpg" && sFile != "peg" && sFile != "bmp")
                {
                    sMsg = fileData[index].FileName + "不是圖片檔案！<br>";
                }
                else
                {
                    fileData[index].SaveAs(sPath);
                }
            }
            catch (Exception ex)
            {
                sMsg = ex.Message;
            }
        }

        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    #endregion

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}