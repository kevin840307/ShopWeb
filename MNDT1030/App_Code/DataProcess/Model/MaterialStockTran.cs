using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// MaterialStockTran 的摘要描述
/// </summary>
public class MaterialStockTran
{
    private string g_sMaterialId = "";
    private string g_sWarehouseId = "";
    private string g_sAmount = "";
    private string g_sDescription = "";
    private string g_sCreateId = "";

    public MaterialStockTran()
    {
        //
        // TODO: 在這裡新增建構函式邏輯
        //
    }

    public MaterialStockTran MaterialId(string sData)
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

    public MaterialStockTran WarehouseId(string sData)
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

    public MaterialStockTran Amount(string sData)
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

    public MaterialStockTran Description(string sData)
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

    public MaterialStockTran CreateId(string sData)
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