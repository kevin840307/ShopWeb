using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// Account 的摘要描述
/// </summary>
public class ShopItem
{
    private string g_sProductId = "";
    private string g_sCategory = "";
    private string g_sContent = "";
    private string g_sDescription = "";
    private string g_sRemarks = "";
    private string g_sType = "";
    private string g_sFold = "";
    private string g_sStatus = "";
    private string g_sCreateId = "";
    private string g_sModifyId = "";
    private string g_sOrder = "";


    public ShopItem()
    {

    }


    public ShopItem ProductId(string sData)
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

    public ShopItem Category(string sData)
    {
        g_sCategory = sData;
        return this;
    }

    public string category
    {
        get
        {
            return g_sCategory;
        }
    }

    public ShopItem Content(string sData)
    {
        g_sContent = sData;
        return this;
    }

    public string content
    {
        get
        {
            return g_sContent;
        }
    }

    public ShopItem Description(string sData)
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

    public ShopItem Remarks(string sData)
    {
        g_sRemarks = sData;
        return this;
    }

    public string remarks
    {
        get
        {
            return g_sRemarks;
        }
    }

    public ShopItem Type(string sData)
    {
        g_sType = sData;
        return this;
    }

    public string type
    {
        get
        {
            return g_sType;
        }
    }

    public ShopItem Fold(string sData)
    {
        g_sFold = sData;
        return this;
    }

    public string fold
    {
        get
        {
            return g_sFold;
        }
    }

    public ShopItem CreateId(string sData)
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

    public ShopItem ModifyId(string sData)
    {
        g_sModifyId = sData;
        return this;
    }

    public string modify_id
    {
        get
        {
            return g_sModifyId;
        }
    }

    public ShopItem Status(string sData)
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

    public ShopItem Order(string sData)
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