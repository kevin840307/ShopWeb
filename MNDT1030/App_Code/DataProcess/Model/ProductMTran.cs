using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// ProductMTran 的摘要描述
/// </summary>
public class ProductMTran
{
    private string g_sProductId = "";
    private string g_sIP = "";
    private string g_sStatus = "";
    private string g_sCreateId = "";

    public ProductMTran()
    {

    }

    public ProductMTran ProductId(string sData)
    {
        g_sProductId = sData;
        return this;
    }

    public string product_id
    {
        get
        {
            return g_sProductId;
        }
    }

    public ProductMTran IP(string sData)
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

    public ProductMTran CreateId(string sData)
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

    public ProductMTran Status(string sData)
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