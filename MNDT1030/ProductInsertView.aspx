<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="ProductInsertView.aspx.cs" Inherits="ProductInsertView" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="Css/content-header.css" rel="stylesheet" />
    <link href="Css/content-view.css" rel="stylesheet" />
    <link href="Css/tab-style1.css" rel="stylesheet" />
    <link href="Css/frame-style3.css" rel="stylesheet" />
    <link href="Css/content-style1.css" rel="stylesheet" />
    <script src="Scripts/View/Admin/Product/product-insert-view.js"></script>
    <script src="Scripts/Presenter/Admin/Product/product-insert-presenter.js"></script>
    <script type="text/javascript">
        var productInsertView = {};
        $(function () {

            function fnInitialization() {
                var productInsertPresenter = {};
                productInsertView.__proto__ = ProductInsertView.prototype;
                productInsertPresenter.__proto__ = ProductInsertPresenter.prototype;
                ProductInsertView.call(productInsertView, productInsertPresenter);
                ProductInsertPresenter.call(productInsertPresenter, productInsertView);
                productInsertPresenter.fnInitialization();
            }

            fnInitialization();
        });
    </script>
    <div id="content_header_div">
        <h2>產品資料維護</h2>
        <ul>
            <li>
                <a href="Menu.aspx">首頁</a>
            </li>
            <li>
                <a href="AccountSearchView.aspx?page=1">產品資料維護</a>
            </li>
        </ul>
        <div class="content-header-right">
            <button type="button" class="btn-img-style1" id="btn_back" onclick="window.location='ProductSearchView.aspx'">
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
                        <img src="Image/person.png" /><p>產品資料新增</p>
                    </h3>
                </div>

                <div class="frame-content-div">
                    <div id="tab" class="tab-style1">
                        <ul class="tab-items">
                            <li class='tab-item select' id="tab1" onclick="productInsertView.fnTitleTabEvent(this);" >產品資訊</li>
                        </ul>
                        <form class='content-style1 tab-content' id="tab1_content" onsubmit="productInsertView.fnInsert(event);">
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*ID</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_product_id" maxlength="13" pattern="[a-zA-Z0-9]{1,15}" placeholder="ID" required="required" class="input-data-required" />
                                </div>
                            </div>
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*名稱</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_name" maxlength="15" placeholder="名稱" required="required" class="input-data-required" />
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>公司</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_company_id" placeholder="公司" list="company_list" maxlength="5" class="input-data" />
                                    <datalist id="company_list">
                                    </datalist>
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>單位</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_unit" placeholder="單位" list="unit_list" maxlength="5" class="input-data" />
                                    <datalist id="unit_list">
                                    </datalist>
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>成本</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_cost" placeholder="成本" pattern="[0-9]{1,7}[.]{0,1}[0-9]{0,3}" maxlength="10" class="input-data" />
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>價格</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_price" placeholder="價格" pattern="[0-9]{1,7}[.]{0,1}[0-9]{0,3}" maxlength="10" class="input-data" />
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>貨幣</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_currency" placeholder="貨幣" list="currency_list" maxlength="5" class="input-data" />
                                    <datalist id="currency_list">
                                    </datalist>
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>保存期限(天)</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_shelf_life" placeholder="保存期限(天)" pattern="[0-9]{1,3}" maxlength="3" class="input-data" />
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>描述</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_description" placeholder="描述" maxlength="50" class="input-data" />
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
