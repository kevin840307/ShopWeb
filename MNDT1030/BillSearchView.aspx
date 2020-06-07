<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="BillSearchView.aspx.cs" Inherits="BillSearchView" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="Css/content-header.css" rel="stylesheet" />
    <link href="Css/content-view.css" rel="stylesheet" />
    <link href="Css/list-style1.css" rel="stylesheet" />
    <link href="Css/filter-style1.css" rel="stylesheet" />
    <link href="Css/frame-style1.css" rel="stylesheet" />
    <link href="Css/content-style1.css" rel="stylesheet" />
    <script src="Scripts/View/Admin/Bill/bill-search-view.js"></script>
    <script src="Scripts/Presenter/Admin/Bill/bill-search-presenter.js"></script>
    <script type="text/javascript">

        var billSearchView = {};
        var billSearchPresenter = {};

        $(function () {
            function fnInitialization() {
                addScrollTopEvent(window, '#filter_div', '#list_div', 20);
                billSearchView.__proto__ = BillSearchView.prototype;
                billSearchPresenter.__proto__ = BillSearchPresenter.prototype;
                BillSearchView.call(billSearchView, billSearchPresenter);
                BillSearchPresenter.call(billSearchPresenter, billSearchView);
                billSearchPresenter.fnInitialization();
            }

            fnInitialization();
        });

    </script>
    <div id="content_header_div">
        <div class="content-header-left">
            <h2>進貨未付款帳單資料</h2>
            <ul>
                <li>
                    <a href="Menu.aspx">首頁</a>
                </li>
                <li>
                    <a href="BillSearchView.aspx?page=1">進貨未付款帳單資料</a>
                </li>
            </ul>
        </div>
        <div class="content-header-right">
            <button type="button" class="btn-img-style1" id="btn_report" onclick="billSearchPresenter.fnReport()">
                <img src="Image/report.png"></button>
            <button type="button" class="btn-img-style1" id="btn_print" onclick="billSearchPresenter.fnPrint()">
                <img src="Image/print.png"></button>
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
                            <img src="Image/person.png" /><p>進貨未付款帳單資料清單</p>
                        </h3>
                    </div>
                    <div class="frame-content-div">
                        <div class="list-style1">
                            <div class="list-data-div">
                                <div>
                                    顯示筆數：
                                <select class="drop-style1" id="select_page_size" onchange="billSearchView.fnMaxPageSizeChange(this);">
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
                                        <td class='general'>公司 ID</td>
                                        <td class='general'>材料 ID</td>
                                        <td class='general'>數量</td>
                                        <td class='general'>價錢</td>
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
                            <div class="general">公司 ID</div>
                            <div class="general">
                                <input type="text" id="filter_company_id" class="input-data" placeholder="ID" maxlength="5" />
                            </div>
                            <div class="general">日期起</div>
                            <div class="general">
                                <input type="date" id="filter_date_S" class="input-data" />
                            </div>
                            <div class="general">日期迄</div>
                            <div class="general">
                                <input type="date" id="filter_date_E" class="input-data" />
                            </div>
                            
                            <div class="general-center">
                                <input type="button" id="btn_search" class="btn-search" value="搜尋" onclick="billSearchView.fnFilterChange();" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>


