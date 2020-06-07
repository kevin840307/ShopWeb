using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// ProductStock 的摘要描述
/// </summary>
public class ProductStock
{
    private string g_sProductId = "";
    private string g_sWarehouseId = "";
    private string g_sAmount = "";
    private string g_sSafeAmount = "";
    private string g_sCreateId = "";
    private string g_sOrder = "";

    public ProductStock()
    {
        //
        // TODO: 在這裡新增建構函式邏輯
        //
    }

    public ProductStock ProductId(string sData)
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

    public ProductStock WarehouseId(string sData)
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

    public ProductStock Amount(string sData)
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

    public ProductStock SafeAmount(string sData)
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

    public ProductStock CreateId(string sData)
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

    public ProductStock Order(string sData)
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