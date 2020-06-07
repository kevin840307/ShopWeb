using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btn_account_login_Click(object sender, EventArgs e)
    {
        string sId = text_account_id.Text.ToString();
        string sPassword = text_account_password.Text.ToString();
        DataTable dtData = Functions.fnLoginDT(ref sId, ref sPassword);
        if(dtData.Rows.Count == 1)
        {
            Session["sId"] = sId;
            Session["sIdName"] = dtData.Rows[0][0].ToString() ;
            string sJavaScript = "<script language=javascript>location.href='Menu.aspx';</script>";
            this.Literal1.Text = sJavaScript;
        }
        else
        {
            lab_error.Text = "帳號或密碼錯誤";
            //string sJavaScript = "<script language=javascript>alert('登入失敗!');</script>";
            //this.Literal1.Text = sJavaScript;
        }

    }
}