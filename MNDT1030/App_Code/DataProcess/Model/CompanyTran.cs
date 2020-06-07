using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// Account 的摘要描述
/// </summary>
public class CompanyTran
{
    private string g_sCompanyId = "";
    private string g_sIP = "";
    private string g_sStatus = "";
    private string g_sCreateId = "";

    public CompanyTran()
    {

    }

    public CompanyTran CompanyId(string sData)
    {
        g_sCompanyId = sData;
        return this;
    }

    public string company_id
    {
        get
        {
            return g_sCompanyId;
        }
    }

    public CompanyTran IP(string sData)
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

    public CompanyTran CreateId(string sData)
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

    public CompanyTran Status(string sData)
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