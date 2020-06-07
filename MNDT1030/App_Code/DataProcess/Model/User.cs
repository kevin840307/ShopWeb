using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// Account 的摘要描述
/// </summary>
public class User
{
    private string g_sId = "";
    private string g_sAccount = "";
    private string g_sPassword = "";
    private string g_sEncryptPassword = "";
    private string g_sName = "";
    private string g_sPhone = "";
    private string g_sAddress = "";
    private string g_sStatus = "";
    private string g_sCreateId = "";
    private string g_sOrder = "";

    public User()
    {

    }

    

    public User Id(string sData)
    {
        g_sId = sData;
        return this;
    }

    public string id
    {
        get
        {
            return g_sId;
        }
    }

    public User Account(string sData)
    {
        g_sAccount = sData;
        return this;
    }

    public string account
    {
        get
        {
            return g_sAccount;
        }
    }

    public User Password(string sData)
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

    public User Name(string sData)
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

    public User EncryptPassword(string sData)
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

    public User Phone(string sData)
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

    public User Address(string sData)
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

    public User CreateId(string sData)
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

    public User Status(string sData)
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

    public User Order(string sData)
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