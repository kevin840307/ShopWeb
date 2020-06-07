<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="MNDT1040.aspx.cs" Inherits="MNDT1040" %>

<%@ Register Assembly="GGridView" Namespace="GGridView" TagPrefix="cc1" %>
<asp:Content runat="server" ID="const" ContentPlaceHolderID="ContentPlaceHolder1">
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
                                <asp:Label runat="server" Text="父代碼：" CssClass="font-style1"></asp:Label>
                            </td>
                            <td class="left">
                                <asp:TextBox ID="text_code_kind" runat="server" CssClass="font-style1"></asp:TextBox>
                            </td>


                            <td class="right">
                                <asp:Label runat="server" Text="父代碼名稱：" CssClass="font-style1"></asp:Label>
                            </td>
                            <td class="left">
                                <asp:TextBox ID="text_code_kind_name" runat="server" CssClass="font-style1"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="right">
                                <asp:Label runat="server" Text="子代碼：" CssClass="font-style1"></asp:Label>
                            </td>
                            <td class="left">
                                <asp:TextBox ID="text_code" runat="server" CssClass="font-style1"></asp:TextBox>
                            </td>


                            <td class="right">
                                <asp:Label runat="server" Text="子代碼名稱：" CssClass="font-style1"></asp:Label>
                            </td>
                            <td class="left">
                                <asp:TextBox ID="text_code_name" runat="server" CssClass="font-style1"></asp:TextBox>
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
                        <cc1:GGridView runat="server" Width="1005px" CellPadding="4" CssClass="white-style2 no-border border-style1 font-style2" AllowPaging="True"
                            EmptyShowHeader="True" GridLines="Horizontal" AllowSorting="True" EmptyDataText="無顯示資料" AutoGenerateColumns="False"
                            ID="grid_data_m" DataSourceID="sds_main" DataKeyNames="code_kind"
                            OnRowDataBound="grid_data_RowDataBound" OnRowCommand="grid_data_m_RowCommand">
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

                                <asp:TemplateField HeaderText="父代碼" SortExpression="code_kind">
                                    <ItemTemplate>
                                        <asp:Label ID="lab_code_kind" runat="server" Text='<%#Bind("code_kind") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle Width="10%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="父代碼名稱">
                                    <ItemTemplate>
                                        <asp:Label ID="lab_code_kind_name" runat="server" Text='<%#Bind("code_kind_name") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle Width="10%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="代碼描述">
                                    <ItemTemplate>
                                        <asp:Label ID="lab_code_description" runat="server" Text='<%#Bind("code_description") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle Width="10%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="備註">
                                    <ItemTemplate>
                                        <asp:Label ID="lab_code_remarks" runat="server" Text='<%#Bind("code_remarks") %>'></asp:Label>
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
                    </asp:Panel>
                </asp:View>

                <asp:View ID="view_detail" runat="server">
                    <table class="blue-style2 table-size1 center">
                        <tr>
                            <td>主檔</td>
                        </tr>
                    </table>
                    <asp:FormView runat="server" ID="fv_master_form" DataSourceID="sds_main" CssClass="max-width" DefaultMode="Edit" DataKeyNames="code_kind"
                        OnItemCommand="fv_master_form_ItemCommand">
                        <InsertItemTemplate>
                            <table class="max-width">
                                <tr class="max-width">
                                    <td class="right">
                                        <asp:Label runat="server" Text="父代碼："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_insert_code_kind"></asp:TextBox>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="父代碼名稱："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_insert_code_kind_name"></asp:TextBox>
                                    </td>
                                </tr>

                                <tr class="max-width">
                                    <td class="right">
                                        <asp:Label runat="server" Text="父代碼敘述："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_insert_code_description"></asp:TextBox>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="備註："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_insert_code_remarks"></asp:TextBox>
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
                                    <td colspan="3" rowspan="3" class="left">
                                        <asp:ImageButton ID="imgbtn_last" runat="server" ImageUrl="~/Image/last_one.png" onmouseover="this.src='/Image/last_one_1.png'" onmouseout="this.src='/Image/last_one.png'" OnClick="imgbtn_last_Click" />
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="父代碼："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_edit_code_kind" Text='<%#Bind("code_kind") %>' ReadOnly="true" CssClass="gray-style2"></asp:TextBox>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="父代碼名稱："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_edit_code_kind_name" Text='<%#Bind("code_kind_name") %>'></asp:TextBox>
                                    </td>
                                      <td colspan="3" rowspan="3" class="right">
                                        <asp:ImageButton ID="imgbtn_next" runat="server" ImageUrl="~/Image/next_one.png" onmouseover="this.src='/Image/next_one_1.png'" onmouseout="this.src='/Image/next_one.png'" OnClick="imgbtn_next_Click" />
                                    </td>
                                </tr>

                                <tr class="max-width">
                                    <td class="right">
                                        <asp:Label runat="server" Text="父代碼敘述："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_edit_code_description" Text='<%#Bind("code_description") %>'></asp:TextBox>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="備註："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_edit_code_remarks" Text='<%#Bind("code_remarks") %>'></asp:TextBox>
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
                    </asp:FormView>
                    <asp:Panel runat="server" ID="panel_detail" ScrollBars="Vertical" Height="400px" CssClass="div-scroll div-scroll-size2" Visible="false">
                        <asp:UpdatePanel runat="server">
                            <ContentTemplate>
                                <cc1:GGridView runat="server" EmptyShowHeader="True" FooterInsert="true" EmptyDataText="無顯示資料" OnRowDataBound="grid_data_RowDataBound"
                                    OnRowCommand="grid_data_d_RowCommand" Width="1005px" GridLines="Horizontal" AllowSorting="True"
                                    AutoGenerateColumns="False" CellPadding="4" CssClass="white-style2 no-border border-style1 font-style2" AllowPaging="True"
                                    ID="grid_data_d" DataSourceID="sds_detail" DataKeyNames="code_kind, code">
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

                                        <asp:TemplateField HeaderText="父代碼" SortExpression="code_kind">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_code_kind" runat="server" Text='<%#Bind("code_kind") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="子代碼">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_code" runat="server" Text='<%#Bind("code") %>'></asp:Label>
                                            </ItemTemplate>
                                            <%--<EditItemTemplate>
                                                <asp:TextBox ID="text_code" runat="server" Width="90%" Text='<%#Bind("code") %>'></asp:TextBox>
                                            </EditItemTemplate>--%>
                                            <FooterTemplate>
                                                <asp:TextBox ID="text_code" runat="server" Width="90%"></asp:TextBox>
                                            </FooterTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="子代碼名稱">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_code_name" runat="server" Text='<%#Bind("code_name") %>'></asp:Label>
                                            </ItemTemplate>
                                            <EditItemTemplate>
                                                <asp:TextBox ID="text_code_name" runat="server" Width="90%" Text='<%#Bind("code_name") %>'></asp:TextBox>
                                            </EditItemTemplate>
                                            <FooterTemplate>
                                                <asp:TextBox ID="text_code_name" runat="server" Width="90%"></asp:TextBox>
                                            </FooterTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="參數">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_parameter" runat="server" Text='<%#Bind("parameter") %>'></asp:Label>
                                            </ItemTemplate>
                                            <EditItemTemplate>
                                                <asp:TextBox ID="text_parameter" runat="server" Width="90%" Text='<%#Bind("parameter") %>'></asp:TextBox>
                                            </EditItemTemplate>
                                            <FooterTemplate>
                                                <asp:TextBox ID="text_parameter" runat="server" Width="90%"></asp:TextBox>
                                            </FooterTemplate>
                                            <HeaderStyle Width="10%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="備註">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_code_remarks" runat="server" Text='<%#Bind("code_remarks") %>'></asp:Label>
                                            </ItemTemplate>
                                            <EditItemTemplate>
                                                <asp:TextBox ID="text_code_remarks" runat="server" Width="90%" Text='<%#Bind("code_remarks") %>'></asp:TextBox>
                                            </EditItemTemplate>
                                            <FooterTemplate>
                                                <asp:TextBox ID="text_code_remarks" runat="server" Width="90%"></asp:TextBox>
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
                                <asp:SqlDataSource ID="sds_detail" runat="server" ConnectionString="<%$ ConnectionStrings:MNDT %>" OldValuesParameterFormatString="original_{0}" ProviderName="<%$ ConnectionStrings:MNDT.ProviderName %>" SelectCommand="SELECT [code_kind]
      ,[code]
      ,[code_name]
      ,[parameter]
      ,[code_remarks]
      ,[create_user_id]
      ,CONVERT(char, [create_datetime], 111) AS 'create_datetime'
      ,[modify_user_id]
      ,CONVERT(char, [modify_datetime], 111) AS 'modify_datetime'
