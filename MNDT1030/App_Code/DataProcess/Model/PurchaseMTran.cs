using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// PurchaseD 的摘要描述
/// </summary>
public class PurchaseMTran
{
    private string g_sOrderId = "";
    private string g_sIP = "";
    private string g_sStatus = "";
    private string g_sCreateId = "";

    public PurchaseMTran()
    {

    }

    public PurchaseMTran OrderId(string sData)
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
    

    public PurchaseMTran IP(string sData)
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

    public PurchaseMTran CreateId(string sData)
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

    public PurchaseMTran Status(string sData)
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