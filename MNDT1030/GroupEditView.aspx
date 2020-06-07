<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="GroupEditView.aspx.cs" Inherits="GroupEditView" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="Css/content-header.css" rel="stylesheet" />
    <link href="Css/content-view.css" rel="stylesheet" />
    <link href="Css/list-style1.css" rel="stylesheet" />
    <link href="Css/frame-style3.css" rel="stylesheet" />
    <link href="Css/frame-style2.css" rel="stylesheet" />
    <link href="Css/tab-style1.css" rel="stylesheet" />
    <link href="Css/tab-style2.css" rel="stylesheet" />
    <link href="Css/content-style1.css" rel="stylesheet" />
    <script src="Scripts/Presenter/Admin/Group/group-edit-presenter.js"></script>
    <script src="Scripts/View/Admin/Group/group-edit-view.js"></script>
    <script type="text/javascript">
        var groupEditView = {};
        var groupEditPresenter = {};
        $(function () {

            function fnInitialization() {
                groupEditView.__proto__ = GroupEditView.prototype;
                groupEditPresenter.__proto__ = GroupEditPresenter.prototype;
                GroupEditView.call(groupEditView, groupEditPresenter);
                GroupEditPresenter.call(groupEditPresenter, groupEditView);
                groupEditPresenter.fnInitialization();
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
            <button type="button" class="btn-img-style1" id="btn_last" onclick="groupEditView.fnLast();" title="上一筆">
                <img src="Image/last.png"></button>
            <button type="button" class="btn-img-style1" id="btn_next" onclick="groupEditView.fnNext();" title="下一筆">
                <img src="Image/next.png"></button>
            <button type="button" class="btn-img-style1" id="btn_back" onclick="window.location='GroupSearchView.aspx'">
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
                        <img src="Image/person.png" /><p>群組資料編輯</p>
                    </h3>
                </div>

                <div class="frame-content-div">
                    <div id="tab" class="tab-style1">
                        <ul class="tab-items">
                            <li class='tab-item select' id="tab1" onclick="groupEditView.fnTitleTabEvent(this);" >群組資訊</li>
                            <li class='tab-item' id="tab2" onclick="groupEditView.fnTitleTabEvent(this);" >組員資訊</li>
                            <li class='tab-item' id="tab3" onclick="groupEditView.fnTitleTabEvent(this);" >作業資訊</li>
                        </ul>

                        <form class='content-style1 tab-content' id="tab1_content" onsubmit="groupEditView.fnTab1Update(event);">
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*ID</label>
                                </div>
                                <div class="col-10-right">
                                    <label id="lab_group_id">ID</label>
                                </div>
                            </div>
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>名稱</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_name" maxlength="15" placeholder="名稱" class="input-data" />
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

                        <form class='content-style1 tab-content hide' id="tab2_content" onsubmit="groupEditView.fnTab2Insert(this, event);">
                            <div class="frame-style2">
                                <div class="frame-title-div">
                                    <div class="left-div">
                                        <h3 class="title-h3-style1">
                                            <img src="Image/person.png" />組員資訊
                                        </h3>
                                    </div>
                                    <div class="right-div">
                                        <div class="action">
                                            <button type="button" class="btn-img-style1" id="details_refresh" onclick="groupEditPresenter.fnInitializationTab2()">
                                                <img src="Image/refresh.png"></button>
                                        </div>
                                    </div>
                                </div>
                                <div class="frame-content-div">
                                    <div class="list-style1">
                                        <div class="list-data-div">
                                            <div>
                                                顯示筆數：
                                                <select class="drop-style1" id="select_page_size" onchange="groupEditView.fnMaxPageSizeChange(this);">
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
                                                    <td class='general'>ID</td>
                                                    <td class='general'>名稱</td>
                                                    <td class='general'>建立ID</td>
                                                    <td class='time'><a>建立時間</a></td>
                                                    <td class='general'>修改ID</td>
                                                    <td class='time'><a>修改時間</a></td>
                                                    <td class='time'>動作</td>
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
                            <div class="title">
                                組員資訊新增
                            </div>
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*ID</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" list="account_list" maxlength="5" required="required" class="input-data-required" id="tab2_id" />
                                    <datalist id="account_list">
                                    </datalist>
                                </div>
                            </div>
                            <div class="general-right">
                                <input type="submit" class="col-2 button-style1" />
                            </div>
                        </form>

                        <div class='content-style1 tab-content hide' id="tab3_content">
                            <div class="tab-style2">
                                <div class="col-2-left">
                                    <div>
                                        <ul class="tab-items" id="program_menu">
                                        </ul>
                                    </div>
                                </div>
                                <div class="col-10-right content-style1" id="program_content">
                                </div>
                            </div>
                            <datalist id="program_list">
                            </datalist>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
