<%@ WebHandler Language="C#" Class="AccountHandler" %>

using System;
using System.Web;
using System.Data;

public class AccountHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    private UserRepository g_userRepository = new UserRepository();
    private User g_user = new User();

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string sMethod = context.Request.QueryString["method"];
        sMethod = (sMethod == null) ? context.Request.Form["method"] : sMethod;
        if (sMethod != null)
        {
            PublicApi.fnReadLoginCookie(context);
            if (sMethod == "fnLogin" || context.Session["id"] != null)
            {
                System.Reflection.MethodInfo methodInfo = this.GetType().GetMethod(sMethod);
                if (methodInfo != null)
                {
                    fnInitData(context);
                    methodInfo.Invoke(this, new object[] { context });
                }
            }
        }
    }

    private void fnInitData(HttpContext context)
    {
        string sId = context.Request.QueryString["id"];
        string sAccount = context.Request.QueryString["account"];
        string sPassword = context.Request.QueryString["password"];
        string sName = context.Request.QueryString["name"];
        string sPhone = context.Request.QueryString["phone"];
        string sAddress = context.Request.QueryString["address"];
        string sStatus = context.Request.QueryString["status"];
        string sOrder = context.Request.QueryString["order"];

        g_user.Id(sId)
                .Account(sAccount)
                .Password(sPassword)
                .Name(sName)
                .Phone(sPhone)
                .Address(sAddress)
                .Status(sStatus)
                .CreateId(PublicApi.fnNullChange(context.Session["id"], ""))
                .Order(sOrder);
    }

    #region User

    public void fnSelects(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sOrder = context.Request.QueryString["order"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];

        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);

            DataTable dtData = g_userRepository.fnSelects(g_user, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCount(HttpContext context)
    {
        string sSize = g_userRepository.fnCount(g_user);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnSelect(HttpContext context)
    {
        DataTable dtData = g_userRepository.fnSelect(g_user);

        if (dtData.Rows.Count == 1)
        {
            string sPassword = AESEncryption.AESDecryptString(dtData.Rows[0][2].ToString()).Replace("\0", "");
            dtData.Rows[0][2] = sPassword;
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnSelectId(HttpContext context)
    {
        string sMsg = "Y";
        string sNUM = context.Request.QueryString["NUM"];
        string sId = g_userRepository.fnSelectId(g_user, sNUM);

        if (sId == " ")
        {
            sMsg = "訊息：已無下筆資料。";
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"id\":\"" + sId + "\", \"NUM\":\"" + sNUM + "\"}");
    }


    public void fnInsert(HttpContext context)
    {
        string sMsg = fnCheckData(g_user);

        if (sMsg == "Y")
        {
            string sEncryptPassword = AESEncryption.AESEncryptString(g_user.password);
            g_user.EncryptPassword(sEncryptPassword);
            sMsg = g_userRepository.fnInsert(g_user);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"account\":\"" + g_user.account + "\"}");
    }

    public void fnUpdate(HttpContext context)
    {
        string sMsg = fnCheckData(g_user);

        if (sMsg == "Y")
        {
            string sIP = PublicApi.fnRetrieveIP(context.Request);
            string sEncryptPassword = AESEncryption.AESEncryptString(g_user.password);

            g_user.EncryptPassword(sEncryptPassword);
            sMsg = g_userRepository.fnUpdate(g_user, sIP, g_user.create_id);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    public void fnDelete(HttpContext context)
    {
        string sMsg = "Y";
        string sIP = PublicApi.fnRetrieveIP(context.Request);

        sMsg = g_userRepository.fnDelete(g_user, sIP, g_user.create_id);
        sMsg = sMsg.Replace("\r\n", "");
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    public void fnDeletes(HttpContext context)
    {
        string sMsg = "Y";
        string sIP = PublicApi.fnRetrieveIP(context.Request);

        sMsg = g_userRepository.fnDeletes(g_user, sIP, g_user.create_id);
        sMsg = sMsg.Replace("\r\n", "");
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    public void fnExport(HttpContext context)
    {
        string sMsg = "Y";
        DataTable dtData = g_userRepository.fnExport(g_user);
        bool bCheck = PublicApi.fnExportDataTableToExcel(dtData, 0, "User", context);

        if (!bCheck)
        {
            sMsg = "錯誤訊息：匯出失敗。";
        }
        sMsg = sMsg.Replace("\r\n", "");
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    public void fnReport(HttpContext context)
    {
        string sMsg = "Y";
        DataTable dtData = g_userRepository.fnSelects(g_user);

        if (dtData.Rows.Count > 0)
        {
            context.Session["PrintDT"] = dtData;
        }
        else
        {
            sMsg = "錯誤訊息：筆數少於一筆。";
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    public void fnPrint(HttpContext context)
    {
        DataTable dtData = g_userRepository.fnSelects(g_user);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnLogin(HttpContext context)
    {

        string sMsg = "Y";
        string sEncryptPassword = AESEncryption.AESEncryptString(g_user.password);

        g_user.EncryptPassword(sEncryptPassword);
        DataTable dtData = g_userRepository.fnLogin(g_user);

        if (dtData.Rows.Count == 1)
        {
            fnWriteLoginCookie(context
                , dtData.Rows[0][0].ToString()
                , dtData.Rows[0][1].ToString()
                , g_user.account
                , g_user.password);
        }
        else
        {
            sMsg = "錯誤訊息：帳號密碼錯誤。";
        }

        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    public void fnWriteLoginCookie(HttpContext context, string sId, string sName, string sAccountId, string sPassword)
    {
        HttpCookie htCookie = new HttpCookie("login");
        htCookie.Values.Add("id", sId);
        htCookie.Values.Add("account_id", sAccountId);
        htCookie.Values.Add("password", sPassword);
        htCookie.Values.Add("name", sName);
        htCookie.Expires = DateTime.Now.AddYears(1);
        HttpContext.Current.Response.Cookies.Add(htCookie);
        context.Session["id"] = sId;
        context.Session["account_id"] = sAccountId;
        context.Session["password"] = sPassword;
        context.Session["name"] = sName;
    }

    public void fnLogout(HttpContext context)
    {
        HttpCookie htCookie = new HttpCookie("login");
        htCookie.Expires = DateTime.Now.AddDays(-1);
        HttpContext.Current.Response.Cookies.Add(htCookie);
        context.Session["id"] = null;
        context.Session["account_id"] = null;
        context.Session["password"] = null;
        context.Session["name"] = null;
    }

    public void fnSelectList(HttpContext context)
    {
        if (context.Session["id"] != null)
        {
            UserRepository userRepository = new UserRepository();
            DataTable dtData = userRepository.fnSelectList();
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    private string fnCheckData(User user)
    {
        string sMsg = "Y";
        if (user.account.Length > 15)
        {
            sMsg = "錯誤訊息：帳號長度錯誤。";
        }
        else if (user.password.Length > 15)
        {
            sMsg = "錯誤訊息：密碼長度錯誤。";
        }
        else if (user.name.Length > 10)
        {
            sMsg = "錯誤訊息：名稱長度錯誤。";

        }
        else if (user.phone.Length > 10)
        {
            sMsg = "錯誤訊息：手機長度錯誤。";
        }
        else if (user.address.Length > 50)
        {
            sMsg = "錯誤訊息：地址長度錯誤。";
        }
        return sMsg;
    }

    public void fnImport(HttpContext context)
    {
        string sMsg = "Y";
        var fileData = context.Request.Files["FileUpload"];

        fileData.SaveAs(context.Server.MapPath("/\\Import\\User.xls"));

        string[] sColumns = { "帳號", "密碼", "名子", "地址", "手機" };
        string sSql = "  INSERT INTO [MNDTuser]  " +
               "             ([account]  " +
               "             ,[password]  " +
               "             ,[name]  " +
               "             ,[address]  " +
               "             ,[phone]  " +
               "             ,[create_id]  " +
               "             ,[create_datetime])  " +
               "       VALUES  " +
               "             ('{" + sColumns[0] + "}'  " +
               "             ,'{" + sColumns[1] + "}'  " +
               "             ,'{" + sColumns[2] + "}'  " +
               "             ,'{" + sColumns[3] + "}'  " +
               "             ,'{" + sColumns[4] + "}'  " +
               "             ,'" + context.Session["id"] + "'  " +
               "             ,GETDATE())  ";

        sMsg = PublicApi.fnImportExcel("User.xls", sSql, sColumns, context);
        sMsg = sMsg.Replace("\r\n", "");
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    #endregion


    #region UserTran

    public void fnSelectsTran(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];
        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);
            UserTran userTran = new UserTran();

            userTran.Id(g_user.id);
            DataTable dtData = g_userRepository.fnSelects(userTran, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCountTran(HttpContext context)
    {
        UserTran userTran = new UserTran();

        userTran.Id(g_user.id);
        string sSize = g_userRepository.fnCount(userTran);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    #endregion

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}