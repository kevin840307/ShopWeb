using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// GroupD 的摘要描述
/// </summary>
public class GroupD
{
    private string g_sGroupId = "";
    private string g_sId = "";
    private string g_sCreateId = "";

    public GroupD()
    {
    }

    public GroupD Id(string sData)
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

    public GroupD GroupId(string sData)
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

    public GroupD CreateId(string sData)
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