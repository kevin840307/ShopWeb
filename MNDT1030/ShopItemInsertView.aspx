<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="ShopItemInsertView.aspx.cs" Inherits="ShopItemInsertView" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="Css/content-header.css" rel="stylesheet" />
    <link href="Css/content-view.css" rel="stylesheet" />
    <link href="Css/tab-style1.css" rel="stylesheet" />
    <link href="Css/content-style1.css" rel="stylesheet" />
    <link href="Css/frame-style3.css" rel="stylesheet" />
    <script src="Scripts/View/Admin/ShopItem/shop-item-insert-view.js"></script>
    <script src="Scripts/Presenter/Admin/ShopItem/shop-item-insert-presenter.js"></script>
    <script src="tinymce/tinymce.min.js"></script>
    <script type="text/javascript">
        var shopItemInsertView = {};
        $(function () {

            function fnInitialization() {
                var shopItemInsertPresenter = {};
                shopItemInsertView.__proto__ = ShopItemInsertView.prototype;
                shopItemInsertPresenter.__proto__ = ShopItemInsertPresenter.prototype;
                ShopItemInsertView.call(shopItemInsertView, shopItemInsertPresenter);
                ShopItemInsertPresenter.call(shopItemInsertPresenter, shopItemInsertView);
                shopItemInsertPresenter.fnInitialization();
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
                <a href="ShopItemSearchView.aspx?page=1">產品資料維護</a>
            </li>
        </ul>
        <div class="content-header-right">
            <button type="button" class="btn-img-style1" id="btn_back" onclick="window.location='ShopItemSearchView.aspx'">
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
                        <img src="Image/paint.png" /><p>產品資料新增</p>
                    </h3>
                </div>

                <div class="frame-content-div">
                    <div id="tab" class="tab-style1">
                        <ul class="tab-items">
                            <li class='tab-item select' id="tab1" onclick="shopItemInsertView.fnTitleTabEvent(this);">產品資訊</li>
                            <li class='tab-item prohibited' id="tab2" onclick="shopItemInsertView.fnTitleTabEvent(this);">內容</li>
                            <li class='tab-item prohibited' id="tab3" onclick="shopItemInsertView.fnTitleTabEvent(this);">圖片</li>
                        </ul>
                        <form class='content-style1 tab-content' id="tab1_content" onsubmit="shopItemInsertView.fnTab1Insert(event);">
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*產品ID</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_product_id" list="product_id_list" maxlength="15" pattern="[a-zA-Z0-9]{1,15}" placeholder="產品" required="required" class="input-data-required" />
                                    <datalist id="product_id_list">
                                    </datalist>
                                </div>
                            </div>
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*類別</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_category" list="category_list" maxlength="15" placeholder="類別" required="required" class="input-data-required" />
                                    <datalist id="category_list">
                                    </datalist>
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*描述</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_description" maxlength="100" placeholder="描述" required="required" class="input-data-required" />
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*種類</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_type" list="type_list" pattern="[0-9]{2}" maxlength="2" placeholder="種類" value="01" required="required" class="input-data-required" />
                                    <datalist id="type_list">
                                    </datalist>
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*折數</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_fold" placeholder="折數" value="1" required="required" class="input-data-required" />
                                </div>
                            </div>


                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>備註</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_remarks" maxlength="50" placeholder="備註" class="input-data" />
                                </div>
                            </div>

                            <div class="general-right">
                                <input type="submit" value="下一步" class="col-2 button-style1" />
                            </div>
                        </form>

                        <form class='tab-content content-style1 hide' id="tab2_content" onsubmit="shopItemInsertView.fnTab2Update(event);">
                            <div class="frame-style2">
                                <div class="frame-title-div">
                                    <div class="left-div">
                                        <h3 class="title-h3-style1">
                                            <img src="Image/paint.png" />內容
                                        </h3>
                                    </div>
                                </div>
                                <div class="general">
                                    <div class="col-12">
                                        <input type="text" id="text_content" placeholder="備註" class="editor input-data" />
                                    </div>
                                </div>
                            </div>
                            <div class="general-right">
                                <input type="submit" value="下一步" class="col-2 button-style1" />
                            </div>
                        </form>

                        <form class='tab-content content-style1 hide' id="tab3_content" onsubmit="shopItemInsertView.fnTab3Update(event);">
                            <div class="frame-style2">
                                <div class="frame-title-div">
                                    <div class="left-div">
                                        <h3 class="title-h3-style1">
                                            <img src="Image/paint.png" />上傳圖片
                                        </h3>
                                    </div>
                                </div>
                            </div>
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>封面圖</label>
                                </div>
                                <div class="col-10-right">
                                    <button id="btn_first_file" type="button" class="btn-style1" onclick="shopItemInsertView.fnFileFirst();">選擇檔案</button>
                                    <input id="file_first" type="file" class="btn-img-style1" style="display: none" onchange="shopItemInsertView.fnFileFirstChange(this);" />
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>展示圖</label>
                                </div>
                                <div class="col-10-right">
                                    <button id="btn_file" type="button" class="btn-style1" onclick="shopItemInsertView.fnFile();">選擇檔案</button>
                                    <input id="file" type="file" class="btn-img-style1" style="display: none" onchange="shopItemInsertView.fnFileChange(this);" multiple="multiple" />
                                </div>

                            </div>
                            <div class="general-right">
                                <input type="submit" value="提交" class="col-2 button-style1" />
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
