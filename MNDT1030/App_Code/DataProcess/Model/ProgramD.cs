using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// ProgramD 的摘要描述
/// </summary>
public class ProgramD
{
    private string g_sGroupId = "";
    private string g_sProgramId = "";
    private string g_sCreateId = "";
    private string g_sRead = "";
    private string g_sWrite = "";
    private string g_sExecute = "";

    public ProgramD()
    {
        //
        // TODO: 在這裡新增建構函式邏輯
        //
    }

    public ProgramD GroupId(string sData)
    {
        g_sGroupId = sData;
        return this;
    }

    public string group_id
    {
        get
        {
            return g_sGroupId;
        }
    }

    public ProgramD ProgramId(string sData)
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

    public ProgramD Read(string sData)
    {
        g_sRead = sData;
        return this;
    }

    public string read
    {
        get
        {
            return g_sRead;
        }
    }

    public ProgramD Write(string sData)
    {
        g_sWrite = sData;
        return this;
    }

    public string write
    {
        get
        {
            return g_sWrite;
        }
    }

    public ProgramD Execute(string sData)
    {
        g_sExecute = sData;
        return this;
    }

    public string execute
    {
        get
        {
            return g_sExecute;
        }
    }

    public ProgramD CreateId(string sData)
    {
        g_sCreateId = sData;
        return this;
    }

    public string create_id
    {
        get
        {
            return g_sCreateId;
        }
    }
}