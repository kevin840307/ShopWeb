using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// SReturnD 的摘要描述
/// </summary>
public class SReturnMTran
{
    private string g_sReturnId = "";
    private string g_sIP = "";
    private string g_sStatus = "";
    private string g_sCreateId = "";

    public SReturnMTran()
    {

    }

    public SReturnMTran ReturnId(string sData)
    {
        g_sReturnId = sData;
        return this;
    }

    public string return_id
    {
        get
        {
            return g_sReturnId;
        }
    }
    

    public SReturnMTran IP(string sData)
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

    public SReturnMTran CreateId(string sData)
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

    public SReturnMTran Status(string sData)
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