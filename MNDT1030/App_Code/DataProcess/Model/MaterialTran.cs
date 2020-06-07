using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// MaterialTran 的摘要描述
/// </summary>
public class MaterialTran
{
    private string g_sMaterialId = "";
    private string g_sIP = "";
    private string g_sStatus = "";
    private string g_sCreateId = "";

    public MaterialTran()
    {
        //
        // TODO: 在這裡新增建構函式邏輯
        //
    }

    public MaterialTran MaterialId(string sData)
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

    public MaterialTran IP(string sData)
    {
        g_sIP = sData;
        return this;
    }

    public string ip
    {
        get
        {
            return g_sIP;
        }
    }

    public MaterialTran CreateId(string sData)
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

    public MaterialTran Status(string sData)
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
}