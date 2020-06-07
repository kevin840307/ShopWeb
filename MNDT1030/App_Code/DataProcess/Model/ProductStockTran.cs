using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// ProductStockTran 的摘要描述
/// </summary>
public class ProductStockTran
{
    private string g_sProductId = "";
    private string g_sWarehouseId = "";
    private string g_sAmount = "";
    private string g_sDescription = "";
    private string g_sCreateId = "";

    public ProductStockTran()
    {
        //
        // TODO: 在這裡新增建構函式邏輯
        //
    }

    public ProductStockTran ProductId(string sData)
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

    public ProductStockTran WarehouseId(string sData)
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

    public ProductStockTran Amount(string sData)
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

    public ProductStockTran Description(string sData)
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

    public ProductStockTran CreateId(string sData)
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