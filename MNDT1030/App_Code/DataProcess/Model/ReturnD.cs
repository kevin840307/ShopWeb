using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// ReturnD 的摘要描述
/// </summary>
public class ReturnD
{
    private string g_sSeq = "";
    private string g_sReturnId = "";
    private string g_sMaterialId = "";
    private string g_sWarehouseId = "";
    private string g_sAmount = "";
    private string g_sPrice = "";
    private string g_sComplete = "";
    private string g_sPayComplete = "";
    private string g_sDescription = "";
    private string g_sCreateId = "";



    public ReturnD()
    {
        //
        // TODO: 在這裡新增建構函式邏輯
        //
    }


    public ReturnD Seq(string sData)
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

    public ReturnD ReturnId(string sData)
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

    public ReturnD MaterialId(string sData)
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

    public ReturnD WarehouseId(string sData)
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
    
    public ReturnD Amount(string sData)
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

    public ReturnD Price(string sData)
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

    public ReturnD Complete(string sData)
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


    public ReturnD PayComplete(string sData)
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

    public ReturnD Description(string sData)
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

    public ReturnD CreateId(string sData)
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