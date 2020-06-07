<%@ Page Language="C#" AutoEventWireup="false" CodeFile="ReportPage.aspx.cs" Inherits="ReportPage" %>

<%@ Register Assembly="CrystalDecisions.Web, Version=13.0.2000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304"
    Namespace="CrystalDecisions.Web" TagPrefix="CR" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>報表預覽</title>
    <link href="/aspnet_client/system_web/2_0_50727/crystalreportviewers13/css/default.css"
        rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="DIV1">
        <CR:CrystalReportViewer ID="CrystalReportViewer1" runat="server" />
        &nbsp;
    </div>
    </form>
</body>
</html>
