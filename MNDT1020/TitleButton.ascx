<%@ Control Language="C#" AutoEventWireup="true" CodeFile="TitleButton.ascx.cs" Inherits="TitleButton" %>
<script type="text/javascript">
    function save_bottom() {
        setTimeout(save_move_bottom, 100);
    }

    function save_move_bottom() {
        $('.div-scroll').animate({ scrollTop: 2000 }, 'slow');
    }

    function file() {
        document.getElementById('<%=fu_file_upload.ClientID%>').click();
    }

    function file_data() {
        document.getElementById('<%=text_file_data.ClientID%>').value = document.getElementById('<%=fu_file_upload.ClientID%>').value;
    }

    function call_insert() {
        if ($("#ContentPlaceHolder1_grid_data_m_ibtn_insert").length > 0) {
            $("#ContentPlaceHolder1_grid_data_m_ibtn_insert").click();
            //var href = $("#ContentPlaceHolder1_grid_data_m_linkbtn_insert").attr('href');
            //if (href.indexOf('ctl02$linkbtn_insert') >= 0) {
            //    javascript: __doPostBack('ctl00$ContentPlaceHolder1$grid_data_m$ctl02$linkbtn_insert', '');
            //} else {
            //    javascript: __doPostBack('ctl00$ContentPlaceHolder1$grid_data_m$ctl00$linkbtn_insert', '')
            //}

        }
        else if ($("#ContentPlaceHolder1_grid_data_d_ibtn_insert").length > 0) {
            $("#ContentPlaceHolder1_grid_data_d_ibtn_insert").click();
            //var href = $("#ContentPlaceHolder1_grid_data_d_linkbtn_insert").attr('href');
            //if (href.indexOf('ctl02$linkbtn_insert') >= 0) {
            //    javascript: __doPostBack('ctl00$ContentPlaceHolder1$grid_data_d$ctl02$linkbtn_insert', '');
            //} else {
            //    javascript: __doPostBack('ctl00$ContentPlaceHolder1$grid_data_d$ctl00$linkbtn_insert', '');
            //}
        }
        else if ($("#ibtn_insert").length > 0) {
            $("#ibtn_insert").click();
        }

        save_bottom();
    }
</script>
<table class="blue-style2 table-size1">
    <tr>
        <td colspan="4">
            <asp:Button runat="server" Text="F2 新增" ID="btn_insert" BorderStyle="None" OnClientClick="call_insert(); return false;" CssClass="blue-style6 button-size2" />
            <asp:Button runat="server" Text="F3 列印" ID="btn_print" BorderStyle="None" CssClass="blue-style6 button-size2" />
            <asp:Button runat="server" Text="F4 匯出" ID="btn_export" BorderStyle="None" CssClass="blue-style6 button-size2" />
            <asp:Button runat="server" Text="F7 取消" ID="btn_cancel" BorderStyle="None" CssClass="blue-style6 button-size2" OnClientClick="return false;" CommandName="CancelData" />
            <asp:FileUpload runat="server" ID="fu_file_upload" Width="0%" onchange="file_data()" />
            <asp:Button runat="server" Text="匯入" ID="btn_import" BorderStyle="None" CssClass="blue-style6 button-size2" />
            <asp:Button runat="server" Text="選擇檔案" ID="btn_file" OnClientClick="file(); return false;" BorderStyle="None" CssClass="blue-style6 button-size2" />
            <asp:TextBox runat="server" ID="text_file_data" Text="檔案路徑" BorderStyle="None" Enabled="false" CssClass="blue-style1"></asp:TextBox>
        </td>
    </tr>
</table>
