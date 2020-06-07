<%@ WebHandler Language="C#" Class="KindHandler" %>

using System;
using System.Web;
using System.Data;

public class KindHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    KindRepository g_kindRepository = new KindRepository();
    KindM g_kindM = new KindM();
    KindD g_kindD = new KindD();

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string sMethod = context.Request.QueryString["method"];
        if (sMethod != null)
        {
            System.Reflection.MethodInfo methodInfo = this.GetType().GetMethod(sMethod);
            if (methodInfo != null)
            {
                fnInitData(context);
                methodInfo.Invoke(this, new object[] { context });
            }
        }
    }

    private void fnInitData(HttpContext context)
    {
        string sKindId = context.Request.QueryString["kind_id"];
        string sName = context.Request.QueryString["name"];
        string sDescription = context.Request.QueryString["description"];
        string sOrder = context.Request.QueryString["order"];

        string sCodeId = context.Request.QueryString["code_id"];
        string sParameter = context.Request.QueryString["parameter"];
        string sStatus = context.Request.QueryString["status"];

        g_kindM.KindId(sKindId)
                .Name(sName)
                .Description(sDescription)
                .CreateId(context.Session["id"].ToString())
                .Order(sOrder);

        g_kindD.KindId(sKindId)
                .CodeId(sCodeId)
                .Name(sName)
                .Parameter(sParameter)
                .CreateId(context.Session["id"].ToString())
                .Status(sStatus);
    }

    #region KindMaster

    public void fnSelects(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sOrder = context.Request.QueryString["order"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];

        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);

            DataTable dtData = g_kindRepository.fnSelects(g_kindM, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCount(HttpContext context)
    {
        string sSize = g_kindRepository.fnCount(g_kindM);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnSelectKindId(HttpContext context)
    {
        string sNUM = context.Request.QueryString["NUM"];
        if (sNUM != null && sNUM.Length > 0)
        {
            string sMsg = "Y";
            string sKindId = g_kindRepository.fnSelectKindId(g_kindM, sNUM);

            if (sKindId == " ")
            {
                sMsg = "訊息：已無下筆資料。";
            }
            context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"kind_id\":\"" + sKindId + "\", \"NUM\":\"" + sNUM + "\"}");
        }
    }

    public void fnSelect(HttpContext context)
    {
        DataTable dtData = g_kindRepository.fnSelect(g_kindM);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnInsert(HttpContext context)
    {
        string sMsg = fnCheckData(g_kindM);

        if (sMsg == "Y")
        {
            sMsg = g_kindRepository.fnInsert(g_kindM);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"kind_id\":\"" + g_kindM.kind_id + "\"}");
    }

    public void fnUpdate(HttpContext context)
    {
        string sMsg = fnCheckData(g_kindM);

        if (sMsg == "Y")
        {
            sMsg = g_kindRepository.fnUpdate(g_kindM);
            sMsg = sMsg.Replace("\r\n", "");
        }

        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    public void fnDelete(HttpContext context)
    {
        string sMsg = "Y";

        sMsg = g_kindRepository.fnDelete(g_kindM);
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    private string fnCheckData(KindM kind)
    {
        string sMsg = "Y";

        if (kind.kind_id.Length < 1)
        {
            sMsg = "錯誤訊息：ID驗證錯誤。";
        }
        return sMsg;
    }

    #endregion



    #region KindDetails

    public void fnSelectsD(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];

        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);

            DataTable dtData = g_kindRepository.fnSelects(g_kindD, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCountD(HttpContext context)
    {
        string sSize = g_kindRepository.fnCount(g_kindD);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnSelectList(HttpContext context)
    {
        DataTable dtData = g_kindRepository.fnSelectList(g_kindD);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnInsertD(HttpContext context)
    {
        string sMsg = fnCheckData(g_kindD);

        if (sMsg == "Y")
        {
            sMsg = g_kindRepository.fnInsert(g_kindD);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\": \"" + sMsg + "\" "
                            + ", \"code_id\": \"" + g_kindD.code_id + "\" "
                            + ", \"name\": \"" + g_kindD.name + "\" "
                            + ", \"parameter\": \"" + g_kindD.parameter + "\" "
                            + ", \"status\": \"N\" }");
    }

    public void fnInsertsD(HttpContext context)
    {
        string sMsg = "";
        string[] sCodeIds = g_kindD.code_id.Split(',');
        string[] sNames = g_kindD.name.Split(',');
        string[] sParameters = g_kindD.parameter.Split(',');

        for (int iIndex = 0; iIndex < sCodeIds.Length; iIndex++)
        {
            string sInsertMsg = "Y";
            KindD kindD = new KindD();

            kindD.KindId(g_kindD.kind_id)
                  .CodeId(sCodeIds[iIndex])
                  .Name(sNames[iIndex])
                  .Parameter(sParameters[iIndex])
                  .CreateId(g_kindD.create_id);
            sInsertMsg = fnCheckData(kindD);
            if (sInsertMsg == "Y")
            {
                sInsertMsg = g_kindRepository.fnInsert(kindD);
                if (sInsertMsg != "Y")
                {
                    sMsg += kindD.code_id + "：" + sInsertMsg.Replace("\r\n", "") + "</br>";
                }
            }
            else
            {
                sMsg += sInsertMsg.Replace("\r\n", "") + "</br>";
            }
        }
        sMsg = sMsg.Length == 0 ? "Y" : sMsg;
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    public void fnUpdateD(HttpContext context)
    {
        string sMsg = "";

        sMsg = fnCheckData(g_kindD);
        if (sMsg == "Y")
        {
            string sIP = PublicApi.fnRetrieveIP(context.Request);

            sMsg = g_kindRepository.fnUpdate(g_kindD, sIP, g_kindD.create_id);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\": \"" + sMsg + "\" "
                            + ", \"code_id\": \"" + g_kindD.code_id + "\" "
                            + ", \"name\": \"" + g_kindD.name + "\" "
                            + ", \"parameter\": \"" + g_kindD.parameter + "\" "
                            + ", \"status\": \"" + g_kindD.status + "\" }");
    }

    public void fnUpdatesD(HttpContext context)
    {
        string sMsg = "";
        string[] sCodeIds = g_kindD.code_id.Split(',');
        string[] sNames = g_kindD.name.Split(',');
        string[] sParameters = g_kindD.parameter.Split(',');
        string[] sStatuss = g_kindD.status.Split(',');
        string sIP = PublicApi.fnRetrieveIP(context.Request);

        for (int iIndex = 0; iIndex < sCodeIds.Length; iIndex++)
        {
            string sUpdateMsg = "Y";
            KindD kindD = new KindD();

            kindD.KindId(g_kindD.kind_id)
                  .CodeId(sCodeIds[iIndex])
                  .Name(sNames[iIndex])
                  .Parameter(sParameters[iIndex])
                  .Status(sStatuss[iIndex])
                  .CreateId(g_kindD.create_id);
            sUpdateMsg = fnCheckData(kindD);
            if (sUpdateMsg == "Y")
            {
                sUpdateMsg = g_kindRepository.fnUpdate(kindD, sIP, g_kindD.create_id);
                if (sUpdateMsg != "Y")
                {
                    sMsg += kindD.code_id + "：" + sUpdateMsg.Replace("\r\n", "") + "</br>";
                }
            }
            else
            {
                sMsg += sUpdateMsg.Replace("\r\n", "") + "</br>";
            }
        }
        sMsg = sMsg.Length == 0 ? "Y" : sMsg;
        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }


    public void fnDeleteD(HttpContext context)
    {
        string sMsg = "Y";
        string sIP = PublicApi.fnRetrieveIP(context.Request);

        sMsg = g_kindRepository.fnDelete(g_kindD, sIP, g_kindD.create_id);
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    private string fnCheckData(KindD kindD)
    {
        string sMsg = "Y";

        if (!g_kindRepository.fnIsExist(g_kindM))
        {
            sMsg = "錯誤訊息：類別ID驗證錯誤。";
        }
        else if (kindD.kind_id.Length < 1)
        {
            sMsg = "錯誤訊息：群組ID驗證錯誤。";
        }
        else if (kindD.code_id.Length < 1)
        {
            sMsg = "錯誤訊息：代碼不得為空。";
        }
        return sMsg;
    }

    #endregion


    #region KindDetailsTran

    public void fnSelectsDTran(HttpContext context)
    {
        KindDTran kindDTran = new KindDTran();
        kindDTran.KindId(g_kindD.kind_id)
                 .CodeId(g_kindD.code_id);
        DataTable dtData = g_kindRepository.fnSelects(kindDTran);
        context.Response.Write(PublicApi.fnGetJson(dtData));
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