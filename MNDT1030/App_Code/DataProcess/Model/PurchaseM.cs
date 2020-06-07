using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// PurchaseM 的摘要描述
/// </summary>
public class PurchaseM
{

    private string g_sOrderId = "";
    private string g_sId = "";
    private string g_sDatetime = "";
    private string g_sComplete = "";
    private string g_sStatus = "";
    private string g_sDescription = "";
    private string g_sCreateId = "";
    private string g_sOrder = "";

    public PurchaseM()
    {
        //
        // TODO: 在這裡新增建構函式邏輯
        //
    }

    public PurchaseM OrderId(string sData)
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

    public PurchaseM Id(string sData)
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

    public PurchaseM Datetime(string sData)
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

    public PurchaseM Complete(string sData)
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

    public PurchaseM Status(string sData)
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

    public PurchaseM Description(string sData)
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

    public PurchaseM CreateId(string sData)
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

    public PurchaseM Order(string sData)
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