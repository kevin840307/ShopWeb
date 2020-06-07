<%@ WebHandler Language="C#" Class="BillHandler" %>

using System;
using System.Web;
using System.Data;

public class BillHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{

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
                    methodInfo.Invoke(this, new object[] { context });
                }
            }
        }
    }

    #region Bill

    public void fnSelects(HttpContext context)
    {
        ReceiveRepository receiveRepository = new ReceiveRepository();
        string sCompanyId = context.Request.QueryString["company_id"];
        string sDateS = context.Request.QueryString["date_S"];
        string sDateE = context.Request.QueryString["date_E"];
        string sPage = context.Request.QueryString["page"];
        string sOrder = context.Request.QueryString["order"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];

        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);

            DataTable dtData = receiveRepository.fnSelects(sCompanyId, sDateS, sDateE, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCount(HttpContext context)
    {
        ReceiveRepository receiveRepository = new ReceiveRepository();
        string sCompanyId = context.Request.QueryString["company_id"];
        string sDateS = context.Request.QueryString["date_S"];
        string sDateE = context.Request.QueryString["date_E"];
        string sSize = receiveRepository.fnCount(sCompanyId, sDateS, sDateE);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnReport(HttpContext context)
    {
        string sMsg = "Y";
        BillRepository billRepository = new BillRepository();
        string sCompanyId = context.Request.QueryString["company_id"];
        string sDateS = context.Request.QueryString["date_S"];
        string sDateE = context.Request.QueryString["date_E"];
        DataTable dtData = billRepository.fnReport(sCompanyId, sDateS, sDateE);

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

    //public void fnPrint(HttpContext context)
    //{
    //    DataTable dtData = g_userRepository.fnSelects(g_user);
    //    context.Response.Write(PublicApi.fnGetJson(dtData));
    //}

    #endregion

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}