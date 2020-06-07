<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;">
<html xmlns="http://www.w3.org/1999/xhtml">
  
<head runat="server">
    <title>登入</title>
    <link href="Css/bakdround.css" rel="stylesheet" />
    <link href="Css/button.css" rel="stylesheet" />
    <link href="Css/size.css" rel="stylesheet" />
    <link href="Css/login.css" rel="stylesheet" />
    <link href="Css/table.css" rel="stylesheet" />
    <link href="Css/textbox.css" rel="stylesheet" />
</head>

<body class="green-style1">
    <form id="form1" runat="server">
    <%-- <iframe width="0" height="0" style="display:none;" src="https://www.youtube.com/embed/A0lzynrwXD4?autoplay=1&loop=1" frameborder="0" allowfullscreen></iframe>
     --%>  
        <div style="position: relative">
            <asp:Panel runat="server">
                <table class="white-style1 login-context-size1">
                    <tr>
                        <td class="center" colspan="2">
                            <img src="Image/Reddit-48.png" />
                        </td>
                    </tr>
                    <tr>
                        <td class="right">
                            <asp:Label runat="server" Text="帳號：" CssClass="font-style1"></asp:Label>
                        </td>
                        <td class="left">
                            <asp:TextBox runat="server" ID="text_account_id" CssClass="text-size1"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="right">
                            <asp:Label runat="server" Text="密碼：" CssClass="font-style1"></asp:Label>
                        </td>
                        <td class="left">
                            <asp:TextBox runat="server" ID="text_account_password" CssClass="text-size1"></asp:TextBox>
                        </td>
                    </tr>
                    <tr style="height:0px;">
                        <td class="center" colspan="2">
                        <asp:Label ID="lab_error" runat="server" ForeColor="Red"></asp:Label>
                            </td>
                    </tr>
                    <tr>
                        <td class="center" colspan="2">
                            <asp:Button runat="server" ID="btn_account_login" Text="登入" CssClass="blue-style5 button-size1" OnClick="btn_account_login_Click"></asp:Button>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </div>
        <asp:Literal ID="Literal1" runat="server"></asp:Literal>
    </form>
</body>
</html>
