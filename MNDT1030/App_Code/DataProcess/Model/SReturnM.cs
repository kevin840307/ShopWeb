using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// SReturnM 的摘要描述
/// </summary>
public class SReturnM
{
    private string g_sReturnId = "";
    private string g_sOrderId = "";
    private string g_sId = "";
    private string g_sDatetime = "";
    private string g_sComplete = "";
    private string g_sStatus = "";
    private string g_sDescription = "";
    private string g_sCreateId = "";
    private string g_sOrder = "";

    public SReturnM()
    {
        //
        // TODO: 在這裡新增建構函式邏輯
        //
    }

    public SReturnM ReturnId(string sData)
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

    public SReturnM OrderId(string sData)
    {
        g_sOrderId = sData;
        return this;
    }

    public string order_id
    {
        get
        {
            return g_sOrderId;
        }
    }

    public SReturnM Id(string sData)
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

    public SReturnM Datetime(string sData)
    {
        g_sDatetime = sData;
        return this;
    }

    public string datetime
    {
        get
        {
            return g_sDatetime;
        }
    }

    public SReturnM Complete(string sData)
    {
        g_sComplete = sData;
        return this;
    }

    public string complete
    {
        get
        {
            return g_sComplete;
        }
    }

    public SReturnM Status(string sData)
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

    public SReturnM Description(string sData)
    {
        g_sDescription = sData;
        return this;
    }

    public string description
    {
        get
        {
            return g_sDescription;
        }
    }

    public SReturnM CreateId(string sData)
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

    public SReturnM Order(string sData)
    {
        g_sOrder = sData;
        return this;
    }

    public string order
    {
        get
        {
            return g_sOrder;
        }
    }
}