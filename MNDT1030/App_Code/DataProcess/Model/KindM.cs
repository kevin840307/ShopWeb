using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// KindM 的摘要描述
/// </summary>
public class KindM
{
    private string g_sKindId = "";
    private string g_sName = "";
    private string g_sDescription = "";
    private string g_sCreateId = "";
    private string g_sOrder = "";

    public KindM()
    {
        //
        // TODO: 在這裡新增建構函式邏輯
        //
    }

    public KindM KindId(string sData)
    {
        g_sKindId = sData;
        return this;
    }

    public string kind_id
    {
        get
        {
            return g_sKindId;
        }
    }

    public KindM Name(string sData)
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

    public KindM Description(string sData)
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

    public KindM CreateId(string sData)
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

    public KindM Order(string sData)
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