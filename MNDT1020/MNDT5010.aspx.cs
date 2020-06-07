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
using System.Text;

public partial class MNDT5010: System.Web.UI.Page
{
    private void fnSearchData()
    {


        string sMasterSql = "  SELECT [product_kind]  " +
                            "        ,[product_code]  " +
                            "        ,[product_code_name]  " +
                            "        ,[company_id]  " +
                            "        ,[product_unit]  " +
                            "        ,[product_norm]  " +
                            "        ,[product_cost]  " +
                            "        ,[product_pricing]  " +
                            "        ,[product_deadline] " +
                            "        ,SUBSTRING([product_remarks], 1, 10) 'product_remarks'  " +
                            "        ,[create_user_id]  " +
                            "        ,CONVERT(char, [create_datetime], 111) AS 'create_datetime'  " +
                            "        ,[modify_user_id]  " +
                            "        ,CONVERT(char, [modify_datetime], 111) AS 'modify_datetime'  " +
                            "  FROM [MNDTproduct_details]  " +
                            "  WHERE 1 = 1 ";
        Functions.fnAddCondition(ref text_product_kind, ref sMasterSql, "[product_kind]");
        Functions.fnAddCondition(ref text_product_code_name, ref sMasterSql, "[product_code_name]");
        Functions.fnAddCondition(ref text_product_code, ref sMasterSql, "[product_code]");
        fnAddKindNameCondition(ref sMasterSql);
        sds_main.SelectCommand = sMasterSql;
        sds_main.DataBind();
        grid_data_m.DataBind();
        ViewState["sSqlSearch"] = sMasterSql;
    }

    private void fnAddKindNameCondition(ref string sMasterSql)
    {
        string sDetailSql = "  SELECT [product_kind]  " +
                            "  FROM [MNDTproduct_master] " +
                            "  WHERE 1 = 1  ";
        if (text_product_kind_name.Text.Length > 0)
        {
            Functions.fnAddCondition(ref text_product_kind_name, ref sDetailSql, "[product_kind_name]");
            Functions.fnAddCondition(ref sMasterSql, ref sDetailSql, "[product_kind]");
        }
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
        ((Label)Master.FindControl("lab_title")).Text = "存貨資料維護<MNDT5010>";
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
            case "SelectData":
                int iIndex = int.Parse(e.CommandArgument.ToString());
                string sProductKind = ((Label)grid_data_m.Rows[fnGetGridViewSelect(iIndex)].FindControl("lab_product_kind")).Text.ToString();
                string sProductCode = ((Label)grid_data_m.Rows[fnGetGridViewSelect(iIndex)].FindControl("lab_product_code")).Text.ToString();
                fnOpenEdit(sProductKind, sProductCode);
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
    }

    private void fnOpenEdit(string sProductKind, string sProductCode)
    {
        multi_view.ActiveViewIndex = 1;
        fnSetSelectMasterView(sProductKind, sProductCode);
    }

    private void fnSetSelectMasterView(string sProductKind, string sProductCode)
    {
        ViewState["product_kind"] = sProductKind;
        ViewState["product_code"] = sProductCode;
        sds_detail.SelectParameters["product_kind"].DefaultValue = sProductKind;
        sds_detail.SelectParameters["product_code"].DefaultValue = sProductCode;
        sds_detail.DataBind();
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
        GridView gridData = fnGetNowGridView();
        GridViewEvent.fnGridViewRowDataBound(this, ref gridData, e.Row, 40, "#89BBFE", "#FFFFFF");
    }

    protected void grid_data_SelectedIndexChanged(object sender, EventArgs e)
    {
        GridView gridData = fnGetNowGridView();
        GridViewEvent.fnGridViewSelectedIndexChanged(ref gridData, "#89BBFE");
    }

