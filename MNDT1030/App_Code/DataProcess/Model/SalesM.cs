using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// SalesM 的摘要描述
/// </summary>
public class SalesM
{
    private string g_sOrderId = "";
    private string g_sId = "";
    private string g_sPay = "";
    private string g_sOrderStatus = "";
    private string g_sDatetime = "";
    private string g_sComplete = "";
    private string g_sStatus = "";
    private string g_sDescription = "";
    private string g_sCreateId = "";
    private string g_sOrder = "";

    public SalesM()
    {
        //
        // TODO: 在這裡新增建構函式邏輯
        //
    }

    public SalesM OrderId(string sData)
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

    public SalesM Id(string sData)
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

    public SalesM Pay(string sData)
    {
        g_sPay = sData;
        return this;
    }

    public string pay
    {
        get
        {
            return g_sPay;
        }
    }

    public SalesM OrderStatus(string sData)
    {
        g_sOrderStatus = sData;
        return this;
    }

    public string order_status
    {
        get
        {
            return g_sOrderStatus;
        }
    }

    public SalesM Datetime(string sData)
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

    public SalesM Complete(string sData)
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

    public SalesM Status(string sData)
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

    public SalesM Description(string sData)
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

    public SalesM CreateId(string sData)
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

    public SalesM Order(string sData)
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