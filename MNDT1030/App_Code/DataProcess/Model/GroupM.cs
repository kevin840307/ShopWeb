using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// Group 的摘要描述
/// </summary>
public class GroupM
{
    private User g_user = new User();
    private string g_sGroupId = "";
    private string g_sName = "";
    private string g_sDescription = "";
    private string g_sCreateId = "";
    private string g_sOrder = "";

    public GroupM()
    {
    }

    public GroupM GroupId(string sData)
    {
        g_sGroupId = sData;
        return this;
    }

    public string group_id
    {
        get
        {
            return g_sGroupId;
        }
    }

    public GroupM Name(string sData)
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

    public GroupM Description(string sData)
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

    public GroupM CreateId(string sData)
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

    public GroupM Order(string sData)
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

    public User user
    {
        get
        {
            return g_user;
        }
    }
}