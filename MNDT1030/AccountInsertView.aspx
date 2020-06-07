<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="AccountInsertView.aspx.cs" Inherits="AccountInsertView" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="Css/content-header.css" rel="stylesheet" />
    <link href="Css/content-view.css" rel="stylesheet" />
    <link href="Css/tab-style1.css" rel="stylesheet" />
    <link href="Css/content-style1.css" rel="stylesheet" />
    <link href="Css/frame-style3.css" rel="stylesheet" />
    <script src="Scripts/View/Admin/Account/account-insert-view.js"></script>
    <script src="Scripts/Presenter/Admin/Account/account-insert-presenter.js"></script>
    <script type="text/javascript">
        var accountInsertView = {};
        $(function () {

            function fnInitialization() {
                var accountInsertPresenter = {};
                accountInsertView.__proto__ = AccountInsertView.prototype;
                accountInsertPresenter.__proto__ = AccountInsertPresenter.prototype;
                AccountInsertView.call(accountInsertView, accountInsertPresenter);
                AccountInsertPresenter.call(accountInsertPresenter, accountInsertView);
                accountInsertPresenter.fnInitialization();
            }

            fnInitialization();
        });
    </script>
    <div id="content_header_div">
        <h2>會員資料維護</h2>
        <ul>
            <li>
                <a href="Menu.aspx">首頁</a>
            </li>
            <li>
                <a href="AccountSearchView.aspx?page=1">會員資料維護</a>
            </li>
        </ul>
        <div class="content-header-right">
            <button type="button" class="btn-img-style1" id="btn_back" onclick="window.location='AccountSearchView.aspx'" >
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
                        <img src="Image/person.png" /><p>會員資料新增</p>
                    </h3>
                </div>

                <div class="frame-content-div" onsubmit="accountInsertView.fnInsert(event);" >
                    <div id="tab" class="tab-style1">
                        <ul class="tab-items">
                            <li class='tab-item select' id="tab1" onclick="accountInsertView.fnTitleTabEvent(this);" >帳號資訊</li>
                        </ul>
                        <form class='content-style1 tab-content' id="tab1_content">
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*帳號</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_account" maxlength="15" pattern="[a-zA-Z0-9]{1,15}" placeholder="帳號" required="required" class="input-data-required" />
                                </div>
                            </div>
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*名稱</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_name" maxlength="10" placeholder="名稱" required="required" class="input-data-required" />
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*密碼</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="password" id="text_password" maxlength="15" pattern="[a-zA-Z0-9]{1,15}" placeholder="密碼" required="required" class="input-data-required" />
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*確認</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="password" id="text_check_password" maxlength="15" pattern="[a-zA-Z0-9]{1,15}" placeholder="確認密碼" required="required" class="input-data-required" />
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>手機</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_phone" pattern="[0-9]{10}" maxlength="10" placeholder="手機" class="input-data" />
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>地址</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_address" placeholder="地址" class="input-data" />
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
