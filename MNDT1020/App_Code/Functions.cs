using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

/// <summary>
/// Summary description for Functions
/// </summary>
public class Functions
{
    public static string fnGetConStr(string sLsConn)
    {
        return System.Web.Configuration.WebConfigurationManager.ConnectionStrings[sLsConn].ConnectionString;
    }
    public static System.Data.DataTable fnGetDt(string sStr, string sLsConn)
    {
        System.Data.SqlClient.SqlConnection sqlConn = new System.Data.SqlClient.SqlConnection(fnGetConStr(sLsConn));
        System.Data.SqlClient.SqlDataAdapter sqldataAdapter = new System.Data.SqlClient.SqlDataAdapter(sStr, sqlConn);
        System.Data.DataTable dtData = new System.Data.DataTable();
        sqldataAdapter.Fill(dtData);
        return dtData;
    }

    public static System.Data.DataTable fnGetProgrameAuthority(string sId)
    {
        string sSql = " SELECT DISTINCT [program_d].[program_id] " +
                        " FROM [MNDTprogram_details] [program_d], [MNDTgroup_details] [group_d] " +
                        " WHERE [program_d].[group_id] = [group_d].[group_id] " +
                        "   AND [group_d].[account_id] = '" + sId + "' " +
                        "   AND [program_d].[au_run] = 'true' ";
        return Functions.fnGetDt(sSql, "MNDT");
    }

    public static System.Data.DataTable fnLoginDT(ref string sId, ref string sPassword)
    {
        string sSql = " SELECT [account_name] " +
                        " FROM [MNDTaccount] " +
                        " WHERE [account_id] = '" + sId + "' " +
                        "   AND [account_password] = '" + sPassword + "' ";
        System.Data.DataTable dtData = Functions.fnGetDt(sSql, "MNDT");
        return Functions.fnGetDt(sSql, "MNDT"); ;
    }

    public static string fnExecuteSQL(string sSql, string sConn)
    {
        System.Data.SqlClient.SqlConnection conn = null;
        conn = new System.Data.SqlClient.SqlConnection(fnGetConStr(sConn));
        System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand();

        cmd.Connection = conn;
        try
        {
            conn.Open();
            cmd.CommandText = sSql;
            cmd.ExecuteNonQuery();
            return "";
        }
        catch (Exception ex)
        {
            return ex.Message.ToString();
        }
        finally
        {
            conn.Close();
        }
    }

    public static string fnGetValue(string sSql, string sConn)
    {
        string sValue = null;
        System.Data.SqlClient.SqlConnection sqlConn = new System.Data.SqlClient.SqlConnection(fnGetConStr(sConn));
        sqlConn.Open();
        System.Data.SqlClient.SqlCommand sqlComm = null;
        sqlComm = new System.Data.SqlClient.SqlCommand(sSql, sqlConn);
        sValue = (sqlComm.ExecuteScalar() == null) ? " " : sqlComm.ExecuteScalar().ToString();
        sqlConn.Close();
        return sValue;
    }

