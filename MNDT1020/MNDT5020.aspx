<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" MaintainScrollPositionOnPostback="true" EnableEventValidation="false" Async="true" AutoEventWireup="true" CodeFile="MNDT5020.aspx.cs" Inherits="MNDT5020" %>

<%@ Register Assembly="GGridView" Namespace="GGridView" TagPrefix="cc1" %>

<asp:Content runat="server" ID="const" ContentPlaceHolderID="ContentPlaceHolder1">
    <script type="text/javascript">

        //$(document).ready(function () {

        //});

        $(function () {

        });
    </script>
    <asp:UpdatePanel runat="server"  UpdateMode="Conditional">
        <ContentTemplate>
            <asp:MultiView runat="server" ID="multi_view" ActiveViewIndex="0">
                <asp:View runat="server" ID="view_master">
                    <asp:Panel runat="server">
                        <table class="blue-style2 table-size1">
                            <tr>
                                <td rowspan="2">&nbsp;查詢<br />
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
                                <td colspan="6" class="center">
                                    <asp:Button runat="server" Text="查詢" ID="btn_search" CssClass="blue-style6 button-size2" BorderStyle="None" OnClick="btn_search_Click" />
                                    <asp:Button runat="server" Text="清除" CssClass="blue-style6 button-size2" BorderStyle="None" />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>

                    <asp:Panel runat="server" ScrollBars="Vertical" Height="460px" CssClass="div-scroll div-scroll-size1" ID="panel_scroll_m">
                        <asp:UpdatePanel runat="server">
                            <ContentTemplate>
                                <%--FreezeHeader="true" ScrollVertical="true" ScrollVerticalClass="div-scroll div-scroll-size2"--%>
                                <cc1:GGridView runat="server" EmptyShowHeader="True" EmptyDataText="無顯示資料" OnRowDataBound="grid_data_m_RowDataBound" OnRowCommand="grid_data_m_RowCommand"
                                    OnSelectedIndexChanged="grid_data_m_SelectedIndexChanged" OnSelectedIndexChanging="grid_data_m_SelectedIndexChanging"
                                    Width="1005px" GridLines="Horizontal" AllowSorting="True" CssClass="white-style2 no-border border-style1 font-style2"
                                    AutoGenerateColumns="False" AllowPaging="True" CellPadding="4" ForeColor="Black"
                                    ID="grid_data_m" DataSourceID="sds_main" DataKeyNames="account_id">

                                    <Columns>

                                        <asp:TemplateField HeaderText="新增">
                                            <HeaderTemplate>
                                                <asp:ImageButton ID="ibtn_insert" CommandName="OpenInsert" OnClientClick="save_bottom();" runat="server" ImageUrl="~/Image/header_add.png" CssClass="margin-top-6"></asp:ImageButton>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:ImageButton ID="ibtn_Select" CommandName="SelectData" runat="server" ImageUrl="~/Image/select.png" onmouseover="this.src='/Image/select_1.png'" onmouseout="this.src='/Image/select.png'" CommandArgument='<%# Container.DataItemIndex %>'></asp:ImageButton>
                                                <asp:ImageButton ID="ibtn_delete" CommandName="Delete" runat="server" ImageUrl="~/Image/delete.png" onmouseover="this.src='/Image/delete_1.png'" onmouseout="this.src='/Image/delete.png'" OnClientClick="return(confirm('確認要刪除嗎？'))"></asp:ImageButton>
                                            </ItemTemplate>
                                            <HeaderStyle Width="9%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="帳號" SortExpression="account_id">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_account_id" runat="server" Text='<%#Bind("account_id") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="9%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="密碼">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_account_password" runat="server" Text='<%#Bind("account_password") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="9%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="名稱">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_account_name" runat="server" Text='<%#Bind("account_name") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="9%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="地址">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_account_addr" runat="server" Text='<%#Bind("account_addr") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="9%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="手機">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_account_phone" runat="server" Text='<%#Bind("account_phone") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="9%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="部門">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_account_department" runat="server" Text='<%#Bind("account_department") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="9%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="建立人員">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_create_user_id" runat="server" Text='<%#Bind("create_user_id") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="9%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="建立時間" SortExpression="create_datetime">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_create_datetime" runat="server" Text='<%#Bind("create_datetime") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="9%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="修改人員">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_modify_user_id" runat="server" Text='<%#Bind("modify_user_id") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="9%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="修改時間">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_modify_datetime" runat="server" Text='<%#Bind("modify_datetime") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="9%" />
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
                    <table class="blue-style2 table-size1 center">
                        <tr>
                            <td>主檔</td>
                        </tr>
                    </table>
                    <asp:FormView runat="server" ID="fv_master_form" CssClass="max-width" DefaultMode="Edit" DataSourceID="sds_main" DataKeyNames="account_id" OnItemCommand="form_view_master_ItemCommand">
                        <InsertItemTemplate>
                            <table class="max-width">
                                <tr class="max-width">
                                    <td class="right">
                                        <asp:Label runat="server" Text="帳號："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_account_id" ></asp:TextBox>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="密碼："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_account_password" ></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="right">
                                        <asp:Label runat="server" Text="名稱："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_account_name" ></asp:TextBox>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="手機："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_account_phone" ></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="right">
                                        <asp:Label runat="server" Text="部門："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:DropDownList runat="server" ID="drop_account_department" Width="41%" OnDataBinding="drop_account_department_DataBinding" ></asp:DropDownList>
                                    </td>
                                    
                                </tr>
                                <tr>
                                    <td class="right">
                                        <asp:Label runat="server" Text="地址："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_account_addr"  Width="100%"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>

                                    <td colspan="4" class="center">
                                        <asp:Button runat="server" CssClass="blue-style6 button-size2" Text="新增" CommandName="InsertData" />
                                        <asp:Button runat="server" CssClass="blue-style6 button-size2" Text="取消" CommandName="Cancel" ID="btn_master_cancel" />
                                    </td>

                                </tr>
                            </table>
                        </InsertItemTemplate>

                        <EditItemTemplate>
                            <table class="max-width">
                                <tr class="max-width">
                                    <td colspan="3" rowspan="4" class="left">
                                        <asp:ImageButton ID="imgbtn_last" runat="server" ImageUrl="~/Image/last_one.png" onmouseover="this.src='/Image/last_one_1.png'" onmouseout="this.src='/Image/last_one.png'" OnClick="imgbtn_last_Click" />
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="帳號："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_account_id" Text='<%#Bind("account_id") %>' ReadOnly="true" CssClass="gray-style2"></asp:TextBox>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="密碼："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_account_password" Text='<%#Bind("account_password") %>'></asp:TextBox>
                                    </td>
                                    <td colspan="3" rowspan="4" class="right">
                                        <asp:ImageButton ID="imgbtn_next" runat="server" ImageUrl="~/Image/next_one.png" onmouseover="this.src='/Image/next_one_1.png'" onmouseout="this.src='/Image/next_one.png'" OnClick="imgbtn_next_Click" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="right">
                                        <asp:Label runat="server" Text="名稱："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_account_name" Text='<%#Bind("account_name") %>'></asp:TextBox>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="手機："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_account_phone" Text='<%#Bind("account_phone") %>'></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="right">
                                        <asp:Label runat="server" Text="部門："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:DropDownList runat="server" ID="drop_account_department" Width="49%" SelectedValue='<%#Bind("account_department") %>'  OnDataBinding="drop_account_department_DataBinding" ></asp:DropDownList>
                                    </td>
                                    
                                </tr>
                                <tr>
                                    <td class="right">
                                        <asp:Label runat="server" Text="地址："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_account_addr" Text='<%#Bind("account_addr") %>' Width="100%"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>

                                    <td colspan="8" class="center">
                                        <asp:Button runat="server" CssClass="blue-style6 button-size2" Text="更新" CommandName="Update" OnClientClick="return(confirm('確認要更新嗎？'))" />
                                        <asp:Button runat="server" CssClass="blue-style6 button-size2" Text="刪除" CommandName="Delete" OnClientClick="return(confirm('確認要刪除嗎？'))" />
                                        <asp:Button runat="server" CssClass="blue-style6 button-size2" Text="取消" CommandName="Cancel" ID="btn_master_cancel" />
                                    </td>

                                </tr>
                            </table>

                        </EditItemTemplate>

                    </asp:FormView>
                </asp:View>
            </asp:MultiView>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="grid_data_m" EventName="RowCommand" />
            <%-- <asp:AsyncPostBackTrigger ControlID="form_view_master" EventName="ItemCommand" />--%>
        </Triggers>
    </asp:UpdatePanel>

    <asp:Literal ID="Literal1" runat="server"></asp:Literal>

    <%--<asp:UpdatePanel ID="UpdatePanel1" runat="server" ChildrenAsTriggers="false" UpdateMode="conditional">
        <ContentTemplate>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btn_search" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>--%>
    <asp:SqlDataSource ID="sds_main" OnUpdated="sds_main_Updated" runat="server" ConnectionString="<%$ ConnectionStrings:MNDT %>" OldValuesParameterFormatString="original_{0}" ProviderName="<%$ ConnectionStrings:MNDT.ProviderName %>" UpdateCommand="UPDATE [MNDTaccount]
   SET [account_password] = @account_password
      ,[account_name] = @account_name
      ,[account_addr] = @account_addr
      ,[account_phone] = @account_phone
      ,[account_department] = @account_department
      ,[modify_user_id] = @sId
      ,[modify_datetime] = GETDATE()
