using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// Account 的摘要描述
/// </summary>
public class UserTran
{
    private string g_sId = "";
    private string g_sIP = "";
    private string g_sStatus = "";
    private string g_sCreateId = "";

    public UserTran()
    {

    }

    public UserTran Id(string sData)
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

    public UserTran IP(string sData)
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

    public UserTran CreateId(string sData)
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

    public UserTran Status(string sData)
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