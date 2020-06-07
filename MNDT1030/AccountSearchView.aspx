<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="AccountSearchView.aspx.cs" Inherits="AccountSearchView" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="Css/content-header.css" rel="stylesheet" />
    <link href="Css/content-view.css" rel="stylesheet" />
    <link href="Css/list-style1.css" rel="stylesheet" />
    <link href="Css/filter-style1.css" rel="stylesheet" />
    <link href="Css/frame-style1.css" rel="stylesheet" />
    <link href="Css/content-style1.css" rel="stylesheet" />
    <script src="Scripts/View/Admin/Account/account-search-view.js"></script>
    <script src="Scripts/Presenter/Admin/Account/account-search-presenter.js"></script>
    <script type="text/javascript">

        var accountSearchView = {};
        var accountSearchPresenter = {};

        $(function () {
            function fnInitialization() {
                addScrollTopEvent(window, '#filter_div', '#list_div', 20);
                accountSearchView.__proto__ = AccountSearchView.prototype;
                accountSearchPresenter.__proto__ = AccountSearchPresenter.prototype;
                AccountSearchView.call(accountSearchView, accountSearchPresenter);
                AccountSearchPresenter.call(accountSearchPresenter, accountSearchView);
                accountSearchPresenter.fnInitialization();
            }

            fnInitialization();
        });

    </script>
    <div id="content_header_div">
        <div class="content-header-left">
            <h2>會員資料維護</h2>
            <ul>
                <li>
                    <a href="Menu.aspx">首頁</a>
                </li>
                <li>
                    <a href="AccountSearchView.aspx?page=1">會員資料維護</a>
                </li>
            </ul>
        </div>
        <div class="content-header-right">
            <button type="button" class="btn-img-style1" id="btn_insert_view" onclick="window.location='AccountInsertView.aspx'">
                <img src="Image/insert.png"></button>
            <button type="button" class="btn-img-style2" id="btn_delete_view" onclick="accountSearchView.fnDeteles()">
                <img src="Image/delete.png"></button>
            <button type="button" class="btn-img-style1" id="btn_export" onclick="accountSearchPresenter.fnExport()">
                <img src="Image/export.png"></button>
            <button type="button" class="btn-img-style1" id="btn_report" onclick="accountSearchPresenter.fnReport()">
                <img src="Image/report.png"></button>
            <button type="button" class="btn-img-style1" id="btn_print" onclick="accountSearchPresenter.fnPrint()">
                <img src="Image/print.png"></button>
            <div>
                <button id="btn_file" type="button" class="btn-style1" onclick="accountSearchView.fnFile();">選擇檔案</button>
                <button id="btn_upload" type="button" class="btn-style1" onclick="accountSearchView.fnImport();">匯入</button>
                <input id="file" type="file" class="btn-img-style1" style="display: none" onchange="accountSearchView.fnFileChange(this);" />
            </div>
        </div>
    </div>
    <div class="line-style1"></div>
    <div id="content-view">
        <div id="content-message-div" class="general msg-div">
            <img src="Image/close-out.png" onmouseout="this.src='Image/close-out.png'" onmouseover="this.src='Image/close-in.png'" class="close" />
            <p>警告訊息：無。</p>
        </div>
        <div class="col-9-left">
            <div class="spacing-right">
                <div class="frame-style1" id="list_div">
                    <div class="frame-title-div title-h3-style1">
                        <h3>
                            <img src="Image/person.png" /><p>會員資料維護清單</p>
                        </h3>
                    </div>
                    <div class="frame-content-div">
                        <div class="list-style1">
                            <div class="list-data-div">
                                <div>
                                    顯示筆數：
                                <select class="drop-style1" id="select_page_size" onchange="accountSearchView.fnMaxPageSizeChange(this);">
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
                                        <td class='checkboxs'></td>
                                        <td class='general'><a onclick="accountSearchView.fnOrderChange('id');">ID</a></td>
                                        <td class='general'><a onclick="accountSearchView.fnOrderChange('account');">帳號</a></td>
                                        <td class='general'><a onclick="accountSearchView.fnOrderChange('name');">名稱</a></td>
                                        <td class='general'>電話</td>
                                        <td class='time'><a onclick="accountSearchView.fnOrderChange('create_datetime');">建立時間</a></td>
                                        <td>操作</td>
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
        <div class="col-3-right">
            <div>
                <div class="frame-style1" id="filter_div">
                    <div class="frame-title-div title-h3-style1">
                        <h3>
                            <img src="Image/search.png" /><p>搜尋</p>
                        </h3>
                    </div>
                    <div class="frame-content-div">
                        <div class="filter-style1">
                            <div class="general">ID</div>
                            <div class="general">
                                <input type="text" id="filter_id" class="input-data" placeholder="ID" maxlength="5" />
                            </div>
                            <div class="general">帳號</div>
                            <div class="general">
                                <input type="text" id="filter_account" class="input-data" placeholder="帳號" maxlength="15" />
                            </div>
                            <div class="general">名稱</div>
                            <div class="general">
                                <input type="text" id="filter_name" class="input-data" placeholder="名稱" maxlength="10" />
                            </div>
                            <div class="general">狀態</div>
                            <div class="general">
                                <select class="drop-style1" id="filter_status">
                                    <option value="">無</option>
                                    <option value="N">正常</option>
                                    <option value="D">刪除</option>
                                </select>
                            </div>
                            <div class="general-center">
                                <input type="button" id="btn_search" class="btn-search" value="搜尋" onclick="accountSearchView.fnFilterChange();" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>


