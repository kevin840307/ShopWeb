using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;

/// <summary>
/// Summary description for Functions
/// </summary>
public class PublicApi
{

    public static string fnGetConStr(string sLsConn)
    {
        return System.Web.Configuration.WebConfigurationManager.ConnectionStrings[sLsConn].ConnectionString;
    }

    // 將DataTable資料序列化
    public static string fnGetJson(System.Data.DataTable dtData)
    {
        System.Web.Script.Serialization.JavaScriptSerializer serObj = new System.Web.Script.Serialization.JavaScriptSerializer();
        List<Dictionary<string, object>> lsData = new List<Dictionary<string, object>>();
        Dictionary<string, object> dicMap;
        foreach (DataRow dr in dtData.Rows)
        {
            dicMap = new Dictionary<string, object>();
            foreach (DataColumn col in dtData.Columns)
            {
                dicMap.Add(col.ColumnName, dr[col]);
            }
            lsData.Add(dicMap);
        }
        return serObj.Serialize(lsData);
    }

    public static System.Data.DataTable fnGetDt(string sStr, string sLsConn)
    {
        System.Data.SqlClient.SqlConnection sqlConn = new System.Data.SqlClient.SqlConnection(fnGetConStr(sLsConn));
        System.Data.SqlClient.SqlDataAdapter sqldataAdapter = new System.Data.SqlClient.SqlDataAdapter(sStr, sqlConn);
        System.Data.DataTable dtData = new System.Data.DataTable();
        sqldataAdapter.Fill(dtData);
        return dtData;
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

    public static string fnAddCondition(string sColName, string sData)
    {
        if (sData != null && sData.Length > 0)
        {
            return " AND " + sColName + " LIKE '" + sData + "' ";
        }
        return "";
    }

    public static string fnRetrieveIP(HttpRequest request)
    {
        string sIp = request.ServerVariables["HTTP_X_FORWARDED_FOR"];
        if (sIp == null || sIp.Trim() == string.Empty)
        {
            sIp = request.ServerVariables["REMOTE_ADDR"];
        }
        return sIp;
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
            return "Y";
        }
        catch (SqlException ex)
        {
            return ex.Message.ToString();
        }
        finally
        {
            conn.Close();
        }
    }

    public static void fnReadLoginCookie(HttpContext context)
    {
        var reData = HttpContext.Current.Request.Cookies["login"];
        if (reData != null)
        {
            context.Session["id"] = reData["id"];
            context.Session["account_id"] = reData["account_id"];
            context.Session["password"] = reData["password"];
            context.Session["name"] = reData["name"];
        }
    }

    public static bool fnExportDataTableToExcel(DataTable dtData, int iStartPos, string sFileName, HttpContext context)
    {
        string sSaveFileName = sFileName + ".xls";
        System.IO.File.Delete(context.Server.MapPath("/\\ExcelFile\\") + sSaveFileName);
        System.IO.File.Copy(context.Server.MapPath("/\\ExcelFile\\MNDT.xls"), context.Server.MapPath("/\\ExcelFile\\" + sSaveFileName));
        Microsoft.Office.Interop.Excel.Application appApplication = new Microsoft.Office.Interop.Excel.ApplicationClass();
        Microsoft.Office.Interop.Excel.Workbook wbExcelPath = appApplication.Workbooks.Open(context.Server.MapPath("/\\ExcelFile\\" + sSaveFileName));
        Microsoft.Office.Interop.Excel.Worksheet wsPage = (Microsoft.Office.Interop.Excel.Worksheet)wbExcelPath.ActiveSheet;
        wsPage.Name = "Sheet1";
        wsPage.get_Range("A:Z", Type.Missing).NumberFormatLocal = "@";  //設定A-Z欄儲存格格式為文字

        for (int iPos = iStartPos; iPos < dtData.Columns.Count; iPos++)
        {
            string sPos = (char)(65 - iStartPos + iPos) + "1";
            wsPage.Range[sPos].Value = dtData.Columns[iPos].ToString();
            wsPage.Range[sPos].Interior.Color = System.Drawing.Color.Yellow;
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
        return true;
    }

    public static bool fnDownloadExcel(string sFileName, HttpContext context)
    {
        string sExcelPath = context.Server.MapPath("/\\ExcelFile\\" + sFileName);
        try
        {
            byte[] bData = System.IO.File.ReadAllBytes(sExcelPath);
            //System.IO.File.Delete(pagePage.Server.MapPath(sPath) + sFileName);

            context.Response.ClearHeaders();
            context.Response.Clear();
            context.Response.Expires = 0;
            context.Response.Buffer = true;
            context.Response.AddHeader("content-disposition", "attachment; filename=\"" + System.Web.HttpUtility.UrlEncode(sFileName, System.Text.Encoding.UTF8) + "\"");
            context.Response.ContentType = "application/vnd.ms-excel";
            context.Response.BinaryWrite(bData);
            context.Response.Flush();
            context.Response.End();
            return false;
        }
        catch (Exception ex)
        {
            return true;
        }
    }

    public static string fnImportExcel(string sFileName, string sSql, string[] sColumnName, HttpContext context)
    {
        string sPath = context.Server.MapPath("/\\Import\\" + sFileName);
        if (File.Exists(sPath) == false)
        {
            return "錯誤訊息：找無檔案。";
        }

        string strConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + sPath +
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
        }
        DataTable dtData = myDataSet.Tables["Excelinfo"].DefaultView.ToTable();
        return fnInsertSql(dtData, sSql, sColumnName);
    }

