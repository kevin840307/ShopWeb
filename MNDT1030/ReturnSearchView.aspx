﻿<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="ReturnSearchView.aspx.cs" Inherits="ReturnSearchView" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="Css/content-header.css" rel="stylesheet" />
    <link href="Css/content-view.css" rel="stylesheet" />
    <link href="Css/frame-style1.css" rel="stylesheet" />
    <link href="Css/list-style1.css" rel="stylesheet" />
    <link href="Css/filter-style1.css" rel="stylesheet" />
    <script src="Scripts/Presenter/Admin/Return/return-search-presenter.js"></script>
    <script src="Scripts/View/Admin/Return/return-search-view.js"></script>
    <script type="text/javascript">

        var returnSearchView = {};
        var returnSearchPresenter = {};

        $(function () {
            function fnInitialization() {
                addScrollTopEvent(window, '#filter_div', '#list_div', 20);
                returnSearchView.__proto__ = ReturnSearchView.prototype;
                returnSearchPresenter.__proto__ = ReturnSearchPresenter.prototype;
                ReturnSearchView.call(returnSearchView, returnSearchPresenter);
                ReturnSearchPresenter.call(returnSearchPresenter, returnSearchView);
                returnSearchPresenter.fnInitialization();

                //var groupSearchPresenter2 = {};                                             //var groupSearchPresenter2 = new GroupSearchPresenter(returnSearchView);
                //groupSearchPresenter2.__proto__ = GroupSearchPresenter.prototype;           // Object.setPrototypeOf(groupSearchPresenter2, GroupSearchPresenter.prototype);
                //GroupSearchPresenter.call(groupSearchPresenter2, returnSearchView);
            }
            fnInitialization();
        });


    </script>
    <div id="content_header_div">
        <h2>進退貨資料維護</h2>
        <ul>
            <li>
                <a href="Menu.aspx">首頁</a>
            </li>
            <li>
                <a href="ReturnSearchView.aspx?page=1">進退貨資料維護</a>
            </li>
        </ul>
        <div class="content-header-right">
            <button type="button" class="btn-img-style1" id="btn_insert_view" onclick="window.location='ReturnInsertView.aspx'">
                <img src="Image/insert.png"></button>
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
                            <img src="Image/person.png" /><p>進退貨資料維護清單</p>
                        </h3>
                    </div>
                    <div class="frame-content-div">
                        <div class="list-style1">
                            <div class="list-data-div">
                                <div>
                                    顯示筆數：
                                <select class="drop-style1" id="select_page_size" onchange="returnSearchView.fnMaxPageSizeChange(this);">
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
                                        <td class='general'><a onclick="returnSearchView.fnOrderChange('return_id')">退貨單號</a></td>
                                        <td class='general'><a onclick="returnSearchView.fnOrderChange('order_id')">進貨單號</a></td>
                                        <td class='general'><a onclick="returnSearchView.fnOrderChange('id')">退貨人 ID</a></td>
                                        <td class='time'><a onclick="returnSearchView.fnOrderChange('datetime')">退貨時間</a></td>
                                        <td class='general'>審核</td>
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
            <div class="frame-style1" id="filter_div">
                <div class="frame-title-div title-h3-style1">
                    <h3>
                        <img src="Image/search.png" /><p>搜尋</p>
                    </h3>
                </div>
                <div class="frame-content-div">
                    <div class="filter-style1">
                        <div class="general">進貨單號</div>
                        <div class="general">
                            <input type="text" id="filter_order_id" class="input-data" placeholder="進貨單號" maxlength="13" />
                        </div>
                        <div class="general">退貨單號</div>
                        <div class="general">
                            <input type="text" id="filter_return_id" class="input-data" placeholder="退貨單號" maxlength="13" />
                        </div>
                        <div class="general">退貨人 ID</div>
                        <div class="general">
                            <input type="text" id="filter_id" class="input-data" placeholder="退貨人 ID" maxlength="5" pattern="[0-9]" />
                        </div>
                         <div class="general">退貨日期</div>
                        <div class="general">
                            <input type="date" id="filter_datetime" class="input-data" />
                        </div>
                        <div class="general-center">
                            <input type="button" id="btn_search" class="btn-search" value="搜尋" onclick="returnSearchView.fnFilterChange();" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>


