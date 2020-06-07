<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="MNDT1030.aspx.cs" Inherits="MNDT1030" %>

<%@ Register Assembly="GGridView" Namespace="GGridView" TagPrefix="cc1" %>

<asp:Content runat="server" ID="const" ContentPlaceHolderID="ContentPlaceHolder1">
    <asp:UpdatePanel runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:MultiView runat="server" ID="multi_view" ActiveViewIndex="0">
                <asp:View runat="server" ID="view_master">
                    <asp:UpdatePanel runat="server">
                        <ContentTemplate>
                            <table class="blue-style2 table-size1">
                                <tr>
                                    <td rowspan="4">&nbsp;查詢<br />
                                        條件區</td>
                                </tr>
                                <tr>
                                    <td class="right">
                                        <asp:Label runat="server" Text="使用者帳號：" CssClass="font-style1"></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox ID="text_account_id" runat="server" CssClass="font-style1"></asp:TextBox>
                                    </td>


                                    <td class="right">
                                        <asp:Label runat="server" Text="使用者名稱：" CssClass="font-style1"></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox ID="text_account_name" runat="server" CssClass="font-style1"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="right">
                                        <asp:Label runat="server" Text="群組代碼：" CssClass="font-style1"></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox ID="text_group_id" runat="server" CssClass="font-style1"></asp:TextBox>
                                    </td>


                                    <td class="right">
                                        <asp:Label runat="server" Text="群組名稱：" CssClass="font-style1"></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox ID="text_group_name" runat="server" CssClass="font-style1"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="right">
                                        <asp:Label runat="server" Text="作業代碼：" CssClass="font-style1"></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox ID="text_program_id" runat="server" CssClass="font-style1"></asp:TextBox>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="作業名稱：" CssClass="font-style1"></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox ID="text_program_name" runat="server" CssClass="font-style1"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="8" class="center">
                                        <asp:Button runat="server" Text="查詢" ID="btn_search" CssClass="blue-style6 button-size2" BorderStyle="None" OnClick="btn_search_Click" />
                                        <asp:Button runat="server" Text="清除" CssClass="blue-style6 button-size2" BorderStyle="None" />
                                    </td>
                                </tr>
                            </table>
                            <asp:Panel runat="server" ScrollBars="Vertical" Height="460px" CssClass="div-scroll div-scroll-size2" ID="panel_scroll_m">
                                <asp:UpdatePanel runat="server">
                                    <ContentTemplate>
                                        <cc1:GGridView runat="server" EmptyShowHeader="true" EmptyDataText="無顯示資料" Width="1005px" GridLines="Horizontal" AllowSorting="True"
                                            AutoGenerateColumns="False" CssClass="white-style2 no-border border-style1 font-style2" AllowPaging="True" OnRowDataBound="grid_data_RowDataBound"
                                            OnSelectedIndexChanged="grid_data_SelectedIndexChanged" OnSelectedIndexChanging="grid_data_SelectedIndexChanging" OnRowCommand="grid_data_m_RowCommand"
                                            ID="grid_data_m" DataSourceID="sds_main" DataKeyNames="group_id">
                                            <Columns>
                                                <asp:TemplateField HeaderText="新增">
                                                    <HeaderTemplate>
                                                        <image src="Image/select.png" class="margin-top-6"></image>
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:ImageButton ID="ibtn_Select" CommandName="SelectData" runat="server" ImageUrl="~/Image/select.png" onmouseover="this.src='/Image/select_1.png'" onmouseout="this.src='/Image/select.png'" CommandArgument='<%# Container.DataItemIndex %>'></asp:ImageButton>
                                                    </ItemTemplate>
                                                    <HeaderStyle Width="10%" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="群組編號" SortExpression="group_id">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="lab_group_id" Text='<%#Bind("group_id") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle Width="10%" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="群組名稱">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="lab_group_name" Text='<%#Bind("group_name") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle Width="10%" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="群組描述">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lab_group_description" runat="server" Text='<%#Bind("group_description") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle Width="10%" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="備註">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lab_group_remarks" runat="server" Text='<%#Bind("group_remarks") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle Width="10%" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="建立人員">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lab_create_user_id" runat="server" Text='<%#Bind("create_user_id") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle Width="10%" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="建立時間" SortExpression="create_datetime">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lab_create_datetime" runat="server" Text='<%#Bind("create_datetime") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle Width="10%" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="修改人員">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lab_modify_user_id" runat="server" Text='<%#Bind("modify_user_id") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle Width="10%" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="修改時間" SortExpression="modify_datetime">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lab_modify_datetime" runat="server" Text='<%#Bind("modify_datetime") %>'></asp:Label>
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
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="btn_search" EventName="Click" />
                                    </Triggers>
                                </asp:UpdatePanel>
                            </asp:Panel>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </asp:View>

                <asp:View runat="server" ID="view_detail">
                    <table class="max-width">
                        <tr>
                            <td colspan="3" rowspan="3" class="left">
                                <asp:ImageButton ID="imgbtn_last" runat="server" ImageUrl="~/Image/last_one.png" onmouseover="this.src='/Image/last_one_1.png'" onmouseout="this.src='/Image/last_one.png'" OnClick="imgbtn_last_Click" />

                            </td>
                            <td class="right">
                                <asp:Label runat="server" Text="群組帳號：" CssClass="font-style1" ID="lab_group_id"></asp:Label>
                            </td>
                            <td class="left">
                                <asp:TextBox ID="text_edit_group_id" runat="server" CssClass="font-style1 gray-style2" ReadOnly="true"></asp:TextBox>
                            </td>
                            <td class="right">
                                <asp:Label runat="server" Text="群組名稱：" CssClass="font-style1"></asp:Label>
                            </td>
                            <td class="left">
                                <asp:TextBox ID="text_edit_group_name" runat="server" CssClass="font-style1 gray-style2"></asp:TextBox>
                            </td>
                            <td colspan="3" rowspan="3" class="right">
                                <asp:ImageButton ID="imgbtn_next" runat="server" ImageUrl="~/Image/next_one.png" onmouseover="this.src='/Image/next_one_1.png'" onmouseout="this.src='/Image/next_one.png'" OnClick="imgbtn_next_Click" />
                            </td>
                        </tr>
                        <tr class="center">
                            <td rowspan="4" colspan="4">
                                <asp:Button runat="server" CssClass="blue-style6 button-size2" Text="取消" CommandName="Cancel" ID="btn_detail_cancel" OnClick="btn_detail_cancel_Click" />
                            </td>
                        </tr>
                    </table>

                    <table class="blue-style2 table-size1 center">
                        <tr>
                            <td>已新增項目</td>
                        </tr>
                    </table>

                    <asp:Panel runat="server" ScrollBars="Vertical" Height="460px" CssClass="div-scroll div-scroll-size3">
                        <asp:UpdatePanel runat="server">
                            <ContentTemplate>
                                <cc1:GGridView runat="server" ID="grid_data_d" EmptyShowHeader="true" EmptyDataText="無顯示資料" Width="1005px" GridLines="Horizontal" AllowSorting="True"
                                    AutoGenerateColumns="False" OnRowDataBound="grid_data_RowDataBound" OnSelectedIndexChanged="grid_data_SelectedIndexChanged"
                                    OnSelectedIndexChanging="grid_data_SelectedIndexChanging" CssClass="white-style2 no-border border-style1 font-style2" AllowPaging="True" DataSourceID="sds_detail"
                                    DataKeyNames="group_id, program_id" OnRowCommand="grid_data_d_RowCommand">
                                    <Columns>
                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <asp:ImageButton ID="ibtn_edit" CommandName="Edit" runat="server" ImageUrl="~/Image/edit.png" onmouseover="this.src='/Image/edit_1.png'" onmouseout="this.src='/Image/edit.png'"></asp:ImageButton>
                                                <asp:ImageButton ID="ibtn_delete" CommandName="Delete" runat="server" ImageUrl="~/Image/delete.png" onmouseover="this.src='/Image/delete_1.png'" onmouseout="this.src='/Image/delete.png'" OnClientClick="return(confirm('確認要刪除嗎？'))"></asp:ImageButton>
                                            </ItemTemplate>
                                            <EditItemTemplate>
                                                <asp:ImageButton ID="ibtn_update" CommandName="Update" runat="server" ImageUrl="~/Image/update.png" onmouseover="this.src='/Image/update_1.png'" onmouseout="this.src='/Image/update.png'" OnClientClick="return(confirm('確認要更新嗎？'))"></asp:ImageButton>
                                                <asp:ImageButton ID="ibtn_cancel" CommandName="Cancel" runat="server" ImageUrl="~/Image/cancel.png" onmouseover="this.src='/Image/cancel_1.png'" onmouseout="this.src='/Image/cancel.png'"></asp:ImageButton>
                                            </EditItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="群組編號" SortExpression="group_id">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_group_id" runat="server" Text='<%#Bind("group_id") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="作業代碼" SortExpression="program_id">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_program_id" runat="server" Text='<%#Bind("program_id") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="執行">
                                            <ItemTemplate>
                                                <asp:CheckBox runat="server" ID="ch_au_run" CssClass="check-style1" Checked='<%#Bind("au_run")%>' Enabled="false" />
                                            </ItemTemplate>
                                            <EditItemTemplate>
                                                <asp:CheckBox runat="server" ID="ch_au_run" CssClass="check-style1" Checked='<%#Bind("au_run")%>' />
                                            </EditItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="匯出">
                                            <ItemTemplate>
                                                <asp:CheckBox runat="server" ID="ch_au_export" CssClass="check-style1" Checked='<%#Bind("au_export")%>' Enabled="false" />
                                            </ItemTemplate>
                                            <EditItemTemplate>
                                                <asp:CheckBox runat="server" ID="ch_au_export" CssClass="check-style1" Checked='<%#Bind("au_export")%>' />
                                            </EditItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="列印">
                                            <ItemTemplate>
                                                <asp:CheckBox runat="server" ID="ch_au_print" CssClass="check-style1" Checked='<%#Bind("au_print")%>' Enabled="false" />
                                            </ItemTemplate>
                                            <EditItemTemplate>
                                                <asp:CheckBox runat="server" ID="ch_au_print" CssClass="check-style1" Checked='<%#Bind("au_print")%>' />
                                            </EditItemTemplate>
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
                                                        <asp:ListItem>5</asp:ListItem>
                                                        <asp:ListItem>10</asp:ListItem>
                                                        <asp:ListItem>20</asp:ListItem>
                                                        <asp:ListItem>30</asp:ListItem>
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

                    <table class="blue-style2 table-size1 center">
                        <tr>
                            <td>未新增項目</td>
                        </tr>
                    </table>

                    <asp:Panel runat="server" ScrollBars="Vertical" Height="460px" CssClass="div-scroll div-scroll-size3">
                        <asp:UpdatePanel runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <cc1:GGridView runat="server" ID="grid_data_add" EmptyShowHeader="True" EmptyDataText="無顯示資料" Width="1005px" GridLines="Horizontal" AllowSorting="True"
                                    AutoGenerateColumns="False" OnRowDataBound="grid_data_RowDataBound" OnSelectedIndexChanged="grid_data_SelectedIndexChanged"
                                    OnSelectedIndexChanging="grid_data_SelectedIndexChanging" CssClass="white-style2 no-border border-style1 font-style2" AllowPaging="True" DataSourceID="sds_add" FooterInsert="False">

                                    <Columns>
                                        <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:CheckBox runat="server" ID="cb_all" CssClass="check-style1 margin-top-6" OnCheckedChanged="cb_all_CheckedChanged" AutoPostBack="true" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%--<input class="check-style1" type="checkbox" id="chSelect" runat="server"> --%>
                                                <asp:CheckBox runat="server" ID="cb_select" CssClass="check-style1" />
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="作業代碼" SortExpression="program_id">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_program_id" runat="server" Text='<%#Bind("program_id") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="作業名稱" SortExpression="program_id">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_program_name" runat="server" Text='<%#Bind("program_name") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="15%" />
                                        </asp:TemplateField>


                                        <asp:TemplateField HeaderText="執行">
                                            <ItemTemplate>
                                                <asp:CheckBox runat="server" ID="ch_au_run" CssClass="check-style1" Checked='<%#Bind("au_run")%>' />
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="匯出">
                                            <ItemTemplate>
                                                <asp:CheckBox runat="server" ID="ch_au_export" CssClass="check-style1" Checked='<%#Bind("au_export")%>' />
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>


                                        <asp:TemplateField HeaderText="列印">
                                            <ItemTemplate>
                                                <asp:CheckBox runat="server" ID="ch_au_print" CssClass="check-style1" Checked='<%#Bind("au_print")%>' />
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                    </Columns>
                                    <PagerTemplate>
                                        <table style="width: 100%">
                                            <tr style="width: 100%">
                                                <td class="left">
                                                    <asp:LinkButton runat="server" ID="linkbtn_first" Text="第一頁" OnClick="linkbtn_first_Click1"></asp:LinkButton>
                                                    <asp:LinkButton runat="server" ID="linkbtn_next" Text="下一頁" OnClick="linkbtn_next_Click1"></asp:LinkButton>
                                                    <asp:LinkButton runat="server" ID="linkbtn_previous" Text="上一頁" OnClick="linkbtn_previous_Click1"></asp:LinkButton>
                                                    <asp:LinkButton runat="server" ID="linkbtn_last" Text="最後一頁" OnClick="linkbtn_last_Click1"></asp:LinkButton>
                                                </td>
                                                <td class="right">
                                                    <asp:DropDownList runat="server" ID="drop_page_index" CssClass="blue-style4 dropdwonlist_size1" OnDataBinding="drop_page_index_DataBinding1" OnSelectedIndexChanged="drop_page_index_SelectedIndexChanged1" AutoPostBack="true"></asp:DropDownList>
                                                    <asp:Label ID="lab_sum" runat="server" Text="顯示筆數："></asp:Label>
                                                    <asp:DropDownList runat="server" ID="drop_page_size" CssClass="blue-style4 dropdwonlist_size1" OnDataBinding="drop_page_size_DataBinding1" AutoPostBack="true" OnSelectedIndexChanged="drop_page_size_SelectedIndexChanged1">
                                                        <asp:ListItem>5</asp:ListItem>
                                                        <asp:ListItem>10</asp:ListItem>
                                                        <asp:ListItem>20</asp:ListItem>
                                                        <asp:ListItem>30</asp:ListItem>
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

                    <table class="max-width">
                        <tr class="center">
                            <td>
                                <asp:UpdatePanel runat="server">
                                    <ContentTemplate>
                                        <asp:Button runat="server" Text="新增" CssClass="blue-style6 button-size2" ID="btn_insert_program" BorderStyle="None" OnClick="btn_insert_program_Click" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </asp:View>
            </asp:MultiView>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="grid_data_m" EventName="RowCommand" />
            <asp:AsyncPostBackTrigger ControlID="grid_data_d" EventName="RowDeleted" />
            <asp:AsyncPostBackTrigger ControlID="grid_data_add" EventName="RowCommand" />
            <asp:AsyncPostBackTrigger ControlID="btn_insert_program" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>
    <asp:SqlDataSource runat="server" ID="sds_main" ConnectionString="<%$ ConnectionStrings:MNDT %>" ProviderName="<%$ ConnectionStrings:MNDT.ProviderName %>"></asp:SqlDataSource>
    <asp:SqlDataSource runat="server" ID="sds_detail" ConnectionString="<%$ ConnectionStrings:MNDT %>" ProviderName="<%$ ConnectionStrings:MNDT.ProviderName %>" SelectCommand="SELECT [group_id]
      ,[program_id]
      ,[au_run]
      ,[au_export]
      ,[au_print]
      ,[create_user_id]
      ,CONVERT(char, [create_datetime], 111) 'create_datetime'
      ,[modify_user_id]
      ,CONVERT(char, [modify_datetime], 111) 'modify_datetime'