    public static string fnInsertSql(DataTable dtData, string sSql, string[] sColumnName)
    {
        int[] iColumnIndex = new int[sColumnName.Length];
        string sMsg = "Y";
        string sSaveSql = "";

        for (int iCIndex = 0; iCIndex < sColumnName.Length; iCIndex++)
        {
            bool bFind = true;
            for (int iIndex = 0; bFind && iIndex < dtData.Columns.Count; iIndex++)
            {
                if (sColumnName[iCIndex] == dtData.Rows[0][iIndex].ToString())
                {
                    iColumnIndex[iCIndex] = iIndex;
                    bFind = false;
                }
            }
        }

        for (int iPos = 1; iPos < dtData.Rows.Count; iPos++)
        {
            sSaveSql = sSql;
            if (dtData.Rows[iPos][0].ToString().Replace(" ", "").Length > 0)
            {
                for (int iCIndex = 0; iCIndex < sColumnName.Length; iCIndex++)
                {
                    sSaveSql = sSaveSql.Replace("{" + sColumnName[iCIndex] + "}", dtData.Rows[iPos][iColumnIndex[iCIndex]].ToString());
                }
                string sExecutMessage = fnExecuteSQL(sSaveSql, "MNDT");
                if (sExecutMessage != "Y")
                {
                    sMsg += "匯入錯誤：第" + iPos + "筆" + " 訊息：" + sExecutMessage + "<br><br>";
                }
            }
            else
            {
                return sMsg;
            }
        }
        return sMsg;
    }

    public static string fnNullChange(object objData)
    {
        return fnNullChange(objData, "");
    }

    public static string fnNullChange(object objData, string sData)
    {
        return (objData == null || objData.ToString() == "") ? sData : objData.ToString();
    }

    public static string fnGetOrderNum(HttpContext context, string sType)
    {
        KindRepository kindRepository = new KindRepository();
        KindD kindD = new KindD();
        kindD.KindId("O01")
            .CodeId("DATE")
            .CreateId(context.Session["id"].ToString());
        string sNowDate = DateTime.Now.ToString("yyyyMMdd");
        string sCodeDate = kindRepository.fnSelect(kindD);

        if (sNowDate != sCodeDate)
        {
            fnSetZeroOrder();
        }

        kindD.CodeId(sType);
        string sNowNum = kindRepository.fnSelect(kindD);
        string sSql =
                     "  UPDATE [MNDTkind_details]  " +
                     "     SET [parameter] = '" + (int.Parse(sNowNum) + 1).ToString() + "'  " +
                     " WHERE [kind_id] = 'O01' " +
                     "   AND [code_id] = '" + sType + "' ";
        PublicApi.fnExecuteSQL(sSql, "MNDT");
        return sNowDate + fnFixOrder(sNowNum);
    }

    public static void fnSetZeroOrder()
    {
        string sSql =
                      "  UPDATE [MNDTkind_details]  " +
                      "     SET [parameter] = '0'  " +
                      " WHERE [kind_id] = 'O01' " +
                      "   AND [code_id] IN ('A01', 'A02', 'B01', 'B02') ";
        sSql +=
                "  UPDATE [MNDTkind_details]  " +
                "     SET [parameter] = '" + DateTime.Now.ToString("yyyyMMdd") + "'  " +
                " WHERE [kind_id] = 'O01' " +
                "   AND [code_id] = 'DATE' ";

        PublicApi.fnExecuteSQL(sSql, "MNDT");
    }

    private static string fnFixOrder(string sNum)
    {
        for(int iIndex = sNum.Length; iIndex < 3; iIndex++)
        {
            sNum = "0" + sNum;
        }
        return sNum;
    }

}