using Microsoft.VisualBasic;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Web.UI;
using System.Web;

partial class ReportPage : System.Web.UI.Page
{

    //拋轉資料
    public void ExportExcel(Control DataGrid)
    {
        Response.Clear();
        Response.Buffer = true;
        Response.AddHeader("content-disposition", "attachment; filename=" + DateTime.Now.ToString("yyyyMMdd") + ".xls");
        Response.ContentType = "application/vnd.ms-excel";
        Response.Charset = "";
        EnableViewState = false;
        dynamic tw = new System.IO.StringWriter();
        dynamic hw = new HtmlTextWriter(tw);
        DataGrid.RenderControl(hw);
        Response.Write(tw);
        Response.End();
    }

    protected void Page_Init(object sender, System.EventArgs e)
    {
        try
        {
            string sPath = HttpContext.Current.Request.MapPath("~/Report\\");

            //表示一个报表，并且包含定义、格式化、加载、导出和打印该报表的属性和方法。
           
            CrystalDecisions.CrystalReports.Engine.ReportDocument Report = new CrystalDecisions.CrystalReports.Engine.ReportDocument();
            CrystalDecisions.Shared.ParameterDiscreteValue discreteVal = new CrystalDecisions.Shared.ParameterDiscreteValue();
            CrystalDecisions.Shared.ParameterValues paraValues = new CrystalDecisions.Shared.ParameterValues();

            //加载你事先做好的Crystal Report报表文件
            Report.Load(sPath + Request.QueryString["ReportName"], CrystalDecisions.Shared.OpenReportMethod.OpenReportByTempCopy);
            string sData = Functions.fnGetConStr("MNDT").Replace(";", ",");
            // 設定報表內SQL Server資料庫的登入資訊
            CrystalDecisions.Shared.TableLogOnInfo logonInfo = new CrystalDecisions.Shared.TableLogOnInfo();

            foreach (CrystalDecisions.CrystalReports.Engine.Table table in Report.Database.Tables)
            {
                logonInfo = table.LogOnInfo;
                var _with1 = logonInfo.ConnectionInfo;
                _with1.ServerName = fnGetData(sData, "Data Source");
                _with1.DatabaseName = fnGetData(sData, "Initial Catalog");
                _with1.UserID = fnGetData(sData, "User ID");
                _with1.Password = fnGetData(sData, "Password");
                table.ApplyLogOnInfo(logonInfo);
            }


            Report.SetDataSource(Session["PrintDT"]);
            if (Report.ParameterFields["列印人員"] != null)
            {
                Report.SetParameterValue("列印人員", Session["sId"]);
            }
            CrystalReportViewer1.PrintMode = CrystalDecisions.Web.PrintMode.ActiveX; //列印顯示列印選項，但只有IE會出現這功能
            //Report.PrintToPrinter(1, true, 0, 0); // 直接列印
            CrystalReportViewer1.ReportSource = Report;

            //CrystalReportViewer1.HasExportButton = false; //將匯出的功能False掉
            //CrystalReportViewer1.HasPrintButton = false;
            //CrystalReportViewer1.HasToggleGroupTreeButton = false; //將樹狀結構的按鈕False掉
            //CrystalReportViewer1.DisplayGroupTree = false; //將樹狀結構狀態False掉

        }
        catch (Exception e1)
        {
            Functions.fnMessageBox(e1.ToString(), this);
        }
    }


    private string fnGetData(string sData, string sKey)
    {
        int iPosS = sData.IndexOf(sKey) + sKey.Length;
        string sSplit = sData.Substring(iPosS, sData.Length - iPosS);
        int iPosE = sSplit.IndexOf(",");
        return sSplit.Substring(0, iPosE).Replace("=", "");
    }

    protected void ReportPage_Unload(object sender, EventArgs e)
    {
        CrystalReportViewer1.Dispose();
    }

    protected void CrystalReportViewer1_Unload(object sender, EventArgs e)
    {
        CrystalReportViewer1.Dispose();
    }
    public ReportPage()
    {
        Unload += ReportPage_Unload;
        Init += Page_Init;
    }
}
