<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="CompanyInsertView.aspx.cs" Inherits="CompanyInsertView" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="Css/content-header.css" rel="stylesheet" />
    <link href="Css/content-view.css" rel="stylesheet" />
    <link href="Css/tab-style1.css" rel="stylesheet" />
    <link href="Css/content-style1.css" rel="stylesheet" />
    <link href="Css/frame-style3.css" rel="stylesheet" />
    <script src="Scripts/View/Admin/Company/company-insert-view.js"></script>
    <script src="Scripts/Presenter/Admin/Company/company-insert-presenter.js"></script>
    <script type="text/javascript">
        var companyInsertView = {};
        $(function () {

            function fnInitialization() {
                var companyInsertPresenter = {};
                companyInsertView.__proto__ = CompanyInsertView.prototype;
                companyInsertPresenter.__proto__ = CompanyInsertPresenter.prototype;
                CompanyInsertView.call(companyInsertView, companyInsertPresenter);
                CompanyInsertPresenter.call(companyInsertPresenter, companyInsertView);
                companyInsertPresenter.fnInitialization();
            }

            fnInitialization();
        });
    </script>
    <div id="content_header_div">
        <h2>廠商資料維護</h2>
        <ul>
            <li>
                <a href="Menu.aspx">首頁</a>
            </li>
            <li>
                <a href="CompanySearchView.aspx?page=1">廠商資料維護</a>
            </li>
        </ul>
        <div class="content-header-right">
            <button type="button" class="btn-img-style1" id="btn_back" onclick="window.location='CompanySearchView.aspx'">
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
                        <img src="Image/person.png" /><p>廠商資料新增</p>
                    </h3>
                </div>

                <div class="frame-content-div" onsubmit="companyInsertView.fnInsert(event);">
                    <div id="tab" class="tab-style1">
                        <ul class="tab-items">
                            <li class='tab-item select' id="tab1" onclick="companyInsertView.fnTitleTabEvent(this);">廠商資訊</li>
                        </ul>
                        <form class='content-style1 tab-content' id="tab1_content">
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*廠商 ID</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_company_id" maxlength="15" pattern="[a-zA-Z0-9]{1,15}" placeholder="ID" required="required" class="input-data-required" />
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
                                    <label>統編</label>
                                </div>
                                <div class="col-10-right">
                                    <input id="text_tax_id" maxlength="8" pattern="[0-9]{1,8}" placeholder="統編" class="input-data" />
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>付款方式</label>
                                </div>
                                <div class="col-10-right">
                                    <input id="text_pay" maxlength="5" list="pay_list" placeholder="付款方式" class="input-data" />
                                </div>
                                <datalist id="pay_list">
                                </datalist>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*信箱</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="email" id="text_email" maxlength="30" placeholder="信箱" required="required" class="input-data-required" />
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>電話</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_tel" pattern="[0-9]{9}" maxlength="9" placeholder="電話" class="input-data" />
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*手機</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_phone" pattern="[0-9]{10}" maxlength="10" placeholder="手機" required="required" class="input-data-required" />
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*地址</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_address" maxlength="50" placeholder="地址" required="required" class="input-data-required" />
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
