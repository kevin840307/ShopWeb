using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ADMIN_Handler_Download : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["path"] != null)
        {
            string sFilePath = Request["path"].ToString();
            string sFileName = Request["name"].ToString() ;
            string sExcelPath = HttpContext.Current.Server.MapPath(sFilePath + sFileName);
            try
            {
                byte[] bData = System.IO.File.ReadAllBytes(sExcelPath);
                HttpContext.Current.Response.ClearHeaders();
                HttpContext.Current.Response.Clear();
                HttpContext.Current.Response.Expires = 0;
                HttpContext.Current.Response.Buffer = true;
                HttpContext.Current.Response.AddHeader("content-disposition", "attachment; filename=\"" + System.Web.HttpUtility.UrlEncode(sFileName, System.Text.Encoding.UTF8) + "\"");
                HttpContext.Current.Response.ContentType = "application/vnd.ms-excel";
                HttpContext.Current.Response.BinaryWrite(bData);
                HttpContext.Current.Response.Flush();
                HttpContext.Current.Response.End();
            }
            catch (Exception ex)
            {

            }
        }
    }
}