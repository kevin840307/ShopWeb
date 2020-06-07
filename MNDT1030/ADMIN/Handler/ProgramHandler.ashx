<%@ WebHandler Language="C#" Class="ProgramHandler" %>

using System.Data;
using System.Web;
using System.Web.SessionState;
using System.IO;

public class ProgramHandler : IHttpHandler, IReadOnlySessionState
{
    ProgramRepository g_programRepository = new ProgramRepository();
    ProgramM g_programM = new ProgramM();
    ProgramD g_programD = new ProgramD();

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
        string sProgramId = context.Request.QueryString["program_id"];
        string sGroupId = context.Request.QueryString["group_id"];
        string sRead = fnChangeBool(context.Request.QueryString["read"]);
        string sWrite = fnChangeBool(context.Request.QueryString["write"]);
        string sExecute = fnChangeBool(context.Request.QueryString["execute"]);

        g_programM.ProgramId(sProgramId)
                .Id(context.Session["id"].ToString());

        g_programD.ProgramId(sProgramId)
                .GroupId(sGroupId)
                .Read(sRead)
                .Write(sWrite)
                .Execute(sExecute)
                .CreateId(context.Session["id"].ToString());
    }

    private string fnChangeBool(object obj)
    {
        if (obj == null) return "";
        if (obj.ToString() == "true")
        {
            return "Y";
        }
        return "N";
    }

    #region ProgramMaster

    public void Selects(HttpContext context)
    {
        DataTable dtData = g_programRepository.fnSelects(g_programM);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnSelectList(HttpContext context)
    {
        if (context.Session["id"] != null)
        {
            ProgramRepository programRepository = new ProgramRepository();

            DataTable dtData = g_programRepository.fnSelectList();
            context.Response.Write(PublicApi.fnGetJson(dtData));
        }
    }

    #endregion




    #region ProgramDetails

    public void fnSelectsD(HttpContext context)
    {
        DataTable dtData = g_programRepository.fnSelects(g_programD);
        context.Response.Write(PublicApi.fnGetJson(dtData));
    }

    public void fnInsertD(HttpContext context)
    {
        string sMsg = "Y";

        sMsg = fnCheckData(g_programD);
        if (sMsg == "Y")
        {
            sMsg = g_programRepository.fnInsert(g_programD);
        }
        sMsg = sMsg.Replace("\r\n", "");
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    public void fnUpdateD(HttpContext context)
    {
        string sMsg = "Y";

        sMsg = fnCheckData(g_programD);
        if (sMsg == "Y")
        {
            sMsg = g_programRepository.fnUpdate(g_programD);
        }
        sMsg = sMsg.Replace("\r\n", "");
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    public void fnDeleteD(HttpContext context)
    {
        string sMsg = "Y";

        sMsg = g_programRepository.fnDelete(g_programD);
        sMsg = sMsg.Replace("\r\n", "");
        context.Response.Write("{ \"msg\":\"" + sMsg + "\"}");
    }

    private string fnCheckData(ProgramD data)
    {
        string sMsg = "Y";
        GroupM groupM = new GroupM();
        GroupRepository groupRepository = new GroupRepository();

        groupM.GroupId(g_programD.group_id);

        if (data.group_id.Length < 0 || !groupRepository.fnIsExist(groupM))
        {
            sMsg = "錯誤訊息：群組ID錯誤。";
        }
        else if (data.program_id.Length < 0 || !g_programRepository.fnIsExist(g_programM))
        {
            sMsg = "錯誤訊息：作業ID錯誤。";
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