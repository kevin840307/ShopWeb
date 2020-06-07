<%@ Page Language="C#" Async="true" MasterPageFile="~/MasterPage.master" EnableEventValidation="false" AutoEventWireup="true" CodeFile="MNDT3040.aspx.cs" Inherits="MNDT3040" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<%@ Register Assembly="GGridView" Namespace="GGridView" TagPrefix="cc1" %>


<asp:Content runat="server" ID="const" ContentPlaceHolderID="ContentPlaceHolder1">

    <asp:Literal runat="server" ID="Literal1"></asp:Literal>
    <asp:UpdatePanel runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:MultiView runat="server" ID="multi_view" ActiveViewIndex="0">
                <asp:View runat="server" ID="view_master">
                    <table class="blue-style2 table-size1">
                        <tr>
                            <td rowspan="4">&nbsp;查詢<br />
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
                                <asp:Label runat="server" Text="進貨單日期：" CssClass="font-style1"></asp:Label>
                            </td>
                            <td class="left">
                                <asp:TextBox ID="text_receive_datetime" runat="server" CssClass="text-size2 pointer-style1"></asp:TextBox>
                                <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="text_receive_datetime" Format="yyyy/MM/dd"></asp:CalendarExtender>
                            </td>
                        </tr>
                        <tr>
                            <td class="right">
                                <asp:Label runat="server" Text="退貨單日期：" CssClass="font-style1"></asp:Label>
                            </td>
                            <td class="left">
                                <asp:TextBox ID="text_return_datetime" runat="server" CssClass="text-size2 pointer-style1"></asp:TextBox>
                                <asp:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="text_return_datetime" Format="yyyy/MM/dd"></asp:CalendarExtender>
                            </td>
                        </tr>
                        <tr>
                            <td class="right">
                                <asp:Label runat="server" Text="退貨人：" CssClass="font-style1"></asp:Label>
                            </td>
                            <td class="left">
                                <asp:DropDownList ID="drop_return_id" runat="server" CssClass="dropdwonlist-size2" DataSourceID="sds_return_id" DataTextField="account_name" DataValueField="account_id"></asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" class="center">
                                <asp:Button runat="server" Text="查詢" ID="btn_search" CssClass="blue-style6 button-size2" OnClick="btn_search_Click" />
                                <asp:Button runat="server" Text="清除" CssClass="blue-style6 button-size2" />
                            </td>
                        </tr>
                    </table>
                    <asp:Panel runat="server" ScrollBars="Vertical" Height="460px" CssClass="div-scroll div-scroll-size2" ID="panel_scroll_m">
                        <asp:UpdatePanel runat="server">
                            <ContentTemplate>
                                <cc1:GGridView EmptyShowHeader="True" EmptyDataText="無顯示資料" runat="server" OnRowDataBound="grid_data_RowDataBound" OnSelectedIndexChanged="grid_data_SelectedIndexChanged"
                                    OnSelectedIndexChanging="grid_data_SelectedIndexChanging" OnRowCommand="grid_data_m_RowCommand"
                                    Width="1005px" GridLines="Horizontal" AllowSorting="True"
                                    AutoGenerateColumns="False" CssClass="white-style2 no-border border-style1 font-style2" AllowPaging="True"
                                    ID="grid_data_m" DataSourceID="sds_main" DataKeyNames="return_order, purchase_order">
                                    <Columns>
                                        <asp:TemplateField HeaderText="新增">
                                            <HeaderTemplate>
                                                <asp:ImageButton ID="ibtn_insert" CommandName="OpenInsert" OnClientClick="save_bottom();" runat="server" ImageUrl="~/Image/header_add.png" CssClass="margin-top-6"></asp:ImageButton>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:ImageButton ID="ibtn_Select" CommandName="SelectData" runat="server" ImageUrl="~/Image/select.png" onmouseover="this.src='/Image/select_1.png'" onmouseout="this.src='/Image/select.png'" CommandArgument='<%# Container.DataItemIndex %>'></asp:ImageButton>
                                                <asp:ImageButton ID="ibtn_delete" CommandName="Delete" runat="server" ImageUrl="~/Image/delete.png" onmouseover="this.src='/Image/delete_1.png'" onmouseout="this.src='/Image/delete.png'" OnClientClick="return(confirm('明細+主檔確認要刪除嗎？'))"></asp:ImageButton>
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="退貨單號">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_return_order" runat="server" Text='<%#Bind("return_order") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="進貨單號" SortExpression="group_id">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_purchase_order" runat="server" Text='<%#Bind("purchase_order") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="退貨人">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_return_id" Visible="false" runat="server" Text='<%#Bind("return_id") %>'></asp:Label>
                                                <asp:Label ID="lab_account_name" runat="server" Text='<%#Bind("account_name") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="退貨單日期">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_return_datetime" runat="server" Text='<%#Bind("return_datetime") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="進貨單日期">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_receive_datetime" runat="server" Text='<%#Bind("receive_datetime") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="備註">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_return_remarks" runat="server" Text='<%#Bind("return_remarks") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
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

                                    <HeaderStyle CssClass="no-border header-style1 font-style1" ForeColor="White" />
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
                        </asp:UpdatePanel>
                    </asp:Panel>
                </asp:View>

                <asp:View runat="server" ID="view_detail">

                    <table class="blue-style2 table-size1 center">
                        <tr>
                            <td>主檔</td>
                        </tr>
                    </table>

                    <asp:FormView runat="server" ID="fv_master_form" DataSourceID="sds_main" CssClass="max-width" DefaultMode="Edit" DataKeyNames="return_order" OnItemCommand="fv_master_form_ItemCommand">
                        <EditItemTemplate>
                            <table class="max-width">

                                <tr class="max-width">
                                    <td colspan="3" rowspan="5" class="left">
                                        <asp:ImageButton ID="imgbtn_last" runat="server" ImageUrl="~/Image/last_one.png" onmouseover="this.src='/Image/last_one_1.png'" onmouseout="this.src='/Image/last_one.png'" OnClick="imgbtn_last_Click" />
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="退貨單號："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_return_order" Text='<%#Bind("return_order") %>' Enabled="false" CssClass="text-size2"></asp:TextBox>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="退貨人："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:DropDownList runat="server" ID="drop_edit_return_id" Text='<%#Bind("return_id") %>' CssClass="dropdwonlist-size2" OnDataBinding="drop_return_id_DataBinding"></asp:DropDownList>
                                    </td>
                                    <td colspan="3" rowspan="5" class="right">
                                        <asp:ImageButton ID="imgbtn_next" runat="server" ImageUrl="~/Image/next_one.png" onmouseover="this.src='/Image/next_one_1.png'" onmouseout="this.src='/Image/next_one.png'" OnClick="imgbtn_next_Click" />
                                    </td>
                                </tr>


                                <tr class="max-width">
                                    <td class="right">
                                        <asp:Label runat="server" Text="進貨單號："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_edit_purchase_order" Text='<%#Bind("purchase_order") %>' Enabled="false" CssClass="text-size2"></asp:TextBox>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="進貨單日期："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_edit_receive_datetime" Text='<%#Bind("receive_datetime") %>' CssClass="text-size2 pointer-style1" Enabled="false"></asp:TextBox>
                                    </td>
                                </tr>


                                <tr class="max-width">
                                    <td class="right">
                                        <asp:Label runat="server" Text="退貨單日期："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_edit_return_datetime" Text='<%#Bind("return_datetime") %>' CssClass="text-size2 pointer-style1"></asp:TextBox>
                                        <asp:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="text_edit_return_datetime" Format="yyyy/MM/dd"></asp:CalendarExtender>
                                    </td>
                                </tr>

                                <tr class="max-width">
                                    <td class="right">
                                        <asp:Label runat="server" Text="備註："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_edit_return_remarks" Text='<%#Bind("return_remarks") %>' TextMode="MultiLine" CssClass="text-no-size text-size2"></asp:TextBox>
                                    </td>

                                </tr>
                                <tr>
                                    <td colspan="8" class="center">
                                        <asp:Button runat="server" CssClass="blue-style6 button-size2" Text="更新" CommandName="Update" OnClientClick="return(confirm('確認要更新嗎？'))" />
                                        <asp:Button runat="server" CssClass="blue-style6 button-size2" Text="刪除" CommandName="Delete" OnClientClick="return(confirm('主檔+明細確認要刪除嗎？'))" />
                                        <asp:Button runat="server" CssClass="blue-style6 button-size2" Text="取消" CommandName="Cancel" ID="btn_master_cancel" />
                                    </td>
                                </tr>
                            </table>
                            <table class="blue-style2 table-size1 center">
                                <tr>
                                    <td>明細</td>
                                </tr>
                            </table>
                        </EditItemTemplate>

                        <InsertItemTemplate>
                            <table class="max-width">
                                <tr>
                                    <td class="right">
                                        <asp:Label runat="server" Text="退貨單號："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" Text="自動填入" Enabled="false" CssClass="text-size2"></asp:TextBox>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="退貨人："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:DropDownList runat="server" ID="drop_insert_return_id" CssClass="dropdwonlist-size2" OnDataBinding="drop_return_id_DataBinding"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="right">
                                        <asp:Label runat="server" Text="進貨單號："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:DropDownList runat="server" ID="drop_purchase_order" CssClass="text-size2" OnDataBinding="drop_purchase_order_DataBinding" AutoPostBack="true" OnSelectedIndexChanged="drop_purchase_order_SelectedIndexChanged"></asp:DropDownList>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="退貨單日期："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_insert_return_datetime" CssClass="text-size2 pointer-style1"></asp:TextBox>
                                        <asp:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="text_insert_return_datetime" Format="yyyy/MM/dd"></asp:CalendarExtender>
                                    </td>
                                </tr>
                                <tr class="max-width">
                                    <td class="right">
                                        <asp:Label runat="server" Text="進貨單日期："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:DropDownList runat="server" ID="text_insert_receive_datetime" CssClass="text-size2" OnDataBinding="text_insert_receive_datetime_DataBinding" OnSelectedIndexChanged="text_insert_receive_datetime_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                                    </td>

                                </tr>


                                <tr>
                                    <td class="right">
                                        <asp:Label runat="server" Text="備註："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_insert_return_remarks" TextMode="MultiLine" CssClass="text-no-size text-size2"></asp:TextBox>
                                    </td>

                                </tr>
                                <tr>

                                    <td colspan="8" class="center">
                                        <asp:Button runat="server" CssClass="blue-style6 button-size2" Text="新增" CommandName="InsertData" />
                                        <asp:Button runat="server" CssClass="blue-style6 button-size2" Text="取消" CommandName="Cancel" ID="btn_master_cancel" />
                                    </td>

                                </tr>
                            </table>
                        </InsertItemTemplate>
                    </asp:FormView>

                    <asp:Panel ID="panel_detail" runat="server" ScrollBars="Vertical" Height="400px" CssClass="div-scroll div-scroll-size6" Visible="false">
                        <asp:UpdatePanel runat="server">
                            <ContentTemplate>
                                <cc1:GGridView runat="server" EmptyShowHeader="True" FooterInsert="true" EmptyDataText="無顯示資料" OnRowDataBound="grid_data_RowDataBound" OnSelectedIndexChanged="grid_data_SelectedIndexChanged"
                                    OnSelectedIndexChanging="grid_data_SelectedIndexChanging" OnRowCommand="grid_data_d_RowCommand" Width="1005px" GridLines="Horizontal" AllowSorting="True"
                                    AutoGenerateColumns="False" CellPadding="4" CssClass="white-style2 no-border border-style1 font-style2" AllowPaging="True"
                                    ID="grid_data_d" DataSourceID="sds_detail" DataKeyNames="return_order, purchase_order, product_kind, product_code">
                                    <Columns>
                                        <asp:TemplateField HeaderText="新增">
                                            <HeaderTemplate>
                                                <asp:ImageButton ID="ibtn_insert" CommandName="OpenInsert" OnClientClick="save_bottom();" runat="server" ImageUrl="~/Image/header_add.png" CssClass="margin-top-6"></asp:ImageButton>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:ImageButton ID="ibtn_edit" CommandName="Edit" runat="server" ImageUrl="~/Image/edit.png" onmouseover="this.src='/Image/edit_1.png'" onmouseout="this.src='/Image/edit.png'"></asp:ImageButton>
                                                <asp:ImageButton ID="ibtn_delete" CommandName="Delete" runat="server" ImageUrl="~/Image/delete.png" onmouseover="this.src='/Image/delete_1.png'" onmouseout="this.src='/Image/delete.png'" OnClientClick="return(confirm('確認要刪除嗎？'))"></asp:ImageButton>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                <asp:ImageButton ID="ibtn_insert" CommandName="InsertData" runat="server" ImageUrl="~/Image/insert.png" onmouseover="this.src='/Image/insert_1.png'" onmouseout="this.src='/Image/insert.png'"></asp:ImageButton>
                                                <asp:ImageButton ID="ibtn_cancel" CommandName="CloseInsert" runat="server" ImageUrl="~/Image/cancel.png" onmouseover="this.src='/Image/cancel_1.png'" onmouseout="this.src='/Image/cancel.png'"></asp:ImageButton>
                                            </FooterTemplate>
                                            <EditItemTemplate>
                                                <asp:ImageButton ID="ibtn_update" CommandName="Update" runat="server" ImageUrl="~/Image/update.png" onmouseover="this.src='/Image/update_1.png'" onmouseout="this.src='/Image/update.png'" OnClientClick="return(confirm('確認要更新嗎？'))"></asp:ImageButton>
                                                <asp:ImageButton ID="ibtn_cancel" CommandName="Cancel" runat="server" ImageUrl="~/Image/cancel.png" onmouseover="this.src='/Image/cancel_1.png'" onmouseout="this.src='/Image/cancel.png'"></asp:ImageButton>
                                            </EditItemTemplate>
                                            <HeaderStyle Width="8%" />
                                        </asp:TemplateField>


                                        <asp:TemplateField HeaderText="退貨編號" SortExpression="purchase_order">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_return_order" runat="server" Text='<%#Bind("return_order") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="15%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="產品分類">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_product_kind_name" runat="server" Text='<%#Bind("product_kind_name") %>'></asp:Label>
                                                <asp:Label ID="lab_product_kind" runat="server" Text='<%#Bind("product_kind") %>' Visible="false"></asp:Label>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                <asp:DropDownList ID="drop_product_kind" runat="server" Width="90%" OnSelectedIndexChanged="drop_product_kind_SelectedIndexChanged" OnDataBinding="drop_product_kind_DataBinding" AutoPostBack="true"></asp:DropDownList>
                                            </FooterTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="產品名稱">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_product_code_name" runat="server" Text='<%#Bind("product_code_name") %>'></asp:Label>
                                                <asp:Label ID="lab_product_code" runat="server" Text='<%#Bind("product_code") %>' Visible="false"></asp:Label>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                <asp:DropDownList ID="drop_product_code" runat="server" OnSelectedIndexChanged="drop_product_code_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                                            </FooterTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="退貨數量">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_return_amount" runat="server" Text='<%#Bind("return_amount") %>'></asp:Label>
                                                <asp:Label ID="lab_product_unit1" runat="server" Text='<%#Bind("product_unit") %>'></asp:Label>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                <asp:TextBox ID="text_return_amount" runat="server" Width="90%" OnTextChanged="text_return_amount_TextChanged" AutoPostBack="true"></asp:TextBox>
                                            </FooterTemplate>
                                            <EditItemTemplate>
                                                <asp:TextBox ID="text_return_amount" runat="server" Text='<%#Bind("return_amount") %>' OnTextChanged="text_return_amount_TextChanged" AutoPostBack="true" Width="90%"></asp:TextBox>
                                            </EditItemTemplate>
                                            <HeaderStyle Width="8%" />
                                        </asp:TemplateField>


                                        <asp:TemplateField HeaderText="收回金額">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_return_money" runat="server" Text='<%#Bind("return_money_get") %>'></asp:Label>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                <asp:TextBox ID="text_return_money_get" runat="server" Width="90%"></asp:TextBox>
                                            </FooterTemplate>
                                            <EditItemTemplate>
                                                <asp:TextBox ID="text_return_money_get" runat="server" Text='<%#Bind("return_money_get") %>' Width="90%"></asp:TextBox>
                                            </EditItemTemplate>
                                            <HeaderStyle Width="8%" />
                                        </asp:TemplateField>


                                        <asp:TemplateField HeaderText="退貨原因">
                                            <ItemTemplate>
                                                <asp:Label runat="server" ID="lab_return_reason" Text='<%#Bind("return_reason") %>'></asp:Label>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                <asp:TextBox ID="text_return_reason" runat="server" Width="90%"></asp:TextBox>
                                            </FooterTemplate>
                                            <EditItemTemplate>
                                                <asp:TextBox ID="text_return_reason" runat="server" Text='<%#Bind("return_reason") %>' Width="90%"></asp:TextBox>
                                            </EditItemTemplate>
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
                                    <HeaderStyle CssClass="no-border header-style1 font-style1" ForeColor="White" />
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
                        </asp:UpdatePanel>
                    </asp:Panel>
                </asp:View>
            </asp:MultiView>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="grid_data_m" EventName="RowCommand" />
            <asp:AsyncPostBackTrigger ControlID="drop_return_id" EventName="DataBinding" />
        </Triggers>
    </asp:UpdatePanel>
    <asp:SqlDataSource ID="sds_main" OnUpdated="sds_main_Updated" OnInserted="sds_main_Inserted" runat="server" ConnectionString="<%$ ConnectionStrings:MNDT %>" ProviderName="<%$ ConnectionStrings:MNDT.ProviderName %>" UpdateCommand="UPDATE [MNDTreturn_master]
   SET [return_id] = @return_id
      ,[return_datetime] = @return_datetime
      ,[return_remarks] = @return_remarks
      ,[modify_user_id] = @sId
      ,[modify_datetime] = GETDATE()
