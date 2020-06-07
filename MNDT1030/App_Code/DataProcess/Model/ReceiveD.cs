using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// ReceiveD 的摘要描述
/// </summary>
public class ReceiveD
{
    private string g_sSeq = "";
    private string g_sOrderId = "";
    private string g_sMaterialId = "";
    private string g_sWarehouseId = "";
    private string g_sAmount = "";
    private string g_sPrice = "";
    private string g_sComplete = "";
    private string g_sPayComplete = "";
    private string g_sDescription = "";
    private string g_sCreateId = "";



    public ReceiveD()
    {
        //
        // TODO: 在這裡新增建構函式邏輯
        //
    }

    public ReceiveD Seq(string sData)
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

    public ReceiveD OrderId(string sData)
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

    public ReceiveD MaterialId(string sData)
    {
        g_sMaterialId = sData;
        return this;
    }

    public string material_id
    {
        get
        {
            return g_sMaterialId;
        }
    }

    public ReceiveD WarehouseId(string sData)
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
    
    public ReceiveD Amount(string sData)
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


    public ReceiveD Price(string sData)
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

    public ReceiveD Complete(string sData)
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


    public ReceiveD PayComplete(string sData)
    {
        g_sPayComplete = sData;
        return this;
    }

    public string pay_complete
    {
        get
        {
            return g_sPayComplete;
        }
    }

    public ReceiveD Description(string sData)
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

    public ReceiveD CreateId(string sData)
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