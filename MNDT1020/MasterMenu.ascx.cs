using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterMenu : System.Web.UI.UserControl
{
    DataTable g_dtData = null;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["iHide"] == null) Session["iHide"] = 0;
        fnMenuSH();
        if (!IsPostBack)
        {
            if (Session["sid"] == null)
            {
                string sJavaScript = "<script language=javascript>location.href='Login.aspx';</script>";
                this.Literal1.Text = sJavaScript;
            }
            else
            {
                fnInitMenu();
            }
        }
    }

    private void fnMenuSH()
    {
        if (Session["iHide"].ToString() == "1")
        {
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "menu_hide", "menu_hide();", true);
            link_show_hide.Text = "顯示";
        }
        else
        {
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "menu_show", "menu_show();", true);
            link_show_hide.Text = "隱藏";
        }
    }

    private void fnInitMenu()
    {
        DataTable dtProgram = fnGetProgram();
        g_dtData = Functions.fnGetProgrameAuthority(Session["sId"].ToString());
        fnSetMenuRoot(ref dtProgram);
    }

    private DataTable fnGetProgram()
    {
        string sSql = "  SELECT [program_id]  " +
                        "        ,[program_name]  " +
                        "        ,[program_parent]  " +
                        "  FROM [MNDTprogram_master]  ";
        return Functions.fnGetDt(sSql, "MNDT");
    }

    private void fnSetMenuRoot(ref DataTable dtProgram)
    {
        string sURLCompare = System.IO.Path.GetFileName(Request.PhysicalPath).Substring(4, 1);
        string sSelet = "program_parent = 'ROOT'";
        DataRow[] drRoot = dtProgram.Select(sSelet);
        lt_html.Text = "";
        if (Session["iHide"].ToString() == "1")
        {
            lt_html.Text += " <ul class=\"menu hide-obj\"> ";
        }
        else
        {
            lt_html.Text += " <ul class=\"menu\"> ";
        }

        for (int iPos = 0; iPos < drRoot.Length; iPos++)
        {
            string sHideClass = "hide-obj";
            string sPressClass = "";
            string sIcoClass = "up";
            
            if (sURLCompare == drRoot[iPos][0].ToString().Substring(4, 1))
            {
                sHideClass = "";
                sPressClass = "current";
                sIcoClass = "down";
            }
           
            lt_html.Text += " <li class=\"level1 " + sPressClass + "" + drRoot[iPos][0].ToString() + "\"> ";
            lt_html.Text += " <a href=\"#none\" class=\"" + sPressClass + "\"><em class=\"ico ico1\"></em>" + drRoot[iPos][1].ToString() + "<i class=\"" + sIcoClass + "\"></i></a> ";
            lt_html.Text += " <ul class=\"level2 " + sHideClass + "\"> ";
            fnSetMenuChild(ref dtProgram, drRoot[iPos][0].ToString());
            lt_html.Text += " </ul> ";
            lt_html.Text += " </li> ";
        }
        lt_html.Text += " <li class=\"logout\"> ";
        lt_html.Text += " <a href=\"Login.aspx\"><em class=\"sico ico5\"></em>登出</a> ";
        lt_html.Text += " </li> ";
        lt_html.Text += " </ul>";
    }

    private void fnSetMenuChild(ref DataTable dtProgram, string sRootId)
    {
        string sURLCompare = System.IO.Path.GetFileName(Request.PhysicalPath).Substring(0, 8);
        string sSelet = "program_parent = '" + sRootId + "'";
        DataRow[] drChild = dtProgram.Select(sSelet);
        for (int iPos = 0; iPos < drChild.Length; iPos++)
        {
            string sLevel2Class = "";
            if(sURLCompare == drChild[iPos][0].ToString())
            {
                sLevel2Class = "select_style1";
            }
            string sCheckSelect = "program_id = '" + drChild[iPos][0].ToString() + "'";
            DataRow[] drChildAuthority = g_dtData.Select(sCheckSelect);
            if (drChildAuthority.Length > 0)
            {
                lt_html.Text += " <li class=\"" + sLevel2Class + "\"><a class=\"level2-lu-a " + sLevel2Class + "\" href=\"" + drChild[iPos][0].ToString() + ".aspx" + "\" >" + drChild[iPos][1].ToString() + "</a></li> ";
            }
        }
    }
    protected void link_show_hide_Click(object sender, EventArgs e)
    {
        if (Session["iHide"].ToString() == "0")
        {
            Session["iHide"] = 1;
            link_show_hide.Text = "顯示";
            lt_html.Text = lt_html.Text.Replace("menu", "menu hide-obj");
        }
        else
        {
            Session["iHide"] = 0;
            link_show_hide.Text = "隱藏";
            lt_html.Text = lt_html.Text.Replace("menu hide-obj", "menu");
        }
        fnMenuSH();
    }
}