using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// SalesD 的摘要描述
/// </summary>
public class SalesMTran
{
    private string g_sOrderId = "";
    private string g_sIP = "";
    private string g_sStatus = "";
    private string g_sCreateId = "";

    public SalesMTran()
    {

    }

    public SalesMTran OrderId(string sData)
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
    

    public SalesMTran IP(string sData)
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

    public SalesMTran CreateId(string sData)
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

    public SalesMTran Status(string sData)
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