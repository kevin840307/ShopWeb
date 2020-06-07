<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="ShopItemEditView.aspx.cs" Inherits="ShopItemEditView" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="Css/content-header.css" rel="stylesheet" />
    <link href="Css/content-view.css" rel="stylesheet" />
    <link href="Css/frame-style3.css" rel="stylesheet" />
    <link href="Css/frame-style1.css" rel="stylesheet" />
    <link href="Css/list-style1.css" rel="stylesheet" />
    <link href="Css/tab-style1.css" rel="stylesheet" />
    <link href="Css/content-style1.css" rel="stylesheet" />
    <script src="Scripts/Presenter/Admin/ShopItem/shop-item-edit-presenter.js"></script>
    <script src="Scripts/View/Admin/ShopItem/shop-item-edit-view.js"></script>
        <script src="tinymce/tinymce.min.js"></script>
    <script type="text/javascript">

        var shopItemEditView = {};

        $(function () {

            function fnInitialization() {
                var shopItemEditPresenter = {};
                shopItemEditView.__proto__ = ShopItemEditView.prototype;
                shopItemEditPresenter.__proto__ = ShopItemEditPresenter.prototype;
                ShopItemEditView.call(shopItemEditView, shopItemEditPresenter);
                ShopItemEditPresenter.call(shopItemEditPresenter, shopItemEditView);
                shopItemEditPresenter.fnInitialization();
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
            <button type="button" class="btn-img-style1" id="btn_last" onclick="shopItemEditView.fnLast();" title="上一筆">
                <img src="Image/last.png"></button>
            <button type="button" class="btn-img-style1" id="btn_next" onclick="shopItemEditView.fnNext();" title="下一筆">
                <img src="Image/next.png"></button>
            <button type="button" class="btn-img-style1" id="btn_back" onclick="window.location='ShopItemSearchView.aspx'" title="返回">
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
                        <img src="Image/paint.png" /><p>產品資料編輯</p>
                    </h3>
                </div>

                <div class="frame-content-div">
                     <div id="tab" class="tab-style1">
                        <ul class="tab-items">
                            <li class='tab-item select' id="tab1" onclick="shopItemEditView.fnTitleTabEvent(this);">產品資訊</li>
                            <li class='tab-item' id="tab2" onclick="shopItemEditView.fnTitleTabEvent(this);">內容</li>
                            <li class='tab-item' id="tab3" onclick="shopItemEditView.fnTitleTabEvent(this);">圖片</li>
                        </ul>
                        <form class='content-style1 tab-content' id="tab1_content" onsubmit="shopItemEditView.fnUpdate(event);">
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*產品ID</label>
                                </div>
                                <div class="col-10-right">
                                    <label id="lab_product_id" />
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
                                    <input type="text" id="text_type" list="type_list" pattern="[0-9]{2}" maxlength="2" placeholder="種類" required="required" class="input-data-required" />
                                    <datalist id="type_list">
                                    </datalist>
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*折數</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_fold" placeholder="折數" pattern="[0-9]\.*[0-9]*" maxlength="4" required="required" class="input-data-required" />
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
                                <input type="submit" class="col-2 button-style1" />
                            </div>
                        </form>

                        <form class='tab-content content-style1 hide' id="tab2_content" onsubmit="shopItemEditView.fnUpdate(event);">
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
                                <input type="submit" class="col-2 button-style1" />
                            </div>
                        </form>

                        <form class='tab-content content-style1 hide' id="tab3_content">
                            <div class="frame-style2">
                                <div class="frame-title-div">
                                    <div class="left-div">
                                        <h3 class="title-h3-style1">
                                            <img src="Image/paint.png" />上傳圖片
                                        </h3>
                                    </div>
                                </div>
                            </div>
                            <link href="Css/item-data.css" rel="stylesheet" />
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>封面圖</label>
                                </div>
                                <div class="col-10-right" id="cover_img_div">
                                </div>
                                </div>
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>封面圖</label>
                                </div>
                                <div class="col-10-right">
                                    <button id="btn_first_file" type="button" class="btn-style1" onclick="shopItemEditView.fnFileFirst();">選擇檔案</button>
                                    <input id="file_first" type="file" class="btn-img-style1" style="display: none" onchange="shopItemEditView.fnFileFirstChange(this);" />
                                </div>
                            </div>
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>展示圖</label>
                                </div>
                                <div class="col-10-right" id="show_img_div">
                                </div>
                                </div>
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>展示圖</label>
                                </div>
                                <div class="col-10-right">
                                    <button id="btn_file" type="button" class="btn-style1" onclick="shopItemEditView.fnFile();">選擇檔案</button>
                                    <input id="file" type="file" class="btn-img-style1" style="display: none" onchange="shopItemEditView.fnFileChange(this);" multiple="multiple" />
                                </div>

                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
