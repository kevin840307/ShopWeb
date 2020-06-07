using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// KindD 的摘要描述
/// </summary>
public class KindD
{
    private string g_sKindId = "";
    private string g_sCodeId = "";
    private string g_sName = "";
    private string g_sParameter = "";
    private string g_sStatus = "";
    private string g_sCreateId = "";

    public KindD()
    {
        //
        // TODO: 在這裡新增建構函式邏輯
        //
    }

    public KindD KindId(string sData)
    {
        g_sKindId = sData;
        return this;
    }

    public string kind_id
    {
        get
        {
            return g_sKindId;
        }
    }

    public KindD CodeId(string sData)
    {
        g_sCodeId = sData;
        return this;
    }

    public string code_id
    {
        get
        {
            return g_sCodeId;
        }
    }

    public KindD Name(string sData)
    {
        g_sName = sData;
        return this;
    }

    public string name
    {
        get
        {
            return g_sName;
        }
    }


    public KindD Parameter(string sData)
    {
        g_sParameter = sData;
        return this;
    }

    public string parameter
    {
        get
        {
            return g_sParameter;
        }
    }

    public KindD Status(string sData)
    {
        g_sStatus = sData;
        return this;
    }

    public string status
    {
        get
        {
            return g_sStatus;
        }
    }

    public KindD CreateId(string sData)
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