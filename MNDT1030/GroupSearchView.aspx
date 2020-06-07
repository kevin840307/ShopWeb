<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="GroupSearchView.aspx.cs" Inherits="GroupSearchView" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="Css/content-header.css" rel="stylesheet" />
    <link href="Css/content-view.css" rel="stylesheet" />
    <link href="Css/frame-style1.css" rel="stylesheet" />
    <link href="Css/list-style1.css" rel="stylesheet" />
    <link href="Css/filter-style1.css" rel="stylesheet" />
    <script src="Scripts/Presenter/Admin/Group/group-search-presenter.js"></script>
    <script src="Scripts/View/Admin/Group/group-search-view.js"></script>
    <script type="text/javascript">

        var groupSearchView = {};
        var groupSearchPresenter = {};

        $(function () {
            function fnInitialization() {
                addScrollTopEvent(window, '#filter_div', '#list_div', 20);
                groupSearchView.__proto__ = GroupSearchView.prototype;
                groupSearchPresenter.__proto__ = GroupSearchPresenter.prototype;
                GroupSearchView.call(groupSearchView, groupSearchPresenter);
                GroupSearchPresenter.call(groupSearchPresenter, groupSearchView);
                groupSearchPresenter.fnInitialization();

                //var groupSearchPresenter2 = {};                                             //var groupSearchPresenter2 = new GroupSearchPresenter(groupSearchView);
                //groupSearchPresenter2.__proto__ = GroupSearchPresenter.prototype;           // Object.setPrototypeOf(groupSearchPresenter2, GroupSearchPresenter.prototype);
                //GroupSearchPresenter.call(groupSearchPresenter2, groupSearchView);
            }
            fnInitialization();
        });


    </script>
    <div id="content_header_div">
        <h2>群組資料維護</h2>
        <ul>
            <li>
                <a href="Menu.aspx">首頁</a>
            </li>
            <li>
                <a href="GroupSearchView.aspx?page=1">群組資料維護</a>
            </li>
        </ul>
        <div class="content-header-right">
            <button type="button" class="btn-img-style1" id="btn_insert_view" onclick="window.location='GroupInsertView.aspx'">
                <img src="Image/insert.png"></button>
            <%--            <button type="button" class="btn-img-style1" id="btn_export" onclick="accountSearchPresenter.fnExport()">
                <img src="Image/export.png"></button>
            <button type="button" class="btn-img-style1" id="btn_report" onclick="accountSearchPresenter.fnReport()">
                <img src="Image/report.png"></button>
            <button type="button" class="btn-img-style1" id="btn_print" onclick="accountSearchPresenter.fnPrint()">
                <img src="Image/print.png"></button>--%>
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
                            <img src="Image/person.png" /><p>群組資料維護清單</p>
                        </h3>
                    </div>
                    <div class="frame-content-div">
                        <div class="list-style1">
                            <div class="list-data-div">
                                <div>
                                    顯示筆數：
                                <select class="drop-style1" id="select_page_size" onchange="groupSearchView.fnMaxPageSizeChange(this);">
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
                                        <td class='general'><a onclick="groupSearchView.fnOrderChange('group_id')">ID</a></td>
                                        <td class='general'><a onclick="groupSearchView.fnOrderChange('name')">名稱</a></td>
                                        <td class='time'><a onclick="groupSearchView.fnOrderChange('create_datetime')">建立時間</a></td>
                                        <td class='time'><a onclick="groupSearchView.fnOrderChange('modify_datetime')">修改時間</a></td>
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
                        <div class="general">群組 ID</div>
                        <div class="general">
                            <input type="text" id="filter_group_id" class="input-data" placeholder="ID" maxlength="15" />
                        </div>
                        <div class="general">帳號 ID</div>
                        <div class="general">
                            <input type="text" id="filter_id" class="input-data" placeholder="ID" maxlength="3" />
                        </div>
                        <div class="general">帳號</div>
                        <div class="general">
                            <input type="text" id="filter_account" class="input-data" placeholder="帳號" maxlength="15" />
                        </div>
                        <div class="general">名稱</div>
                        <div class="general">
                            <input type="text" id="filter_name" class="input-data" placeholder="名稱" maxlength="10" />
                        </div>
                        <div class="general-center">
                            <input type="button" id="btn_search" class="btn-search" value="搜尋" onclick="groupSearchView.fnFilterChange();" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>


