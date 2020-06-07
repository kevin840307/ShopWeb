﻿<%@ Page Language="C#" Async="true" MasterPageFile="~/MasterPage.master" EnableEventValidation="false" AutoEventWireup="true" CodeFile="MNDT3010.aspx.cs" Inherits="MNDT3010" %>

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
                                <asp:Label runat="server" Text="請購日期：" CssClass="font-style1"></asp:Label>
                            </td>
                            <td class="left">
                                <asp:TextBox ID="text_requisition_datetime" runat="server" CssClass="text-size2 pointer-style1"></asp:TextBox>
                                <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="text_requisition_datetime" Format="yyyy/MM/dd"></asp:CalendarExtender>
                            </td>
                        </tr>
                        <tr>

                            <td class="right">
                                <asp:Label runat="server" Text="審核：" CssClass="font-style1"></asp:Label>
                            </td>
                            <td class="left">
                                <asp:DropDownList ID="drop_requisition_review" runat="server" CssClass="dropdwonlist-size2">
                                    <asp:ListItem Value="0">未審核</asp:ListItem>
                                    <asp:ListItem Value="1">已審核</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td class="right">
                                <asp:Label runat="server" Text="需求日期：" CssClass="font-style1"></asp:Label>
                            </td>
                            <td class="left">
                                <asp:TextBox ID="text_need_datetime" runat="server" CssClass="text-size2 pointer-style1"></asp:TextBox>
                                <asp:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="text_need_datetime" Format="yyyy/MM/dd"></asp:CalendarExtender>
                            </td>
                        </tr>
                        <tr>
                            <td class="right">
                                <asp:Label runat="server" Text="請購人：" CssClass="font-style1"></asp:Label>
                            </td>
                            <td class="left">
                                <asp:DropDownList ID="drop_requisition_id" runat="server" CssClass="dropdwonlist-size2" DataSourceID="sds_requisition_id" DataTextField="account_name" DataValueField="account_id"></asp:DropDownList>
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
                                    ID="grid_data_m" DataSourceID="sds_main" DataKeyNames="purchase_order">
                                    <Columns>
                                        <asp:TemplateField HeaderText="新增">
                                            <HeaderTemplate>
                                                <asp:ImageButton ID="ibtn_insert" CommandName="OpenInsert" OnClientClick="save_bottom();" runat="server" ImageUrl="~/Image/header_add.png" CssClass="margin-top-6"></asp:ImageButton>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:ImageButton ID="ibtn_Select" CommandName="SelectData" runat="server" ImageUrl="~/Image/select.png" onmouseover="this.src='/Image/select_1.png'" onmouseout="this.src='/Image/select.png'" CommandArgument='<%# Container.DataItemIndex %>'></asp:ImageButton>
                                                <asp:ImageButton ID="ibtn_delete" CommandName="Delete" runat="server" ImageUrl="~/Image/delete.png" onmouseover="this.src='/Image/delete_1.png'" onmouseout="this.src='/Image/delete.png'" OnClientClick="return(confirm('明細+主檔確認要刪除嗎？'))"></asp:ImageButton>
                                                <asp:ImageButton ID="ibtn_review" CommandName="Review" runat="server" ImageUrl="~/Image/review.png" onmouseover="this.src='/Image/review_1.png'" onmouseout="this.src='/Image/review.png'" CommandArgument='<%# Container.DataItemIndex %>' OnClientClick="return(confirm('確認要審核嗎？'))"></asp:ImageButton>
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="進貨單號" SortExpression="group_id">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_purchase_order" runat="server" Text='<%#Bind("purchase_order") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="請購人">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_requisition_id" Visible="false" runat="server" Text='<%#Bind("requisition_id") %>'></asp:Label>
                                                <asp:Label ID="lab_account_name" runat="server" Text='<%#Bind("account_name") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="請購日期">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_requisition_datetime" runat="server" Text='<%#Bind("requisition_datetime") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="需求日期">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_need_datetime" runat="server" Text='<%#Bind("need_datetime") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="請購審核">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_requisition_review" runat="server" Text='<%#Bind("requisition_review") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="用途" SortExpression="create_datetime">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_requisition_use" runat="server" Text='<%#Bind("requisition_use") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="備註">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_requisition_remarks" runat="server" Text='<%#Bind("requisition_remarks") %>'></asp:Label>
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

                    <asp:FormView runat="server" ID="fv_master_form" DataSourceID="sds_main" CssClass="max-width" DefaultMode="Edit" DataKeyNames="purchase_order" OnItemCommand="fv_master_form_ItemCommand">
                        <EditItemTemplate>
                            <table class="max-width">

                                <tr class="max-width">
                                    <td colspan="3" rowspan="5" class="left">
                                        <asp:ImageButton ID="imgbtn_last" runat="server" ImageUrl="~/Image/last_one.png" onmouseover="this.src='/Image/last_one_1.png'" onmouseout="this.src='/Image/last_one.png'" OnClick="imgbtn_last_Click" />
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="進貨單號："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_edit_purchase_order" Text='<%#Bind("purchase_order") %>' Enabled="false" CssClass="text-size2"></asp:TextBox>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="請購人："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:DropDownList runat="server" ID="drop_edit_requisition_id" Text='<%#Bind("requisition_id") %>' CssClass="dropdwonlist-size2" OnDataBinding="drop_requisition_id_DataBinding"></asp:DropDownList>
                                    </td>
                                    <td colspan="3" rowspan="5" class="right">
                                        <asp:ImageButton ID="imgbtn_next" runat="server" ImageUrl="~/Image/next_one.png" onmouseover="this.src='/Image/next_one_1.png'" onmouseout="this.src='/Image/next_one.png'" OnClick="imgbtn_next_Click" />
                                    </td>
                                </tr>

                                <tr class="max-width">
                                    <td class="right">
                                        <asp:Label runat="server" Text="請購日期："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_edit_requisition_datetime" Text='<%#Bind("requisition_datetime") %>' CssClass="text-size2 pointer-style1"></asp:TextBox>
                                        <asp:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="text_edit_requisition_datetime" Format="yyyy/MM/dd"></asp:CalendarExtender>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="需求日期："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_edit_need_datetime" Text='<%#Bind("need_datetime") %>' CssClass="text-size2 pointer-style1"></asp:TextBox>
                                        <asp:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="text_edit_need_datetime" Format="yyyy/MM/dd"></asp:CalendarExtender>
                                    </td>
                                </tr>

                                <tr class="max-width">
                                    <td class="right">
                                        <asp:Label runat="server" Text="審核："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_requisition_review" Text='<%#Bind("requisition_review") %>' Enabled="false" CssClass="text-size2"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="right">
                                        <asp:Label runat="server" Text="用途："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_edit_requisition_use" Text='<%#Bind("requisition_use") %>' CssClass="text-size2"></asp:TextBox>
                                    </td>
                                </tr>

                                <tr class="max-width">
                                    <td class="right">
                                        <asp:Label runat="server" Text="備註："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_edit_requisition_remarks" Text='<%#Bind("requisition_remarks") %>' TextMode="MultiLine" CssClass="text-no-size text-size2"></asp:TextBox>
                                    </td>

                                </tr>
                                <tr>
                                    <td colspan="8" class="center">
                                        <asp:Button runat="server" CssClass="blue-style6 button-size2" Text="更新" CommandName="Update" OnClientClick="return(confirm('確認要更新嗎？'))" />
                                        <asp:Button runat="server" CssClass="blue-style6 button-size2" Text="審核" CommandName="Review" OnClientClick="return(confirm('確定要通過審核嗎？'))" />
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
                                <tr class="max-width">
                                    <td class="right">
                                        <asp:Label runat="server" Text="進貨單號："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" Text="自動填入" Enabled="false" CssClass="text-size2"></asp:TextBox>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="請購人："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:DropDownList runat="server" ID="drop_insert_requisition_id" CssClass="dropdwonlist-size2" OnDataBinding="drop_requisition_id_DataBinding"></asp:DropDownList>
                                    </td>
                                </tr>

                                <tr class="max-width">
                                    <td class="right">
                                        <asp:Label runat="server" Text="請購日期："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_insert_requisition_datetime" CssClass="text-size2 pointer-style1"></asp:TextBox>
                                        <asp:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="text_insert_requisition_datetime" Format="yyyy/MM/dd"></asp:CalendarExtender>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="需求日期："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_insert_need_datetime" CssClass="text-size2 pointer-style1"></asp:TextBox>
                                        <asp:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="text_insert_need_datetime" Format="yyyy/MM/dd"></asp:CalendarExtender>
                                    </td>
                                </tr>

                                <tr>
                                    <td class="right">
                                        <asp:Label runat="server" Text="用途："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_insert_requisition_use" CssClass="text-size2"></asp:TextBox>
                                    </td>
                                </tr>

                                <tr>
                                    <td class="right">
                                        <asp:Label runat="server" Text="備註："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_insert_requisition_remarks" TextMode="MultiLine" CssClass="text-no-size text-size2"></asp:TextBox>
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
                                    ID="grid_data_d" DataSourceID="sds_detail" DataKeyNames="purchase_order, product_kind, product_code">
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
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="進貨編號" SortExpression="purchase_order">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_purchase_order" runat="server" Text='<%#Bind("purchase_order") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="15%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="產品分類">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_product_kind" runat="server" Text='<%#Bind("product_kind_name") %>'></asp:Label>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                <asp:DropDownList ID="drop_product_kind" runat="server" Width="90%" OnSelectedIndexChanged="drop_product_kind_SelectedIndexChanged" OnDataBinding="drop_product_kind_DataBinding" AutoPostBack="true"></asp:DropDownList>
                                            </FooterTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="產品名稱">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_product_code" runat="server" Text='<%#Bind("product_code_name") %>'></asp:Label>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                <asp:DropDownList ID="drop_product_code" runat="server" OnSelectedIndexChanged="drop_product_code_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                                            </FooterTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="產品數量">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_requisition_amount" runat="server" Text='<%#Bind("requisition_amount") %>'></asp:Label>
                                                <asp:Label ID="lab_product_unit1" runat="server" Text='<%#Bind("product_unit") %>'></asp:Label>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                <asp:TextBox ID="text_requisition_amount" runat="server" Width="90%" OnTextChanged="text_requisition_amount_TextChanged" AutoPostBack="true"></asp:TextBox>
                                            </FooterTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>


                                        <asp:TemplateField HeaderText="產品金額">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_requisition_money" runat="server" Text='<%#Bind("requisition_money") %>'></asp:Label>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                <asp:TextBox ID="text_requisition_money" runat="server" Text="點選確認價格" Width="90%" ReadOnly="true"></asp:TextBox>
                                            </FooterTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="修訂數量">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_requisition_amount_mod" runat="server" Text='<%#Bind("requisition_amount_mod") %>'></asp:Label>
                                                <asp:Label ID="lab_product_unit2" runat="server" Text='<%#Bind("product_unit") %>'></asp:Label>
                                            </ItemTemplate>
                                            <EditItemTemplate>
                                                <asp:TextBox ID="text_requisition_amount_mod" runat="server" Text='<%#Bind("requisition_amount_mod") %>' Width="90%"></asp:TextBox>
                                            </EditItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>


                                        <asp:TemplateField HeaderText="修訂金額">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_requisition_money_mod" runat="server" Text='<%#Bind("requisition_money_mod") %>'></asp:Label>
                                            </ItemTemplate>
                                            <EditItemTemplate>
                                                <asp:TextBox ID="text_requisition_money_mod" runat="server" Text='<%#Bind("requisition_money_mod") %>' Width="90%"></asp:TextBox>
                                            </EditItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="備註">
                                            <ItemTemplate>
                                                <asp:Label runat="server" ID="lab_requisition_remarks" Text='<%#Bind("requisition_remarks") %>'></asp:Label>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                <asp:TextBox ID="text_requisition_remarks" runat="server" Width="90%"></asp:TextBox>
                                            </FooterTemplate>
                                            <EditItemTemplate>
                                                <asp:TextBox ID="text_requisition_remarks" runat="server" Text='<%#Bind("requisition_remarks") %>' Width="90%"></asp:TextBox>
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
            <asp:AsyncPostBackTrigger ControlID="drop_requisition_id" EventName="DataBinding" />
        </Triggers>
    </asp:UpdatePanel>
    <asp:SqlDataSource ID="sds_main" OnUpdated="sds_main_Updated" OnInserted="sds_main_Inserted" runat="server" ConnectionString="<%$ ConnectionStrings:MNDT %>" ProviderName="<%$ ConnectionStrings:MNDT.ProviderName %>" UpdateCommand="UPDATE [MNDTrequisition_master]
   SET [requisition_id] = @requisition_id
      ,[requisition_datetime] = @requisition_datetime
      ,[need_datetime] = @need_datetime
      ,[requisition_use] = @requisition_use
      ,[requisition_remarks] = @requisition_remarks
      ,[modify_user_id] = @sId
      ,[modify_datetime] = GETDATE()
