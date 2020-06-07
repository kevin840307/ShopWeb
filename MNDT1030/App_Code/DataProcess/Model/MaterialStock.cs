using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// MaterialStock 的摘要描述
/// </summary>
public class MaterialStock
{
    private string g_sMaterialId = "";
    private string g_sWarehouseId = "";
    private string g_sAmount = "";
    private string g_sSafeAmount = "";
    private string g_sCreateId = "";
    private string g_sOrder = "";

    public MaterialStock()
    {
        //
        // TODO: 在這裡新增建構函式邏輯
        //
    }

    public MaterialStock MaterialId(string sData)
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

    public MaterialStock WarehouseId(string sData)
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

    public MaterialStock Amount(string sData)
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

    public MaterialStock SafeAmount(string sData)
    {
        g_sSafeAmount = sData;
        return this;
    }

    public string safe_amount
    {
        get
        {
            return g_sSafeAmount;
        }
    }

    public MaterialStock CreateId(string sData)
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

    public MaterialStock Order(string sData)
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