WHERE [return_order] = @original_return_order"
        InsertCommand="INSERT INTO [MNDTreturn_master]
           ([return_order]
           ,[purchase_order]
           ,[return_id]
           ,[return_datetime]
           ,[return_remarks]
           ,[create_user_id]
           ,[create_datetime]
           ,[modify_user_id]
           ,[modify_datetime])
VALUES
           (@return_order
           ,@purchase_order
           ,@return_id
           ,@return_datetime
           ,@return_remarks
           ,@sId
           ,GETDATE()
           ,@sId
           ,GETDATE())"
        DeleteCommand="UPDATE [MNDTstock] 
   SET [MNDTstock].[stock_amount] = [return_d].[return_amount] + [MNDTstock].[stock_amount]
      ,[modify_user_id] = @sId
      ,[modify_datetime] = GETDATE()
FROM [MNDTreturn_details] [return_d]
WHERE [MNDTstock].[purchase_order] = @original_purchase_order
                  AND [return_d].[return_order] = @original_return_order
	AND [return_d].[product_kind] = [MNDTstock].[product_kind]
	AND [return_d].[product_code] = [MNDTstock].[product_code]


DELETE FROM [MNDTreturn_master]
WHERE [return_order] =@original_return_order

DELETE FROM [MNDTreturn_details]
WHERE [return_order] =@original_return_order"
        OldValuesParameterFormatString="original_{0}" OnDeleted="sds_main_Deleted">
        <DeleteParameters>
            <asp:SessionParameter Name="sId" SessionField="sId" />
            <asp:Parameter Name="original_purchase_order" />
            <asp:Parameter Name="original_return_order" />
        </DeleteParameters>
        <InsertParameters>
            <asp:SessionParameter Name="sId" SessionField="sId" />
            <asp:Parameter Name="return_order" />
            <asp:Parameter Name="purchase_order" />
            <asp:Parameter Name="return_id" />
            <asp:Parameter Name="return_datetime" />
            <asp:Parameter Name="return_remarks" />
        </InsertParameters>
        <UpdateParameters>
            <asp:SessionParameter Name="sId" SessionField="sId" />
            <asp:Parameter Name="return_id" />
            <asp:Parameter Name="return_datetime" />
            <asp:Parameter Name="return_remarks" />
            <asp:Parameter Name="original_return_order" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sds_return_id" runat="server" SelectCommand="SELECT '' 'account_id', '' 'account_name' UNION SELECT [account_id]       
                                 ,[account_id]  + '：' +  [account_name] AS 'account_name'
                           FROM [MNDTaccount]       
                           WHERE [account_department] = '0001'   "
        ConnectionString="<%$ ConnectionStrings:MNDT %>" ProviderName="<%$ ConnectionStrings:MNDT.ProviderName %>"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sds_detail" runat="server" ConnectionString="<%$ ConnectionStrings:MNDT %>" ProviderName="<%$ ConnectionStrings:MNDT.ProviderName %>" SelectCommand="SELECT [return_d].[return_order]
      ,@purchase_order 'purchase_order'
      ,[return_d].[product_kind]
	  ,[product_m].[product_kind_name]
      ,[return_d].[product_code]
	  ,[product_d].[product_code_name]
	  ,[product_d].[product_unit]
      ,[return_d].[return_amount]
      ,[return_d].[return_money_get]
      ,[return_d].[return_reason]
