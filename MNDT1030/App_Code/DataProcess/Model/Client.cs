using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// Account 的摘要描述
/// </summary>
public class Client
{
    private string g_sClientId = "";
    private string g_sPassword = "";
    private string g_sEncryptPassword = "";
    private string g_sName = "";
    private string g_sEmail = "";
    private string g_sPhone = "";
    private string g_sTel = "";
    private string g_sAddress = "";
    private string g_sDescription = "";
    private string g_sStatus = "";
    private string g_sCreateId = "";
    private string g_sOrder = "";

    public Client()
    {

    }

    

    public Client ClientId(string sData)
    {
        g_sClientId = sData;
        return this;
    }

    public string client_id
    {
        get
        {
            return g_sClientId;
        }
    }

    public Client Email(string sData)
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

    public Client Password(string sData)
    {
        g_sPassword = sData;
        return this;
    }

    public string password
    {
        get
        {
            return g_sPassword;
        }
    }

    public Client Name(string sData)
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

    public Client EncryptPassword(string sData)
    {
        g_sEncryptPassword = sData;
        return this;
    }

    public string encrypt_password
    {
        get
        {
            return g_sEncryptPassword;
        }
    }

    public Client Phone(string sData)
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

    public Client Tel(string sData)
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

    public Client Address(string sData)
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

    public Client Description(string sData)
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

    public Client CreateId(string sData)
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

    public Client Status(string sData)
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

    public Client Order(string sData)
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