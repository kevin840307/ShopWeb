<%@ WebHandler Language="C#" Class="ClientHandler" %>

using System;
using System.Web;
using System.Data;

public class ClientHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    private ClientRepository g_clientRepository = new ClientRepository();
    private Client g_client = new Client();

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string sMethod = context.Request.QueryString["method"];
        sMethod = (sMethod == null) ? context.Request.Form["method"] : sMethod;
        if (sMethod != null)
        {
            PublicApi.fnReadLoginCookie(context);
            if (context.Session["id"] != null)
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
        string sClientId = context.Request.QueryString["client_id"];
        string sPassword = context.Request.QueryString["password"];
        string sEmail = context.Request.QueryString["email"];
        string sName = context.Request.QueryString["name"];
        string sPhone = context.Request.QueryString["phone"];
        string sTel = context.Request.QueryString["tel"];
        string sAddress = context.Request.QueryString["address"];
        string sDescription = context.Request.QueryString["description"];
        string sStatus = context.Request.QueryString["status"];
        string sOrder = context.Request.QueryString["order"];

        g_client.ClientId(sClientId)
                .Password(sPassword)
                .Name(sName)
                .Email(sEmail)
                .Phone(sPhone)
                .Tel(sTel)
                .Address(sAddress)
                .Description(sDescription)
                .Status(sStatus)
                .CreateId(context.Session["id"].ToString())
                .Order(sOrder);
    }

    #region Client

    public void fnSelects(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sOrder = context.Request.QueryString["order"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];

        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);

            DataTable dtData = g_clientRepository.fnSelects(g_client, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCount(HttpContext context)
    {
        string sSize = g_clientRepository.fnCount(g_client);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnSelect(HttpContext context)
    {
        DataTable dtData = g_clientRepository.fnSelect(g_client);

        if (dtData.Rows.Count == 1)
        {
            string sPassword = AESEncryption.AESDecryptString(dtData.Rows[0][2].ToString()).Replace("\0", "");
            dtData.Rows[0][2] = sPassword;
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnSelectClientId(HttpContext context)
    {
        string sMsg = "Y";
        string sNUM = context.Request.QueryString["NUM"];
        string sClientId = g_clientRepository.fnSelectClientId(g_client, sNUM);

        if (sClientId == " ")
        {
            sMsg = "訊息：已無下筆資料。";
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"client_id\":\"" + sClientId + "\", \"NUM\":\"" + sNUM + "\"}");
    }


    public void fnInsert(HttpContext context)
    {
        string sMsg = fnCheckData(g_client);

        if (sMsg == "Y")
        {
            string sEncryptPassword = AESEncryption.AESEncryptString(g_client.password);
            g_client.EncryptPassword(sEncryptPassword);
            sMsg = g_clientRepository.fnInsert(g_client);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"client_id\":\"" + g_client.client_id + "\"}");
    }

    public void fnUpdate(HttpContext context)
    {
        string sMsg = fnCheckData(g_client);

        if (sMsg == "Y")
        {
            string sIP = PublicApi.fnRetrieveIP(context.Request);
            string sEncryptPassword = AESEncryption.AESEncryptString(g_client.password);

            g_client.EncryptPassword(sEncryptPassword);
            sMsg = g_clientRepository.fnUpdate(g_client, sIP, g_client.create_id);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    public void fnDelete(HttpContext context)
    {
        string sMsg = "Y";
        string sIP = PublicApi.fnRetrieveIP(context.Request);

        sMsg = g_clientRepository.fnDelete(g_client, sIP, g_client.create_id);
        sMsg = sMsg.Replace("\r\n", "");
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    public void fnDeletes(HttpContext context)
    {
        string sMsg = "Y";
        string sIP = PublicApi.fnRetrieveIP(context.Request);

        sMsg = g_clientRepository.fnDeletes(g_client, sIP, g_client.create_id);
        sMsg = sMsg.Replace("\r\n", "");
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    public void fnExport(HttpContext context)
    {
        string sMsg = "Y";
        DataTable dtData = g_clientRepository.fnExport(g_client);
        bool bCheck = PublicApi.fnExportDataTableToExcel(dtData, 0, "Client", context);

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
        DataTable dtData = g_clientRepository.fnSelects(g_client);

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
        DataTable dtData = g_clientRepository.fnSelects(g_client);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnLogin(HttpContext context)
    {

        string sMsg = "Y";
        string sEncryptPassword = AESEncryption.AESEncryptString(g_client.password);

        g_client.EncryptPassword(sEncryptPassword);
        DataTable dtData = g_clientRepository.fnLogin(g_client);

        if (dtData.Rows.Count == 1)
        {
            fnWriteLoginCookie(context
                , dtData.Rows[0][0].ToString()
                , dtData.Rows[0][1].ToString()
                , g_client.client_id
                , g_client.password);
        }
        else
        {
            sMsg = "錯誤訊息：帳號密碼錯誤。";
        }

        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    public void fnWriteLoginCookie(HttpContext context, string sId, string sName, string sClientId, string sPassword)
    {
        HttpCookie htCookie = new HttpCookie("login");
        htCookie.Values.Add("id", sId);
        htCookie.Values.Add("client_id", sClientId);
        htCookie.Values.Add("password", sPassword);
        htCookie.Values.Add("name", sName);
        htCookie.Expires = DateTime.Now.AddYears(1);
        HttpContext.Current.Response.Cookies.Add(htCookie);
        context.Session["id"] = sId;
        context.Session["client_id"] = sClientId;
        context.Session["password"] = sPassword;
        context.Session["name"] = sName;
    }

    public void fnLogout(HttpContext context)
    {
        HttpCookie htCookie = new HttpCookie("login");
        htCookie.Expires = DateTime.Now.AddDays(-1);
        HttpContext.Current.Response.Cookies.Add(htCookie);
        context.Session["id"] = null;
        context.Session["client_id"] = null;
        context.Session["password"] = null;
        context.Session["name"] = null;
    }

    public void fnSelectList(HttpContext context)
    {
        if (context.Session["id"] != null)
        {
            ClientRepository clientRepository = new ClientRepository();
            DataTable dtData = clientRepository.fnSelectList();
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    private string fnCheckData(Client client)
    {
        string sMsg = "Y";
        if (client.client_id.Length > 15)
        {
            sMsg = "錯誤訊息：帳號長度錯誤。";
        }
        else if (client.password.Length > 15)
        {
            sMsg = "錯誤訊息：密碼長度錯誤。";
        }
        else if (client.name.Length > 10)
        {
            sMsg = "錯誤訊息：名稱長度錯誤。";

        }
        else if (client.phone.Length > 10)
        {
            sMsg = "錯誤訊息：手機長度錯誤。";
        }
        else if (client.address.Length > 50)
        {
            sMsg = "錯誤訊息：地址長度錯誤。";
        }
        return sMsg;
    }

    public void fnImport(HttpContext context)
    {
        string sMsg = "Y";
        var fileData = context.Request.Files["FileUpload"];

        fileData.SaveAs(context.Server.MapPath("/\\Import\\Client.xls"));

        string[] sColumns = { "帳號", "密碼", "名子", "地址", "手機" };
        string sSql = "  INSERT INTO [MNDTclient]  " +
               "             ([client]  " +
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

        sMsg = PublicApi.fnImportExcel("Client.xls", sSql, sColumns, context);
        sMsg = sMsg.Replace("\r\n", "");
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    #endregion


    #region ClientTran

    public void fnSelectsTran(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];
        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);
            ClientTran clientTran = new ClientTran();

            clientTran.ClientId(g_client.client_id);
            DataTable dtData = g_clientRepository.fnSelects(clientTran, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCountTran(HttpContext context)
    {
        ClientTran clientTran = new ClientTran();

        clientTran.ClientId(g_client.client_id);
        string sSize = g_clientRepository.fnCount(clientTran);
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