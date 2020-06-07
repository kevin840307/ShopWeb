using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// QuotesD 的摘要描述
/// </summary>
public class QuotesD
{
    private string g_sOrderId = "";
    private string g_sProductId = "";
    private string g_sAmount = "";
    private string g_sPrice = "";
    private string g_sModifyAmount = "";
    private string g_sModifyPrice = "";
    private string g_sDescription = "";
    private string g_sCreateId = "";

    public QuotesD()
    {
        //
        // TODO: 在這裡新增建構函式邏輯
        //
    }

    public QuotesD OrderId(string sData)
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

    public QuotesD ProductId(string sData)
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

    public QuotesD Amount(string sData)
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


    public QuotesD Price(string sData)
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

    public QuotesD ModifyAmount(string sData)
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


    public QuotesD ModifyPrice(string sData)
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

    public QuotesD Description(string sData)
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

    public QuotesD CreateId(string sData)
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