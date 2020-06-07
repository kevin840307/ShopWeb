<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" MaintainScrollPositionOnPostback="true" EnableEventValidation="false" Async="true" AutoEventWireup="true" CodeFile="MNDT5010.aspx.cs" Inherits="MNDT5010" %>

<%@ Register Assembly="GGridView" Namespace="GGridView" TagPrefix="cc1" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content runat="server" ID="const" ContentPlaceHolderID="ContentPlaceHolder1">
    <script type="text/javascript">
        //\d = [0-9]
        function check_price(e, pnumber) {
            if (!/^\d{1,5}\.(\d{1,3})?$/.test(pnumber)) {
                var newValue = /^\d{1,5}/.exec(e.value);
                if (newValue != null) {
                    e.value = newValue;
                }
                else {
                    e.value = "";
                }
            }
            return false;
        }

        function check_month(e, pnumber) {
            if (!/^\d{1,2}\.(\d{1,1})?$/.test(pnumber)) {
                var newValue = /^\d{1,2}/.exec(e.value);
                if (newValue != null) {
                    e.value = newValue;
                }
                else {
                    e.value = "";
                }
            }
            return false;
        }

        function file_image() {
            document.getElementById('ContentPlaceHolder1_fv_master_form_fu_file_image_upload').click();
        }

        function file_image_data() {
            document.getElementById('ContentPlaceHolder1_fv_master_form_text_file_image_data').value = document.getElementById('ContentPlaceHolder1_fv_master_form_fu_file_image_upload').value;
        }

        function delete_img(e) {
            if (confirm("確認要刪除?!")) {
                $.ajax({
                    type: 'post',
                    url: 'ActionService.asmx/fnDeleteProductImage',
                    data: 'sFileName=' + e.alt,
                    success: function (domXml) {
                        var xmlDom = domXml;
                        var result = xmlDom.childNodes[0].firstChild.nodeValue;
                        if (result == 'true') {
                            //$(e).parent().remove();
                            $(e).remove();
                            alert('刪除成功');
                        } else {
                            alert('刪除失敗');
                        }
                    },
                    error: function () { alert('刪除失敗'); }
                });
            }
        }


        $(function () {

        });
    </script>
    <asp:UpdatePanel runat="server" UpdateMode="Conditional" ID="up_multi">
        <ContentTemplate>
            <asp:MultiView runat="server" ID="multi_view" ActiveViewIndex="0">
                <asp:View runat="server" ID="view_master">
                    <asp:Panel runat="server">
                        <table class="blue-style2 table-size1">
                            <tr>
                                <td rowspan="3">&nbsp;查詢<br />
                                    條件區</td>
                            </tr>
                            <tr>
                                <td class="right">
                                    <asp:Label runat="server" Text="產品父代碼：" CssClass="font-style1"></asp:Label>
                                </td>
                                <td class="left">
                                    <asp:TextBox ID="text_product_kind" runat="server" CssClass="text-size2"></asp:TextBox>
                                </td>


                                <td class="right">
                                    <asp:Label runat="server" Text="父代碼名稱：" CssClass="font-style1"></asp:Label>
                                </td>
                                <td class="left">
                                    <asp:TextBox ID="text_product_kind_name" runat="server" CssClass="text-size2"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td class="right">
                                    <asp:Label runat="server" Text="產品子代碼：" CssClass="font-style1"></asp:Label>
                                </td>
                                <td class="left">
                                    <asp:TextBox ID="text_product_code" runat="server" CssClass="text-size2"></asp:TextBox>
                                </td>

                                <td class="right">
                                    <asp:Label runat="server" Text="子代碼名稱：" CssClass="font-style1"></asp:Label>
                                </td>
                                <td class="left">
                                    <asp:TextBox ID="text_product_code_name" runat="server" CssClass="text-size2"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" class="center">
                                    <asp:Button runat="server" Text="查詢" ID="btn_search" CssClass="blue-style6 button-size2" BorderStyle="None" OnClick="btn_search_Click" />
                                    <asp:Button runat="server" Text="清除" CssClass="blue-style6 button-size2" BorderStyle="None" />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>

                    <asp:Panel runat="server" ScrollBars="Vertical" CssClass="div-scroll div-scroll-size5" ID="panel_scroll_m">
                        <asp:UpdatePanel runat="server">
                            <ContentTemplate>
                                <%--FreezeHeader="true" ScrollVertical="true" ScrollVerticalClass="div-scroll div-scroll-size2"--%>
                                <cc1:GGridView runat="server" EmptyShowHeader="True" EmptyDataText="無顯示資料" OnRowDataBound="grid_data_RowDataBound" OnRowCommand="grid_data_m_RowCommand"
                                    OnSelectedIndexChanged="grid_data_SelectedIndexChanged" OnSelectedIndexChanging="grid_data_SelectedIndexChanging"
                                    Width="1480px" GridLines="Horizontal" AllowSorting="True" CssClass="white-style2 no-border border-style1 font-style2"
                                    AutoGenerateColumns="False" AllowPaging="True" CellPadding="4" ForeColor="Black"
                                    ID="grid_data_m" DataSourceID="sds_main" DataKeyNames="product_kind, product_code">

                                    <Columns>
                                        <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:ImageButton ID="ibtn_insert" OnClientClick="save_bottom();" runat="server" ImageUrl="~/Image/select.png" CssClass="margin-top-6"></asp:ImageButton>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:ImageButton ID="ibtn_Select" CommandName="SelectData" runat="server" ImageUrl="~/Image/select.png" onmouseover="this.src='/Image/select_1.png'" onmouseout="this.src='/Image/select.png'" CommandArgument='<%# Container.DataItemIndex %>'></asp:ImageButton>
                                            </ItemTemplate>
                                            <HeaderStyle Width="6.7%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="父代碼" SortExpression="product_kind">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_product_kind" runat="server" Text='<%#Bind("product_kind") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="6.7%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="子代碼">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_product_code" runat="server" Text='<%#Bind("product_code") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="6.7%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="子代碼名稱">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_product_code_name" runat="server" Text='<%#Bind("product_code_name") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="6.7%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="廠商代號">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_company_id" runat="server" Text='<%#Bind("company_id") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="6.7%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="單位">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_product_unit" runat="server" Text='<%#Bind("product_unit") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="6.7%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="規格">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_product_norm" runat="server" Text='<%#Bind("product_norm") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="6.7%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="成本">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_product_cost" runat="server" Text='<%#Bind("product_cost") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="6.7%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="定價">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_product_pricing" runat="server" Text='<%#Bind("product_pricing") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="6.7%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="保存期限">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_product_deadline" runat="server" Text='<%#Bind("product_deadline") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="6.7%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="備註">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_product_remarks" runat="server" Text='<%#Bind("product_remarks") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="7%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="建立人員">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_create_user_id" runat="server" Text='<%#Bind("create_user_id") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="6.7%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="建立時間" SortExpression="create_datetime">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_create_datetime" runat="server" Text='<%#Bind("create_datetime") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="6.7%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="修改人員">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_modify_user_id" runat="server" Text='<%#Bind("modify_user_id") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="6.7%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="修改時間">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_modify_datetime" runat="server" Text='<%#Bind("modify_datetime") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="6.7%" />
                                        </asp:TemplateField>
                                    </Columns>

                                    <PagerTemplate>
                                        <table style="width: 100%">
                                            <tr style="width: 100%">
                                                <td class="left">
                                                    <asp:LinkButton runat="server" ID="linkbtn_first" Text="第一頁" OnClick="linkbtn_first_Click"></asp:LinkButton>
                                                    <asp:LinkButton runat="server" ID="linkbtn_next" Text="下一頁" OnClick="linkbtn_next_Click"></asp:LinkButton>
                                                    <asp:LinkButton runat="server" ID="linkbtn_previous" Text="上一頁" OnClick="linkbtn_previous_Click"></asp:LinkButton>
                                                    <asp:LinkButton runat="server" ID="linkbtn_last" Text="最後一頁" OnClick="linkbtn_last_Click"></asp:LinkButton>
                                                </td>
                                                <td class="right">
                                                    <asp:DropDownList runat="server" ID="drop_page_index" CssClass="blue-style4 dropdwonlist_size1" OnDataBinding="drop_page_index_DataBinding" OnSelectedIndexChanged="drop_page_index_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                                                    <asp:Label ID="lab_sum" runat="server" Text="顯示筆數："></asp:Label>
                                                    <asp:DropDownList runat="server" ID="drop_page_size" CssClass="blue-style4 dropdwonlist_size1" OnDataBinding="drop_page_size_DataBinding" AutoPostBack="true" OnSelectedIndexChanged="drop_page_size_SelectedIndexChanged">
                                                        <asp:ListItem>10</asp:ListItem>
                                                        <asp:ListItem>20</asp:ListItem>
                                                        <asp:ListItem>30</asp:ListItem>
                                                        <asp:ListItem>40</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                        </table>
                                    </PagerTemplate>
                                    <EmptyDataTemplate>
                                        無顯示資料!-
                                    </EmptyDataTemplate>
                                    <HeaderStyle CssClass="no-border header-style1 font-style1" ForeColor="White" Width="100%" />
                                    <RowStyle CssClass="no-border font-style1" />
                                    <FooterStyle CssClass="foot-style1" />
                                    <PagerSettings Position="Top" />
                                    <PagerStyle CssClass="gridpage-style1 font-style1" ForeColor="Black" HorizontalAlign="Right" />
                                    <SelectedRowStyle CssClass="select-style1" Font-Bold="true" />
                                    <SortedAscendingCellStyle CssClass="gray-style1" />
                                    <SortedAscendingHeaderStyle CssClass="black-style1" />
                                    <SortedDescendingCellStyle CssClass="gray-style12" />
                                    <SortedDescendingHeaderStyle CssClass="black-style2" />
                                </cc1:GGridView>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="btn_search" EventName="Click" />
                                <asp:AsyncPostBackTrigger ControlID="grid_data_m" EventName="RowCommand" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </asp:Panel>
                </asp:View>

                <asp:View runat="server" ID="view_detail">
                    <asp:Panel runat="server">
                        <table class="blue-style2 table-size1">
                            <tr>
                                <td colspan="2" rowspan="3" class="left">
                                    <asp:ImageButton ID="imgbtn_last" runat="server" ImageUrl="~/Image/last_one.png" onmouseover="this.src='/Image/last_one_1.png'" onmouseout="this.src='/Image/last_one.png'" OnClick="imgbtn_last_Click" />
                                </td>
                                <td rowspan="3">&nbsp;查詢<br />
                                    條件區</td>

                            </tr>
                            <tr>
                                <td class="right">
                                    <asp:Label runat="server" Text="進貨單號：" CssClass="font-style1"></asp:Label>
                                </td>
                                <td class="left">
                                    <asp:TextBox ID="text_purchase_order" runat="server" CssClass="text-size2"></asp:TextBox>
                                </td>


                                <td class="right">
                                    <asp:Label runat="server" Text="存貨日期：" CssClass="font-style1"></asp:Label>
                                </td>
                                <td class="left">
                                    <asp:TextBox ID="text_stock_date" runat="server" CssClass="text-size2"></asp:TextBox>
                                    <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="text_stock_date" Format="yyyy/MM/dd"></asp:CalendarExtender>
                                </td>
                                <td colspan="1" rowspan="2" class="right">
                                    <asp:ImageButton ID="imgbtn_next" runat="server" ImageUrl="~/Image/next_one.png" onmouseover="this.src='/Image/next_one_1.png'" onmouseout="this.src='/Image/next_one.png'" OnClick="imgbtn_next_Click" />
                                </td>
                            </tr>

                            <tr>
                                <td colspan="4" class="center">
                                    <asp:Button runat="server" Text="查詢" ID="btn_serarch_stock" CssClass="blue-style6 button-size2" BorderStyle="None" OnClick="btn_serarch_stock_Click" />
                                    <asp:Button runat="server" Text="清除" CssClass="blue-style6 button-size2" BorderStyle="None" />
                                    <asp:Button runat="server" CssClass="blue-style6 button-size2" Text="取消" ID="btn_detail_cancel" OnClick="btn_master_cancel_Click" />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>

                    <asp:Panel runat="server" ScrollBars="Vertical" CssClass="div-scroll div-scroll-size5" ID="panel1">
                        <asp:UpdatePanel runat="server">
                            <ContentTemplate>
                                <cc1:GGridView runat="server" EmptyShowHeader="True" EmptyDataText="無顯示資料" OnRowDataBound="grid_data_RowDataBound"
                                    OnSelectedIndexChanged="grid_data_SelectedIndexChanged" OnSelectedIndexChanging="grid_data_SelectedIndexChanging"
                                    Width="1005px" GridLines="Horizontal" AllowSorting="True" CssClass="white-style2 no-border border-style1 font-style2"
                                    AutoGenerateColumns="False" AllowPaging="True" CellPadding="4" ForeColor="Black"
                                    ID="grid_data_d" DataSourceID="sds_detail" DataKeyNames="purchase_order, product_kind, product_code">

                                    <Columns>
                                        <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:ImageButton ID="ibtn_insert" OnClientClick="save_bottom();" runat="server" ImageUrl="~/Image/select.png" CssClass="margin-top-6"></asp:ImageButton>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:ImageButton ID="ibtn_edit" CommandName="Edit" runat="server" ImageUrl="~/Image/edit.png" onmouseover="this.src='/Image/edit_1.png'" onmouseout="this.src='/Image/edit.png'"></asp:ImageButton>
                                            </ItemTemplate>
                                            <EditItemTemplate>
                                                <asp:ImageButton ID="ibtn_update" CommandName="Update" runat="server" ImageUrl="~/Image/update.png" onmouseover="this.src='/Image/update_1.png'" onmouseout="this.src='/Image/update.png'" OnClientClick="return(confirm('確認要更新嗎？'))"></asp:ImageButton>
                                                <asp:ImageButton ID="ibtn_cancel" CommandName="Cancel" runat="server" ImageUrl="~/Image/cancel.png" onmouseover="this.src='/Image/cancel_1.png'" onmouseout="this.src='/Image/cancel.png'"></asp:ImageButton>
                                            </EditItemTemplate>
                                            <HeaderStyle Width="6%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="進貨單號">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_purchase_order" runat="server" Text='<%#Bind("purchase_order") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="13%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="產品分類" SortExpression="product_kind">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_product_kind_name" runat="server" Text='<%#Bind("product_kind_name") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="產品名稱">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_product_code_name" runat="server" Text='<%#Bind("product_code_name") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="存貨數量">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_stock_amount" runat="server" Text='<%#Bind("stock_amount") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="倉庫名稱">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_warehouse_id_name" runat="server" Text='<%#Bind("warehouse_name") %>'></asp:Label>
                                            </ItemTemplate>
                                            <EditItemTemplate>
                                                <asp:DropDownList ID="drop_warehouse_id" runat="server" SelectedValue='<%#Bind("warehouse_id") %>' CssClass="dropdwonlist-size2" OnDataBinding="drop_warehouse_id_DataBinding"></asp:DropDownList>
                                            </EditItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="進貨單日期">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_stock_date" runat="server" Text='<%#Bind("stock_date") %>'></asp:Label>
                                            </ItemTemplate>
                                            <EditItemTemplate>
                                                <asp:TextBox ID="text_stock_date" runat="server" Text='<%#Bind("stock_date") %>'></asp:TextBox>
                                                <asp:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="text_stock_date" Format="yyyy/MM/dd"></asp:CalendarExtender>
                                            </EditItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="調整日期">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_stock_adjustment_date" runat="server" Text='<%#Bind("stock_adjustment_date") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>


                                        <asp:TemplateField HeaderText="備註">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_stock_remarks" runat="server" Text='<%#Bind("stock_remarks") %>'></asp:Label>
                                            </ItemTemplate>
                                            <EditItemTemplate>
                                                <asp:TextBox ID="lab_stock_remarks" runat="server" Text='<%#Bind("stock_remarks") %>' CssClass="text-size2"></asp:TextBox>
                                            </EditItemTemplate>
                                            <HeaderStyle Width="15%" />
                                        </asp:TemplateField>

                                    </Columns>

                                    <PagerTemplate>
                                        <table style="width: 100%">
                                            <tr style="width: 100%">
                                                <td class="left">
                                                    <asp:LinkButton runat="server" ID="linkbtn_first" Text="第一頁" OnClick="linkbtn_first_Click"></asp:LinkButton>
                                                    <asp:LinkButton runat="server" ID="linkbtn_next" Text="下一頁" OnClick="linkbtn_next_Click"></asp:LinkButton>
                                                    <asp:LinkButton runat="server" ID="linkbtn_previous" Text="上一頁" OnClick="linkbtn_previous_Click"></asp:LinkButton>
                                                    <asp:LinkButton runat="server" ID="linkbtn_last" Text="最後一頁" OnClick="linkbtn_last_Click"></asp:LinkButton>
                                                </td>
                                                <td class="right">
                                                    <asp:DropDownList runat="server" ID="drop_page_index" CssClass="blue-style4 dropdwonlist_size1" OnDataBinding="drop_page_index_DataBinding" OnSelectedIndexChanged="drop_page_index_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                                                    <asp:Label ID="lab_sum" runat="server" Text="顯示筆數："></asp:Label>
                                                    <asp:DropDownList runat="server" ID="drop_page_size" CssClass="blue-style4 dropdwonlist_size1" OnDataBinding="drop_page_size_DataBinding" AutoPostBack="true" OnSelectedIndexChanged="drop_page_size_SelectedIndexChanged">
                                                        <asp:ListItem>10</asp:ListItem>
                                                        <asp:ListItem>20</asp:ListItem>
                                                        <asp:ListItem>30</asp:ListItem>
                                                        <asp:ListItem>40</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                        </table>
                                    </PagerTemplate>
                                    <EmptyDataTemplate>
                                        無顯示資料!-
                                    </EmptyDataTemplate>
                                    <HeaderStyle CssClass="no-border header-style1 font-style1" ForeColor="White" Width="100%" />
                                    <RowStyle CssClass="no-border font-style1" />
                                    <FooterStyle CssClass="foot-style1" />
                                    <PagerSettings Position="Top" />
                                    <PagerStyle CssClass="gridpage-style1 font-style1" ForeColor="Black" HorizontalAlign="Right" />
                                    <SelectedRowStyle CssClass="select-style1" Font-Bold="true" />
                                    <SortedAscendingCellStyle CssClass="gray-style1" />
                                    <SortedAscendingHeaderStyle CssClass="black-style1" />
                                    <SortedDescendingCellStyle CssClass="gray-style12" />
                                    <SortedDescendingHeaderStyle CssClass="black-style2" />
                                </cc1:GGridView>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="btn_search" EventName="Click" />
                                <asp:AsyncPostBackTrigger ControlID="grid_data_m" EventName="RowCommand" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </asp:Panel>
                </asp:View>
            </asp:MultiView>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="grid_data_m" EventName="RowCommand" />
            <%-- <asp:AsyncPostBackTrigger ControlID="form_view_master" EventName="ItemCommand" />--%>
        </Triggers>
    </asp:UpdatePanel>

    <asp:Literal ID="Literal1" runat="server"></asp:Literal>

    <asp:SqlDataSource ID="sds_main" runat="server" ConnectionString="<%$ ConnectionStrings:MNDT %>" OldValuesParameterFormatString="original_{0}" ProviderName="<%$ ConnectionStrings:MNDT.ProviderName %>"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sds_detail" runat="server" SelectCommand="SELECT [stock].[product_kind]
	  ,[product_m].[product_kind_name]
      ,[stock].[product_code]
	  ,[product_d].[product_code_name]
      ,[stock].[purchase_order]
      ,[stock].[warehouse_id]
	  ,[warehouse].[warehouse_name]
      ,[stock].[stock_amount]
      ,[stock].[stock_adjustment_date]
      ,[stock].[stock_remarks]
	  ,CONVERT(char, [stock].[stock_date], 111) 'stock_date'
