using System;
using System.Collections.Generic;
using System.Data;
using System.EnterpriseServices;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MNDT3040 : System.Web.UI.Page
{
    private void fnSearchData()
    {
        string sMasterSql = "  SELECT [return_m].[return_order]  " +
                            "        ,[return_m].[purchase_order] " +
                            "        ,[return_m].[return_id]  " +
                            "        ,[account].[account_name] " +
                            "        ,CONVERT(char, [return_m].[return_datetime], 111) 'return_datetime'  " +
                            "        ,CONVERT(char, [receive_m].[receive_datetime], 111) 'receive_datetime'  " +
                            "        ,[return_m].[return_remarks]  " +
                            "  FROM [MNDTreturn_master] [return_m] LEFT JOIN [MNDTaccount] [account] " +
                            "  ON [return_m].[return_id] = [account].[account_id] LEFT JOIN [MNDTreceive_master] [receive_m] " +
                            "  ON [return_m].[purchase_order] = [receive_m].[purchase_order] " +
                            "  WHERE 1 = 1 ";
        Functions.fnAddCondition(ref text_purchase_order, ref sMasterSql, "[return_m].[purchase_order]");
        Functions.fnAddConditionDate(ref text_return_datetime, ref sMasterSql, "[return_m].[return_datetime]");
        Functions.fnAddConditionDate(ref text_return_datetime, ref sMasterSql, "[return_m].[return_to_datetime]");
        Functions.fnAddCondition(ref drop_return_id, ref sMasterSql, "[return_m].[return_id]");

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
        ((Label)Master.FindControl("lab_title")).Text = "進貨退貨資料維護<MNDT3040>";
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
        string sSql = "  INSERT INTO [MNDTreturn_master]  " +
                        "             ([purchase_order]  " +
                        "             ,[return_id]  " +
                        "             ,[return_datetime]  " +
                        "             ,[return_to_datetime]  " +
                        "             ,[return_complete]  " +
                        "             ,[return_remarks]  " +
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
                        "             ,'" + Session["sId"] + "' " +
                        "             ,GETDATE()  " +
                        "             ,'" + Session["sId"] + "' " +
                        "             ,GETDATE())  ";
        string sMessage = await Task.Run(() => Functions.fnUploadExcelAsync(fuFileUpload, sSql, 6, this));
        Functions.fnShowLabelMessage(this, sMessage);
        grid_data_m.DataBind();
    }

    private async void fnUploadDetailExcel(FileUpload fuFileUpload)
    {
        string sSql = "  INSERT INTO [MNDTgroup_details]  " +
                        "             ([purchase_order]  " +
                        "             ,[product_kind]  " +
                        "             ,[product_code]  " +
                        "             ,[return_amount]  " +
                        "             ,[return_money]  " +
                        "             ,[return_amount_mod]  " +
                        "             ,[return_money_mod]  " +
                        "             ,[return_remarks]  " +
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
        int iIndex = -1;
        switch (sCommand)
        {
            case "SelectData":
                iIndex = int.Parse(e.CommandArgument.ToString());
                string sROrder = ((Label)grid_data_m.Rows[fnGetGridViewSelect(iIndex)].FindControl("lab_return_order")).Text;
                string sPOrder = ((Label)grid_data_m.Rows[fnGetGridViewSelect(iIndex)].FindControl("lab_purchase_order")).Text;
                ViewState["pOrder"] = ((Label)grid_data_m.Rows[fnGetGridViewSelect(iIndex)].FindControl("lab_purchase_order")).Text;
                fnOpenEdit(sROrder, sPOrder);
                ViewState["SelectMaster"] = iIndex;
                break;
            case "OpenInsert":
                fnOpenInset();
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
        }
    }


    private void fnOpenEdit(string sROrder, string sPOrder)
    {
        ViewState["pOrder"] = sPOrder;
        multi_view.ActiveViewIndex = 1;
        fnSetSelectMasterView(sROrder);
        sds_detail.SelectParameters["return_order"].DefaultValue = sROrder;
        sds_detail.SelectParameters["purchase_order"].DefaultValue = sPOrder;
        sds_detail.DataBind();
        grid_data_d.DataBind();
        panel_detail.Visible = true;
        fv_master_form.ChangeMode(FormViewMode.Edit);
        ViewState["sSqlDatail"] = sds_detail.SelectCommand.Replace("@return_order", "'" + sROrder + "'")
                                                           .Replace("@purchase_order", "'" + sPOrder + "'");
    }

    private void fnSetSelectMasterView(string sOrder)
    {
        string sMasterSql = "  SELECT TOP 1 [return_m].[return_order]  " +
                            "        ,[return_m].[purchase_order] " +
                            "        ,[return_m].[return_id]  " +
                            "        ,[account].[account_name] " +
                            "        ,CONVERT(char, [return_m].[return_datetime], 111) 'return_datetime'  " +
                            "        ,CONVERT(char, [receive_m].[receive_datetime], 111) 'receive_datetime'  " +
                            "        ,[return_m].[return_remarks]  " +
                            "  FROM [MNDTreturn_master] [return_m] LEFT JOIN [MNDTaccount] [account] " +
                            "  ON [return_m].[return_id] = [account].[account_id] LEFT JOIN [MNDTreceive_master] [receive_m] " +
                            "  ON [return_m].[purchase_order] = [receive_m].[purchase_order] " +
                            "  WHERE [return_order] = '" + sOrder + "' ";
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
        string sSql1 = "  SELECT COUNT([return_order])  " +
                        "  FROM [MNDTreturn_master]  " +
                        "  WHERE CONVERT(char, [create_datetime], 111) = CONVERT(char, GETDATE(), 111)  ";
        string sOrderNum = Functions.fnGetValue(sSql1, "MNDT");

        while (sOrderNum.Length < 4)
        {
            sOrderNum = "0" + sOrderNum;
        }
        sOrderNum = "QT" + DateTime.Now.ToString("yyyyMMdd") + sOrderNum;
        ViewState["insert_rorder"] = sOrderNum;
        return sOrderNum;
    }

    private void fnInsertMaster()
    {
        sds_main.InsertParameters["return_order"].DefaultValue = fnGetOrderNum();
        sds_main.InsertParameters["purchase_order"].DefaultValue = ((DropDownList)fv_master_form.FindControl("drop_purchase_order")).SelectedValue;
        sds_main.InsertParameters["return_id"].DefaultValue = ((DropDownList)fv_master_form.FindControl("drop_insert_return_id")).SelectedValue;
        sds_main.InsertParameters["return_datetime"].DefaultValue = ((TextBox)fv_master_form.FindControl("text_insert_return_datetime")).Text;
        sds_main.InsertParameters["return_remarks"].DefaultValue = ((TextBox)fv_master_form.FindControl("text_insert_return_remarks")).Text;
        ViewState["insert_porder"] = ((DropDownList)fv_master_form.FindControl("drop_purchase_order")).SelectedValue;
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
            fnOpenEdit(ViewState["insert_rorder"].ToString(), ViewState["insert_porder"].ToString());
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

        sds_detail.InsertParameters["return_order"].DefaultValue = ((TextBox)fv_master_form.FindControl("text_return_order")).Text;
        sds_detail.InsertParameters["product_kind"].DefaultValue = ((DropDownList)ctControl.FindControl("drop_product_kind")).SelectedValue;
        sds_detail.InsertParameters["product_code"].DefaultValue = ((DropDownList)ctControl.FindControl("drop_product_code")).SelectedValue;
        sds_detail.InsertParameters["return_amount"].DefaultValue = ((TextBox)ctControl.FindControl("text_return_amount")).Text;
        sds_detail.InsertParameters["return_money_get"].DefaultValue = ((TextBox)ctControl.FindControl("text_return_money_get")).Text;
        sds_detail.InsertParameters["return_reason"].DefaultValue = ((TextBox)ctControl.FindControl("text_return_reason")).Text;
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

    private bool fnCheckStock(string sOrder, string sKind, string sCode, string sNum)
    {
        string sSql = "  SELECT [receive_amount_mod]  " +
                         "  FROM [MNDTreceive_details]  " +
                         "  WHERE [product_kind] =  '" + sKind + "' " +
                         "  	AND [product_code] =  '" + sCode + "' " +
                         "  	AND [purchase_order] =  '" + sOrder + "' ";
        try
        {
            if (int.Parse(Functions.fnGetValue(sSql, "MNDT")) >= int.Parse(sNum))
            {
                return true;
            }
            return false;
        }
        catch
        {
            return false;
        }
    }

    private void fnSetZero()
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
        ((TextBox)ctControl.FindControl("text_return_amount")).Text = "0";
        ((TextBox)ctControl.FindControl("text_return_money_get")).Text = "0.000";
    }
    protected void text_return_amount_TextChanged(object sender, EventArgs e)
    {
        TextBox textData = ((TextBox)sender);
        TextBox textMoney = ((TextBox)textData.Parent.FindControl("text_return_money_get"));
        string sKind = "";
        string sCode = "";
        string sOrder = ((TextBox)fv_master_form.FindControl("text_edit_purchase_order")).Text;
        try
        {
            sKind = ((DropDownList)textData.Parent.FindControl("drop_product_kind")).SelectedValue;
            sCode = ((DropDownList)textData.Parent.FindControl("drop_product_code")).SelectedValue;
        }
        catch
        {
            sKind = ((Label)textData.Parent.FindControl("lab_product_kind")).Text;
            sCode = ((Label)textData.Parent.FindControl("lab_product_code")).Text;
        }

        if (fnCheckStock(sOrder, sKind, sCode, textData.Text))
        {
            try
            {
                float iAmount = float.Parse(textData.Text.ToString());
                float iPrice = float.Parse(fnGetProductPrice(sKind, sCode));
                textMoney.Text = (iAmount * iPrice).ToString("f3");
            }
            catch
            { }
        }
        else
        {
            fnSetZero();
            Functions.fnShowMessage(this, "進貨數量小於退貨！");
        }
    }
    protected void drop_return_id_DataBinding(object sender, EventArgs e)
    {
        string sSql = "  SELECT [account_id]  " +
                        "        ,[account_id] + '：' + [account_name]  " +
                        "  FROM [MNDTaccount]  " +
                        "  WHERE [account_department] = '0002'  ";
        Functions.fnSetDropDownList(sSql, ((DropDownList)sender));
    }
    protected void drop_product_kind_DataBinding(object sender, EventArgs e)
    {
        string sOrderSql = "  SELECT DISTINCT [product_kind]  " +
                        "  FROM [MNDTreceive_details]  " +
                        "  WHERE [purchase_order] = '" + ViewState["pOrder"].ToString() + "'  ";

        string sSql = "  SELECT [product_kind]  " +
                        "        ,[product_kind] + '：' + [product_kind_name]  " +
                        "  FROM [MNDTproduct_master]  " +
                        "  WHERE 1 = 1 ";
        Functions.fnAddCondition(ref sSql, ref sOrderSql, "[product_kind]");
        Functions.fnSetDropDownList(sSql, ((DropDownList)sender));
    }
    protected void drop_product_kind_SelectedIndexChanged(object sender, EventArgs e)
    {
        string sKind = ((DropDownList)sender).SelectedValue;
        DropDownList dropCode = ((DropDownList)((DropDownList)sender).Parent.FindControl("drop_product_code"));

        string sOrderSql = "  SELECT DISTINCT [product_code]  " +
                        "  FROM [MNDTreceive_details]  " +
                        "  WHERE [product_kind] = '" + sKind + "' " +
                        "   AND [purchase_order] = '" + ViewState["pOrder"].ToString() + "'  ";

        string sSql = "  SELECT [product_code]  " +
                        "        ,[product_code] + '：' + [product_code_name]  " +
                        "  FROM [MNDTproduct_details]  " +
                        "  WHERE [product_kind] = '" + sKind + "'  ";

        Functions.fnAddCondition(ref sSql, ref sOrderSql, "[product_code]");
        ViewState["detail_kind"] = sKind;
        Functions.fnSetDropDownList(sSql, dropCode);
    }
    protected void drop_product_code_SelectedIndexChanged(object sender, EventArgs e)
    {
        string sCode = ((DropDownList)sender).SelectedValue;
        ViewState["detail_pruduct_unit"] = fnGetProductPrice(ViewState["detail_kind"].ToString(), sCode);
        fnSetZero();
    }

    private string fnGetProductPrice(string sKind, string sCode)
    {
        string sSql = "  SELECT ISNULL([product_cost], '0')  " +
                       "  FROM [MNDTproduct_details]  " +
                       "  WHERE [product_kind] = '" + sKind + "'  " +
                       "       AND [product_code] = '" + sCode + "' ";
        return Functions.fnGetValue(sSql, "MNDT");
    }
    protected void sds_detail_Deleted(object sender, SqlDataSourceStatusEventArgs e)
    {
        Functions.fnSQLActionMessage(this, e, "刪除成功");
    }
    protected void drop_purchase_order_DataBinding(object sender, EventArgs e)
    {
        DropDownList dropData = ((DropDownList)sender);
        string sSql = "  SELECT [purchase_order]  " +
                        "        ,[purchase_order]  " +
                        "  FROM [MNDTreceive_master]  ";
        Functions.fnSetDropDownList(sSql, dropData);
    }
    protected void text_insert_receive_datetime_DataBinding(object sender, EventArgs e)
    {
        DropDownList dropData = ((DropDownList)sender);
        string sSql = "  SELECT [purchase_order]  " +
                        "        ,CONVERT(char, [receive_datetime], 111)  " +
                        "  FROM [MNDTreceive_master]  ";
        Functions.fnSetDropDownList(sSql, dropData);
    }
    protected void drop_purchase_order_SelectedIndexChanged(object sender, EventArgs e)
    {
        DropDownList dropData = ((DropDownList)fv_master_form.FindControl("text_insert_receive_datetime"));
        dropData.SelectedValue = ((DropDownList)sender).SelectedValue;
    }
    protected void text_insert_receive_datetime_SelectedIndexChanged(object sender, EventArgs e)
    {
        DropDownList dropData = ((DropDownList)fv_master_form.FindControl("drop_purchase_order"));
        dropData.SelectedValue = ((DropDownList)sender).SelectedValue;
    }
}