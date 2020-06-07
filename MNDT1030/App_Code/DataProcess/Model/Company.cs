using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// Account 的摘要描述
/// </summary>
public class Company
{
    private string g_sCompanyId = "";
    private string g_sName = "";
    private string g_sEmail = "";
    private string g_sPay = "";
    private string g_sTaxId = "";
    private string g_sPhone = "";
    private string g_sTel = "";
    private string g_sAddress = "";
    private string g_sDescription = "";
    private string g_sStatus = "";
    private string g_sCreateId = "";
    private string g_sOrder = "";

    public Company()
    {

    }

    

    public Company CompanyId(string sData)
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

    public Company Email(string sData)
    {
        g_sEmail = sData;
        return this;
    }

    public string email
    {
        get
        {
            return g_sEmail;
        }
    }

    public Company Pay(string sData)
    {
        g_sPay = sData;
        return this;
    }

    public string pay
    {
        get
        {
            return g_sPay;
        }
    }

    public Company Name(string sData)
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

    public Company TaxId(string sData)
    {
        g_sTaxId = sData;
        return this;
    }

    public string tax_id
    {
        get
        {
            return g_sTaxId;
        }
    }
    public Company Phone(string sData)
    {
        g_sPhone = sData;
        return this;
    }

    public string phone
    {
        get
        {
            return g_sPhone;
        }
    }

    public Company Tel(string sData)
    {
        g_sTel = sData;
        return this;
    }

    public string tel
    {
        get
        {
            return g_sTel;
        }
    }

    public Company Address(string sData)
    {
        g_sAddress = sData;
        return this;
    }

    public string address
    {
        get
        {
            return g_sAddress;
        }
    }

    public Company Description(string sData)
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

    public Company CreateId(string sData)
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

    public Company Status(string sData)
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

    public Company Order(string sData)
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