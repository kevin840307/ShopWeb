﻿using System;
using System.Collections.Generic;
using System.Data;
using System.EnterpriseServices;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MNDT3010 : System.Web.UI.Page
{
    private void fnSearchData()
    {
        string sMasterSql = "  SELECT [requisition_m].[purchase_order]  " +
                            "        ,[requisition_m].[requisition_id]  " +
                            "        ,[account].[account_name] " +
                            "        ,CONVERT(char, [requisition_m].[requisition_datetime], 111) 'requisition_datetime'  " +
                            "        ,CONVERT(char, [requisition_m].[need_datetime], 111) 'need_datetime'  " +
                            "        ,CASE [requisition_m].[requisition_review] WHEN '1' THEN '已審核' ELSE '未審核' END 'requisition_review'  " +
                            "        ,[requisition_m].[requisition_use]  " +
                            "        ,[requisition_m].[requisition_remarks]  " +
                            "  FROM [MNDTrequisition_master] [requisition_m] LEFT JOIN [MNDTaccount] [account] " +
                            "  ON [requisition_m].[requisition_id] = [account].[account_id] " +
                            "  WHERE 1 = 1 ";
        Functions.fnAddCondition(ref text_purchase_order, ref sMasterSql, "[requisition_m].[purchase_order]");
        Functions.fnAddCondition(ref text_requisition_datetime, ref sMasterSql, "[requisition_m].[requisition_datetime]");
        Functions.fnAddCondition(ref text_need_datetime, ref sMasterSql, "[requisition_m].[need_datetime]");
        Functions.fnAddCondition(ref drop_requisition_review, ref sMasterSql, "[requisition_m].[requisition_review]");
        Functions.fnAddCondition(ref drop_requisition_id, ref sMasterSql, "[requisition_m].[requisition_id]");

        sds_main.SelectCommand = sMasterSql;
        sds_main.DataBind();
        grid_data_m.DataBind();
        ViewState["sSqlSearch"] = sMasterSql;
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
        //fv_view.ChangeMode(FormViewMode.ReadOnly);
        //btn_file.Attributes.Add("onclick", "document.getElementById('" + fuFileUpload.ClientID + "').click(); return false;");
        Control conTitleBtn = Master.FindControl("title_button");
        ((Button)conTitleBtn.FindControl("btn_print")).Click += btn_print_Click;
        ((Button)conTitleBtn.FindControl("btn_export")).Click += btn_export_Click;
        ((Button)conTitleBtn.FindControl("btn_import")).Click += btn_import_Click;
        ((Label)Master.FindControl("lab_title")).Text = "請購資料維護<MNDT3010>";
        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "set_scroll", "set_scroll();", true);
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
        //GridView gridData = fnGetNowGridView();
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

    protected void btn_print_Click(object sender, EventArgs e)
    {
        GridView gridData = fnGetNowGridView();
        string sPrintName = "MNDT3010_1";
        if (gridData.ID == "grid_data_m")
        {
            Session["PrintDT"] = Functions.fnGetDt("SELECT * FROM [MNDTgroup_master]", "MNDT");
        }
        else if (gridData.ID == "grid_data_d" && ViewState["sSqlDatail"] != null)
        {
            Session["PrintDT"] = Functions.fnGetDt(ViewState["sSqlDatail"].ToString(), "MNDT");
            sPrintName = "MNDT3010_2";
        }
        Literal1.Text = "<script type=\"text/javascript\">window.open('ReportPage.aspx?ReportName=" + sPrintName + ".rpt','','resizable=yes,location=no')</script>";

    }

    protected void btn_export_Click(object sender, EventArgs e)
    {
        GridView gridData = fnGetNowGridView();
        if (gridData.ID == "grid_data_m")
        {
            fnSearchData();
            DataTable dtData = Functions.fnGetDt(ViewState["sSqlSearch"].ToString(), "MNDT");
            Functions.fnExportDataTableToExcel(grid_data_m, dtData, 1, "群組資料1", this);
        }
        else if (gridData.ID == "grid_data_d" && ViewState["sSqlDatail"] != null)
        {
            DataTable dtData = Functions.fnGetDt(ViewState["sSqlDatail"].ToString(), "MNDT");
            Functions.fnExportDataTableToExcel(grid_data_m, dtData, 1, "群組資料2", this);
        }
        //labError.Text = "匯出成功";
        //ScriptManager.RegisterStartupScript(Page, Page.GetType(), "ShowError", "ShowError();", true);
    }

    protected void btn_import_Click(object sender, EventArgs e)
    {
        Control ctParent = ((Button)sender).Parent;
        FileUpload fuFileUpload = ((FileUpload)ctParent.FindControl("fu_file_upload"));
        GridView gridData = fnGetNowGridView();
        if (gridData.ID == "grid_data_m")
        {
            fnUploadMasterExcel(fuFileUpload);
        }
        else if (gridData.ID == "grid_data_d")
        {
            fnUploadDetailExcel(fuFileUpload);
        }
    }

    private async void fnUploadMasterExcel(FileUpload fuFileUpload)
    {
        string sSql = "  INSERT INTO [MNDTrequisition_master]  " +
                        "             ([purchase_order]  " +
                        "             ,[requisition_id]  " +
                        "             ,[requisition_datetime]  " +
                        "             ,[need_datetime]  " +
                        "             ,[requisition_review]  " +
                        "             ,[requisition_use]  " +
                        "             ,[requisition_remarks]  " +
                        "             ,[create_user_id]  " +
                        "             ,[create_datetime]  " +
                        "             ,[modify_user_id]  " +
                        "             ,[modify_datetime])  " +
                        "  VALUES  " +
                        "             ('{code1}' " +
                        "             ,'{code2}' " +
                        "             ,'{code3}' " +
                        "             ,'{code4}' " +
                        "             ,'{code5}' " +
                        "             ,'{code6}' " +
                        "             ,'{code7}' " +
                        "             ,'" + Session["sId"] + "' " +
                        "             ,GETDATE()  " +
                        "             ,'" + Session["sId"] + "' " +
                        "             ,GETDATE())  ";
        string sMessage = await Task.Run(() => Functions.fnUploadExcelAsync(fuFileUpload, sSql, 7, this));
        Functions.fnShowLabelMessage(this, sMessage);
        grid_data_m.DataBind();
    }

    private async void fnUploadDetailExcel(FileUpload fuFileUpload)
    {
        string sSql = "  INSERT INTO [MNDTgroup_details]  " +
                        "             ([purchase_order]  " +
                        "             ,[product_kind]  " +
                        "             ,[product_code]  " +
                        "             ,[requisition_amount]  " +
                        "             ,[requisition_money]  " +
                        "             ,[requisition_amount_mod]  " +
                        "             ,[requisition_money_mod]  " +
                        "             ,[requisition_remarks]  " +
                        "             ,[create_user_id]  " +
                        "             ,[create_datetime]  " +
                        "             ,[modify_user_id]  " +
                        "             ,[modify_datetime])  " +
                        "  VALUES  " +
                        "             ('{code1}' " +
                        "             ,'{code2}' " +
                        "             ,'{code3}' " +
                        "             ,'{code4}' " +
                        "             ,'{code5}' " +
                        "             ,'{code6}' " +
                        "             ,'{code7}' " +
                        "             ,'{code8}' " +
                        "             ,'" + Session["sId"] + "' " +
                        "             ,GETDATE()  " +
                        "             ,'" + Session["sId"] + "' " +
                        "             ,GETDATE())  ";

        string sMessage = await Task.Run(() => Functions.fnUploadExcelAsync(fuFileUpload, sSql, 8, this));
        Functions.fnShowLabelMessage(this, sMessage);
        grid_data_d.DataBind();
    }

    protected void grid_data_m_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string sCommand = e.CommandName;
        string sOrder = "";
        int iIndex = -1;
        switch (sCommand)
        {
            case "SelectData":
                iIndex = int.Parse(e.CommandArgument.ToString());
                sOrder = ((Label)grid_data_m.Rows[fnGetGridViewSelect(iIndex)].FindControl("lab_purchase_order")).Text;
                fnOpenEdit(sOrder);
                ViewState["SelectMaster"] = iIndex;
                break;
            case "OpenInsert":
                fnOpenInset();
                break;
            case "Review":
                iIndex = int.Parse(e.CommandArgument.ToString());
                sOrder = ((Label)grid_data_m.Rows[fnGetGridViewSelect(iIndex)].FindControl("lab_purchase_order")).Text;
                fnReviewOrder(sOrder, "1");
                grid_data_m.DataBind();
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

    protected void fv_master_form_ItemCommand(object sender, FormViewCommandEventArgs e)
    {
        string sCommand = e.CommandName;
        switch (sCommand)
        {
            case "Cancel":
                fnCloseEdit();
                break;
            case "InsertData":
                fnInsertMaster();
                break;
            case "Review":
                string sOrder = ((TextBox)fv_master_form.FindControl("text_edit_purchase_order")).Text;
                fnReviewOrder(sOrder, "1");
                fnOpenEdit(sOrder);
                break;
        }
    }

    private void fnReviewOrder(string sOrder, string sStatus)
    {
        string sSql = "  UPDATE [MNDTrequisition_master]  " +
                    "     SET [requisition_review] = '" + sStatus + "' " +
                    "  WHERE [purchase_order] = '" + sOrder + "' ";
        if(Functions.fnExecuteSQL(sSql, "MNDT") == "" )
        {
            fnInsertPurchaseM(sOrder);
        }
        else
        {
            Functions.fnShowMessage(this, Functions.fnExecuteSQL(sSql, "MNDT"), "審核失敗");
        }
    }

    private void fnInsertPurchaseM(string sOrder)
    {
        string sSql = "  INSERT INTO [MNDTpurchase_master]  " +
                        "             ([purchase_order]  " +
                        "             ,[purchase_id]  " +
                        "             ,[purchase_datetime]  " +
                        "             ,[purchase_complete] " +
                        "             ,[create_user_id]  " +
                        "             ,[create_datetime]  " +
                        "             ,[modify_user_id]  " +
                        "             ,[modify_datetime])  " +
                        "  SELECT TOP 1 [purchase_order]  " +
                        "             ,[requisition_id]  " +
                        "             ,GETDATE()  " +
                        "             ,'0'  " +
                        "             ,'" + Session["sId"].ToString() + "'  " +
                        "             ,GETDATE()  " +
                        "             ,'" + Session["sId"].ToString() + "'  " +
                        "             ,GETDATE()  " +
                        "  FROM [MNDTrequisition_master]  " +
                        "  WHERE purchase_order = '" + sOrder + "'  ";
        if(Functions.fnExecuteSQL(sSql, "MNDT") == "")
        {
            fnInsertPurchaseD(sOrder);
        }
        else
        {
            Functions.fnShowMessage(this, Functions.fnExecuteSQL(sSql, "MNDT"), "審核失敗");
        }
    }

    private void fnInsertPurchaseD(string sOrder)
    {
        string sSql = "  INSERT INTO [MNDTpurchase_details]  " +
                        "             ([purchase_order]  " +
                        "             ,[product_kind]  " +
                        "             ,[product_code]  " +
                        "             ,[purchase_amount]  " +
                        "             ,[purchase_money]  " +
                        "             ,[purchase_amount_mod]  " +
                        "             ,[purchase_money_mod]  " +
                        "  		      ,[purchase_complete]  " +
                        "             ,[create_user_id]  " +
                        "             ,[create_datetime]  " +
                        "             ,[modify_user_id]  " +
                        "             ,[modify_datetime])  " +
                        "  SELECT purchase_order  " +
                        "             ,product_kind  " +
                        "             ,product_code  " +
                        "             ,requisition_amount_mod  " +
                        "             ,requisition_money_mod  " +
                        "             ,requisition_amount_mod  " +
                        "             ,requisition_money_mod  " +
                        "  		      ,'0'  " +
                        "             ,'" + Session["sId"].ToString() + "'  " +
                        "             ,GETDATE()  " +
                        "             ,'" + Session["sId"].ToString() + "'  " +
                        "             ,GETDATE()  " +
                        "  FROM [MNDTrequisition_details]  " +
                        "  WHERE [purchase_order] = '" + sOrder + "'  ";
        Functions.fnShowMessage(this, Functions.fnExecuteSQL(sSql, "MNDT"), "審核成功");
    }

    private void fnOpenEdit(string sOrder)
    {
        multi_view.ActiveViewIndex = 1;
        fnSetSelectMasterView(sOrder);
        sds_detail.SelectParameters["purchase_order"].DefaultValue = sOrder;
        sds_detail.DataBind();
        grid_data_d.DataBind();
        panel_detail.Visible = true;
        fv_master_form.ChangeMode(FormViewMode.Edit);
        ViewState["sSqlDatail"] = sds_detail.SelectCommand.Replace("@purchase_order", "'" + sOrder + "'");
    }

    private void fnSetSelectMasterView(string sOrder)
    {
        string sMasterSql = "  SELECT TOP 1 [purchase_order]  " +
                           "        ,[requisition_id]  " +
                           "        ,CONVERT(char, [requisition_datetime], 111) 'requisition_datetime'  " +
                           "        ,CONVERT(char, [need_datetime], 111) 'need_datetime'  " +
                           "        ,CASE [requisition_review] WHEN '1' THEN '已審核' ELSE '未審核' END 'requisition_review'  " +
                           "        ,[requisition_use]  " +
                           "        ,[requisition_remarks]  " +
                           "  FROM [MNDTrequisition_master]  " +
                           "  WHERE [purchase_order] = '" + sOrder + "' ";
        sds_main.SelectCommand = sMasterSql;
        ViewState["sSqlMaster"] = sMasterSql;
        sds_main.DataBind();
    }
    private void fnCloseEdit()
    {
        multi_view.ActiveViewIndex = 0;
        panel_detail.Visible = false;
        fnSearchData();
    }
    private void fnOpenInset()
    {
        multi_view.ActiveViewIndex = 1;
        fv_master_form.ChangeMode(FormViewMode.Insert);
    }

    private string fnGetOrderNum()
    {
        string sSql1 = "  SELECT [parameter]  " +
                        "  FROM [MNDTcode_details]  " +
                        "  WHERE [code_kind] = 'Order'  " +
                        "  	AND [code] = 'A01'  " +
                        "  	AND CONVERT(char, [modify_datetime], 111) = CONVERT(char, GETDATE(), 111)  ";
        int iNum = 0;
        string sOrderNum = Functions.fnGetValue(sSql1, "MNDT");
        sOrderNum = (sOrderNum == "") ? "0" : sOrderNum;

        if (int.TryParse(sOrderNum, out iNum))
        {
            while (sOrderNum.Length < 4)
            {
                sOrderNum = "0" + sOrderNum;
            }
            sOrderNum = "MN" + DateTime.Now.ToString("yyyyMMdd") + sOrderNum;
            ViewState["insert_order"] = sOrderNum;
            ViewState["update_order"] = iNum + 1;
            return sOrderNum;
        }
        return "000000000";
    }

    private string fnUpdateOrderNum()
    {
        string sSql2 = "  UPDATE [MNDTcode_details]  " +
                            "  SET [parameter] = '" + ViewState["update_order"].ToString() + "'  " +
                            "  	,[modify_datetime] = GETDATE()  " +
                            "  WHERE [code_kind] = 'Order'  " +
                            "  	AND [code] = 'A01'  ";
        return Functions.fnExecuteSQL(sSql2, "MNDT");
    }

    private void fnInsertMaster()
    {
        sds_main.InsertParameters["purchase_order"].DefaultValue = fnGetOrderNum();
        sds_main.InsertParameters["requisition_id"].DefaultValue = ((DropDownList)fv_master_form.FindControl("drop_insert_requisition_id")).SelectedValue;
        sds_main.InsertParameters["requisition_datetime"].DefaultValue = ((TextBox)fv_master_form.FindControl("text_insert_requisition_datetime")).Text;
        sds_main.InsertParameters["need_datetime"].DefaultValue = ((TextBox)fv_master_form.FindControl("text_insert_need_datetime")).Text;
        sds_main.InsertParameters["requisition_use"].DefaultValue = ((TextBox)fv_master_form.FindControl("text_insert_requisition_use")).Text;
        sds_main.InsertParameters["requisition_remarks"].DefaultValue = ((TextBox)fv_master_form.FindControl("text_insert_requisition_remarks")).Text;
        sds_main.Insert();
    }
    protected void sds_main_Updated(object sender, SqlDataSourceStatusEventArgs e)
    {
        Functions.fnSQLActionMessage(this, e, "更新成功");
        sds_main.SelectCommand = ViewState["sSqlMaster"].ToString();
    }
    protected void sds_main_Inserted(object sender, SqlDataSourceStatusEventArgs e)
    {
        Functions.fnSQLActionMessage(this, e, "新增成功");
        if (e.Exception == null)
        {
            fnUpdateOrderNum();
            fnOpenEdit(ViewState["insert_order"].ToString());
        }
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

        sds_detail.InsertParameters["purchase_order"].DefaultValue = ((TextBox)fv_master_form.FindControl("text_edit_purchase_order")).Text;
        sds_detail.InsertParameters["product_kind"].DefaultValue = ((DropDownList)ctControl.FindControl("drop_product_kind")).SelectedValue;
        sds_detail.InsertParameters["product_code"].DefaultValue = ((DropDownList)ctControl.FindControl("drop_product_code")).SelectedValue;
        sds_detail.InsertParameters["requisition_amount"].DefaultValue = ((TextBox)ctControl.FindControl("text_requisition_amount")).Text;
        sds_detail.InsertParameters["requisition_money"].DefaultValue = ((TextBox)ctControl.FindControl("text_requisition_money")).Text;
        sds_detail.InsertParameters["requisition_remarks"].DefaultValue = ((TextBox)ctControl.FindControl("text_requisition_remarks")).Text;
        sds_detail.Insert();
    }
    protected void sds_detail_Inserted(object sender, SqlDataSourceStatusEventArgs e)
    {
        Functions.fnSQLActionMessage(this, e, "新增成功");
        if (e.Exception == null)
        {
            fnInsertTemplate();
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
    protected void sds_detail_Updated(object sender, SqlDataSourceStatusEventArgs e)
    {
        Functions.fnSQLActionMessage(this, e, "更新成功");
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

    protected void text_requisition_amount_TextChanged(object sender, EventArgs e)
    {
        TextBox textData = ((TextBox)sender);
        try
        {
            float iAmount = float.Parse(textData.Text.ToString());
            float iPrice = float.Parse(ViewState["detail_pruduct_unit"].ToString());
            TextBox textMoney = ((TextBox)textData.Parent.FindControl("text_requisition_money"));
            textMoney.Text = (iAmount * iPrice).ToString("f3");
        }
        catch
        { }
    }
    protected void drop_requisition_id_DataBinding(object sender, EventArgs e)
    {
        string sSql = "  SELECT [account_id]  " +
                        "        ,[account_id] + '：' + [account_name]  " +
                        "  FROM [MNDTaccount]  " +
                        "  WHERE [account_department] = '0001'  ";
        Functions.fnSetDropDownList(sSql, ((DropDownList)sender));
    }
    protected void drop_product_kind_DataBinding(object sender, EventArgs e)
    {
        string sSql = "  SELECT [product_kind]  " +
                        "        ,[product_kind] + '：' + [product_kind_name]  " +
                        "  FROM [MNDTproduct_master]  ";
        Functions.fnSetDropDownList(sSql, ((DropDownList)sender));
    }
    protected void drop_product_kind_SelectedIndexChanged(object sender, EventArgs e)
    {
        string sKind = ((DropDownList)sender).SelectedValue;
        DropDownList dropCode = ((DropDownList)((DropDownList)sender).Parent.FindControl("drop_product_code"));
        string sSql = "  SELECT [product_code]  " +
                        "        ,[product_code] + '：' + [product_code_name]  " +
                        "  FROM [MNDTproduct_details]  " +
                        "  WHERE [product_kind] = '" + sKind + "'  ";
        ViewState["detail_kind"] = sKind;
        Functions.fnSetDropDownList(sSql, dropCode);
    }
    protected void drop_product_code_SelectedIndexChanged(object sender, EventArgs e)
    {
        string sCode = ((DropDownList)sender).SelectedValue;
        string sSql = "  SELECT ISNULL([product_cost], '0')  " +
                        "  FROM [MNDTproduct_details]  " +
                        "  WHERE [product_kind] = '" + ViewState["detail_kind"].ToString() + "'  " +
                        "       AND [product_code] = '" + sCode + "' ";
        ViewState["detail_pruduct_unit"] = Functions.fnGetValue(sSql, "MNDT");
    }
    protected void sds_detail_Deleted(object sender, SqlDataSourceStatusEventArgs e)
    {
        Functions.fnSQLActionMessage(this, e, "刪除成功");
    }
}