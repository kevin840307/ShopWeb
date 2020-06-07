<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="CarouselEditView.aspx.cs" Inherits="CarouselEditView" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="Css/content-header.css" rel="stylesheet" />
    <link href="Css/content-view.css" rel="stylesheet" />
    <link href="Css/frame-style3.css" rel="stylesheet" />
    <link href="Css/frame-style1.css" rel="stylesheet" />
    <link href="Css/list-style1.css" rel="stylesheet" />
    <link href="Css/tab-style1.css" rel="stylesheet" />
    <link href="Css/content-style1.css" rel="stylesheet" />
    <script src="Scripts/Presenter/Admin/Carousel/carousel-edit-presenter.js"></script>
    <script src="Scripts/View/Admin/Carousel/carousel-edit-view.js"></script>
        <script src="tinymce/tinymce.min.js"></script>
    <script type="text/javascript">

        var carouselEditView = {};

        $(function () {

            function fnInitialization() {
                var carouselEditPresenter = {};
                carouselEditView.__proto__ = CarouselEditView.prototype;
                carouselEditPresenter.__proto__ = CarouselEditPresenter.prototype;
                CarouselEditView.call(carouselEditView, carouselEditPresenter);
                CarouselEditPresenter.call(carouselEditPresenter, carouselEditView);
                carouselEditPresenter.fnInitialization();
            }

            fnInitialization();
        });
    </script>
    <div id="content_header_div">
        <h2>輪播資料維護</h2>
        <ul>
            <li>
                <a href="Menu.aspx">首頁</a>
            </li>
            <li>
                <a href="CarouselSearchView.aspx?page=1">輪播資料維護</a>
            </li>
        </ul>
        <div class="content-header-right">
            <button type="button" class="btn-img-style1" id="btn_last" onclick="carouselEditView.fnLast();" title="上一筆">
                <img src="Image/last.png"></button>
            <button type="button" class="btn-img-style1" id="btn_next" onclick="carouselEditView.fnNext();" title="下一筆">
                <img src="Image/next.png"></button>
            <button type="button" class="btn-img-style1" id="btn_back" onclick="window.location='CarouselSearchView.aspx'" title="返回">
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
                        <img src="Image/paint.png" /><p>輪播資料編輯</p>
                    </h3>
                </div>

                <div class="frame-content-div">
                     <div id="tab" class="tab-style1">
                        <ul class="tab-items">
                            <li class='tab-item select' id="tab1" onclick="carouselEditView.fnTitleTabEvent(this);">資訊</li>
                            <li class='tab-item' id="tab2" onclick="carouselEditView.fnTitleTabEvent(this);">圖片</li>
                        </ul>
                        <form class='content-style1 tab-content' id="tab1_content" onsubmit="carouselEditView.fnUpdate(event);">
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*ID</label>
                                </div>
                                <div class="col-10-right">
                                    <label id="lab_carousel_id" />
                                </div>
                            </div>
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*名稱</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_name" list="category_list" maxlength="15" placeholder="名稱" required="required" class="input-data-required" />
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

                        <form class='tab-content content-style1 hide' id="tab2_content">
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
                                    <button id="btn_file" type="button" class="btn-style1" onclick="carouselEditView.fnFile();">選擇檔案</button>
                                    <input id="file" type="file" class="btn-img-style1" style="display: none" onchange="carouselEditView.fnFileChange(this);" multiple="multiple" />
                                </div>

                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
