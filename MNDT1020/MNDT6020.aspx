<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" MaintainScrollPositionOnPostback="true" EnableEventValidation="false" Async="true" AutoEventWireup="true" CodeFile="MNDT6020.aspx.cs" ValidateRequest="false" Inherits="MNDT6020" %>

<%@ Register Assembly="GGridView" Namespace="GGridView" TagPrefix="cc1" %>
<asp:Content runat="server" ID="const" ContentPlaceHolderID="ContentPlaceHolder1">
    <!DOCTYPE html>
    <script src="tinymce/tinymce.min.js"></script>
    <script src="tinymce/jquery.tinymce.min.js"></script>
    <script type="text/javascript">

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
                    url: 'ActionService.asmx/fnDeleteShopImage',
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

        function show_editor() {
            tinymce.remove();
            tinymce.init({
                selector: '.editor',
                language: 'zh_TW',
                width: 1022,
                height: 350,
                plugins: ['advlist autolink lists link image charmap print preview anchor',
                          'searchreplace visualblocks code fullscreen textcolor colorpicker',
                          'insertdatetime media table contextmenu paste code hr pagebreak nonbreaking'],
                toolbar: ['newdocument preview fullscreen code print searchreplace selectall | bold italic underline strikethrough superscript subscript removeformat forecolor backcolor | alignleft aligncenter alignright alignjustify |',
                'undo redo cut copy paste pastetext pasteword | bullist numlist outdent indent | blockquote nonbreaking hr pagebreak charmap anchor link unlink image table']
            });
        }

        function shop_item_actions(action) {
            var ProductCode;
            if (action == 'fnInsertShopItem') {
                ProductCode = $('#ContentPlaceHolder1_fv_master_form_drop_product_code').val()
            } else {
                ProductCode = $('#ContentPlaceHolder1_fv_master_form_text_product_code').val()
            }

            $.ajax({
                type: 'post',
                url: 'ActionService.asmx/' + action,
                data: {
                    sProductCode: ProductCode,
                    sShopName: $('#ContentPlaceHolder1_fv_master_form_text_shop_name').val(),
                    sShopCategory: $('#ContentPlaceHolder1_fv_master_form_drop_shop_category').val(),
                    sShopRemarks: $('#ContentPlaceHolder1_fv_master_form_text_shop_remarks').val(),
                    sShopDescription: $('#ContentPlaceHolder1_fv_master_form_text_shop_description').val(),
                    sShopSpecial: $('#ContentPlaceHolder1_fv_master_form_drop_shop_special').val(),
                    sShopContent: tinymce.activeEditor.getContent().replace(/</g, "SSS0").replace(/>/g, "SSS1").replace(/"/g, "''")
                },
                success: function (domXml) {
                    var xmlDom = domXml;
                    var result = xmlDom.childNodes[0].firstChild.nodeValue;
                    if (result.length > 10) {
                        ShowError(result);
                    } else {
                        ShowMessage(result);
                    }
                },
                error: function () { ShowMessage('失敗'); }
            });

        }

        $(function () {

        });
    </script>
    <asp:UpdatePanel runat="server" UpdateMode="Conditional">
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
                                <td>
                                    <asp:Label runat="server" Text="產品代碼：" CssClass="font-style1"></asp:Label>
                                    <asp:TextBox ID="text_product_code" runat="server" CssClass="text-size3"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3" class="center">
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
                                    ID="grid_data_m" DataSourceID="sds_main" DataKeyNames="product_code">

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

                                        <asp:TemplateField HeaderText="產品代瑪" SortExpression="product_code">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_product_code" runat="server" Text='<%#Bind("product_code") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="9%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="商品名稱">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_shop_name" runat="server" Text='<%#Bind("shop_name") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="9%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="描述">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_shop_description" runat="server" Text='<%#Bind("shop_description") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Width="9%" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="備註">
                                            <ItemTemplate>
                                                <asp:Label ID="lab_rotation_remarks" runat="server" Text='<%#Bind("shop_remarks") %>'></asp:Label>
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
                    <asp:FormView runat="server" ID="fv_master_form" CssClass="max-width" DefaultMode="Edit" DataSourceID="sds_main" DataKeyNames="product_code" OnItemCommand="form_view_master_ItemCommand">
                        <InsertItemTemplate>
                            <table class="max-width">
                                <tr class="max-width">
                                    <td class="right">
                                        <asp:Label runat="server" Text="產品代號："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:DropDownList runat="server" ID="drop_product_code" CssClass="dropdwonlist-size3" OnDataBinding="text_product_code_DataBinding"></asp:DropDownList>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="商品名稱："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_shop_name" CssClass="text-size4"></asp:TextBox>
                                    </td>
                                </tr>

                                <tr class="max-width">
                                    <td class="right">
                                        <asp:Label runat="server" Text="產品類別："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:DropDownList runat="server" ID="drop_shop_category" CssClass="dropdwonlist-size3" OnDataBinding="drop_shop_category_DataBinding"></asp:DropDownList>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="備註："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_shop_remarks" CssClass="text-size4"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="right">
                                        <asp:Label runat="server" Text="特殊類別："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:DropDownList runat="server" ID="drop_shop_special" CssClass="dropdwonlist-size3" OnDataBinding="drop_shop_special_DataBinding"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="right">
                                        <asp:Label runat="server" Text="產品描述："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_shop_description" Height="80px" TextMode="MultiLine" CssClass="text-size4"></asp:TextBox>
                                </tr>
                                <tr>

                                    <td colspan="4" class="center">
                                        <asp:Button runat="server" CssClass="blue-style6 button-size2" Text="新增" CommandName="InsertData" OnClientClick="shop_item_actions('fnInsertShopItem');" />
                                        <asp:Button runat="server" CssClass="blue-style6 button-size2" Text="取消" CommandName="Cancel" ID="btn_master_cancel" />
                                    </td>

                                </tr>
                            </table>
                            <asp:TextBox runat="server" ID="text_editor" TextMode="MultiLine" CssClass="editor"></asp:TextBox>
                        </InsertItemTemplate>

                        <EditItemTemplate>
                            <table class="max-width">
                                <tr class="max-width">
                                    <td colspan="4" rowspan="4" class="left">
                                        <asp:ImageButton ID="imgbtn_last" runat="server" ImageUrl="~/Image/last_one.png" onmouseover="this.src='/Image/last_one_1.png'" onmouseout="this.src='/Image/last_one.png'" OnClick="imgbtn_last_Click" />
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="產品代號："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" Text='<%#Bind("product_code") %>' ID="text_product_code" CssClass="text-size4" Enabled="false"></asp:TextBox>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="商品名稱："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" Text='<%#Bind("shop_name") %>' ID="text_shop_name" CssClass="text-size4"></asp:TextBox>
                                    </td>
                                    <td colspan="4" rowspan="4" class="right">
                                        <asp:ImageButton ID="imgbtn_next" runat="server" ImageUrl="~/Image/next_one.png" onmouseover="this.src='/Image/next_one_1.png'" onmouseout="this.src='/Image/next_one.png'" OnClick="imgbtn_next_Click" />
                                    </td>
                                </tr>
                                <tr class="max-width">
                                    <td class="right">
                                        <asp:Label runat="server" Text="產品類別："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:DropDownList runat="server" SelectedValue='<%#Bind("shop_category") %>' ID="drop_shop_category" CssClass="dropdwonlist-size3" OnDataBinding="drop_shop_category_DataBinding"></asp:DropDownList>
                                    </td>
                                    <td class="right">
                                        <asp:Label runat="server" Text="備註："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_shop_remarks" Text='<%#Bind("shop_remarks") %>' CssClass="text-size4"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="right">
                                        <asp:Label runat="server" Text="特殊類別："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:DropDownList runat="server" ID="drop_shop_special"  SelectedValue='<%#Bind("shop_special") %>' CssClass="dropdwonlist-size3" OnDataBinding="drop_shop_special_DataBinding"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="right">
                                        <asp:Label runat="server" Text="產品描述："></asp:Label>
                                    </td>
                                    <td class="left">
                                        <asp:TextBox runat="server" ID="text_shop_description" Text='<%#Bind("shop_description") %>' Height="80px" TextMode="MultiLine" CssClass="text-size4"></asp:TextBox>
                                </tr>
                                <tr>

                                    <td colspan="10" class="center">
                                        <asp:Button runat="server" CssClass="blue-style6 button-size2" Text="更新" CommandName="UpdateDate" OnClientClick="if(confirm('確認要更新嗎？')) shop_item_actions('fnUpdateShopItem'); else return false;" />
                                        <asp:Button runat="server" CssClass="blue-style6 button-size2" Text="刪除" CommandName="Delete" OnClientClick="return(confirm('確認要刪除嗎？'))" />
                                        <asp:Button runat="server" CssClass="blue-style6 button-size2" Text="取消" CommandName="Cancel" ID="btn_master_cancel" />
                                    </td>

                                </tr>
                                <tr class="row-style1">
                                    <td colspan="12" class="center">
                                        <asp:UpdatePanel runat="server">
                                            <ContentTemplate>
                                                <asp:FileUpload runat="server" AllowMultiple="true" ID="fu_file_image_upload" Width="0%" Height="0%" onchange="file_image_data()" />
                                                <asp:Button runat="server" Text="上傳" ID="btn_save_image" OnClick="btn_save_image_Click" CommandName="111" BorderStyle="None" CssClass="blue-style6 button-size2" />
                                                <asp:Button runat="server" Text="選擇圖片" ID="btn_file_image" OnClientClick="file_image(); return false;" BorderStyle="None" CssClass="blue-style6 button-size2" />
                                                <asp:TextBox runat="server" ID="text_file_image_data" Text="檔案路徑" BorderStyle="None" Enabled="false" CssClass="blue-style1"></asp:TextBox>
                                            </ContentTemplate>
                                            <Triggers>
                                                <asp:PostBackTrigger ControlID="btn_save_image" />
                                            </Triggers>
                                        </asp:UpdatePanel>
                                    </td>

                                </tr>
                            </table>
                            <asp:UpdatePanel runat="server">
                                <ContentTemplate>
                                    <asp:TextBox runat="server" ID="text_editor" TextMode="MultiLine" CssClass="editor" Text='<%#Bind("shop_content") %>'></asp:TextBox>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                            <asp:Panel runat="server" ScrollBars="Vertical" CssClass="div-scroll div-scroll-size7">
                                <asp:Literal ID="lt_image_html" runat="server" OnDataBinding="lt_image_html_DataBinding"></asp:Literal>
                            </asp:Panel>
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
    <asp:SqlDataSource ID="sds_main" OnUpdated="sds_main_Updated" runat="server" ConnectionString="<%$ ConnectionStrings:MNDT %>" OldValuesParameterFormatString="original_{0}" ProviderName="<%$ ConnectionStrings:MNDT.ProviderName %>"
        DeleteCommand="DELETE [MNDTshop_item] 
WHERE product_code = @original_product_code"
        OnInserted="sds_main_Inserted" OnDeleted="sds_main_Deleted">
        <DeleteParameters>
            <asp:Parameter Name="original_product_code" />
        </DeleteParameters>
    </asp:SqlDataSource>
</asp:Content>
