using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Material 的摘要描述
/// </summary>
public class Material
{
    private string g_sMaterialId = "";
    private string g_sCompanyId = "";
    private string g_sName = "";
    private string g_sUnit = "";
    private string g_sCurrency = "";
    private string g_sPrice = "";
    private string g_sShelfLife = "";
    private string g_sDescription = "";
    private string g_sStatus = "";
    private string g_sCreateId = "";
    private string g_sOrder = "";

    public Material()
    {
    }

    public Material MaterialId(string sData)
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

    public Material CompanyId(string sData)
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

    public Material Name(string sData)
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

    public Material Unit(string sData)
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

    public Material Currency(string sData)
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

    public Material Price(string sData)
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

    public Material ShelfLife(string sData)
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

    public Material Description(string sData)
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

    public Material Status(string sData)
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

    public Material CreateId(string sData)
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

    public Material Order(string sData)
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