FROM [MNDTstock] [stock] LEFT JOIN [MNDTproduct_master] [product_m]
ON [stock].[product_kind] = [product_m].[product_kind] LEFT JOIN [MNDTproduct_details] [product_d]
ON [stock].[product_kind] = [product_d].[product_kind]
	AND [stock].[product_code] = [product_d].[product_code] LEFT JOIN [MNDTwarehouse] [warehouse]
ON [stock].[warehouse_id] = [warehouse].[warehouse_id] 
WHERE [stock].[product_kind] = @product_kind
	AND [stock].[product_code] = @product_code"
        ConnectionString="<%$ ConnectionStrings:MNDT %>" OldValuesParameterFormatString="original_{0}" ProviderName="<%$ ConnectionStrings:MNDT.ProviderName %>" UpdateCommand="UPDATE [MNDTstock]
   SET [warehouse_id] = @warehouse_id
      ,[stock_remarks] = @stock_remarks
      ,[stock_date] = @stock_date
      ,[modify_user_id] = @sId
      ,[modify_datetime] = GETDATE()
WHERE [product_kind] = @original_product_kind
	AND [product_code] = @original_product_code
	AND [purchase_order] = @original_purchase_order"
        OnUpdated="sds_detail_Updated">
        <SelectParameters>
            <asp:Parameter Name="product_kind" />
            <asp:Parameter Name="product_code" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="warehouse_id" />
            <asp:Parameter Name="stock_remarks" />
            <asp:SessionParameter Name="sId" SessionField="sId" />
            <asp:Parameter Name="original_product_kind" />
            <asp:Parameter Name="original_product_code" />
            <asp:Parameter Name="original_purchase_order" />
            <asp:Parameter Name="stock_date" />
        </UpdateParameters>
    </asp:SqlDataSource>
</asp:Content>
