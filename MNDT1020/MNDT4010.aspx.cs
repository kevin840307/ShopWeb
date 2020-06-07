using System;
using System.Collections.Generic;
using System.Data;
using System.EnterpriseServices;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MNDT4010 : System.Web.UI.Page
{
    private void fnSearchData()
    {
        string sMasterSql = "  SELECT [quotes_m].[shipments_order]  " +
                            "        ,[quotes_m].[quotes_id]  " +
                            "        ,[quotes_m].[client_id]  " +
                            "        ,[client].[client_name]  " +
                            "        ,[account].[account_name] " +
                            "        ,CONVERT(char, [quotes_m].[quotes_datetime], 111) 'quotes_datetime'  " +
                            "        ,CASE [quotes_m].[quotes_complete] WHEN '1' THEN '已報價' ELSE '報價中' END 'quotes_complete'  " +
                            "        ,[quotes_m].[quotes_remarks]  " +
                            "  FROM [MNDTquotes_master] [quotes_m] LEFT JOIN [MNDTaccount] [account] " +
                            "  ON [quotes_m].[quotes_id] = [account].[account_id] LEFT JOIN [MNDTclient] [client] " +
                            "  ON [quotes_m].[client_id] = [client].[client_id] " +
                            "  WHERE 1 = 1 ";
        Functions.fnAddCondition(ref text_shipments_order, ref sMasterSql, "[quotes_m].[shipments_order]");
        Functions.fnAddCondition(ref text_quotes_datetime, ref sMasterSql, "[quotes_m].[quotes_datetime]");
        Functions.fnAddCondition(ref drop_quotes_complete, ref sMasterSql, "[quotes_m].[quotes_complete]");
        Functions.fnAddCondition(ref drop_quotes_id, ref sMasterSql, "[quotes_m].[quotes_id]");
        Functions.fnAddCondition(ref drop_client_id, ref sMasterSql, "[quotes_m].[client_id]");
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
        ((Label)Master.FindControl("lab_title")).Text = "報價資料維護<MNDT4010>";
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
        string sSql = "  INSERT INTO [MNDTquotes_master]  " +
                        "             ([shipments_order]  " +
                        "             ,[quotes_id]  " +
                        "             ,[quotes_datetime]  " +
                        "             ,[quotes_complete]  " +
                        "             ,[quotes_remarks]  " +
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
                        "             ,'" + Session["sId"] + "' " +
                        "             ,GETDATE()  " +
                        "             ,'" + Session["sId"] + "' " +
                        "             ,GETDATE())  ";
        string sMessage = await Task.Run(() => Functions.fnUploadExcelAsync(fuFileUpload, sSql, 5, this));
        Functions.fnShowLabelMessage(this, sMessage);
        grid_data_m.DataBind();
    }

    private async void fnUploadDetailExcel(FileUpload fuFileUpload)
    {
        string sSql = "  INSERT INTO [MNDTgroup_details]  " +
                        "             ([shipments_order]  " +
                        "             ,[product_kind]  " +
                        "             ,[product_code]  " +
                        "             ,[quotes_amount]  " +
                        "             ,[quotes_money]  " +
                        "             ,[quotes_amount_mod]  " +
                        "             ,[quotes_money_mod]  " +
                        "             ,[quotes_remarks]  " +
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
                sOrder = ((Label)grid_data_m.Rows[fnGetGridViewSelect(iIndex)].FindControl("lab_shipments_order")).Text;
                fnOpenEdit(sOrder);
                ViewState["SelectMaster"] = iIndex;
                break;
            case "OpenInsert":
                fnOpenInset();
                break;
            case "Complete":
                iIndex = int.Parse(e.CommandArgument.ToString());
                sOrder = ((Label)grid_data_m.Rows[fnGetGridViewSelect(iIndex)].FindControl("lab_shipments_order")).Text;
                fnCompleteOrder(sOrder, "1");
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
            case "Complete":
                string sOrder = ((TextBox)fv_master_form.FindControl("text_edit_shipments_order")).Text;
                fnCompleteOrder(sOrder, "1");
                fnOpenEdit(sOrder);
                break;
        }
    }

    private void fnCompleteOrder(string sOrder, string sStatus)
    {
        string sSql = "  UPDATE [MNDTquotes_master]  " +
                    "     SET [quotes_complete] = '" + sStatus + "' " +
                    "  WHERE [shipments_order] = '" + sOrder + "' ";
        if (Functions.fnExecuteSQL(sSql, "MNDT") == "")
        {
            fnInsertSalesM(sOrder);
        }
        else
        {
            Functions.fnShowMessage(this, Functions.fnExecuteSQL(sSql, "MNDT"), "採購失敗");
        }
    }

    private void fnInsertSalesM(string sOrder)
    {
        string sSql = "  INSERT INTO [MNDTsales_master]  " +
                        "             ([shipments_order]  " +
                        "             ,[sales_id] " +
                        "             ,[client_id] " +
                        "             ,[sales_datetime]  " +
                        "             ,[sales_complete] " +
                        "             ,[create_user_id]  " +
                        "             ,[create_datetime]  " +
                        "             ,[modify_user_id]  " +
                        "             ,[modify_datetime])  " +
                        "  SELECT TOP 1 [shipments_order]  " +
                        "             ,[quotes_id] " +
                        "             ,[client_id] " +
                        "             ,GETDATE()  " +
                        "             ,'0'  " +
                        "             ,'" + Session["sId"].ToString() + "'  " +
                        "             ,GETDATE()  " +
                        "             ,'" + Session["sId"].ToString() + "'  " +
                        "             ,GETDATE()  " +
                        "  FROM [MNDTquotes_master]  " +
                        "  WHERE [shipments_order] = '" + sOrder + "'  ";
        if (Functions.fnExecuteSQL(sSql, "MNDT") == "")
        {
            fnInsertSalesD(sOrder);
        }
        else
        {
            Functions.fnShowMessage(this, Functions.fnExecuteSQL(sSql, "MNDT"), "進貨主檔新增失敗");
        }
    }

    private void fnInsertSalesD(string sOrder)
    {
        string sSql = "  INSERT INTO [MNDTsales_details]  " +
                        "             ([shipments_order]  " +
                        "             ,[product_kind]  " +
                        "             ,[product_code]  " +
                        "             ,[sales_amount]  " +
                        "             ,[sales_money]  " +
                        "  		      ,[sales_complete]  " +
                        "             ,[create_user_id]  " +
                        "             ,[create_datetime]  " +
                        "             ,[modify_user_id]  " +
                        "             ,[modify_datetime])  " +
                        "  SELECT shipments_order  " +
                        "             ,product_kind  " +
                        "             ,product_code  " +
                        "             ,quotes_amount_mod  " +
                        "             ,quotes_money_mod  " +
                        "  		      ,'0'  " +
                        "             ,'" + Session["sId"].ToString() + "'  " +
                        "             ,GETDATE()  " +
                        "             ,'" + Session["sId"].ToString() + "'  " +
                        "             ,GETDATE()  " +
                        "  FROM [MNDTquotes_details]  " +
                        "  WHERE [shipments_order] = '" + sOrder + "'  ";
        Functions.fnShowMessage(this, Functions.fnExecuteSQL(sSql, "MNDT"), "報價成功");
    }

    private void fnOpenEdit(string sOrder)
    {
        multi_view.ActiveViewIndex = 1;
        fnSetSelectMasterView(sOrder);
        sds_detail.SelectParameters["shipments_order"].DefaultValue = sOrder;
        sds_detail.DataBind();
        grid_data_d.DataBind();
        panel_detail.Visible = true;
        fv_master_form.ChangeMode(FormViewMode.Edit);
        ViewState["sSqlDatail"] = sds_detail.SelectCommand.Replace("@shipments_order", "'" + sOrder + "'");
    }

    private void fnSetSelectMasterView(string sOrder)
    {
        string sMasterSql = "  SELECT TOP 1 [shipments_order]  " +
                           "        ,[quotes_id]  " +
                           "        ,[client_id]  " +
                           "        ,CONVERT(char, [quotes_datetime], 111) 'quotes_datetime'  " +
                           "        ,CASE [quotes_complete] WHEN '1' THEN '已報價' ELSE '報價中' END 'quotes_complete'  " +
                           "        ,[quotes_remarks]  " +
                           "  FROM [MNDTquotes_master]  " +
                           "  WHERE [shipments_order] = '" + sOrder + "' ";
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
                        "  	AND [code] = 'A02'  " +
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
            sOrderNum = "DT" + DateTime.Now.ToString("yyyyMMdd") + sOrderNum;
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
                            "  	AND [code] = 'A02'  ";
        return Functions.fnExecuteSQL(sSql2, "MNDT");
    }

    private void fnInsertMaster()
    {
        sds_main.InsertParameters["shipments_order"].DefaultValue = fnGetOrderNum();
        sds_main.InsertParameters["quotes_id"].DefaultValue = ((DropDownList)fv_master_form.FindControl("drop_insert_quotes_id")).SelectedValue;
        sds_main.InsertParameters["quotes_datetime"].DefaultValue = ((TextBox)fv_master_form.FindControl("text_insert_quotes_datetime")).Text;
        sds_main.InsertParameters["quotes_remarks"].DefaultValue = ((TextBox)fv_master_form.FindControl("text_insert_quotes_remarks")).Text;
        sds_main.InsertParameters["client_id"].DefaultValue = ((DropDownList)fv_master_form.FindControl("drop_insert_client_id")).SelectedValue;
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

        sds_detail.InsertParameters["shipments_order"].DefaultValue = ((TextBox)fv_master_form.FindControl("text_edit_shipments_order")).Text;
        sds_detail.InsertParameters["product_kind"].DefaultValue = ((DropDownList)ctControl.FindControl("drop_product_kind")).SelectedValue;
        sds_detail.InsertParameters["product_code"].DefaultValue = ((DropDownList)ctControl.FindControl("drop_product_code")).SelectedValue;
        sds_detail.InsertParameters["quotes_amount"].DefaultValue = ((TextBox)ctControl.FindControl("text_quotes_amount")).Text;
        sds_detail.InsertParameters["quotes_money"].DefaultValue = ((TextBox)ctControl.FindControl("text_quotes_money")).Text;
        sds_detail.InsertParameters["quotes_remarks"].DefaultValue = ((TextBox)ctControl.FindControl("text_quotes_remarks")).Text;
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

    protected void text_quotes_amount_TextChanged(object sender, EventArgs e)
    {
        TextBox textData = ((TextBox)sender);
        try
        {
            float iAmount = float.Parse(textData.Text.ToString());
            float iPrice = float.Parse(ViewState["detail_pruduct_unit"].ToString());
            TextBox textMoney = ((TextBox)textData.Parent.FindControl("text_quotes_money"));
            textMoney.Text = (iAmount * iPrice).ToString("f3");
        }
        catch
        { }
    }
    protected void drop_quotes_id_DataBinding(object sender, EventArgs e)
    {
        string sSql = "  SELECT [account_id]  " +
                        "        ,[account_id] + '：' + [account_name]  " +
                        "  FROM [MNDTaccount]  " +
                        "  WHERE [account_department] = '0003'  ";
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
        string sSql = "  SELECT ISNULL([product_pricing], '0')  " +
                        "  FROM [MNDTproduct_details]  " +
                        "  WHERE [product_kind] = '" + ViewState["detail_kind"].ToString() + "'  " +
                        "       AND [product_code] = '" + sCode + "' ";
        ViewState["detail_pruduct_unit"] = Functions.fnGetValue(sSql, "MNDT");
    }
    protected void sds_detail_Deleted(object sender, SqlDataSourceStatusEventArgs e)
    {
        Functions.fnSQLActionMessage(this, e, "刪除成功");
    }
    protected void drop_client_id_DataBinding(object sender, EventArgs e)
    {
        string sSql = "  SELECT [client_id]  " +
                        "        ,[client_id] + '：' + [client_name]  " +
                        "  FROM [MNDTclient]  ";
        Functions.fnSetDropDownList(sSql, ((DropDownList)sender));
    }
}