    public static List<string> fnGetLs(string sqlstr, int acoumt, string ls_conn)
    {
        List<string> lsData = new List<string>();
        try
        {
            System.Data.SqlClient.SqlConnection conn = null;
            conn = new System.Data.SqlClient.SqlConnection(System.Web.Configuration.WebConfigurationManager.ConnectionStrings[ls_conn].ConnectionString.ToString());
            System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(sqlstr, conn);
            conn.Open();
            System.Data.SqlClient.SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                for (int pos = 0; pos < acoumt; pos++)
                {
                    lsData.Add(reader[pos].ToString());
                }
            }
            reader.Close();
            cmd.Dispose();
        }
        catch
        {
        }
        return lsData;
    }

    public static void fnMessageBox(string sMessage, System.Web.UI.Page pagePage)
    {
        string sScript = null;
        sScript = string.Format("alert('{0}');", sMessage);
        ScriptManager.RegisterStartupScript(pagePage, pagePage.GetType(), "", sScript, true);
        //pagePage.ClientScript.RegisterStartupScript(pagePage.GetType(), "alert", sScript);
    }

    public static void fnAddConditionDate(ref System.Web.UI.WebControls.TextBox textBox, ref string sSql, string sCondition)
    {
        if (textBox.Text.Length > 0)
        {
            sSql += " AND CONVERT(char, " + sCondition + ", 111) LIKE '" + textBox.Text + "' ";
        }
    }

    public static void fnAddCondition(ref System.Web.UI.WebControls.TextBox textBox, ref string sSql, string sCondition)
    {
        if (textBox.Text.Length > 0)
        {
            sSql += " AND " + sCondition + " LIKE '" + textBox.Text + "' ";
        }
    }

    public static void fnAddCondition(ref System.Web.UI.WebControls.DropDownList dropDownList, ref string sSql, string sCondition)
    {
        if (dropDownList.SelectedValue.Length > 0)
        {
            sSql += " AND " + sCondition + " LIKE '" + dropDownList.SelectedValue + "' ";
        }
    }

    public static void fnAddCondition(ref string sSql, ref string sChidSql, string sCondition)
    {
        if (sChidSql.Length > 0)
        {
            sSql += " AND " + sCondition + " IN (" + sChidSql + ") ";
        }
    }
    public static void fnSetDropDownList(string sSql, DropDownList dropData)
    {
        DataTable dtData = fnGetDt(sSql, "MNDT");

        if (dtData.Rows.Count > 0)
        {
            dropData.Items.Clear();
            dropData.Items.Add(new ListItem("", ""));
            for (int iPos = 0; iPos <= dtData.Rows.Count - 1; iPos++)
            {
                string sShow = dtData.Rows[iPos][0].ToString();
                string sValue = dtData.Rows[iPos][1].ToString();
                dropData.Items.Add(new ListItem(sValue, sShow));
            }
        }
    }

    public static bool fnExportDataTableToExcel(GridView dtHeader, DataTable dtData, int iStartPos, string sFileName, System.Web.UI.Page pagePage)
    {
        string sSaveFileName = sFileName + ".xls";
        System.IO.File.Delete(pagePage.Server.MapPath("ExcelFile\\") + sSaveFileName);
        System.IO.File.Copy(pagePage.Server.MapPath("ExcelFile\\MNDT.xls"), pagePage.Server.MapPath("ExcelFile\\" + sSaveFileName));
        Microsoft.Office.Interop.Excel.Application appApplication = new Microsoft.Office.Interop.Excel.ApplicationClass();
        Microsoft.Office.Interop.Excel.Workbook wbExcelPath = appApplication.Workbooks.Open(pagePage.Server.MapPath("ExcelFile\\" + sSaveFileName));
        Microsoft.Office.Interop.Excel.Worksheet wsPage = (Microsoft.Office.Interop.Excel.Worksheet)wbExcelPath.ActiveSheet;
        wsPage.Name = "Sheet1";
        wsPage.get_Range("A:Z", Type.Missing).NumberFormatLocal = "@";  //設定A-Z欄儲存格格式為文字

        for (int iPos = iStartPos; iPos < dtHeader.Columns.Count; iPos++)
        {
            string sPos = (char)(65 - iStartPos + iPos) + "1";
            wsPage.Range[sPos].Value = dtHeader.Columns[iPos].ToString();
            wsPage.Range[sPos].Interior.Color = Color.Yellow;
        }


        for (int iPosX = 0; iPosX < dtData.Rows.Count; iPosX++)
        {
            for (int iPosY = 0; iPosY < dtData.Columns.Count; iPosY++)
            {
                string sPos = (char)(65 - iStartPos + iPosY + iStartPos) + (iPosX + 2).ToString();
                wsPage.Range[sPos].Value = dtData.Rows[iPosX][iPosY].ToString();
            }
        }

        //appApplication.Visible = True;
        appApplication.Workbooks[1].Save();

        wbExcelPath.Close(false, Type.Missing, Type.Missing);
        appApplication.Workbooks.Close();
        appApplication.Quit();
        System.Runtime.InteropServices.Marshal.ReleaseComObject(wsPage);
        System.Runtime.InteropServices.Marshal.ReleaseComObject(wbExcelPath);
        System.Runtime.InteropServices.Marshal.ReleaseComObject(appApplication);
        wsPage = null;
        wbExcelPath = null;
        appApplication = null;
        GC.Collect();

        bool bCkeck = true;
        while (bCkeck)
        {
            bCkeck = fnDownloadExcel("ExcelFile\\", sSaveFileName, pagePage);
        }
        return true;
    }

    public static bool fnDownloadExcel(string sPath, string sFileName, System.Web.UI.Page pagePage)
    {
        string sExcelPath = pagePage.Server.MapPath(sPath + sFileName);
        try
        {
            byte[] bData = System.IO.File.ReadAllBytes(sExcelPath);
            //System.IO.File.Delete(pagePage.Server.MapPath(sPath) + sFileName);
            pagePage.Response.ClearHeaders();
            pagePage.Response.Clear();
            pagePage.Response.Expires = 0;
            pagePage.Response.Buffer = true;
            pagePage.Response.AddHeader("content-disposition", "attachment; filename=\"" + System.Web.HttpUtility.UrlEncode(sFileName, System.Text.Encoding.UTF8) + "\"");
            pagePage.Response.ContentType = "application/vnd.ms-excel";
            pagePage.Response.BinaryWrite(bData);
            pagePage.Response.End();
            return false;
        }
        catch (Exception ex)
        {
            return true;
        }
    }

    /// 非同步, 網頁不太好使, 太常PostBack
    public async static Task<string> fnUploadExcelAsync(FileUpload fuFileUpload, string sSql, int iAmount, System.Web.UI.Page pagePage)
    {
        if (fuFileUpload.FileName.Length < 1)
        {
            //fnMessageBox("請按瀏覽選擇要上傳的檔案", pagePage);
            return "請按瀏覽選擇要上傳的檔案";
        }
        else if (fuFileUpload.FileName.Substring(fuFileUpload.FileName.Length - 3) != "xls")
        {
            //fnMessageBox("不是*.xls的Excel檔案！", pagePage);
            return "不是*.xls的Excel檔案！";
        }
        else
        {
            if (Directory.Exists(pagePage.Server.MapPath("~/Imports/")) == false)
            {
                Directory.CreateDirectory(pagePage.Server.MapPath("~/Imports/"));
            }

            string appPath = pagePage.Request.PhysicalApplicationPath;
            string filePath = appPath + "\\Imports\\";
            fuFileUpload.SaveAs(filePath + fuFileUpload.FileName);
            string strConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + filePath + fuFileUpload.FileName +
                                        ";Extended Properties='Excel 8.0;HDR=No;IMEX=1'";
            System.Data.OleDb.OleDbDataAdapter myCommeand = new System.Data.OleDb.OleDbDataAdapter("SELECT * FROM [Sheet1$]", strConn);
            DataSet myDataSet = new DataSet();
            try
            {
                myCommeand.Fill(myDataSet, "Excelinfo");
            }
            catch (Exception ex)
            {
                return "活頁步名稱請改Sheet1";
                //myCommeand = new System.Data.OleDb.OleDbDataAdapter("SELECT * FROM [" + fuFileUpload.FileName.Substring(0, fuFileUpload.FileName.Length - 4) + "$]", strConn);
                //myCommeand.Fill(myDataSet, "Excelinfo");
            }
            DataTable dtData = myDataSet.Tables["Excelinfo"].DefaultView.ToTable();
            var vTask = await Task.Run(() => fnInsertSql(dtData, sSql, iAmount));
            return vTask;
        }
    }

    public static void fnShowLabelMessage(Page pagePage, string sMessage)
    {
        if (sMessage.Length > 20)
        {
            ((Label)pagePage.Master.FindControl("lab_m_error")).Text = sMessage;
            ScriptManager.RegisterStartupScript(pagePage, pagePage.GetType(), "ShowError", "ShowError2();", true);
        }
        else
        {
            ((Label)pagePage.Master.FindControl("lab_message")).Text = sMessage;
            ScriptManager.RegisterStartupScript(pagePage, pagePage.GetType(), "ShowMessage", "ShowMessage2();", true);
        }
    }

    public static void fnShowMessage(Page pagePage, string sMessage, string sSuccessMsg)
    {
        if (sMessage.Length > 20)
        {
            sMessage = sMessage.Replace("\n", "<br>").Replace("\r", "");
            ScriptManager.RegisterStartupScript(pagePage, pagePage.GetType(), "ShowError", "ShowError(\"" + sMessage + "\");", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(pagePage, pagePage.GetType(), "ShowMessage", "ShowMessage('" + sSuccessMsg + "');", true);
        }
    }

    public static void fnShowMessage(Page pagePage, string sMessage)
    {
        if (sMessage.Length > 20)
        {
            sMessage = sMessage.Replace("\n", "<br>").Replace("\r", "");
            ScriptManager.RegisterStartupScript(pagePage, pagePage.GetType(), "ShowError", "ShowError(\"" + sMessage + "\");", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(pagePage, pagePage.GetType(), "ShowMessage", "ShowMessage('" + sMessage + "');", true);
        }
    }

    public static string fnInsertSql(DataTable dtData, string sSql, int iAmount)
    {
        string sMessage = "匯入成功<br>";
        string sSaveSql = "";
        int iDTSize = dtData.Rows.Count;
        for (int iPos = 1; iPos < iDTSize; iPos++)
        {
            sSaveSql = sSql;
            if (dtData.Rows[iPos][0].ToString().Replace(" ", "").Length > 0)
            {
                for (int iCodePos = 1; iCodePos <= 5; iCodePos++)
                {
                    sSaveSql = sSaveSql.Replace("{code" + iCodePos + "}", dtData.Rows[iPos][iCodePos - 1].ToString());
                }
                string sExecutMessage = fnExecuteSQL(sSaveSql, "MNDT");
                if (sExecutMessage.Length > 0)
                {
                    sMessage += "匯入錯誤：第" + iPos + "筆" + " 訊息：" + sExecutMessage + "<br><br>";
                }
            }
            else
            {
                return sMessage;
            }
        }
        return sMessage;
    }

    public static void fnSQLActionMessage(Page pagePage, SqlDataSourceStatusEventArgs e, string sSuccessMsg)
    {
        if (e.Exception != null)
        {
            string sMessage = e.Exception.Message.ToString().Replace("\n", "<br>").Replace("\r", "");
            ScriptManager.RegisterStartupScript(pagePage, pagePage.GetType(), "ShowError", "ShowError(\"" + sMessage + "\");", true);
            e.ExceptionHandled = true;
        }
        else
        {
            ScriptManager.RegisterStartupScript(pagePage, pagePage.GetType(), "ShowMessage", "ShowMessage('" + sSuccessMsg + "');", true);
        }
    }
}