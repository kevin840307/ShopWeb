using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MNDT1030 : System.Web.UI.Page
{
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
        //fv_view.ChangeMode(FormViewMode.ReadOnly);
        //btn_file.Attributes.Add("onclick", "document.getElementById('" + fuFileUpload.ClientID + "').click(); return false;");
        Control conTitleBtn = Master.FindControl("title_button");
        //((Button)conTitleBtn.FindControl("btn_print")).Click += btn_print_Click;
        //((Button)conTitleBtn.FindControl("btn_export")).Click += btn_export_Click;
        //((Button)conTitleBtn.FindControl("btn_import")).Click += btn_import_Click;
        ((Label)Master.FindControl("lab_title")).Text = "作業群組作業維護<MNDT1030>";
        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "set_scroll", "set_scroll();", true);
    }

    private void fnSearchData()
    {
        string sMasterSql = "  SELECT [group_id]  " +
                        "        ,[group_name]  " +
                        "        ,SUBSTRING([group_description], 1, 10) 'group_description'  " +
                        "        ,SUBSTRING([group_remarks], 1, 10) 'group_remarks' " +
                        "        ,[create_user_id]  " +
                        "        ,CONVERT(char, [create_datetime], 111) AS 'create_datetime'  " +
                        "        ,[modify_user_id]  " +
                        "        ,CONVERT(char, [modify_datetime], 111) AS 'modify_datetime'  " +
                        "  FROM [MNDTgroup_master]  " +
                        "  WHERE 1 = 1 ";
        Functions.fnAddCondition(ref text_group_id, ref sMasterSql, "[group_id]");
        Functions.fnAddCondition(ref text_group_name, ref sMasterSql, "[group_name]");
        fnAddAccountCondition(ref sMasterSql);
        fnAddProgramCondition(ref sMasterSql);


        sds_main.SelectCommand = sMasterSql;
        sds_main.DataBind();
        grid_data_m.DataBind();
        ViewState["sSqlSearch"] = sMasterSql;
    }
    private void fnAddAccountCondition(ref string sMasterSql)
    {
        string sDetailSql = "  SELECT [group_d].[group_id]  " +
                            "  FROM [MNDTgroup_details] [group_d] LEFT JOIN [MNDTaccount] [acc]  " +
                            "  ON [group_d].[account_id] = [acc].[account_id]  " +
                            "  WHERE 1 = 1  ";
        if (text_account_id.Text.Length > 0 || text_account_name.Text.Length > 0)
        {
            Functions.fnAddCondition(ref text_account_name, ref sDetailSql, "[acc].[account_name]");
            Functions.fnAddCondition(ref text_account_id, ref sDetailSql, "[group_d].[account_id]");
            Functions.fnAddCondition(ref text_group_id, ref sDetailSql, "[group_d].[group_id]");
            Functions.fnAddCondition(ref sMasterSql, ref sDetailSql, "[group_id]");
        }
    }
    private void fnAddProgramCondition(ref string sMasterSql)
    {
        string sDetailSql = "  SELECT [program_d].[group_id]  " +
                                        "  FROM [MNDTprogram_details] [program_d] LEFT JOIN [MNDTprogram_master] [program_m] " +
                                        "  ON [program_d].[program_id] = [program_m].[program_id] " +
                                        "  WHERE 1 = 1  ";
        if (text_program_id.Text.Length > 0 || text_program_name.Text.Length > 0)
        {
            Functions.fnAddCondition(ref text_program_name, ref sDetailSql, "[program_m].[program_name]");
            Functions.fnAddCondition(ref text_program_id, ref sDetailSql, "[program_d].[program_id]");
            Functions.fnAddCondition(ref text_group_id, ref sDetailSql, "[program_d].[group_id]");
            Functions.fnAddCondition(ref sMasterSql, ref sDetailSql, "[group_id]");
        }
    }
    protected void btn_search_Click(object sender, EventArgs e)
    {
        fnSearchData();
    }

    protected void grid_data_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        GridView gridData = ((GridView)sender);
        GridViewEvent.fnGridViewRowDataBound(this, ref gridData, e.Row, 40, "#89BBFE", "#FFFFFF");
    }
    protected void grid_data_SelectedIndexChanged(object sender, EventArgs e)
    {
        GridView gridData = ((GridView)sender);
        GridViewEvent.fnGridViewSelectedIndexChanged(ref gridData, "#89BBFE");
    }
    protected void grid_data_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        GridView gridData = ((GridView)sender);
        GridViewEvent.fnGridViewSelectedIndexChanging(this, ref gridData, "#FFFFFF", "#000000");
    }

    protected override void Render(HtmlTextWriter writer)
    {
        GridView gridData = fnGetNowGridView();
        fnSetSelect(ref gridData);
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

    protected void fnDropYN(object sender, EventArgs e)
    {
        DropDownList dropData = ((DropDownList)sender);
        dropData.Items.Add(new ListItem("是", "Y"));
        dropData.Items.Add(new ListItem("否", "N"));
    }

    private GridView fnGetNowGridView()
    {
        switch (multi_view.ActiveViewIndex)
        {
            case 0:
                return grid_data_m;
            case 1:
                return grid_data_d;
            default:
                return grid_data_m;
        }
    }

    protected void grid_data_m_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string sCommand = e.CommandName;
        switch (sCommand)
        {
            case "SelectData":
                int iIndex = int.Parse(e.CommandArgument.ToString());
                string sGroupId = ((Label)grid_data_m.Rows[fnGetGridViewSelect(iIndex)].FindControl("lab_group_id")).Text.ToString();
                string sGroupName = ((Label)grid_data_m.Rows[fnGetGridViewSelect(iIndex)].FindControl("lab_group_name")).Text.ToString();
                fnOpenEdit(sGroupId, sGroupName);
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
    private void fnOpenEdit(string sGroupId, string sGroupName)
    {
        multi_view.ActiveViewIndex = 1;
        text_edit_group_id.Text = sGroupId;
        text_edit_group_name.Text = sGroupName;
        sds_add.SelectParameters["group_id"].DefaultValue = sGroupId;
        sds_detail.SelectParameters["group_id"].DefaultValue = sGroupId;
        sds_detail.DataBind();
        sds_add.DataBind();
        grid_data_add.DataBind();
        grid_data_d.DataBind();
    }

    protected void imgbtn_last_Click(object sender, ImageClickEventArgs e)
    {
        if (ViewState["sSqlSearch"] != null && ViewState["SelectMaster"] != null)
        {
            int iIndex = int.Parse(ViewState["SelectMaster"].ToString());
            DataTable dtData = Functions.fnGetDt(ViewState["sSqlSearch"].ToString(), "MNDT");
            if (iIndex > 0)
            {
                fnOpenEdit(dtData.Rows[iIndex - 1][0].ToString(), dtData.Rows[iIndex - 1][1].ToString());
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
                fnOpenEdit(dtData.Rows[iIndex + 1][0].ToString(), dtData.Rows[iIndex + 1][1].ToString());
                ViewState["SelectMaster"] = iIndex + 1;
            }
            else
            {
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), "ShowMessage", "ShowMessage('已是最後一筆');", true);
            }
        }
    }
    protected void cb_all_CheckedChanged(object sender, EventArgs e)
    {
        bool bValue = ((CheckBox)sender).Checked;
        int iSize = grid_data_add.Rows.Count;
        for (int iPos = 0; iPos < iSize; iPos++)
        {
            ((CheckBox)grid_data_add.Rows[iPos].FindControl("cb_select")).Checked = bValue;
        }
    }
    protected void btn_insert_program_Click(object sender, EventArgs e)
    {
        string sMessage = "新增成功<br>";
        int iSize = grid_data_add.Rows.Count;
        for (int iPos = 0; iPos < iSize; iPos++)
        {
            bool bSelect = ((CheckBox)grid_data_add.Rows[iPos].FindControl("cb_select")).Checked;
            if (bSelect)
            {
                GridViewRow gvrData = grid_data_add.Rows[iPos];
                string sGroupId = text_edit_group_id.Text;
                string sProgramId = ((Label)gvrData.FindControl("lab_program_id")).Text;
                string sRun = fnBoolToStr(((CheckBox)gvrData.FindControl("ch_au_run")).Checked);
                string sExport = fnBoolToStr(((CheckBox)gvrData.FindControl("ch_au_export")).Checked);
                string sPrint = fnBoolToStr(((CheckBox)gvrData.FindControl("ch_au_print")).Checked);
                sMessage += fnInsertProgram(sProgramId, sGroupId, sRun, sExport, sPrint);
            }
        }
        Functions.fnShowMessage(this, sMessage, "新增成功");
        grid_data_add.DataBind();
        grid_data_d.DataBind();
    }
    private string fnBoolToStr(bool bData)
    {
        return bData.ToString();
    }

    private string fnInsertProgram(string sProgramId, string sGroupId, string sRun, string sExport, string sPrint)
    {
        string sSql = "  INSERT INTO [MNDTprogram_details]  " +
                        "             ([program_id]  " +
                        "             ,[group_id]  " +
                        "             ,[au_run]  " +
                        "             ,[au_export]  " +
                        "             ,[au_print]  " +
                        "             ,[create_user_id]  " +
                        "             ,[create_datetime]  " +
                        "             ,[modify_user_id]  " +
                        "             ,[modify_datetime])  " +
                        "  VALUES  " +
                        "             ('" + sProgramId + "'  " +
                        "             ,'" + sGroupId + "'  " +
                        "             ,'" + sRun + "'  " +
                        "             ,'" + sExport + "'  " +
                        "             ,'" + sPrint + "'  " +
                        "             ,'" + Session["sId"].ToString() + "'  " +
                        "             ,GETDATE() " +
                        "             ,'" + Session["sId"].ToString() + "'  " +
                        "             ,GETDATE())  ";
        return Functions.fnExecuteSQL(sSql, "MNDT");
    }
    protected void btn_detail_cancel_Click(object sender, EventArgs e)
    {
        fnCloseEdit();
    }

    private void fnCloseEdit()
    {
        multi_view.ActiveViewIndex = 0;
    }

    protected void grid_data_d_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string sCommand = e.CommandName;
        switch(sCommand)
        {
            
        }
    }
    protected void sds_detail_Deleted(object sender, SqlDataSourceStatusEventArgs e)
    {
        Functions.fnSQLActionMessage(this, e, "刪除成功");
        if (e.Exception == null)
        {
            grid_data_add.DataBind();
        }
    }
    protected void linkbtn_first_Click1(object sender, EventArgs e)
    {
        GridView gridData = (GridView)grid_data_add;
        GridViewEvent.fnFirstPageEvent(ref gridData);
    }
    protected void linkbtn_next_Click1(object sender, EventArgs e)
    {
        GridView gridData = (GridView)grid_data_add;
        GridViewEvent.fnNextPageEvent(ref gridData);
    }
    protected void linkbtn_previous_Click1(object sender, EventArgs e)
    {
        GridView gridData = (GridView)grid_data_add;
        GridViewEvent.fnPreviousPageEvent(ref gridData);
    }
    protected void linkbtn_last_Click1(object sender, EventArgs e)
    {
        GridView gridData = (GridView)grid_data_add;
        GridViewEvent.fnLastPageEvent(ref gridData);
    }
    protected void drop_page_index_SelectedIndexChanged1(object sender, EventArgs e)
    {
        GridView gridData = (GridView)grid_data_add;
        DropDownList dropData = ((DropDownList)sender);
        GridViewEvent.fnDropPageIndexSelectedIndexChanged(ref gridData, ref dropData);
    }
    protected void drop_page_size_SelectedIndexChanged1(object sender, EventArgs e)
    {
        GridView gridData = (GridView)grid_data_add;
        DropDownList dropData = ((DropDownList)sender);
        GridViewEvent.fnDropPageSizeSelectedIndexChanged(ref gridData, ref dropData);
    }
    protected void drop_page_size_DataBinding1(object sender, EventArgs e)
    {
        GridView gridData = (GridView)grid_data_add;
        DropDownList dropData = ((DropDownList)sender);
        GridViewEvent.fnDropPageSizeDataBinding(ref gridData, ref dropData);
    }
    protected void drop_page_index_DataBinding1(object sender, EventArgs e)
    {
        GridView gridData = (GridView)grid_data_add;
        DropDownList dropData = ((DropDownList)sender);
        GridViewEvent.fnDropPageIndexDataBinding(ref gridData, ref dropData);
    }
}