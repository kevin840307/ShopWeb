<%@ Page Language="C#" Async="true" MasterPageFile="~/MasterPage.master" EnableEventValidation="false" AutoEventWireup="true" CodeFile="MNDT1020.aspx.cs" Inherits="MNDT1020" %>

<%@ Register Assembly="GGridView" Namespace="GGridView" TagPrefix="cc1" %>


<asp:Content runat="server" ID="const" ContentPlaceHolderID="ContentPlaceHolder1">
    <script type="text/javascript">

    </script>
    <asp:Literal runat="server" ID="Literal1"></asp:Literal>
    <asp:UpdatePanel runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:MultiView runat="server" ID="multi_view" ActiveViewIndex="0">
                <asp:View runat="server" ID="view_master">
                    <table class="blue-style2 table-size1">
                        <tr>
                            <td rowspan="3">&nbsp;查詢<br />
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
                            <td colspan="6" class="center">
                                <asp:Button runat="server" Text="查詢" ID="btn_search" CssClass="blue-style6 button-size2" OnClick="btn_search_Click" />
                                <asp:Button runat="server" Text="清除" CssClass="blue-style6 button-size2" />
                            </td>
                        </tr>
                    </table>
                    <asp:Panel runat="server" ScrollBars="Vertical" Height="460px" CssClass="div-scroll div-scroll-size1" ID="panel_scroll_m">
                        <asp:UpdatePanel runat="server">
                            <ContentTemplate>
                                <cc1:GGridView EmptyShowHeader="True" EmptyDataText="無顯示資料" runat="server" OnRowDataBound="grid_data_RowDataBound" OnSelectedIndexChanged="grid_data_SelectedIndexChanged"
                                    OnSelectedIndexChanging="grid_data_SelectedIndexChanging" OnRowCommand="grid_data_m_RowCommand"
                                    Width="1005px" GridLines="Horizontal" AllowSorting="True"
                                    AutoGenerateColumns="False" CssClass="white-style2 no-border border-style1 font-style2" AllowPaging="True"
                                    ID="grid_data_m" DataSourceID="sds_main" DataKeyNames="group_id">
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

                                        <asp:TemplateField HeaderText="群組編號" SortExpression="group_id">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_group_id" runat="server" Text='<%#Bind("group_id") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="群組名稱">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_group_name" runat="server" Text='<%#Bind("group_name") %>'></asp:Label>
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
                        </asp:UpdatePanel>
                    </asp:Panel>
                </asp:View>

                <asp:View runat="server" ID="view_detail">

                    <table class="blue-style2 table-size1 center">
                        <tr>
                            <td>主檔</td>
                        </tr>
                    </table>

                    <asp:FormView runat="server" ID="fv_master_form" DataSourceID="sds_main" CssClass="max-width" DefaultMode="Edit" DataKeyNames="group_id" OnItemCommand="fv_master_form_ItemCommand">
                        <EditItemTemplate>
                            <table class="max-width">

                                <tr class="max-width">
                                    <td colspan="3" rowspan="3" class="left">
                                        <asp:ImageButton ID="imgbtn_last" runat="server" ImageUrl="~/Image/last_one.png" onmouseover="this.src='/Image/last_one_1.png'" onmouseout="this.src='/Image/last_one.png'" OnClick="imgbtn_last_Click" />
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="群組ID："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_edit_group_id" Text='<%#Bind("group_id") %>' ReadOnly="true" CssClass="gray-style2"></asp:TextBox>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="群組名稱："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_edit_group_name" Text='<%#Bind("group_name") %>'></asp:TextBox>
                                    </td>
                                    <td colspan="3" rowspan="3" class="right">
                                        <asp:ImageButton ID="imgbtn_next" runat="server" ImageUrl="~/Image/next_one.png" onmouseover="this.src='/Image/next_one_1.png'" onmouseout="this.src='/Image/next_one.png'" OnClick="imgbtn_next_Click" />
                                    </td>
                                </tr>

                                <tr class="max-width">
                                    <td class="right">
                                        <asp:Label runat="server" Text="群組敘述："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_edit_group_description" Text='<%#Bind("group_description") %>'></asp:TextBox>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="備註："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_edit_group_remarks" Text='<%#Bind("group_remarks") %>'></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="center">
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
                                <tr class="max-width">
                                    <td class="right">
                                        <asp:Label runat="server" Text="群組ID："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_insert_group_id"></asp:TextBox>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="群組名稱："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_insert_group_name"></asp:TextBox>
                                    </td>
                                </tr>

                                <tr class="max-width">
                                    <td class="right">
                                        <asp:Label runat="server" Text="群組敘述："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_insert_group_description"></asp:TextBox>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="備註："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_insert_group_remarks"></asp:TextBox>
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
                    </asp:FormView>

                    <asp:Panel ID="panel_detail" runat="server" ScrollBars="Vertical" Height="400px" CssClass="div-scroll div-scroll-size2" Visible="false">
                        <asp:UpdatePanel runat="server">
                            <ContentTemplate>
                                <cc1:GGridView runat="server" EmptyShowHeader="True" FooterInsert="true" EmptyDataText="無顯示資料" OnRowDataBound="grid_data_RowDataBound" OnSelectedIndexChanged="grid_data_SelectedIndexChanged"
                                    OnSelectedIndexChanging="grid_data_SelectedIndexChanging" OnRowCommand="grid_data_d_RowCommand" Width="1005px" GridLines="Horizontal" AllowSorting="True"
                                    AutoGenerateColumns="False" CellPadding="4" CssClass="white-style2 no-border border-style1 font-style2" AllowPaging="True"
                                    ID="grid_data_d" DataSourceID="sds_detail" DataKeyNames="group_id, account_id">
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

                                        <asp:TemplateField HeaderText="群組編號" SortExpression="group_id">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_group_id" runat="server" Text='<%#Bind("group_id") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="帳號">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_account_id" runat="server" Text='<%#Bind("account_id") %>'></asp:Label>
                                            </ItemTemplate>
                                            <EditItemTemplate>
                                                <asp:DropDownList ID="drop_account_id" runat="server" Width="90%" SelectedValue='<%#Bind("account_id") %>' OnDataBinding="drop_account_id_DataBinding"></asp:DropDownList>
                                            </EditItemTemplate>
                                            <FooterTemplate>
                                                <asp:DropDownList ID="drop_account_id" runat="server" Width="90%" OnDataBinding="drop_account_id_DataBinding"></asp:DropDownList>
                                            </FooterTemplate>
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
                        </asp:UpdatePanel>
                    </asp:Panel>
                </asp:View>
            </asp:MultiView>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="grid_data_m" EventName="RowCommand" />
        </Triggers>
    </asp:UpdatePanel>
    <asp:SqlDataSource ID="sds_main" OnUpdated="sds_main_Updated" OnInserted="sds_main_Inserted" runat="server" ConnectionString="<%$ ConnectionStrings:MNDT %>" ProviderName="<%$ ConnectionStrings:MNDT.ProviderName %>" UpdateCommand="UPDATE [MNDTgroup_master]
   SET [group_name] = @group_name
      ,[group_description] = @group_description
      ,[group_remarks] = @group_remarks
      ,[modify_user_id] = @sId
      ,[modify_datetime] = GETDATE()
