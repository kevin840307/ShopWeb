<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="KindInsertView.aspx.cs" Inherits="KindInsertView" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="Css/content-header.css" rel="stylesheet" />
    <link href="Css/content-view.css" rel="stylesheet" />
    <link href="Css/tab-style1.css" rel="stylesheet" />
    <link href="Css/frame-style3.css" rel="stylesheet" />
    <link href="Css/content-style1.css" rel="stylesheet" />
    <script src="Scripts/View/Admin/Kind/kind-insert-view.js"></script>
    <script src="Scripts/Presenter/Admin/Kind/kind-insert-presenter.js"></script>
    <script type="text/javascript">
        var kindInsertView = {};
        $(function () {

            function fnInitialization() {
                var kindInsertPresenter = {};
                kindInsertView.__proto__ = KindInsertView.prototype;
                kindInsertPresenter.__proto__ = KindInsertPresenter.prototype;
                KindInsertView.call(kindInsertView, kindInsertPresenter);
                KindInsertPresenter.call(kindInsertPresenter, kindInsertView);
                kindInsertPresenter.fnInitialization();
            }

            fnInitialization();
        });
    </script>
    <div id="content_header_div">
        <h2>代碼資料維護</h2>
        <ul>
            <li>
                <a href="Menu.aspx">首頁</a>
            </li>
            <li>
                <a href="AccountSearchView.aspx?page=1">代碼資料維護</a>
            </li>
        </ul>
        <div class="content-header-right">
            <button type="button" class="btn-img-style1" id="btn_back" onclick="window.location='KindSearchView.aspx'">
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
                        <img src="Image/person.png" /><p>代碼資料新增</p>
                    </h3>
                </div>

                <div class="frame-content-div">
                    <div id="tab" class="tab-style1">
                        <ul class="tab-items">
                            <li class='tab-item select' id="tab1" onclick="kindInsertView.fnTitleTabEvent(this);">代碼資訊</li>
                        </ul>
                        <form class='tab-content content-style1' id="tab1_content" onsubmit="kindInsertView.fnInsert(event);">
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*ID</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_kind_id" maxlength="5" placeholder="ID" required="required" class="input-data-required" />
                                </div>
                            </div>
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>名稱</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_name" maxlength="15" placeholder="名稱"  class="input-data" />
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
                                <input type="submit" class="col-2 button-style1" />
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
