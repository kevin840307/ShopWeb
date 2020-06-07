<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="PurchaseInsertView.aspx.cs" Inherits="PurchaseInsertView" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="Css/content-header.css" rel="stylesheet" />
    <link href="Css/content-view.css" rel="stylesheet" />
    <link href="Css/tab-style1.css" rel="stylesheet" />
    <link href="Css/frame-style3.css" rel="stylesheet" />
    <link href="Css/frame-style2.css" rel="stylesheet" />
    <link href="Css/list-style1.css" rel="stylesheet" />
    <link href="Css/content-style1.css" rel="stylesheet" />
    <script src="Scripts/View/Admin/Purchase/purchase-insert-view.js"></script>
    <script src="Scripts/Presenter/Admin/Purchase/purchase-insert-presenter.js"></script>
    <script type="text/javascript">
        var purchaseInsertView = {};
        $(function () {

            function fnInitialization() {
                var purchaseInsertPresenter = {};
                purchaseInsertView.__proto__ = PurchaseInsertView.prototype;
                purchaseInsertPresenter.__proto__ = PurchaseInsertPresenter.prototype;
                PurchaseInsertView.call(purchaseInsertView, purchaseInsertPresenter);
                PurchaseInsertPresenter.call(purchaseInsertPresenter, purchaseInsertView);
                purchaseInsertPresenter.fnInitialization();
            }

            fnInitialization();
        });
    </script>
    <div id="content_header_div">
        <h2>採購資料維護</h2>
        <ul>
            <li>
                <a href="Menu.aspx">首頁</a>
            </li>
            <li>
                <a href="PurchaseSearchView.aspx?page=1">採購資料維護</a>
            </li>
        </ul>
        <div class="content-header-right">
            <button type="button" class="btn-img-style1" id="btn_back" onclick="window.location='PurchaseSearchView.aspx'">
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
                        <img src="Image/person.png" /><p>採購資料新增</p>
                    </h3>
                </div>

                <div class="frame-content-div">
                    <div id="tab" class="tab-style1">
                        <ul class="tab-items">
                            <%--prohibited--%>
                            <li class='tab-item select' id="tab1" onclick="purchaseInsertView.fnTitleTabEvent(this);">採購資訊</li>
                            <li class='tab-item prohibited' id="tab2" onclick="purchaseInsertView.fnTitleTabEvent(this);">材料資訊</li>
                        </ul>
                        <form class='tab-content content-style1' id="tab1_content" onsubmit="purchaseInsertView.fnTab1Insert(event);">
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*單號 ID</label>
                                </div>
                                <div class="col-10-right">
                                    <label id="lab_order_id">自動取得</label>
                                </div>
                            </div>
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*ID</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_id" list="id_list" maxlength="9" pattern="[0-9]" required="required" placeholder="ID" class="input-data-required" />
                                </div>
                                <datalist id="id_list"></datalist>
                            </div>
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*採購日期</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="date" id="text_datetime" required="required" class="input-data-required" />
                                </div>
                            </div>
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>描述</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_description" maxlength="50" placeholder="描述" class="input-data" />
                                </div>
                            </div>

                            <div class="general-right">
                                <input type="submit" value="下一步" class="col-2 button-style1" />
                            </div>
                        </form>

                        <div class='tab-content content-style1 hide' id="tab2_content" >
                            <form class='content-style1' onsubmit="purchaseInsertView.fnTab2Inserts(event);">
                                <div class="frame-style2">
                                    <div class="frame-title-div">
                                        <div class="left-div">
                                            <h3 class="title-h3-style1">
                                                <img src="Image/person.png" />採購資訊
                                            </h3>
                                        </div>
                                        <div class="right-div">
                                            <div class="action">
                                                <button type='button' class='btn-img-style1' onclick='purchaseInsertView.fnTab2AppendInsert();'>
                                                    <img src='Image/insert.png' /></button>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="frame-content-div">
                                        <div class="list-style1">
                                            <div class="list-data-div">
                                                <div>
                                                    顯示筆數：
                                                <select class="drop-style1" id="select_page_size" onchange="purchaseInsertView.fnMaxPageSizeChange(this);">
                                                    <option value="8">8</option>
                                                    <option value="10">10</option>
                                                    <option value="20">20</option>
                                                    <option value="50">50</option>
                                                    <option value="100">100</option>
                                                </select>
                                                </div>
                                            </div>
                                            <table id="list" class="list-table">
                                                <thead>
                                                    <tr>
                                                        <td class='general'>材料 ID</td>
                                                        <td class='general'>數量</td>
                                                        <td class='general'>價錢</td>
                                                        <td class='general'>修訂數量</td>
                                                        <td class='general'>修訂價錢</td>
                                                        <td class='general'>備註</td>
                                                        <td>動作</td>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                </tbody>
                                            </table>
                                            <div class="list-page-div" id="list_page">
                                                <ul>
                                                </ul>
                                            </div>
                                            <datalist id="material_list"></datalist>
                                        </div>
                                    </div>
                                </div>
                                <div class="general-right">
                                    <input type="submit" class="col-2 button-style1" />
                                </div>
                            </form>

                            <form class='content-style1' onsubmit="purchaseInsertView.fnTab2ProductInsert(event);">
                                <div class="frame-style2">
                                    <div class="frame-title-div">
                                        <div class="left-div">
                                            <h3 class="title-h3-style1">產品帶入
                                            </h3>
                                        </div>
                                    </div>

                                    <div class="frame-content-div content-style1">
                                        <div class="general">
                                            <div class="col-2-left-r">
                                                <label class="font-red">*產品 ID</label>
                                            </div>
                                            <div class="col-10-right">
                                                <input type="text" id="text_product_id" maxlength="13" list="product_list" required="required" class="input-data-required" />
                                                <datalist id="product_list"></datalist>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="frame-content-div content-style1">
                                        <div class="general">
                                            <div class="col-2-left-r">
                                                <label class="font-red">*數量</label>
                                            </div>
                                            <div class="col-10-right">
                                                <input type="text" id="text_amount" title="數量" pattern='[0-9]{1,7}[.]{0,1}[0-9]{0,1}' required="required" class="input-data-required" />
                                            </div>
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
    </div>
</asp:Content>
