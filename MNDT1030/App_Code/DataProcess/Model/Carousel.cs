using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// Account 的摘要描述
/// </summary>
public class Carousel
{
    private string g_sCarouselId = "";
    private string g_sName = "";
    private string g_sRemarks = "";
    private string g_sStatus = "";
    private string g_sCreateId = "";
    private string g_sOrder = "";


    public Carousel()
    {

    }


    public Carousel CarouselId(string sData)
    {
        g_sCarouselId = sData;
        return this;
    }

    public string carousel_id
    {
        get
        {
            return g_sCarouselId;
        }
    }

    public Carousel Name(string sData)
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

    public Carousel Remarks(string sData)
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


    public Carousel CreateId(string sData)
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

    public Carousel Status(string sData)
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

    public Carousel Order(string sData)
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