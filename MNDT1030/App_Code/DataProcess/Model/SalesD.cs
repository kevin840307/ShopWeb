using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// SalesD 的摘要描述
/// </summary>
public class SalesD
{
    private string g_sSeq = "";
    private string g_sOrderId = "";
    private string g_sProductId = "";
    private string g_sWarehouseId = "";
    private string g_sAmount = "";
    private string g_sPrice = "";
    private string g_sDescription = "";
    private string g_sCreateId = "";



    public SalesD()
    {
        //
        // TODO: 在這裡新增建構函式邏輯
        //
    }

    public SalesD Seq(string sData)
    {
        g_sSeq = sData;
        return this;
    }

    public string seq
    {
        get
        {
            return g_sSeq;
        }
    }

    public SalesD OrderId(string sData)
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

    public SalesD ProductId(string sData)
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

    public SalesD WarehouseId(string sData)
    {
        g_sWarehouseId = sData;
        return this;
    }

    public string warehouse_id
    {
        get
        {
            return g_sWarehouseId;
        }
    }
    
    public SalesD Amount(string sData)
    {
        g_sAmount = sData;
        return this;
    }

    public string amount
    {
        get
        {
            return g_sAmount;
        }
    }


    public SalesD Price(string sData)
    {
        g_sPrice = sData;
        return this;
    }

    public string price
    {
        get
        {
            return g_sPrice;
        }
    }

    public SalesD Description(string sData)
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

    public SalesD CreateId(string sData)
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
}