WHERE [purchase_order] = @original_purchase_order"
        InsertCommand="INSERT INTO [MNDTrequisition_master]
           ([purchase_order]
           ,[requisition_id]
           ,[requisition_datetime]
           ,[need_datetime]
           ,[requisition_review]
           ,[requisition_use]
           ,[requisition_remarks]
           ,[create_user_id]
           ,[create_datetime]
           ,[modify_user_id]
           ,[modify_datetime])
VALUES
           (@purchase_order
           ,@requisition_id
           ,@requisition_datetime
           ,@need_datetime
           ,'0'
           ,@requisition_use
           ,@requisition_remarks
           ,@sId
           ,GETDATE()
           ,@sId
           ,GETDATE())"
        DeleteCommand="DELETE FROM [MNDTrequisition_master]
WHERE [purchase_order] =@original_purchase_order

DELETE FROM [MNDTrequisition_details]
WHERE [purchase_order] =@original_purchase_order"
        OldValuesParameterFormatString="original_{0}" OnDeleted="sds_main_Deleted">
        <InsertParameters>
            <asp:SessionParameter Name="sId" SessionField="sId" />
            <asp:Parameter Name="requisition_id" />
            <asp:Parameter Name="requisition_datetime" />
            <asp:Parameter Name="need_datetime" />
            <asp:Parameter Name="requisition_use" />
            <asp:Parameter Name="requisition_remarks" />
            <asp:Parameter Name="purchase_order" />
        </InsertParameters>
        <UpdateParameters>
            <asp:SessionParameter Name="sId" SessionField="sId" />
            <asp:Parameter Name="requisition_id" />
            <asp:Parameter Name="need_datetime" />
            <asp:Parameter Name="requisition_use" />
            <asp:Parameter Name="requisition_remarks" />
            <asp:Parameter Name="original_purchase_order" />
            <asp:Parameter Name="requisition_datetime" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sds_requisition_id" runat="server" SelectCommand="SELECT '' 'account_id', '' 'account_name' UNION SELECT [account_id]       
                                 ,[account_id]  + '：' +  [account_name] AS 'account_name'
                           FROM [MNDTaccount]       
                           WHERE [account_department] = '0001'   "
        ConnectionString="<%$ ConnectionStrings:MNDT %>" ProviderName="<%$ ConnectionStrings:MNDT.ProviderName %>"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sds_detail" runat="server" ConnectionString="<%$ ConnectionStrings:MNDT %>" ProviderName="<%$ ConnectionStrings:MNDT.ProviderName %>" SelectCommand="SELECT [requisition_d].[purchase_order]
	  ,[requisition_d].[product_kind]
      ,[product_m].[product_kind_name]
	  ,[requisition_d].[product_code]
      ,[product_d].[product_code_name]
	  ,[product_d].[product_unit]
      ,[requisition_d].[requisition_amount]
      ,[requisition_d].[requisition_money]
      ,[requisition_d].[requisition_amount_mod]
      ,[requisition_d].[requisition_money_mod]
      ,[requisition_d].[requisition_remarks]
