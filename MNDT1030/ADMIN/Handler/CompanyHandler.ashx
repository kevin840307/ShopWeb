<%@ WebHandler Language="C#" Class="CompanyHandler" %>

using System;
using System.Web;
using System.Data;

public class CompanyHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    private CompanyRepository g_companyRepository = new CompanyRepository();
    private Company g_company = new Company();

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
        string sCompanyId = context.Request.QueryString["company_id"];
        string sEmail = context.Request.QueryString["email"];
        string sName = context.Request.QueryString["name"];
        string sTaxId = context.Request.QueryString["tax_id"];
        string sPhone = context.Request.QueryString["phone"];
        string sPay = context.Request.QueryString["pay"];
        string sTel = context.Request.QueryString["tel"];
        string sAddress = context.Request.QueryString["address"];
        string sDescription = context.Request.QueryString["description"];
        string sStatus = context.Request.QueryString["status"];
        string sOrder = context.Request.QueryString["order"];

        g_company.CompanyId(sCompanyId)
                .Name(sName)
                .Email(sEmail)
                .Pay(sPay)
                .TaxId(sTaxId)
                .Phone(sPhone)
                .Tel(sTel)
                .Address(sAddress)
                .Description(sDescription)
                .Status(sStatus)
                .CreateId(context.Session["id"].ToString())
                .Order(sOrder);
    }

    #region Company

    public void fnSelects(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sOrder = context.Request.QueryString["order"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];

        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);

            DataTable dtData = g_companyRepository.fnSelects(g_company, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCount(HttpContext context)
    {
        string sSize = g_companyRepository.fnCount(g_company);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnSelect(HttpContext context)
    {
        DataTable dtData = g_companyRepository.fnSelect(g_company);

        if (dtData.Rows.Count == 1)
        {
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnSelectCompanyId(HttpContext context)
    {
        string sMsg = "Y";
        string sNUM = context.Request.QueryString["NUM"];
        string sCompanyId = g_companyRepository.fnSelectCompanyId(g_company, sNUM);

        if (sCompanyId == " ")
        {
            sMsg = "訊息：已無下筆資料。";
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"company_id\":\"" + sCompanyId + "\", \"NUM\":\"" + sNUM + "\"}");
    }


    public void fnInsert(HttpContext context)
    {
        string sMsg = fnCheckData(g_company);

        if (sMsg == "Y")
        {
            sMsg = g_companyRepository.fnInsert(g_company);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"company_id\":\"" + g_company.company_id + "\"}");
    }

    public void fnUpdate(HttpContext context)
    {
        string sMsg = fnCheckData(g_company);

        if (sMsg == "Y")
        {
            string sIP = PublicApi.fnRetrieveIP(context.Request);

            sMsg = g_companyRepository.fnUpdate(g_company, sIP, g_company.create_id);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    public void fnDelete(HttpContext context)
    {
        string sMsg = "Y";
        string sIP = PublicApi.fnRetrieveIP(context.Request);

        sMsg = g_companyRepository.fnDelete(g_company, sIP, g_company.create_id);
        sMsg = sMsg.Replace("\r\n", "");
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    public void fnDeletes(HttpContext context)
    {
        string sMsg = "Y";
        string sIP = PublicApi.fnRetrieveIP(context.Request);

        sMsg = g_companyRepository.fnDeletes(g_company, sIP, g_company.create_id);
        sMsg = sMsg.Replace("\r\n", "");
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    public void fnExport(HttpContext context)
    {
        string sMsg = "Y";
        DataTable dtData = g_companyRepository.fnExport(g_company);
        bool bCheck = PublicApi.fnExportDataTableToExcel(dtData, 0, "Company", context);

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
        DataTable dtData = g_companyRepository.fnSelects(g_company);

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
        DataTable dtData = g_companyRepository.fnSelects(g_company);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }


    public void fnSelectList(HttpContext context)
    {
        if (context.Session["id"] != null)
        {
            CompanyRepository companyRepository = new CompanyRepository();
            DataTable dtData = companyRepository.fnSelectList();
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    private string fnCheckData(Company company)
    {
        string sMsg = "Y";
        if (company.company_id.Length > 15)
        {
            sMsg = "錯誤訊息：帳號長度錯誤。";
        }
        else if (company.name.Length > 10)
        {
            sMsg = "錯誤訊息：名稱長度錯誤。";

        }
        else if (company.phone.Length > 10)
        {
            sMsg = "錯誤訊息：手機長度錯誤。";
        }
        else if (company.address.Length > 50)
        {
            sMsg = "錯誤訊息：地址長度錯誤。";
        }
        return sMsg;
    }

    public void fnImport(HttpContext context)
    {
        string sMsg = "Y";
        var fileData = context.Request.Files["FileUpload"];

        fileData.SaveAs(context.Server.MapPath("/\\Import\\Company.xls"));

        string[] sColumns = { "帳號", "密碼", "名子", "地址", "手機" };
        string sSql = "  INSERT INTO [MNDTcompany]  " +
               "             ([company]  " +
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

        sMsg = PublicApi.fnImportExcel("Company.xls", sSql, sColumns, context);
        sMsg = sMsg.Replace("\r\n", "");
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    #endregion


    #region CompanyTran

    public void fnSelectsTran(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];
        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);
            CompanyTran companyTran = new CompanyTran();

            companyTran.CompanyId(g_company.company_id);
            DataTable dtData = g_companyRepository.fnSelects(companyTran, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCountTran(HttpContext context)
    {
        CompanyTran companyTran = new CompanyTran();

        companyTran.CompanyId(g_company.company_id);
        string sSize = g_companyRepository.fnCount(companyTran);
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