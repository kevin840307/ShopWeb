<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="Menu.aspx.cs" Inherits="Menu" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="Css/content-header.css" rel="stylesheet" />
    <div id="content_header_div">
        <h2>首頁</h2>
        <ul>
            <li>
                <a href="#">首頁</a>
            </li>
        </ul>
        <div class="content-header-right">
            <%--<button type="button" class="btn-style1" id="btn_back" onclick="window.location='AccountSearchView.aspx'">
                <img src="Image/back.png"></button>--%>
        </div>
    </div>
    <div class="line-style1"></div>
</asp:Content>
