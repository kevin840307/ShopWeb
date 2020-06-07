using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

/// <summary>
/// Summary description for GridViewEvent
/// </summary>
public class GridViewEvent
{
    //public GridViewEvent()
    //{
    //    //
    //    // TODO: Add constructor logic here
    //    //
    //}

    public static void fnGridViewSelectedIndexChanged(ref GridView gvData, string sColor)
    {
        string sStyle2 = "this.style.backgroundColor='" + sColor + "'";
        gvData.Rows[gvData.SelectedIndex].Attributes["onmouseover"] = sStyle2;
        gvData.Rows[gvData.SelectedIndex].Attributes["onmouseout"] = sStyle2;
        gvData.Rows[gvData.SelectedIndex].BackColor = System.Drawing.ColorTranslator.FromHtml(sColor);
    }

    public static void fnGridViewRowDataBound(Page pagePage, ref GridView gvData, GridViewRow gvrData, int iHeight, string sOver, string sOut)
    {
        if (gvrData.RowType == DataControlRowType.DataRow)
        {
            string onmouseoverStyle = "if(this != g_vPrevRow) this.style.backgroundColor='" + sOver + "'";
            string onmouseoutStyle = "if(this != g_vPrevRow) this.style.backgroundColor='" + sOut + "'";
            gvrData.Height = iHeight;
            gvrData.Attributes.Add("style", "cursor:pointer;");
            gvrData.Attributes["onmouseover"] = onmouseoverStyle;
            gvrData.Attributes["onmouseout"] = onmouseoutStyle;
            gvrData.Attributes.Add("onclick", "select_row(this, '" + sOver + "', '" + sOut + "');"); //auto_move();
        }
    }

    public static void fnGridViewSelectedIndexChanging(Page pagePage, ref GridView gvData, string sBackColor, string sFontColor)
    {
        if (gvData.SelectedIndex >= 0 && gvData.SelectedIndex < gvData.Rows.Count)
        {
            string sStyle1 = "this.style.backgroundColor='" + sBackColor + "'; this.style.color = '" + sFontColor + "'";
            gvData.Rows[gvData.SelectedIndex].Attributes["onmouseout"] = sStyle1;
            gvData.Rows[gvData.SelectedIndex].BackColor = System.Drawing.ColorTranslator.FromHtml(sBackColor);
        }
    }

    public static void fnDropPageIndexDataBinding(ref GridView gridData, ref DropDownList dropData)
    {
        for (int iPos = 0; iPos < gridData.PageCount; iPos++)
        {
            ListItem liItem = new ListItem();
            liItem.Text = "第" + (iPos + 1) + "頁";
            liItem.Value = iPos.ToString();
            dropData.Items.Add(liItem);
        }
        dropData.SelectedValue = gridData.PageIndex.ToString();
    }
    public static void fnDropPageIndexSelectedIndexChanged(ref GridView gridData, ref DropDownList dropData)
    {
        gridData.PageIndex = Convert.ToInt16(dropData.SelectedValue);
    }
    public static void fnFirstPageEvent(ref GridView gridData)
    {
        if (gridData.PageCount > 0)
        {
            gridData.PageIndex = 0;
        }
    }
    public static void fnLastPageEvent(ref GridView gridData)
    {
        if (gridData.PageCount > 0)
        {
            gridData.PageIndex = gridData.PageCount - 1;
        }
    }
    public static void fnNextPageEvent(ref GridView gridData)
    {
        if (gridData.PageCount > 0 && gridData.PageIndex < (gridData.PageCount - 1))
        {
            gridData.PageIndex += 1;
        }
    }
    public static void fnPreviousPageEvent(ref GridView gridData)
    {
        if (gridData.PageCount > 0 && gridData.PageIndex > 0)
        {
            gridData.PageIndex -= 1;
        }
    }
    public static void fnDropPageSizeSelectedIndexChanged(ref GridView gridData, ref DropDownList dropData)
    {
        gridData.PageSize = Convert.ToInt16(dropData.SelectedValue);
        gridData.PageIndex = 0;
    }
    public static void fnDropPageSizeDataBinding(ref GridView gridData, ref DropDownList dropData)
    {
        dropData.SelectedValue = gridData.PageSize.ToString();
    }
}