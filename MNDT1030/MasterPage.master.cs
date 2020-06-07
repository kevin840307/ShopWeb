using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class MasterPage : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            PublicApi.fnReadLoginCookie(this.Context);
            if (Session["id"] == null || Session["id"].ToString().Length == 0)
            {
                Response.Redirect("Login.aspx");
            }
        }
    }


}