    protected void grid_data_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        GridView gridData = fnGetNowGridView();
        GridViewEvent.fnGridViewSelectedIndexChanging(this, ref gridData, "#FFFFFF", "#000000");
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
        string sSql = "  INSERT INTO [MNDTproduct_master]  " +
                        "             ([product_kind]  " +
                        "             ,[product_kind_name]  " +
                        "             ,[product_description]  " +
                        "             ,[product_remarks]  " +
                        "             ,[create_user_id]  " +
                        "             ,[create_datetime]  " +
                        "             ,[modify_user_id]  " +
                        "             ,[modify_datetime])  " +
                        "       VALUES  " +
                        "             ('{code1}' " +
                        "             ,'{code2}' " +
                        "             ,'{code3}' " +
                        "             ,'{code4}' " +
                        "             ,'" + Session["sId"] + "' " +
                        "             ,GETDATE()  " +
                        "             ,'" + Session["sId"] + "' " +
                        "             ,GETDATE())  ";
        string sMessage = await Task.Run(() => Functions.fnUploadExcelAsync(fuFileUpload, sSql, 4, this));
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
        Session["PrintDT"] = Functions.fnGetDt("SELECT * FROM [MNDTaccount]", "MNDT");
        Literal1.Text = "<script type=\"text/javascript\">window.open('ReportPage.aspx?ReportName=MNDT2020.rpt','','resizable=yes,location=no')</script>";
    }


    private void fnCloseEdit()
    {
        multi_view.ActiveViewIndex = 0;
        fnSearchData();
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
    protected void drop_warehouse_id_DataBinding(object sender, EventArgs e)
    {
        DropDownList dropData = ((DropDownList)sender);
        string sSql = "  SELECT [warehouse_id]  " +
                        "        ,[warehouse_id] + '：' + [warehouse_name]  " +
                        "  FROM [MNDTwarehouse]  ";
        Functions.fnSetDropDownList(sSql, dropData);
    }

    private void fnSearchStock()
    {
        string sSql = "  SELECT [stock].[product_kind]  " +
                        "  	     ,[product_m].[product_kind_name]  " +
                        "        ,[stock].[product_code]  " +
                        "  	     ,[product_d].[product_code_name]  " +
                        "        ,[stock].[purchase_order]  " +
                        "        ,[stock].[warehouse_id]  " +
                        "  	     ,[warehouse].[warehouse_name]  " +
                        "        ,[stock].[stock_amount]  " +
                        "        ,[stock].[stock_adjustment_date]  " +
                        "        ,[stock].[stock_remarks]  " +
                        "  	     ,CONVERT(char, [stock].[stock_date], 111) 'stock_date'  " +
                        "  FROM [MNDTstock] [stock] LEFT JOIN [MNDTproduct_master] [product_m]  " +
                        "  ON [stock].[product_kind] = [product_m].[product_kind] LEFT JOIN [MNDTproduct_details] [product_d]  " +
                        "  ON [stock].[product_kind] = [product_d].[product_kind]  " +
                        "  	AND [stock].[product_code] = [product_d].[product_code] LEFT JOIN [MNDTwarehouse] [warehouse]  " +
                        "  ON [stock].[warehouse_id] = [warehouse].[warehouse_id] " +
                        "  WHERE [stock].[product_kind] = '" + ViewState["product_kind"].ToString() + "'  " +
                        "  	AND [stock].[product_code] = '" + ViewState["product_code"].ToString() + "'  ";

        Functions.fnAddCondition(ref text_purchase_order, ref sSql, "[stock].[purchase_order]");
        Functions.fnAddConditionDate(ref text_stock_date, ref sSql, "[stock].[stock_date]");
        sds_detail.SelectCommand = sSql;
        sds_detail.DataBind();
        grid_data_d.DataBind();
        ViewState["sSqlDetail"] = sSql;
    }
    protected void btn_serarch_stock_Click(object sender, EventArgs e)
    {
        fnSearchStock();
    }
    protected void btn_master_cancel_Click(object sender, EventArgs e)
    {
        fnCloseEdit();
    }
    protected void sds_detail_Updated(object sender, SqlDataSourceStatusEventArgs e)
    {
        Functions.fnSQLActionMessage(this, e, "更新成功");
    }
}