FROM [MNDTcode_details]
WHERE [code_kind] = @code_kind"
                                    InsertCommand="INSERT INTO [MNDTcode_details]
           ([code_kind]
           ,[code]
           ,[code_name]
           ,[parameter]
           ,[code_remarks]
           ,[create_user_id]
           ,[create_datetime]
           ,[modify_user_id]
           ,[modify_datetime])
VALUES
           (@code_kind
           ,@code
           ,@code_name
           ,@parameter
           ,@code_remarks
           ,@sId
           ,GETDATE()
           ,@sId
           ,GETDATE())"
                                    OnDeleted="sds_detail_Deleted" OnInserted="sds_detail_Inserted" DeleteCommand="DELETE [MNDTcode_details]
WHERE [code_kind] =@original_code_kind
	AND [code] = @original_code"
                                    OnUpdated="sds_detail_Updated" UpdateCommand="UPDATE [MNDTcode_details]
   SET [code_name] = @code_name
      ,[parameter] = @parameter
      ,[code_remarks] = @code_remarks
      ,[modify_user_id] = @sId
      ,[modify_datetime] = GETDATE()
 WHERE [code_kind] =@original_code_kind
	AND [code] = @original_code">
                                    <DeleteParameters>
                                        <asp:Parameter Name="original_code_kind" />
                                        <asp:Parameter Name="original_code" />
                                    </DeleteParameters>
                                    <InsertParameters>
                                        <asp:Parameter Name="code_kind" />
                                        <asp:Parameter Name="code" />
                                        <asp:Parameter Name="code_name" />
                                        <asp:Parameter Name="parameter" />
                                        <asp:Parameter Name="code_remarks" />
                                        <asp:SessionParameter Name="sId" SessionField="sId" />
                                    </InsertParameters>
                                    <SelectParameters>
                                        <asp:Parameter Name="code_kind" />
                                    </SelectParameters>
                                    <UpdateParameters>
                                        <asp:Parameter Name="code_name" />
                                        <asp:Parameter Name="parameter" />
                                        <asp:Parameter Name="code_remarks" />
                                        <asp:SessionParameter Name="sId" SessionField="sId" />
                                        <asp:Parameter Name="original_code_kind" />
                                        <asp:Parameter Name="original_code" />
                                    </UpdateParameters>
                                </asp:SqlDataSource>
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
    <asp:SqlDataSource ID="sds_main" runat="server" ConnectionString="<%$ ConnectionStrings:MNDT %>" OldValuesParameterFormatString="original_{0}" ProviderName="<%$ ConnectionStrings:MNDT.ProviderName %>" InsertCommand="INSERT INTO [MNDTcode_master]
           ([code_kind]
           ,[code_kind_name]
           ,[code_description]
           ,[code_remarks]
           ,[create_user_id]
           ,[create_datetime]
           ,[modify_user_id]
           ,[modify_datetime])
