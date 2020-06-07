using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// Program 的摘要描述
/// </summary>
public class ProgramM
{
    private string g_sProgramId = "";
    private string g_sId = "";

    public ProgramM()
    {
    }

    public ProgramM Id(string sData)
    {
        g_sId = sData;
        return this;
    }

    public string id
    {
        get
        {
            return g_sId;
        }
    }

    public ProgramM ProgramId(string sData)
    {
        g_sProgramId = sData;
        return this;
    }

    public string program_id
    {
        get
        {
            return g_sProgramId;
        }
    }
}