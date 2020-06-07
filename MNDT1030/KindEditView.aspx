<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="KindEditView.aspx.cs" Inherits="KindEditView" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="Css/content-header.css" rel="stylesheet" />
    <link href="Css/content-view.css" rel="stylesheet" />
    <link href="Css/list-style1.css" rel="stylesheet" />
    <link href="Css/frame-style3.css" rel="stylesheet" />
    <link href="Css/frame-style2.css" rel="stylesheet" />
    <link href="Css/tab-style1.css" rel="stylesheet" />
    <link href="Css/content-style1.css" rel="stylesheet" />
    <link href="Css/float-style1.css" rel="stylesheet" />
    <script src="Scripts/Presenter/Admin/Kind/kind-edit-presenter.js"></script>
    <script src="Scripts/View/Admin/Kind/kind-edit-view.js"></script>
    <script type="text/javascript">
        var kindEditView = {};
        var kindEditPresenter = {};
        $(function () {

            function fnInitialization() {
                kindEditView.__proto__ = KindEditView.prototype;
                kindEditPresenter.__proto__ = KindEditPresenter.prototype;
                KindEditView.call(kindEditView, kindEditPresenter);
                KindEditPresenter.call(kindEditPresenter, kindEditView);
                kindEditPresenter.fnInitialization();
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
            <button type="button" class="btn-img-style1" id="btn_last" onclick="kindEditView.fnLast();" title="上一筆">
                <img src="Image/last.png"></button>
            <button type="button" class="btn-img-style1" id="btn_next" onclick="kindEditView.fnNext();" title="下一筆">
                <img src="Image/next.png"></button>
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
                        <img src="Image/person.png" /><p>代碼資料編輯</p>
                    </h3>
                </div>

                <div class="frame-content-div">
                    <div id="tab" class="tab-style1">
                        <ul class="tab-items">
                            <li class='tab-item select' id="tab1" onclick="kindEditView.fnTitleTabEvent(this);" >類別資訊</li>
                            <li class='tab-item' id="tab2" onclick="kindEditView.fnTitleTabEvent(this);" >代碼資訊</li>
                        </ul>

                        <form class='content-style1 tab-content' id="tab1_content" onsubmit="kindEditView.fnTab1Update(event);">
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*ID</label>
                                </div>
                                <div class="col-10-right">
                                    <label id="lab_kind_id">ID</label>
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

                        <form class='tab-content hide' id="tab2_content">
                            <div class="frame-style2">
                                <div class="frame-title-div">
                                    <div class="left-div">
                                        <h3 class="title-h3-style1">
                                            <img src="Image/person.png" />代碼資訊
                                        </h3>
                                    </div>
                                    <div class="right-div">
                                        <div class="action">
                                            <button type="button" class="btn-img-style1" id="details_refresh" onclick="kindEditPresenter.fnInitializationTab2()">
                                                <img src="Image/refresh.png"></button>

                                            <button type='button' class='btn-img-style1' onclick='kindEditView.fnTab2AppendInsert();'>
                                                <img src='Image/insert.png' /></button>

                                            <button type='button' class='btn-img-style3' onclick='kindEditView.fnTab2Inserts();'>
                                                <img src='Image/tick.png' /></button>

                                            <button type='button' class='btn-img-style4' onclick='kindEditView.fnTab2Updates();'>
                                                <img src='Image/save.png' /></button>
                                        </div>
                                    </div>
                                </div>

                                <div class="frame-content-div">
                                    <div class="list-style1">
                                        <div class="list-data-div">
                                            <div>
                                                顯示筆數：
                                                <select class="drop-style1" id="select_page_size" onchange="kindEditView.fnMaxPageSizeChange(this);">
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
                                                    <td class='general'>參數</td>
                                                    <td>動作</td>
                                                    <td class='general'>狀態</td>
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
                        </form>

                        <div id="float_window" class="float-style1">
                            <div class="float-frame">
                                <div class="float-title">
                                    <div class="left-div">
                                        <h3 class="title-h3-style1">
                                            <img src="Image/person.png" />歷史資訊
                                        </h3>
                                    </div>
                                    <div class="right-div">
                                        <img src="Image/close-out.png" onmouseout="this.src='Image/close-out.png'" onmouseover="this.src='Image/close-in.png'" class="img-style" onclick="fnCloseView('#float_window');" />
                                    </div>
                                </div>
                                <div class="float-content">
                                    <div class="frame-style2">
                                        <div class="frame-content-div">
                                            <div class="list-style1">
                                                <div class="list-data-div">
                                                    <p id="tran_message"></p>
                                                </div>
                                                <table id="list_tran" class="list-table">
                                                    <thead>
                                                        <tr>
                                                            <td class='general'>IP</td>
                                                            <td class='general'>狀態</td>
                                                            <td class='general'>建立ID</td>
                                                            <td class='general'>建立時間</td>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                    </tbody>
                                                </table>

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
    </div>
</asp:Content>
