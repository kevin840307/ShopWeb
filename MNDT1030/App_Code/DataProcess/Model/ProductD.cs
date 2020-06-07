using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// ProductD 的摘要描述
/// </summary>
public class ProductD
{
    private string g_sProductId = "";
    private string g_sMaterialId = "";
    private string g_sAmount = "";
    private string g_sCreateId = "";
    
    public ProductD()
    {
        //
        // TODO: 在這裡新增建構函式邏輯
        //
    }

    public ProductD ProductId(string sData)
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

    public ProductD MaterialId(string sData)
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

    public ProductD Amount(string sData)
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

    public ProductD CreateId(string sData)
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