FROM [MNDTreturn_details] [return_d] LEFT JOIN [MNDTproduct_master] [product_m]
ON [return_d].[product_kind] = [product_m].[product_kind] LEFT JOIN [MNDTproduct_details] [product_d]
ON [return_d].[product_kind] = [product_d].[product_kind]
	AND [return_d].[product_code] = [product_d].[product_code]
WHERE [return_order] = @return_order"
        InsertCommand="INSERT INTO [MNDTreturn_details]
           ([return_order]
           ,[product_kind]
           ,[product_code]
           ,[return_amount]
           ,[return_money_get]
           ,[return_reason]
           ,[create_user_id]
           ,[create_datetime]
           ,[modify_user_id]
           ,[modify_datetime])
VALUES
           (@return_order
           ,@product_kind
           ,@product_code
           ,@return_amount
           ,@return_money_get
           ,@return_reason
           ,@sId
           ,GETDATE()
           ,@sId
           ,GETDATE())"
        OnInserted="sds_detail_Inserted" DeleteCommand="UPDATE [MNDTstock]
   SET [stock_amount] = CAST((SELECT [return_amount]
							FROM [MNDTreturn_details]
							WHERE [return_order] = @original_return_order
								AND [product_kind] = @original_product_kind
								AND [product_code] = @original_product_code) AS int)
						+ [stock_amount]
      ,[modify_user_id] = @sId
      ,[modify_datetime] = GETDATE()
