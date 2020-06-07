using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class index : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        fnInit();
    }

    protected void fnInit()
    {
        try
        {
            string sRootDir = "\\ALL\\";
            string sAppPath = Request.PhysicalApplicationPath;
            string filePath = sAppPath + sRootDir;
            lt_image_html.Text = "";
            foreach (string sFilename in System.IO.Directory.GetFiles(filePath))
            {
                fnAddImage(sRootDir, sFilename.Replace(filePath, ""));
            }
        }
        catch
        { }
    }

    private void fnAddImage(string sPath, string sFileName)
    {
        //ltHtml.Text += " <div class='table-size5'> ";
        lt_image_html.Text += " <img src='" + sPath + sFileName + "'> ";
        //ltHtml.Text += " </div>";
    }
}