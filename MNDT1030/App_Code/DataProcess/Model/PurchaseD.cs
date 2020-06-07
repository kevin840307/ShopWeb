using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// PurchaseD 的摘要描述
/// </summary>
public class PurchaseD
{
    private string g_sOrderId = "";
    private string g_sMaterialId = "";
    private string g_sAmount = "";
    private string g_sPrice = "";
    private string g_sModifyAmount = "";
    private string g_sModifyPrice = "";
    private string g_sDescription = "";
    private string g_sCreateId = "";

    public PurchaseD()
    {
        //
        // TODO: 在這裡新增建構函式邏輯
        //
    }

    public PurchaseD OrderId(string sData)
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

    public PurchaseD MaterialId(string sData)
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

    public PurchaseD Amount(string sData)
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


    public PurchaseD Price(string sData)
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

    public PurchaseD ModifyAmount(string sData)
    {
        g_sModifyAmount = sData;
        return this;
    }

    public string modify_amount
    {
        get
        {
            return g_sModifyAmount;
        }
    }


    public PurchaseD ModifyPrice(string sData)
    {
        g_sModifyPrice = sData;
        return this;
    }

    public string modify_price
    {
        get
        {
            return g_sModifyPrice;
        }
    }

    public PurchaseD Description(string sData)
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

    public PurchaseD CreateId(string sData)
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