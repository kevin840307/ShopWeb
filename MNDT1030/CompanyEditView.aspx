<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="CompanyEditView.aspx.cs" Inherits="CompanyEditView" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="Css/content-header.css" rel="stylesheet" />
    <link href="Css/content-view.css" rel="stylesheet" />
    <link href="Css/frame-style3.css" rel="stylesheet" />
    <link href="Css/frame-style1.css" rel="stylesheet" />
    <link href="Css/list-style1.css" rel="stylesheet" />
    <link href="Css/tab-style1.css" rel="stylesheet" />
    <link href="Css/content-style1.css" rel="stylesheet" />
    <script src="Scripts/Presenter/Admin/Company/company-edit-presenter.js"></script>
    <script src="Scripts/View/Admin/Company/company-edit-view.js"></script>
    <script type="text/javascript">

        var companyEditView = {};

        $(function () {

            function fnInitialization() {
                var companyEditPresenter = {};
                companyEditView.__proto__ = CompanyEditView.prototype;
                companyEditPresenter.__proto__ = CompanyEditPresenter.prototype;
                CompanyEditView.call(companyEditView, companyEditPresenter);
                CompanyEditPresenter.call(companyEditPresenter, companyEditView);
                companyEditPresenter.fnInitialization();
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
            <button type="button" class="btn-img-style1" id="btn_last" onclick="companyEditView.fnLast();" title="上一筆">
                <img src="Image/last.png"></button>
            <button type="button" class="btn-img-style1" id="btn_next" onclick="companyEditView.fnNext();" title="下一筆">
                <img src="Image/next.png"></button>
            <button type="button" class="btn-img-style1" id="btn_back" onclick="window.location='CompanySearchView.aspx'" title="返回">
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
                        <img src="Image/person.png" /><p>廠商資料編輯</p>
                    </h3>
                </div>

                <div class="frame-content-div">
                    <div id="tab" class="tab-style1">
                        <ul class="tab-items">
                            <li class='tab-item select' id="tab1" onclick="companyEditView.fnTitleTabEvent(this);" >廠商資訊</li>
                            <li class='tab-item' id="tab2" onclick="companyEditView.fnTitleTabEvent(this);" >歷史資訊</li>
                        </ul>
                        <form class='content-style1 tab-content' id="tab1_content" onsubmit="companyEditView.fnTab1Update(event);">
                            
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*廠商 ID</label>
                                </div>
                                <div class="col-10-right">
                                    <label id="lab_company_id"></label>
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
                                    <label >統編</label>
                                </div>
                                <div class="col-10-right">
                                    <input id="text_tax_id" maxlength="8" pattern="[0-9]{8}" placeholder="統編" class="input-data" />
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
                                    <input type="email" id="text_email" maxlength="30"  placeholder="信箱" required="required" class="input-data-required" />
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
                                    <input type="text" id="text_description" maxlength="50" placeholder="描述"class="input-data" />
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>狀態</label>
                                </div>
                                <div class="col-10-right">
                                    <select id="select_status" class="drop-style1">
                                        <option value="N">正常</option>
                                        <option value="D">作廢</option>
                                    </select>
                                </div>
                            </div>

                            <div class="general-right">
                                <input type="submit" class="col-2 button-style1" />
                            </div>
                        </form>

                        <div class='tab-content hide' id="tab2_content">
                            <div class="frame-style1">
                                <div class="frame-title-div">
                                    <div class="left-div">
                                        <h3 class="title-h3-style1" style="height: 25px;">
                                            <img src="Image/history.png" />歷史資料
                                        </h3>
                                    </div>
                                    <div class="right-div">
                                        <div class="action">
                                            <button type="button" class="btn-img-style1" onclick="companyEditView.fnTab2Refresh();">
                                                <img src="Image/refresh.png"></button>
                                        </div>
                                    </div>
                                </div>

                                <div class="frame-content-div">
                                    <div class="list-style1">
                                        <div class="list-data-div">
                                            <div>
                                                顯示筆數：
                                                <select class="drop-style1" id="select_page_size" onchange="companyEditView.fnMaxPageSizeChange(this);">
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
                                                    <td class='general'>建立ID</td>
                                                    <td class='general'>狀態</a></td>
                                                    <td class='general'>IP</td>
                                                    <td class='long-time'>建立時間</a></td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>
                                        <div class="list-page-div" id="list_page">
                                            <ul>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
