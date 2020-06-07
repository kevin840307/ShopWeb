using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data.OleDb;
using System.Web.UI.WebControls;
using System.Threading;
using System.Threading.Tasks;

public partial class MNDT6010 : System.Web.UI.Page
{
    private void fnSearchData()
    {
        string sSql = "  SELECT  [rotation_id]  " +
                        "        ,[rotation_remarks] " +
                        "        ,[create_user_id]  " +
                        "        ,CONVERT(char, [create_datetime], 111) AS 'create_datetime'  " +
                        "        ,[modify_user_id]  " +
                        "        ,CONVERT(char, [modify_datetime], 111) AS 'modify_datetime'  " +
                        "    FROM [MNDTrotation]  " +
                        "    WHERE 1 = 1 ";
        Functions.fnAddCondition(ref text_rotation_id, ref sSql, "rotation_id");

        sds_main.SelectCommand = sSql;
        sds_main.DataBind();
        grid_data_m.DataBind();
        ViewState["sSqlSearch"] = sSql;
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        fnInit();
        if (!IsPostBack)
        {

        }
        else
        {
            if (multi_view.ActiveViewIndex == 0 && ViewState["sSqlSearch"] != null && ViewState["sSqlSearch"].ToString() != "")
            {
                sds_main.SelectCommand = ViewState["sSqlSearch"].ToString();
                sds_main.DataBind();
            }
        }
    }
    private void fnInit()
    {
        //btn_file.Attributes.Add("onclick", "document.getElementById('" + fuFileUpload.ClientID + "').click(); return false;");
        Control conTitleBtn = Master.FindControl("title_button");
        ((Button)conTitleBtn.FindControl("btn_print")).Click += btn_print_Click;
        ((Button)conTitleBtn.FindControl("btn_export")).Click += btn_export_Click;
        ((Button)conTitleBtn.FindControl("btn_import")).Click += btn_import_Click;
        ((Label)Master.FindControl("lab_title")).Text = "輪播資料維護<MNDT6010>";
        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "set_scroll", "set_scroll();", true);
    }
    protected void btn_search_Click(object sender, EventArgs e)
    {
        fnSearchData();
    }
    protected void grid_data_m_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string sCommand = e.CommandName;
        switch (sCommand)
        {
            case "OpenInsert":
                fnOpenInsert();
                break;
            case "SelectData":
                int iIndex = int.Parse(e.CommandArgument.ToString());
                string sRotationId = ((Label)grid_data_m.Rows[fnGetGridViewSelect(iIndex)].FindControl("lab_rotation_id")).Text.ToString();
                fnOpenEdit(sRotationId);
                ViewState["SelectMaster"] = iIndex;
                break;
        }
    }
    private int fnGetGridViewSelect(int iIndex)
    {
        try
        {
            int iNowPage = int.Parse(((DropDownList)grid_data_m.TopPagerRow.FindControl("drop_page_index")).SelectedValue);
            int iNowSize = int.Parse(((DropDownList)grid_data_m.TopPagerRow.FindControl("drop_page_size")).SelectedValue);
            return (iIndex - (iNowSize * iNowPage));
        }
        catch
        {
            return iIndex;
        }
    }

    private void fnOpenInsert()
    {
        multi_view.ActiveViewIndex = 1;
        fv_master_form.ChangeMode(FormViewMode.Insert);
    }

    private void fnOpenEdit(string srotationId)
    {
        multi_view.ActiveViewIndex = 1;
        fnSetSelectMasterView(srotationId);
        fv_master_form.ChangeMode(FormViewMode.Edit);
    }

    private void fnSetSelectMasterView(string sRotationId)
    {
        string sMasterSql = "  SELECT  [rotation_id]  " +
                       "        ,[rotation_remarks] " +
                       "        ,[create_user_id]  " +
                       "        ,CONVERT(char, [create_datetime], 111) AS 'create_datetime'  " +
                       "        ,[modify_user_id]  " +
                       "        ,CONVERT(char, [modify_datetime], 111) AS 'modify_datetime'  " +
                       "    FROM [MNDTrotation]  " +
                       "    WHERE [rotation_id] = '" + sRotationId + "' ";
        sds_main.SelectCommand = sMasterSql;
        ViewState["sSqlMaster"] = sMasterSql;
        sds_main.DataBind();
    }

    protected void drop_page_index_DataBinding(object sender, EventArgs e)
    {
        GridView gridData = fnGetNowGridView();
        DropDownList dropData = ((DropDownList)sender);
        GridViewEvent.fnDropPageIndexDataBinding(ref gridData, ref dropData);
    }
    protected void drop_page_index_SelectedIndexChanged(object sender, EventArgs e)
    {
        GridView gridData = fnGetNowGridView();
        DropDownList dropData = ((DropDownList)sender);
        GridViewEvent.fnDropPageIndexSelectedIndexChanged(ref gridData, ref dropData);
    }
    protected void linkbtn_first_Click(object sender, EventArgs e)
    {
        GridView gridData = fnGetNowGridView();
        GridViewEvent.fnFirstPageEvent(ref gridData);
    }
    protected void linkbtn_last_Click(object sender, EventArgs e)
    {
        GridView gridData = fnGetNowGridView();
        GridViewEvent.fnLastPageEvent(ref gridData);
    }
    protected void linkbtn_next_Click(object sender, EventArgs e)
    {
        GridView gridData = fnGetNowGridView();
        GridViewEvent.fnNextPageEvent(ref gridData);
    }
    protected void linkbtn_previous_Click(object sender, EventArgs e)
    {
        GridView gridData = fnGetNowGridView();
        GridViewEvent.fnPreviousPageEvent(ref gridData);
    }
    protected void drop_page_size_SelectedIndexChanged(object sender, EventArgs e)
    {
        GridView gridData = fnGetNowGridView();
        DropDownList dropData = ((DropDownList)sender);
        GridViewEvent.fnDropPageSizeSelectedIndexChanged(ref gridData, ref dropData);
    }
    protected void drop_page_size_DataBinding(object sender, EventArgs e)
    {
        GridView gridData = fnGetNowGridView();
        DropDownList dropData = ((DropDownList)sender);
        GridViewEvent.fnDropPageSizeDataBinding(ref gridData, ref dropData);
    }
    private GridView fnGetNowGridView()
    {
        switch (multi_view.ActiveViewIndex)
        {
            case 0:
                return grid_data_m;
            default:
                return grid_data_m;
        }
    }
    protected void grid_data_m_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        GridView gridData = ((GridView)sender);
        GridViewEvent.fnGridViewRowDataBound(this, ref gridData, e.Row, 40, "#89BBFE", "#FFFFFF");

        //if (e.Row.RowType == DataControlRowType.DataRow && fnGetEditState(e.Row))
        //{
        //    e.Row.Attributes["onclick"] = "auto_move();";
        //}
    }

    protected void grid_data_m_SelectedIndexChanged(object sender, EventArgs e)
    {
        GridView gridData = ((GridView)sender);
        GridViewEvent.fnGridViewSelectedIndexChanged(ref gridData, "#89BBFE");
    }

    protected void grid_data_m_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        GridView gridData = ((GridView)sender);
        GridViewEvent.fnGridViewSelectedIndexChanging(this, ref gridData, "#FFFFFF", "#000000");

        //if (grid_data_m.SelectedIndex >= 0 && grid_data_m.SelectedIndex < grid_data_m.Rows.Count && fnGetEditState(grid_data_m.Rows[grid_data_m.SelectedIndex]))
        //{
        //    grid_data_m.Rows[grid_data_m.SelectedIndex].Attributes["onclick"] = "auto_move();";
        //}
    }

    private bool fnGetEditState(GridViewRow drData)
    {
        if (((ImageButton)drData.FindControl("ibtn_edit")) == null)
        {
            return true;
        }
        return false;
    }

    protected override void Render(HtmlTextWriter writer)
    {
        //GridView gridData = ((GridView)grid_data_m);
        //fnSetSelect(ref gridData);
        base.Render(writer);
    }


    private void fnSetSelect(ref GridView gridData)
    {
        try
        {
            for (int i = 0; i < gridData.Rows.Count; i++)
            {
                Page.ClientScript.RegisterForEventValidation(gridData.UniqueID, "Select$" + i.ToString());
            }
        }
        catch (Exception ex)
        {

        }
    }

    public override void VerifyRenderingInServerForm(System.Web.UI.Control ctControl)
    {

    }

    protected void btn_export_Click(object sender, EventArgs e)
    {
        fnSearchData();
        DataTable dtData = Functions.fnGetDt(ViewState["sSqlSearch"].ToString(), "MNDT");
        Functions.fnExportDataTableToExcel(grid_data_m, dtData, 1, "使用者資料維護", this);
        //labError.Text = "匯出成功";
        //Functions.fnMessageBox("更新成功", this);
        //ScriptManager.RegisterStartupScript(Page, Page.GetType(), "ShowMessage", "ShowMessage('更新成功');", true);
    }


    private async void fnUploadExcel(FileUpload fuFileUpload)
    {
        string sSql = "  INSERT INTO [MNDTrotation]  " +
                        "             ([rotation_id]  " +
                        "             ,[rotation_remarks]  " +
                        "             ,[create_user_id]  " +
                        "             ,[create_datetime]  " +
                        "             ,[modify_user_id]  " +
                        "             ,[modify_datetime])  " +
                        "       VALUES  " +
                        "             ('{code1}' " +
                        "             ,'{code2}' " +
                        "             ,'" + Session["sId"] + "' " +
                        "             ,GETDATE()  " +
                        "             ,'" + Session["sId"] + "' " +
                        "             ,GETDATE())  ";
        string sMessage = await Task.Run(() => Functions.fnUploadExcelAsync(fuFileUpload, sSql, 5, this));
        Functions.fnShowLabelMessage(this, sMessage);
        grid_data_m.DataBind();
    }
    protected void btn_import_Click(object sender, EventArgs e)
    {
        Control ctParent = ((Button)sender).Parent;
        FileUpload fuFileUpload = ((FileUpload)ctParent.FindControl("fu_file_upload"));
        fnUploadExcel(fuFileUpload);
    }


    protected void btn_print_Click(object sender, EventArgs e)
    {
        Session["PrintDT"] = Functions.fnGetDt("SELECT * FROM [MNDTrotation]", "MNDT");
        Literal1.Text = "<script type=\"text/javascript\">window.open('ReportPage.aspx?ReportName=MNDT1010.rpt','','resizable=yes,location=no')</script>";
    }
    protected void sds_main_Updated(object sender, SqlDataSourceStatusEventArgs e)
    {
        Functions.fnSQLActionMessage(this, e, "更新成功");
        sds_main.SelectCommand = ViewState["sSqlMaster"].ToString();
    }
    protected void form_view_master_ItemCommand(object sender, FormViewCommandEventArgs e)
    {
        string sCommand = e.CommandName;
        switch (sCommand)
        {
            case "Cancel":
                fnCloseEdit();
                break;
            case "InsertData":
                fnInsert();
                break;
        }
    }

    private void fnInsert()
    {
        sds_main.InsertParameters["rotation_id"].DefaultValue = ((TextBox)fv_master_form.FindControl("text_rotation_id")).Text;
        sds_main.InsertParameters["rotation_remarks"].DefaultValue = ((TextBox)fv_master_form.FindControl("text_rotation_remarks")).Text;
        sds_main.Insert();
    }


    private void fnCloseEdit()
    {
        multi_view.ActiveViewIndex = 0;
        fnSearchData();
    }
    protected void sds_main_Inserted(object sender, SqlDataSourceStatusEventArgs e)
    {
        Functions.fnSQLActionMessage(this, e, "新增成功");
        if (e.Exception == null)
        {
            string srotationId = ((TextBox)fv_master_form.FindControl("text_rotation_id")).Text;
            fnOpenEdit(srotationId);
        }
    }

    protected void imgbtn_last_Click(object sender, ImageClickEventArgs e)
    {
        if (ViewState["sSqlSearch"] != null && ViewState["SelectMaster"] != null)
        {
            int iIndex = int.Parse(ViewState["SelectMaster"].ToString());
            DataTable dtData = Functions.fnGetDt(ViewState["sSqlSearch"].ToString(), "MNDT");
            if (iIndex > 0)
            {
                fnOpenEdit(dtData.Rows[iIndex - 1][0].ToString());
                ViewState["SelectMaster"] = iIndex - 1;
            }
            else
            {
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), "ShowMessage", "ShowMessage('已是第一筆');", true);
            }
        }
    }
    protected void imgbtn_next_Click(object sender, ImageClickEventArgs e)
    {
        if (ViewState["sSqlSearch"] != null && ViewState["SelectMaster"] != null)
        {
            int iIndex = int.Parse(ViewState["SelectMaster"].ToString());
            DataTable dtData = Functions.fnGetDt(ViewState["sSqlSearch"].ToString(), "MNDT");

            if (iIndex < dtData.Rows.Count - 1)
            {
                fnOpenEdit(dtData.Rows[iIndex + 1][0].ToString());
                ViewState["SelectMaster"] = iIndex + 1;
            }
            else
            {
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), "ShowMessage", "ShowMessage('已是最後一筆');", true);
            }
        }
    }
    protected void sds_main_Deleted(object sender, SqlDataSourceStatusEventArgs e)
    {
        Functions.fnSQLActionMessage(this, e, "刪除成功");
        if (e.Exception == null)
        {
            fnCloseEdit();
        }
    }
    protected void drop_rotation_department_DataBinding(object sender, EventArgs e)
    {
        string sSql = "  SELECT [parameter]  " +
                        "        ,[parameter] + '：' + [code_name]  " +
                        "  FROM [MNDTcode_details]  " +
                        "  WHERE [code_kind] = 'Department' ";
        DropDownList dropData = ((DropDownList)sender);
        Functions.fnSetDropDownList(sSql, dropData);
    }

    protected void btn_save_image_Click(object sender, EventArgs e)
    {
        FileUpload fuFileUpload = ((FileUpload)fv_master_form.FindControl("fu_file_image_upload"));
        string sId = ((TextBox)fv_master_form.FindControl("text_rotation_id")).Text;
        Functions.fnShowMessage(this, fnUpLoadImage(fuFileUpload, sId), "上傳成功");
    }
    private string fnUpLoadImage(FileUpload fuFileUpload, string sChildDir)
    {
        string sRootDir = "\\Rotation\\";
        if (fuFileUpload.HasFiles == false)
        {
            return "請按瀏覽選擇要上傳的檔案";
        }

        if (Directory.Exists(Server.MapPath("~" + sRootDir + sChildDir + "\\")) == false)
        {
            Directory.CreateDirectory(Server.MapPath("~" + sRootDir + "/" + sChildDir + "/"));
        }

        string appPath = Request.PhysicalApplicationPath;
        string filePath = appPath + sRootDir + sChildDir + "\\";
        string sErrorMessage = "";

        foreach (HttpPostedFile httpFile in fuFileUpload.PostedFiles)
        {
            string sPath = filePath + httpFile.FileName;
            try
            {
                string sFile = httpFile.FileName.Substring(httpFile.FileName.Length - 3);
                if (sFile != "png" && sFile != "jpg" && sFile != "peg" && sFile != "bmp")
                {
                    sErrorMessage += httpFile.FileName + "不是圖片檔案！<br>";
                }
                else
                {
                    httpFile.SaveAs(sPath);
                    fnAddImage(sRootDir, sChildDir + "\\", httpFile.FileName);
                }
            }
            catch (Exception ex)
            {
                sErrorMessage = ex.Message;
            }
        }
        return sErrorMessage;
    }
    protected void lt_image_html_DataBinding(object sender, EventArgs e)
    {
        try
        {
            string sId = ((TextBox)fv_master_form.FindControl("text_rotation_id")).Text;
            string sChildDir = sId + "\\";
            string sRootDir = "\\Rotation\\";
            string sAppPath = Request.PhysicalApplicationPath;
            string filePath = sAppPath + sRootDir + sChildDir;
            Literal ltHtml = ((Literal)fv_master_form.FindControl("lt_image_html"));
            ltHtml.Text = "";
            foreach (string sFilename in System.IO.Directory.GetFiles(filePath))
            {
                string sFileDir = sRootDir + sChildDir;
                fnAddImage(sRootDir, sChildDir, sFilename.Replace(filePath, ""));
            }
        }
        catch
        { }
    }

    private void fnAddImage(string sRootDir, string sChildDir, string sFileName)
    {
        Literal ltHtml = ((Literal)fv_master_form.FindControl("lt_image_html"));
        string sPath = sRootDir + sChildDir + sFileName;
        //ltHtml.Text += " <div class='table-size5'> ";
        ltHtml.Text += " <img src='" + sPath + "' onclick='delete_img(this)' alt='" + sChildDir + sFileName + "'> ";
        //ltHtml.Text += " </div>";
    }
}