WHERE [purchase_order] = @original_purchase_order
	AND [product_kind] = @original_product_kind
	AND [product_code] = @original_product_code


DELETE FROM [MNDTreturn_details]
WHERE [return_order] =@original_return_order
	AND [product_kind] = @original_product_kind
	AND [product_code] = @original_product_code

"
        OldValuesParameterFormatString="original_{0}" UpdateCommand="UPDATE [MNDTreturn_details]
   SET [return_amount] = @return_amount
      ,[return_money_get] = @return_money_get
      ,[return_reason] = @return_reason
      ,[modify_user_id] = @sId
      ,[modify_datetime] = GETDATE()
WHERE [return_order] =@original_return_order
	AND [product_kind] = @original_product_kind
	AND [product_code] = @original_product_code


UPDATE [MNDTstock]
   SET [stock_amount] = CAST((SELECT [receive_amount_mod]
							FROM [MNDTreceive_details]
							WHERE [purchase_order] = @original_purchase_order
								AND [product_kind] = @original_product_kind
								AND [product_code] = @original_product_code) AS int)
						- CAST(@return_amount AS int)
      ,[modify_user_id] = @sId
      ,[modify_datetime] = GETDATE()
WHERE [purchase_order] = @original_purchase_order
	AND [product_kind] = @original_product_kind
	AND [product_code] = @original_product_code"
        OnUpdated="sds_detail_Updated" OnDeleted="sds_detail_Deleted">
        <DeleteParameters>
            <asp:SessionParameter Name="sId" SessionField="sId" />
            <asp:Parameter Name="original_purchase_order" />
            <asp:Parameter Name="return_amount" />
            <asp:Parameter Name="original_product_kind" />
            <asp:Parameter Name="original_product_code" />
            <asp:Parameter Name="original_return_order" />
        </DeleteParameters>
        <InsertParameters>
            <asp:SessionParameter Name="sId" SessionField="sId" />
            <asp:Parameter Name="return_order" />
            <asp:Parameter Name="product_kind" />
            <asp:Parameter Name="product_code" />
            <asp:Parameter Name="return_amount" />
            <asp:Parameter Name="return_money_get" />
            <asp:Parameter Name="return_reason" />
        </InsertParameters>
        <SelectParameters>
            <asp:Parameter Name="return_order" />
            <asp:Parameter Name="purchase_order" />
        </SelectParameters>
        <UpdateParameters>
            <asp:SessionParameter Name="sId" SessionField="sId" />
            <asp:Parameter Name="return_amount" />
            <asp:Parameter Name="return_money_get" />
            <asp:Parameter Name="return_reason" />
            <asp:Parameter Name="original_return_order" />
            <asp:Parameter Name="original_product_kind" />
            <asp:Parameter Name="original_product_code" />
            <asp:Parameter Name="original_purchase_order" />
        </UpdateParameters>
    </asp:SqlDataSource>

</asp:Content>
