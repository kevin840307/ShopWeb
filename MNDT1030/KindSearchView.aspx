<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="KindSearchView.aspx.cs" Inherits="KindSearchView" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="Css/content-header.css" rel="stylesheet" />
    <link href="Css/content-view.css" rel="stylesheet" />
    <link href="Css/frame-style1.css" rel="stylesheet" />
    <link href="Css/list-style1.css" rel="stylesheet" />
    <link href="Css/filter-style1.css" rel="stylesheet" />
    <script src="Scripts/Presenter/Admin/Kind/kind-search-presenter.js"></script>
    <script src="Scripts/View/Admin/Kind/kind-search-view.js"></script>
    <script type="text/javascript">

        var kindSearchView = {};
        var kindSearchPresenter = {};

        $(function () {
            function fnInitialization() {
                addScrollTopEvent(window, '#filter_div', '#list_div', 20);
                kindSearchView.__proto__ = KindSearchView.prototype;
                kindSearchPresenter.__proto__ = KindSearchPresenter.prototype;
                KindSearchView.call(kindSearchView, kindSearchPresenter);
                KindSearchPresenter.call(kindSearchPresenter, kindSearchView);
                kindSearchPresenter.fnInitialization();

                //var groupSearchPresenter2 = {};                                             //var groupSearchPresenter2 = new GroupSearchPresenter(kindSearchView);
                //groupSearchPresenter2.__proto__ = GroupSearchPresenter.prototype;           // Object.setPrototypeOf(groupSearchPresenter2, GroupSearchPresenter.prototype);
                //GroupSearchPresenter.call(groupSearchPresenter2, kindSearchView);
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
                <a href="KindSearchView.aspx?page=1">代碼資料維護</a>
            </li>
        </ul>
        <div class="content-header-right">
            <button type="button" class="btn-img-style1" id="btn_insert_view" onclick="window.location='KindInsertView.aspx'">
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
                            <img src="Image/person.png" /><p>代碼資料維護清單</p>
                        </h3>
                    </div>
                    <div class="frame-content-div" >
                        <div class="list-style1">
                            <div class="list-data-div">
                                <div>
                                    顯示筆數：
                                <select class="drop-style1" id="select_page_size" onchange="kindSearchView.fnMaxPageSizeChange(this);">
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
                                        <td class='general'><a onclick="kindSearchView.fnOrderChange('kind_id')">ID</a></td>
                                        <td class='general'><a onclick="kindSearchView.fnOrderChange('name')">名稱</a></td>
                                        <td class='time'><a onclick="kindSearchView.fnOrderChange('create_datetime')">建立時間</a></td>
                                        <td class='time'><a onclick="kindSearchView.fnOrderChange('modify_datetime')">修改時間</a></td>
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
                        <div class="general">類別 ID</div>
                        <div class="general">
                            <input type="text" id="filter_kind_id" class="input-data" placeholder="ID" maxlength="15" />
                        </div>
                        <div class="general">名稱</div>
                        <div class="general">
                            <input type="text" id="filter_name" class="input-data" placeholder="名稱" maxlength="10" />
                        </div>
                        <div class="general-center">
                            <input type="button" id="btn_search" class="btn-search" value="搜尋" onclick="kindSearchView.fnFilterChange();" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>