WHERE [group_id] = @group_id"
        InsertCommand="INSERT INTO [MNDTgroup_master]
           ([group_id]
           ,[group_name]
           ,[group_description]
           ,[group_remarks]
           ,[create_user_id]
           ,[create_datetime]
           ,[modify_user_id]
           ,[modify_datetime])
VALUES
           (@group_id
           ,@group_name
           ,@group_description
           ,@group_remarks
           ,@sId
           ,GETDATE()
           ,@sId
           ,GETDATE())"
        DeleteCommand="DELETE FROM [MNDTgroup_master]
WHERE [group_id] = @original_group_id

DELETE FROM [MNDTgroup_details]
WHERE [group_id] = @original_group_id"
        OldValuesParameterFormatString="original_{0}" OnDeleted="sds_main_Deleted">
        <DeleteParameters>
            <asp:Parameter Name="original_group_id" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="group_id" />
            <asp:Parameter Name="group_name" />
            <asp:Parameter Name="group_description" />
            <asp:Parameter Name="group_remarks" />
            <asp:SessionParameter Name="sId" SessionField="sId" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="group_name" />
            <asp:Parameter Name="group_description" />
            <asp:Parameter Name="group_remarks" />
            <asp:SessionParameter Name="sId" SessionField="sId" />
            <asp:Parameter Name="group_id" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sds_detail" runat="server" ConnectionString="<%$ ConnectionStrings:MNDT %>" ProviderName="<%$ ConnectionStrings:MNDT.ProviderName %>" SelectCommand="SELECT [group_id]
      ,[account_id]
      ,[create_user_id]
      ,CONVERT(char, [create_datetime], 111) AS 'create_datetime'
      ,[modify_user_id]
      ,CONVERT(char, [modify_datetime], 111) AS 'modify_datetime'
FROM [MNDTgroup_details]
WHERE [group_id] = @group_id"
        InsertCommand="INSERT INTO [MNDTgroup_details]
           ([group_id]
           ,[account_id]
           ,[create_user_id]
           ,[create_datetime]
           ,[modify_user_id]
           ,[modify_datetime])
VALUES
           (@group_id
           ,@account_id
           ,@sId
           ,GETDATE()
           ,@sId
           ,GETDATE())"
        OnInserted="sds_detail_Inserted" DeleteCommand="DELETE FROM [MNDTgroup_details]
WHERE [group_id] = @original_group_id
	AND [account_id] = @original_account_id"
        OldValuesParameterFormatString="original_{0}" UpdateCommand="UPDATE [MNDTgroup_details]
   SET [account_id] = @account_id
      ,[modify_user_id] = @sId
      ,[modify_datetime] = GETDATE()
WHERE [group_id] = @original_group_id
	AND [account_id] = @original_account_id"
        OnUpdated="sds_detail_Updated">
        <DeleteParameters>
            <asp:Parameter Name="original_group_id" />
            <asp:Parameter Name="original_account_id" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="group_id" />
            <asp:Parameter Name="account_id" />
            <asp:SessionParameter Name="sId" SessionField="sId" />
        </InsertParameters>
        <SelectParameters>
            <asp:Parameter Name="group_id" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="account_id" />
            <asp:SessionParameter Name="sId" SessionField="sId" />
            <asp:Parameter Name="original_group_id" />
            <asp:Parameter Name="original_account_id" />
        </UpdateParameters>
    </asp:SqlDataSource>

</asp:Content>
