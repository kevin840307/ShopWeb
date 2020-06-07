<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="SalesEditView.aspx.cs" Inherits="SalesEditView" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="Css/content-header.css" rel="stylesheet" />
    <link href="Css/content-view.css" rel="stylesheet" />
    <link href="Css/list-style1.css" rel="stylesheet" />
    <link href="Css/frame-style1.css" rel="stylesheet" />
    <link href="Css/frame-style3.css" rel="stylesheet" />
    <link href="Css/frame-style2.css" rel="stylesheet" />
    <link href="Css/tab-style1.css" rel="stylesheet" />
    <link href="Css/content-style1.css" rel="stylesheet" />
    <link href="Css/float-style1.css" rel="stylesheet" />
    <script src="Scripts/Presenter/Admin/Sales/sales-edit-presenter.js"></script>
    <script src="Scripts/View/Admin/Sales/sales-edit-view.js"></script>
    <script type="text/javascript">
        var salesEditView = {};
        var salesEditPresenter = {};
        $(function () {

            function fnInitialization() {
                salesEditView.__proto__ = SalesEditView.prototype;
                salesEditPresenter.__proto__ = SalesEditPresenter.prototype;
                SalesEditView.call(salesEditView, salesEditPresenter);
                SalesEditPresenter.call(salesEditPresenter, salesEditView);
                salesEditPresenter.fnInitialization();
            }

            fnInitialization();
        });

    </script>
    <div id="content_header_div">
        <h2>銷貨資料維護</h2>
        <ul>
            <li>
                <a href="Menu.aspx">首頁</a>
            </li>
            <li>
                <a href="SalesSearchView.aspx?page=1">銷貨資料維護</a>
            </li>
        </ul>
        <div class="content-header-right">
            <button type="button" class="btn-img-style1" id="btn_last" onclick="salesEditView.fnLast();" title="上一筆">
                <img src="Image/last.png"></button>
            <button type="button" class="btn-img-style1" id="btn_next" onclick="salesEditView.fnNext();" title="下一筆">
                <img src="Image/next.png"></button>
            <button type="button" class="btn-img-style1" id="btn_back" onclick="window.location='SalesSearchView.aspx'">
                <img src="Image/back.png"></button>
            <button type="button" class="btn-img-style3" onclick="salesEditView.fnJumpReturn();">
                <img src="Image/change.png"></button>
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
                        <img src="Image/person.png" /><p>銷貨資料編輯</p>
                    </h3>
                </div>

                <div class="frame-content-div">
                    <div id="tab" class="tab-style1">
                        <ul class="tab-items">
                            <li class='tab-item select' id="tab1" onclick="salesEditView.fnTitleTabEvent(this);">銷貨資訊</li>
                            <li class='tab-item' id="tab2" onclick="salesEditView.fnTitleTabEvent(this);">產品資訊</li>
                            <li class='tab-item' id="tab3" onclick="salesEditView.fnTitleTabEvent(this);">歷史資訊</li>
                        </ul>

                        <form class='content-style1 tab-content' id="tab1_content" onsubmit="salesEditView.fnTab1Update(event);">
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*ID</label>
                                </div>
                                <div class="col-10-right">
                                    <label id="lab_order_id">ID</label>
                                </div>
                            </div>
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*ID</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_id" list="id_list" maxlength="9" title="ID" pattern="[0-9]" required="required" placeholder="ID" class="input-data-required" />
                                </div>
                                <datalist id="id_list"></datalist>
                            </div>
                            
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>付款方式</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_pay" list="pay_list" maxlength="5" placeholder="付款方式" class="input-data" />
                                </div>
                                <datalist id="pay_list"></datalist>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>訂單狀態</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_order_status" list="order_status_list" maxlength="5" placeholder="訂單狀態" class="input-data" />
                                </div>
                                <datalist id="order_status_list"></datalist>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*銷貨日期</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="date" id="text_datetime" required="required" class="input-data-required" />
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
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>審核</label>
                                </div>
                                <div class="col-10-right">
                                    <select id="select_complete" class="drop-style1">
                                        <option value="N">未審核</option>
                                        <option value="Y">已審核</option>
                                    </select>
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

                        <form class='tab-content hide' id="tab2_content">
                            <div class="frame-style2">
                                <div class="frame-title-div">
                                    <div class="left-div">
                                        <h3 class="title-h3-style1">
                                            <img src="Image/person.png" />產品資訊
                                        </h3>
                                    </div>
                                    <div class="right-div">
                                        <div class="action">
                                            <button type="button" class="btn-img-style1" id="details_refresh" onclick="salesEditPresenter.fnInitializationTab2()">
                                                <img src="Image/refresh.png"></button>

                                            <button type='button' class='btn-img-style1' onclick='salesEditView.fnTab2AppendInsert();'>
                                                <img src='Image/insert.png' /></button>

                                            <button type='button' class='btn-img-style3' onclick='salesEditView.fnTab2Inserts();'>
                                                <img src='Image/tick.png' /></button>

                                            <button type='button' class='btn-img-style4' onclick='salesEditView.fnTab2Updates();'>
                                                <img src='Image/save.png' /></button>

                                        </div>
                                    </div>
                                </div>

                                <div class="frame-content-div">
                                    <div class="list-style1">
                                        <div class="list-data-div">
                                            <div>
                                                顯示筆數：
                                                <select class="drop-style1" onchange="salesEditView.fnTab2MaxPageSizeChange(this);">
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
                                                    <td class='general'>次序</td>
                                                    <td class='general'>產品 ID</td>
                                                    <td class='general'>倉庫 ID</td>
                                                    <td class='general'>數量</td>
                                                    <td class='general'>價錢</td>
                                                    <td class='general'>備註</td>
                                                    <td>動作</td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>
                                        <div class="list-page-div" id="list_page">
                                            <ul>
                                            </ul>
                                        </div>
                                        <datalist id="product_list"></datalist>
                                        <datalist id="warehouse_list"></datalist>
                                    </div>
                                </div>
                            </div>
                        </form>

                        <div class='tab-content hide' id="tab3_content">
                            <div class="frame-style1">
                                <div class="frame-title-div">
                                    <div class="left-div">
                                        <h3 class="title-h3-style1" style="height: 25px;">
                                            <img src="Image/history.png" />歷史資料
                                        </h3>
                                    </div>
                                </div>

                                <div class="frame-content-div">
                                    <div class="list-style1">
                                        <div class="list-data-div">
                                            <div>
                                                顯示筆數：
                                                <select class="drop-style1" onchange="salesEditView.fnTab3MaxPageSizeChange(this);">
                                                    <option value="8">8</option>
                                                    <option value="10">10</option>
                                                    <option value="20">20</option>
                                                    <option value="50">50</option>
                                                    <option value="100">100</option>
                                                </select>
                                            </div>
                                        </div>
                                        <table id="list_tran" class="list-table">
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
                                        <div class="list-page-div" id="list_tran_page">
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
