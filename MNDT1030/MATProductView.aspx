<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="MATProductView.aspx.cs" Inherits="MATProductView" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="Css/content-header.css" rel="stylesheet" />
    <link href="Css/content-view.css" rel="stylesheet" />
    <link href="Css/tab-style1.css" rel="stylesheet" />
    <link href="Css/frame-style3.css" rel="stylesheet" />
    <link href="Css/frame-style2.css" rel="stylesheet" />
    <link href="Css/list-style1.css" rel="stylesheet" />
    <link href="Css/list-style2.css" rel="stylesheet" />
    <link href="Css/content-style1.css" rel="stylesheet" />
    <script src="Scripts/View/Admin/MATProduct/MAT-product-view.js"></script>
    <script src="Scripts/Presenter/Admin/MATProduct/MAT-product-presenter.js"></script>
    <script type="text/javascript">
        var g_MATProductView = {};
        var g_MATProductPresenter = {};
        $(function () {

            function fnInitialization() {
                g_MATProductView.__proto__ = MATProductView.prototype;
                g_MATProductPresenter.__proto__ = MATProductPresenter.prototype;
                MATProductView.call(g_MATProductView, g_MATProductPresenter);
                MATProductPresenter.call(g_MATProductPresenter, g_MATProductView);
                g_MATProductPresenter.fnInitialization();
            }

            fnInitialization();
        });
    </script>
    <div id="content_header_div">
        <h2>材料轉換產品</h2>
        <ul>
            <li>
                <a href="Menu.aspx">首頁</a>
            </li>
            <li>
                <a href="MATProductView.aspx?page=1">材料轉換產品</a>
            </li>
        </ul>
        <div class="content-header-right">
            <button type="button" class="btn-img-style1" id="btn_back" onclick="window.location='MATProductView.aspx'">
                <img src="Image/back.png"></button>
        </div>
    </div>
    <div class="line-style1"></div>
    <div class="content-view">
        <div id="content-message-div" class="error msg-div">
            <img src="Image/close-out.png" onmouseout="this.src='Image/close-out.png'" onmouseover="this.src='Image/close-in.png'" class="close" />
            <p>警告訊息：無。</p>
        </div>
        <div class="col-12">
            <div class="frame-style3">
                <div class="frame-title-div title-h3-style1">
                    <h3>
                        <img src="Image/person.png" /><p>轉換</p>
                    </h3>
                </div>

                <div class="frame-content-div">
                    <div id="tab" class="tab-style1">
                        <ul class="tab-items">
                            <%--prohibited--%>
                            <li class='tab-item select' id="tab1" onclick="g_MATProductView.fnTitleTabEvent(this);">產品資訊</li>
                            <li class='tab-item prohibited' id="tab2" onclick="g_MATProductView.fnTitleTabEvent(this);">材料資訊</li>
                        </ul>
                        <form class='tab-content content-style1' id="tab1_content" onsubmit="g_MATProductView.fnTab1Select(event);">

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*產品 ID</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_product_id" list="product_list" maxlength="13" title="產品 ID" pattern="[a-zA-Z0-9]{1,15}" required="required" placeholder="ID" class="input-data-required" />
                                </div>
                                <datalist id="product_list"></datalist>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*倉庫 ID</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_warehouse_id" list="warehouse_list" title="倉庫 ID" required="required" placeholder="倉庫 ID" class="input-data-required" />
                                </div>
                                <datalist id="warehouse_list"></datalist>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*數量</label>
                                </div>
                                <div class="col-10-right">
                                    <input type='text' id="text_amount" maxlength='10' placeholder='數量' title="數量" pattern='[0-9]{1,8}' required='required' class='input-data-required' />
                                </div>
                            </div>

                            <div class="general-right">
                                <input type="submit" value="下一步" class="col-2 button-style1" />
                            </div>

                        </form>

                        <form class='tab-content content-style1 hide' id="tab2_content" onsubmit="g_MATProductView.fnTab2Change(event);">

                            <div class="frame-style2">
                                <div class="frame-title-div">
                                    <div class="left-div">
                                        <h3 class="title-h3-style1">所需材料資訊
                                        </h3>
                                    </div>
                                </div>
                                <div class="frame-content-div">
                                    <div class="list-style2">
                                        <table id="list_need" class="list-table">
                                            <thead>
                                                <tr>
                                                    <td class='general'>材料 ID</td>
                                                    <td class='general'>名稱</td>
                                                    <td class='general'>需求數量</td>
                                                    <td class='general'>目前數量</td>
                                                    <td class='general'>缺少數量</td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <div class="frame-style2">
                                <div class="frame-title-div">
                                    <div class="left-div">
                                        <h3 class="title-h3-style1">
                                            <img src="Image/person.png" />材料資訊
                                        </h3>
                                    </div>
                                    <div class="right-div">
                                        <div class="action">
                                            <button type='button' class='btn-img-style1' onclick='g_MATProductView.fnTab2AppendInsert();'>
                                                <img src='Image/insert.png' /></button>
                                        </div>
                                    </div>
                                </div>

                                <div class="frame-content-div">
                                    <div class="list-style1">
                                        <table id="list" class="list-table">
                                            <thead>
                                                <tr>
                                                    <td class='general'>材料 ID</td>
                                                    <td class='general'>倉庫</td>
                                                    <td class='general'>數量</td>
                                                    <td>動作</td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>
                                        <datalist id="material_list"></datalist>
                                    </div>
                                </div>
                            </div>
                            <div class="general-right">
                                <input type="submit" class="col-2 button-style1" />
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