FROM [MNDTrequisition_details] [requisition_d] LEFT JOIN [MNDTproduct_master] [product_m]
ON [requisition_d].[product_kind] = [product_m].[product_kind] LEFT JOIN [MNDTproduct_details] [product_d]
ON [requisition_d].[product_kind] = [product_d].[product_kind]
	AND [requisition_d].[product_code] = [product_d].[product_code]
WHERE [purchase_order] = @purchase_order"
        InsertCommand="INSERT INTO [MNDTrequisition_details]
           ([purchase_order]
           ,[product_kind]
           ,[product_code]
           ,[requisition_amount]
           ,[requisition_money]
           ,[requisition_amount_mod]
           ,[requisition_money_mod]
           ,[requisition_remarks]
           ,[create_user_id]
           ,[create_datetime]
           ,[modify_user_id]
           ,[modify_datetime])
VALUES
           (@purchase_order
           ,@product_kind
           ,@product_code
           ,@requisition_amount
           ,@requisition_money
           ,@requisition_amount
           ,@requisition_money
           ,@requisition_remarks
           ,@sId
           ,GETDATE()
           ,@sId
           ,GETDATE())"
        OnInserted="sds_detail_Inserted" DeleteCommand="DELETE FROM [MNDTrequisition_details]
WHERE [purchase_order] =@original_purchase_order
	AND [product_kind] = @original_product_kind
	AND [product_code] = @original_product_code"
        OldValuesParameterFormatString="original_{0}" UpdateCommand="UPDATE [MNDTrequisition_details]
   SET [requisition_amount_mod] = @requisition_amount_mod
      ,[requisition_money_mod] = @requisition_money_mod
      ,[requisition_remarks] = @requisition_remarks
      ,[modify_user_id] = @sId
      ,[modify_datetime] = GETDATE()