VALUES
           (@code_kind
           ,@code_kind_name
           ,@code_description
           ,@code_remarks
           ,@sId
           ,GETDATE()
           ,@sId
           ,GETDATE())"
        OnInserted="sds_main_Inserted" OnUpdated="sds_main_Updated" UpdateCommand="UPDATE [MNDTcode_master]
   SET [code_kind_name] = @code_kind_name
      ,[code_description] = @code_description
      ,[code_remarks] = @code_remarks
      ,[modify_user_id] = @sId
      ,[modify_datetime] = GETDATE()
WHERE [code_kind] = @code_kind"
        DeleteCommand="DELETE [MNDTcode_details]
WHERE [code_kind] =@original_code_kind

DELETE [MNDTcode_master]
WHERE [code_kind] =@original_code_kind"
        OnDeleted="sds_main_Deleted">
        <DeleteParameters>
            <asp:Parameter Name="original_code_kind" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="code_kind" />
            <asp:Parameter Name="code_kind_name" />
            <asp:Parameter Name="code_description" />
            <asp:Parameter Name="code_remarks" />
            <asp:SessionParameter Name="sId" SessionField="sId" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="code_kind_name" />
            <asp:Parameter Name="code_description" />
            <asp:Parameter Name="code_remarks" />
            <asp:SessionParameter Name="sId" SessionField="sId" />
            <asp:Parameter Name="code_kind" />
        </UpdateParameters>
    </asp:SqlDataSource>
</asp:Content>
