<%@ WebHandler Language="C#" Class="CarouselHandler" %>

using System;
using System.Web;
using System.Data;

public class CarouselHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    private CarouselRepository g_carouselRepository = new CarouselRepository();
    private Carousel g_carousel = new Carousel();

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
        string sCarouselId = context.Request.QueryString["carousel_id"];
        string sName = context.Request.QueryString["name"];
        string sRemarks = context.Request.QueryString["remarks"];
        string sStatus = context.Request.QueryString["status"];
        string sOrder = context.Request.QueryString["order"];

        g_carousel.CarouselId(sCarouselId)
                .Name(sName)
                .Remarks(sRemarks)
                .Status(sStatus)
                .CreateId(PublicApi.fnNullChange(context.Session["id"], ""))
                .Order(sOrder);
    }

    #region Carousel

    public void fnSelects(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sOrder = context.Request.QueryString["order"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];

        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);

            DataTable dtData = g_carouselRepository.fnSelects(g_carousel, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCount(HttpContext context)
    {
        string sSize = g_carouselRepository.fnCount(g_carousel);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnSelect(HttpContext context)
    {
        DataTable dtData = g_carouselRepository.fnSelect(g_carousel);

        if (dtData.Rows.Count == 1)
        {
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }


    public void fnSelectId(HttpContext context)
    {
        string sMsg = "Y";
        string sNUM = context.Request.QueryString["NUM"];
        string scarouselId = g_carouselRepository.fnSelectId(g_carousel, sNUM);

        if (scarouselId == " ")
        {
            sMsg = "訊息：已無下筆資料。";
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"carousel_id\":\"" + scarouselId + "\", \"NUM\":\"" + sNUM + "\"}");
    }


    //public void fnInsert(HttpContext context)
    //{
    //    string sMsg = fnCheckData(g_carousel);

    //    if (sMsg == "Y")
    //    {
    //        sMsg = g_carouselRepository.fnInsert(g_carousel);
    //        sMsg = sMsg.Replace("\r\n", "");
    //    }
    //    context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"carousel_id\":\"" + g_carousel.carousel_id + "\"}");
    //}

    public void fnUpdate(HttpContext context)
    {
        string sMsg = fnCheckData(g_carousel);

        if (sMsg == "Y")
        {
            string sIP = PublicApi.fnRetrieveIP(context.Request);
            sMsg = g_carouselRepository.fnUpdate(g_carousel, sIP, g_carousel.create_id);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    //public void fnDelete(HttpContext context)
    //{
    //    string sMsg = "Y";
    //    string sIP = PublicApi.fnRetrieveIP(context.Request);

    //    sMsg = g_carouselRepository.fnDelete(g_carousel, sIP, g_carousel.create_id);
    //    sMsg = sMsg.Replace("\r\n", "");
    //    context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    //}

    //public void fnDeletes(HttpContext context)
    //{
    //    string sMsg = "Y";
    //    string sIP = PublicApi.fnRetrieveIP(context.Request);

    //    sMsg = g_carouselRepository.fnDeletes(g_carousel, sIP, g_carousel.create_id);
    //    sMsg = sMsg.Replace("\r\n", "");
    //    context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    //}

    //public void fnExport(HttpContext context)
    //{
    //    string sMsg = "Y";
    //    DataTable dtData = g_carouselRepository.fnExport(g_carousel);
    //    bool bCheck = PublicApi.fnExportDataTableToExcel(dtData, 0, "Carousel", context);

    //    if (!bCheck)
    //    {
    //        sMsg = "錯誤訊息：匯出失敗。";
    //    }
    //    sMsg = sMsg.Replace("\r\n", "");
    //    context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    //}

    //public void fnReport(HttpContext context)
    //{
    //    string sMsg = "Y";
    //    DataTable dtData = g_carouselRepository.fnSelects(g_carousel);

    //    if (dtData.Rows.Count > 0)
    //    {
    //        context.Session["PrintDT"] = dtData;
    //    }
    //    else
    //    {
    //        sMsg = "錯誤訊息：筆數少於一筆。";
    //    }
    //    context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    //}

    //public void fnPrint(HttpContext context)
    //{
    //    DataTable dtData = g_carouselRepository.fnSelects(g_carousel);
    //    context.Response.Write(PublicApi.fnGetJson(dtData));
    //}

    public void fnSelectList(HttpContext context)
    {
        if (context.Session["id"] != null)
        {
            CarouselRepository carouselRepository = new CarouselRepository();
            DataTable dtData = carouselRepository.fnSelectList();
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    private string fnCheckData(Carousel carousel)
    {
        string sMsg = "Y";
        if (carousel.carousel_id.Length > 15)
        {
            sMsg = "錯誤訊息：長度錯誤。";
        }
        return sMsg;
    }

    //public void fnImport(HttpContext context)
    //{
    //    string sMsg = "Y";
    //    var fileData = context.Request.Files["FileUpload"];

    //    fileData.SaveAs(context.Server.MapPath("/\\Import\\Carousel.xls"));

    //    string[] sColumns = { "帳號", "密碼", "名子", "地址", "手機" };
    //    string sSql = "  INSERT INTO [MNDTcarousel]  " +
    //           "             ([account]  " +
    //           "             ,[password]  " +
    //           "             ,[name]  " +
    //           "             ,[address]  " +
    //           "             ,[phone]  " +
    //           "             ,[create_id]  " +
    //           "             ,[create_datetime])  " +
    //           "       VALUES  " +
    //           "             ('{" + sColumns[0] + "}'  " +
    //           "             ,'{" + sColumns[1] + "}'  " +
    //           "             ,'{" + sColumns[2] + "}'  " +
    //           "             ,'{" + sColumns[3] + "}'  " +
    //           "             ,'{" + sColumns[4] + "}'  " +
    //           "             ,'" + context.Session["id"] + "'  " +
    //           "             ,GETDATE())  ";

    //    sMsg = PublicApi.fnImportExcel("Carousel.xls", sSql, sColumns, context);
    //    sMsg = sMsg.Replace("\r\n", "");
    //    context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    //}

    public void fnSelectImage(HttpContext context)
    {
        string sRootDir = "\\Rotation\\";
        string appPath = context.Request.PhysicalApplicationPath;
        string filePath = appPath + sRootDir + g_carousel.carousel_id + "\\";
        DataTable data = new DataTable();
        data.Columns.Add("filename");
        foreach (string sFilename in System.IO.Directory.GetFiles(filePath))
        {
            var row = data.NewRow();
            var fileName = sFilename.Replace(filePath, "");

            row[0] = fileName;
            data.Rows.Add(row);
        }
        context.Response.Write(PublicApi.fnGetJson(data));
    }

    public void fnDeleteImage(HttpContext context)
    {
        string scarouselId = context.Request.QueryString["carousel_id"];
        string sFilename = context.Request.QueryString["filename"];
        string sRootDir = "\\Rotation\\";
        string appPath = context.Request.PhysicalApplicationPath;
        string filePath = appPath + sRootDir + scarouselId + "\\" + sFilename;
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

    public void fnUploadImage(HttpContext context)
    {
        string sMsg = "Y";

        var fileData = context.Request.Files;
        var carouselId = context.Request.Form["carousel_id"];
        //fileData.SaveAs(context.Server.MapPath("/\\Import\\Carousel.xls"));
        string sRootDir = "\\Rotation\\";


        if (System.IO.Directory.Exists(context.Server.MapPath("~" + sRootDir + carouselId + "\\")) == false)
        {
            System.IO.Directory.CreateDirectory(context.Server.MapPath("~" + sRootDir + "/" + carouselId + "/"));
        }
        string appPath = context.Request.PhysicalApplicationPath;
        string filePath = appPath + sRootDir + carouselId + "\\";

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