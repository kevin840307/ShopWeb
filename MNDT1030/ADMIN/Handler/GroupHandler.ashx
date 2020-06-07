<%@ WebHandler Language="C#" Class="GroupHandler" %>

using System;
using System.Web;
using System.Data;

public class GroupHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    GroupRepository g_groupRepository = new GroupRepository();
    GroupM g_groupM = new GroupM();
    GroupD g_groupD = new GroupD();

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
        string sId = context.Request.QueryString["id"];
        string sAccount = context.Request.QueryString["account"];
        string sName = context.Request.QueryString["name"];
        string sGroupId = context.Request.QueryString["group_id"];
        string sDescription = context.Request.QueryString["description"];
        string sOrder = context.Request.QueryString["order"];

        g_groupM.GroupId(sGroupId)
                .Name(sName)
                .Description(sDescription)
                .CreateId(context.Session["id"].ToString())
                .Order(sOrder)
                .user.Id(sId)
                     .Account(sAccount);

        g_groupD.GroupId(sGroupId)
                .Id(sId)
                .CreateId(context.Session["id"].ToString());
    }


    #region GroupMaster

    public void fnSelects(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];
        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);
            DataTable dtData = g_groupRepository.fnSelects(g_groupM, iPage, iPageMaxSize);

            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCount(HttpContext context)
    {
        string sSize = g_groupRepository.fnCount(g_groupM);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnSelectGroupId(HttpContext context)
    {
        string sMsg = "Y";
        string sNUM = context.Request.QueryString["NUM"];
        string sGroupId = g_groupRepository.fnSelectGroupId(g_groupM, sNUM);

        if (sGroupId == " ")
        {
            sMsg = "訊息：已無下筆資料。";
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"group_id\":\"" + sGroupId + "\", \"NUM\":\"" + sNUM + "\"}");

    }

    public void fnSelect(HttpContext context)
    {
        DataTable dtData = g_groupRepository.fnSelect(g_groupM);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnInsert(HttpContext context)
    {
        string sMsg = fnCheckData(g_groupM);

        if (sMsg == "Y")
        {
            sMsg = g_groupRepository.fnInsert(g_groupM);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\", \"group_id\":\"" + g_groupM.group_id + "\"}");
    }

    public void fnUpdate(HttpContext context)
    {
        string sMsg = fnCheckData(g_groupM);

        if (sMsg == "Y")
        {
            sMsg = g_groupRepository.fnUpdate(g_groupM);
            sMsg = sMsg.Replace("\r\n", "");
        }

        context.Response.Write("{ \"msg\":\"" + sMsg + "\" }");
    }

    public void fnDelete(HttpContext context)
    {
        string sMsg = "Y";

        sMsg = g_groupRepository.fnDelete(g_groupM);
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    private string fnCheckData(GroupM group)
    {
        string sMsg = "Y";
        if (group.group_id.Length < 1)
        {
            sMsg = "錯誤訊息：ID驗證錯誤。";
        }
        return sMsg;
    }

    #endregion



    #region GroupDetails

    public void fnSelectsD(HttpContext context)
    {
        string sPage = context.Request.QueryString["page"];
        string sPageMaxSize = context.Request.QueryString["page_max_size"];

        if (sPage != null)
        {
            int iPage = Convert.ToInt32(sPage);
            int iPageMaxSize = Convert.ToInt32(sPageMaxSize);
            DataTable dtData = g_groupRepository.fnSelects(g_groupD, iPage, iPageMaxSize);
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    public void fnCountD(HttpContext context)
    {
        string sSize = g_groupRepository.fnCount(g_groupD);
        context.Response.Write("{ \"page_size\":\"" + sSize + "\"}");
    }

    public void fnInsertD(HttpContext context)
    {
        string sMsg = fnCheckData(g_groupD);

        if (sMsg == "Y")
        {
            sMsg = g_groupRepository.fnInsert(g_groupD);
            sMsg = sMsg.Replace("\r\n", "");
        }
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    public void fnDeleteD(HttpContext context)
    {
        string sMsg = "Y";

        sMsg = g_groupRepository.fnDelete(g_groupD);
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    private string fnCheckData(GroupD group)
    {
        string sMsg = "Y";
        UserRepository userRepository = new UserRepository();

        if (!userRepository.fnIsExist(g_groupM.user))
        {
            sMsg = "錯誤訊息：帳號ID驗證錯誤。";
        }
        else if (group.group_id.Length < 1)
        {
            sMsg = "錯誤訊息：群組ID驗證錯誤。";
        }
        return sMsg;
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