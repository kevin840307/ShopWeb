<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="MaterialEditView.aspx.cs" Inherits="MaterialEditView" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="Css/content-header.css" rel="stylesheet" />
    <link href="Css/content-view.css" rel="stylesheet" />
    <link href="Css/frame-style3.css" rel="stylesheet" />
    <link href="Css/frame-style1.css" rel="stylesheet" />
    <link href="Css/list-style1.css" rel="stylesheet" />
    <link href="Css/tab-style1.css" rel="stylesheet" />
    <link href="Css/content-style1.css" rel="stylesheet" />
    <script src="Scripts/Presenter/Admin/Material/material-edit-presenter.js"></script>
    <script src="Scripts/View/Admin/Material/material-edit-view.js"></script>
    <script type="text/javascript">

        var materialEditView = {};

        $(function () {

            function fnInitialization() {
                var materialEditPresenter = {};
                materialEditView.__proto__ = MaterialEditView.prototype;
                materialEditPresenter.__proto__ = MaterialEditPresenter.prototype;
                MaterialEditView.call(materialEditView, materialEditPresenter);
                MaterialEditPresenter.call(materialEditPresenter, materialEditView);
                materialEditPresenter.fnInitialization();
            }

            fnInitialization();
        });
    </script>
    <div id="content_header_div">
        <h2>材料資料維護</h2>
        <ul>
            <li>
                <a href="Menu.aspx">首頁</a>
            </li>
            <li>
                <a href="MaterialSearchView.aspx?page=1">材料資料維護</a>
            </li>
        </ul>
        <div class="content-header-right">
            <button type="button" class="btn-img-style1" id="btn_last" onclick="materialEditView.fnLast();" title="上一筆">
                <img src="Image/last.png"></button>
            <button type="button" class="btn-img-style1" id="btn_next" onclick="materialEditView.fnNext();" title="下一筆">
                <img src="Image/next.png"></button>
            <button type="button" class="btn-img-style1" id="btn_back" onclick="window.location='MaterialSearchView.aspx'" title="返回">
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
                        <img src="Image/person.png" /><p>材料資料編輯</p>
                    </h3>
                </div>

                <div class="frame-content-div">
                    <div id="tab" class="tab-style1">
                        <ul class="tab-items">
                            <li class='tab-item select' id="tab1" onclick="materialEditView.fnTitleTabEvent(this);">材料資訊</li>
                            <li class='tab-item' id="tab2" onclick="materialEditView.fnTitleTabEvent(this);">歷史資訊</li>
                        </ul>
                        <form class='content-style1 tab-content' id="tab1_content" onsubmit="materialEditView.fnTab1Update(event);">
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*ID</label>
                                </div>
                                <div class="col-10-right">
                                    <label id="lab_material_id"></label>
                                </div>
                            </div>
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*名稱</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_name" maxlength="15" placeholder="名稱" required="required" class="input-data-required" />
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>公司</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_company_id" placeholder="公司" list="company_list" maxlength="5" class="input-data" />
                                    <datalist id="company_list">
                                    </datalist>
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>單位</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_unit" placeholder="單位" list="unit_list" maxlength="5" class="input-data" />
                                    <datalist id="unit_list">
                                    </datalist>
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>價格</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_price" placeholder="價格" pattern="[0-9]{1,7}[.]{0,1}[0-9]{0,3}" maxlength="10" class="input-data" />
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>貨幣</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_currency" placeholder="貨幣" list="currency_list" maxlength="5" class="input-data" />
                                    <datalist id="currency_list">
                                    </datalist>
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>保存期限(天)</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_shelf_life" placeholder="保存期限(天)" pattern="[0-9]{1,3}" maxlength="3" class="input-data" />
                                </div>
                            </div>

                            <div class="general">
                                <div class="col-2-left-r">
                                    <label>描述</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_description" placeholder="描述" maxlength="50" class="input-data" />
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
                                            <button type="button" class="btn-img-style1" onclick="materialEditView.fnTab2Refresh();">
                                                <img src="Image/refresh.png"></button>
                                        </div>
                                    </div>
                                </div>

                                <div class="frame-content-div">
                                    <div class="list-style1">
                                        <div class="list-data-div">
                                            <div>
                                                顯示筆數：
                                                <select class="drop-style1" id="select_page_size" onchange="materialEditView.fnMaxPageSizeChange(this);">
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
