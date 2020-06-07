using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// ProductM 的摘要描述
/// </summary>
public class ProductM
{
    private string g_sProductId = "";
    private string g_sCompanyId = "";
    private string g_sName = "";
    private string g_sUnit = "";
    private string g_sCost = "";
    private string g_sCurrency = "";
    private string g_sPrice = "";
    private string g_sShelfLife = "";
    private string g_sDescription = "";
    private string g_sStatus = "";
    private string g_sCreateId = "";
    private string g_sOrder = "";

    public ProductM()
    {
        //
        // TODO: 在這裡新增建構函式邏輯
        //
    }

    public ProductM ProductId(string sData)
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

    public ProductM CompanyId(string sData)
    {
        g_sCompanyId = sData;
        return this;
    }

    public string company_id
    {
        get
        {
            return g_sCompanyId;
        }
    }

    public ProductM Name(string sData)
    {
        g_sName = sData;
        return this;
    }

    public string name
    {
        get
        {
            return g_sName;
        }
    }

    public ProductM Unit(string sData)
    {
        g_sUnit = sData;
        return this;
    }

    public string unit
    {
        get
        {
            return g_sUnit;
        }
    }

    public ProductM Cost(string sData)
    {
        g_sCost = sData;
        return this;
    }

    public string cost
    {
        get
        {
            return g_sCost;
        }
    }

    public ProductM Currency(string sData)
    {
        g_sCurrency = sData;
        return this;
    }

    public string currency
    {
        get
        {
            return g_sCurrency;
        }
    }

    public ProductM Price(string sData)
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

    public ProductM ShelfLife(string sData)
    {
        g_sShelfLife = sData;
        return this;
    }

    public string shelf_life
    {
        get
        {
            return g_sShelfLife;
        }
    }

    public ProductM Description(string sData)
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

    public ProductM Status(string sData)
    {
        g_sStatus = sData;
        return this;
    }

    public string status
    {
        get
        {
            return g_sStatus;
        }
    }

    public ProductM CreateId(string sData)
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

    public ProductM Order(string sData)
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