WHERE [account_id] = @original_account_id"
        DeleteCommand="DELETE [MNDTaccount] 
WHERE account_id = @original_account_id"
        InsertCommand="INSERT INTO [MNDTaccount]
([account_id]
	,[account_password]
	,[account_name]
	,[account_addr]
	,[account_phone]
                  ,[account_department]
	,[create_user_id]
	,[create_datetime]
	,[modify_user_id]
	,[modify_datetime])
VALUES(@account_id
	,@account_password
	,@account_name
	,@account_addr
	,@account_phone
                  ,@account_department
	,@UserId
	,GETDATE()
	,@UserId
	,GETDATE())"
        OnInserted="sds_main_Inserted" OnDeleted="sds_main_Deleted">
        <DeleteParameters>
            <asp:Parameter Name="original_account_id" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="account_id" />
            <asp:Parameter Name="account_password" />
            <asp:Parameter Name="account_name" />
            <asp:Parameter Name="account_addr" />
            <asp:Parameter Name="account_phone" />
            <asp:SessionParameter Name="UserId" SessionField="sId" />
            <asp:Parameter Name="account_department" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="account_password" />
            <asp:Parameter Name="account_name" />
            <asp:Parameter Name="account_addr" />
            <asp:Parameter Name="account_phone" />
            <asp:SessionParameter Name="sId" SessionField="sId" />
            <asp:Parameter Name="original_account_id" />
            <asp:Parameter Name="account_department" />
        </UpdateParameters>
    </asp:SqlDataSource>
</asp:Content>