FROM [MNDTprogram_details]
WHERE [group_id] = @group_id"
        OldValuesParameterFormatString="original_{0}" UpdateCommand="UPDATE [MNDTprogram_details]
   SET [au_run] = @au_run
      ,[au_export] = @au_export
      ,[au_print] = @au_print
      ,[modify_user_id] = @sId
      ,[modify_datetime] = GETDATE()
WHERE [group_id] = @original_group_id
	AND [program_id] = @original_program_id"
        DeleteCommand="DELETE [MNDTprogram_details]
WHERE [group_id] = @original_group_id
	AND [program_id] = @original_program_id"
        OnDeleted="sds_detail_Deleted">
        <DeleteParameters>
            <asp:Parameter Name="original_group_id" />
            <asp:Parameter Name="original_program_id" />
        </DeleteParameters>
        <SelectParameters>
            <asp:Parameter Name="group_id" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="au_run" />
            <asp:Parameter Name="au_export" />
            <asp:Parameter Name="au_print" />
            <asp:SessionParameter Name="sId" SessionField="sId" />
            <asp:Parameter Name="original_group_id" />
            <asp:Parameter Name="original_program_id" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource runat="server" ID="sds_add" ConnectionString="<%$ ConnectionStrings:MNDT %>" ProviderName="<%$ ConnectionStrings:MNDT.ProviderName %>" SelectCommand="SELECT [program_id]
      ,[program_name]
      ,[au_run]
      ,[au_export]
      ,[au_print]
FROM [MNDTprogram_master]
WHERE [program_parent] &lt;&gt; 'ROOT'
	AND [program_id] NOT IN (SELECT [program_id]
							FROM [MNDTprogram_details]
							WHERE [group_id] = @group_id)">
        <SelectParameters>
            <asp:Parameter Name="group_id" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
