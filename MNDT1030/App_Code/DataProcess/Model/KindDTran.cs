using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// KindD 的摘要描述
/// </summary>
public class KindDTran
{
    private string g_sKindId = "";
    private string g_sCodeId = "";
    private string g_sIP = "";
    private string g_sStatus = "";
    private string g_sCreateId = "";

    public KindDTran()
    {

    }

    public KindDTran KindId(string sData)
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

    public KindDTran CodeId(string sData)
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

    public KindDTran IP(string sData)
    {
        g_sIP = sData;
        return this;
    }

    public string ip
    {
        get
        {
            return g_sIP;
        }
    }

    public KindDTran CreateId(string sData)
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

    public KindDTran Status(string sData)
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
}