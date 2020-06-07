using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MNDT1040 : System.Web.UI.Page
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
        ((Label)Master.FindControl("lab_title")).Text = "代碼作業維護<MNDT1040>";
        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "set_scroll", "set_scroll();", true);
    }

    protected void btn_search_Click(object sender, EventArgs e)
    {
        fnSearchData();
    }

    private void fnSearchData()
    {
        string sMasterSql = "  SELECT [code_kind]  " +
                            "        ,[code_kind_name]  " +
                            "        ,SUBSTRING([code_description], 1, 10) 'code_description'  " +
                            "        ,SUBSTRING([code_remarks], 1, 10) 'code_remarks' " +
                            "        ,[create_user_id]  " +
                            "        ,CONVERT(char, [create_datetime], 111) AS 'create_datetime'  " +
                            "        ,[modify_user_id]  " +
                            "        ,CONVERT(char, [modify_datetime], 111) AS 'modify_datetime'  " +
                            "  FROM [MNDTcode_master]  " +
                            "  WHERE 1 = 1 ";
        Functions.fnAddCondition(ref text_code_kind, ref sMasterSql, "[code_kind]");
        Functions.fnAddCondition(ref text_code_kind_name, ref sMasterSql, "[code_kind_name]");

        fnAddCodeCondition(ref sMasterSql);

        sds_main.SelectCommand = sMasterSql;
        sds_main.DataBind();
        grid_data_m.DataBind();
        ViewState["sSqlSearch"] = sMasterSql;
    }

    private void fnAddCodeCondition(ref string sMasterSql)
    {
        string sDetailSql = "  SELECT [code_kind]  " +
                            "  FROM [MNDTcode_details]  " +
                            "  WHERE 1 = 1  ";
        if (text_code.Text.Length > 0 || text_code_name.Text.Length > 0)
        {
            Functions.fnAddCondition(ref text_code, ref sDetailSql, "[code]");
            Functions.fnAddCondition(ref text_code_name, ref sDetailSql, "[code_name]");
            Functions.fnAddCondition(ref sMasterSql, ref sDetailSql, "[code_kind]");
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

    protected void grid_data_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        GridView gridData = ((GridView)sender);
        GridViewEvent.fnGridViewRowDataBound(this, ref gridData, e.Row, 40, "#89BBFE", "#FFFFFF");
    }
    protected void grid_data_m_RowCommand(object sender, GridViewCommandEventArgs e)
    {
         string sCommand = e.CommandName;
         switch (sCommand)
         {
             case "OpenInsert":
                 fnOpenInset();
                 break;
             case "SelectData":
                 int iIndex = int.Parse(e.CommandArgument.ToString());
                 string sCodeKind = ((Label)grid_data_m.Rows[fnGetGridViewSelect(iIndex)].FindControl("lab_code_kind")).Text.ToString();
                 fnOpenEdit(sCodeKind);
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

    private void fnOpenInset()
    {
        multi_view.ActiveViewIndex = 1;
        fv_master_form.ChangeMode(FormViewMode.Insert);
    }
    protected void fv_master_form_ItemCommand(object sender, FormViewCommandEventArgs e)
    {
        string sCommand = e.CommandName;
        switch(sCommand)
        {
            case "InsertData":
                fnInsertMaster();
                break;
            case "Cancel":
                fnCloseEdit();
                break;
        }
    }

    private void fnCloseEdit()
    {
        multi_view.ActiveViewIndex = 0;
        panel_detail.Visible = false;
        fnSearchData();
    }

    private void fnInsertMaster()
    {
        sds_main.InsertParameters["code_kind"].DefaultValue = ((TextBox)fv_master_form.FindControl("text_insert_code_kind")).Text;
        sds_main.InsertParameters["code_kind_name"].DefaultValue = ((TextBox)fv_master_form.FindControl("text_insert_code_kind_name")).Text;
        sds_main.InsertParameters["code_description"].DefaultValue = ((TextBox)fv_master_form.FindControl("text_insert_code_description")).Text;
        sds_main.InsertParameters["code_remarks"].DefaultValue = ((TextBox)fv_master_form.FindControl("text_insert_code_remarks")).Text;
        sds_main.Insert();
    }
    protected void sds_main_Inserted(object sender, SqlDataSourceStatusEventArgs e)
    {
        Functions.fnSQLActionMessage(this, e, "新增成功");
        if (e.Exception == null)
        {
            string sCodeKind = ((TextBox)fv_master_form.FindControl("text_insert_code_kind")).Text;
            fnOpenEdit(sCodeKind);
        }
    }
    private void fnOpenEdit(string sCodeKind)
    {
        multi_view.ActiveViewIndex = 1;
        fnSetSelectMasterView(sCodeKind);
        sds_detail.SelectParameters["code_kind"].DefaultValue = sCodeKind;
        sds_detail.DataBind();
        grid_data_d.DataBind();
        panel_detail.Visible = true;
        fv_master_form.ChangeMode(FormViewMode.Edit);
        ViewState["sSqlDatail"] = sds_detail.SelectCommand.Replace("@code_kind", "'" + sCodeKind + "'");
    }

    private void fnSetSelectMasterView(string sCodeKind)
    {
        string sMasterSql = "  SELECT TOP 1 [code_kind]  " +
                           "        ,[code_kind_name]  " +
                           "        ,[code_description]  " +
                           "        ,[code_remarks]  " +
                           "        ,[create_user_id]  " +
                           "        ,CONVERT(char, [create_datetime], 111) AS 'create_datetime'  " +
                           "        ,[modify_user_id]  " +
                           "        ,CONVERT(char, [modify_datetime], 111) AS 'modify_datetime'  " +
                           "  FROM [MNDTcode_master]  " +
                           "  WHERE [code_kind] = '" + sCodeKind + "' ";

        sds_main.SelectCommand = sMasterSql;
        ViewState["sSqlMaster"] = sMasterSql;
        sds_main.DataBind();
    }
    protected void sds_main_Updated(object sender, SqlDataSourceStatusEventArgs e)
    {
        Functions.fnSQLActionMessage(this, e, "更新成功");
        sds_main.SelectCommand = ViewState["sSqlMaster"].ToString();
    }

    protected void grid_data_d_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string sCommand = e.CommandName;
        switch (sCommand)
        {
            case "OpenInsert":
            case "CloseInsert":
                fnInsertTemplate();
                break;
            case "InsertData":
                fnInsert();
                break;
        }
    }

    private void fnInsertTemplate()
    {
        if (grid_data_d.ShowFooter)
        {
            grid_data_d.ShowFooter = false;
        }
        else
        {
            grid_data_d.ShowFooter = true;
        }
    }

    private void fnInsert()
    {
        Control ctControl = null;
        if (grid_data_d.FooterRow != null)
        {
            ctControl = grid_data_d.FooterRow;
        }
        else
        {
            ctControl = grid_data_d.FindControl("EmptyFooter");
        }
        sds_detail.InsertParameters["code_kind"].DefaultValue = ((TextBox)fv_master_form.FindControl("text_edit_code_kind")).Text;
        sds_detail.InsertParameters["code"].DefaultValue = ((TextBox)ctControl.FindControl("text_code")).Text;
        sds_detail.InsertParameters["code_name"].DefaultValue = ((TextBox)ctControl.FindControl("text_code_name")).Text;
        sds_detail.InsertParameters["parameter"].DefaultValue = ((TextBox)ctControl.FindControl("text_parameter")).Text;
        sds_detail.InsertParameters["code_remarks"].DefaultValue = ((TextBox)ctControl.FindControl("text_code_remarks")).Text;
        sds_detail.Insert();
    }
    protected void sds_detail_Deleted(object sender, SqlDataSourceStatusEventArgs e)
    {
        Functions.fnSQLActionMessage(this, e, "刪除成功");
    }
    protected void sds_detail_Inserted(object sender, SqlDataSourceStatusEventArgs e)
    {
        Functions.fnSQLActionMessage(this, e, "新增成功");
        if (e.Exception == null)
        {
            fnInsertTemplate();
        }
    }
    protected void sds_detail_Updated(object sender, SqlDataSourceStatusEventArgs e)
    {
        Functions.fnSQLActionMessage(this, e, "更新成功");
    }
    protected void sds_main_Deleted(object sender, SqlDataSourceStatusEventArgs e)
    {
        Functions.fnSQLActionMessage(this, e, "刪除成功");
        if (e.Exception == null)
        {
            fnCloseEdit();
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
}