WHERE [purchase_order] =@original_purchase_order
	AND [product_kind] = @original_product_kind
	AND [product_code] = @original_product_code"
        OnUpdated="sds_detail_Updated" OnDeleted="sds_detail_Deleted">
        <DeleteParameters>
            <asp:Parameter Name="original_purchase_order" />
            <asp:Parameter Name="original_product_kind" />
            <asp:Parameter Name="original_product_code" />
        </DeleteParameters>
        <InsertParameters>
            <asp:SessionParameter Name="sId" SessionField="sId" />
            <asp:Parameter Name="purchase_order" />
            <asp:Parameter Name="product_kind" />
            <asp:Parameter Name="product_code" />
            <asp:Parameter Name="requisition_amount" />
            <asp:Parameter Name="requisition_money" />
            <asp:Parameter Name="requisition_remarks" />
        </InsertParameters>
        <SelectParameters>
            <asp:Parameter Name="purchase_order" />
        </SelectParameters>
        <UpdateParameters>
            <asp:SessionParameter Name="sId" SessionField="sId" />
            <asp:Parameter Name="requisition_money_mod" />
            <asp:Parameter Name="requisition_remarks" />
            <asp:Parameter Name="original_purchase_order" />
            <asp:Parameter Name="original_product_kind" />
            <asp:Parameter Name="original_product_code" />
            <asp:Parameter Name="requisition_amount_mod" />
        </UpdateParameters>
    </asp:SqlDataSource>

</asp:Content>
