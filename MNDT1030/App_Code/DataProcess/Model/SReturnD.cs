using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// SReturnD 的摘要描述
/// </summary>
public class SReturnD
{
    private string g_sSeq = "";
    private string g_sReturnId = "";
    private string g_sProductId = "";
    private string g_sWarehouseId = "";
    private string g_sAmount = "";
    private string g_sPrice = "";
    private string g_sDescription = "";
    private string g_sCreateId = "";



    public SReturnD()
    {
        //
        // TODO: 在這裡新增建構函式邏輯
        //
    }


    public SReturnD Seq(string sData)
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

    public SReturnD ReturnId(string sData)
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

    public SReturnD ProductId(string sData)
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

    public SReturnD WarehouseId(string sData)
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
    
    public SReturnD Amount(string sData)
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

    public SReturnD Price(string sData)
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

    public SReturnD Description(string sData)
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

    public SReturnD CreateId(string sData)
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