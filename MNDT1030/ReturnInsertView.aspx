<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="ReturnInsertView.aspx.cs" Inherits="ReturnInsertView" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="Css/content-header.css" rel="stylesheet" />
    <link href="Css/content-view.css" rel="stylesheet" />
    <link href="Css/tab-style1.css" rel="stylesheet" />
    <link href="Css/frame-style3.css" rel="stylesheet" />
    <link href="Css/frame-style2.css" rel="stylesheet" />
    <link href="Css/list-style1.css" rel="stylesheet" />
    <link href="Css/content-style1.css" rel="stylesheet" />
    <script src="Scripts/View/Admin/Return/return-insert-view.js"></script>
    <script src="Scripts/Presenter/Admin/Return/return-insert-presenter.js"></script>
    <script type="text/javascript">
        var returnInsertView = {};
        $(function () {

            function fnInitialization() {
                var returnInsertPresenter = {};
                returnInsertView.__proto__ = ReturnInsertView.prototype;
                returnInsertPresenter.__proto__ = ReturnInsertPresenter.prototype;
                ReturnInsertView.call(returnInsertView, returnInsertPresenter);
                ReturnInsertPresenter.call(returnInsertPresenter, returnInsertView);
                returnInsertPresenter.fnInitialization();
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
                <a href="AccountSearchView.aspx?page=1">進退貨資料維護</a>
            </li>
        </ul>
        <div class="content-header-right">
            <button type="button" class="btn-img-style1" id="btn_back" onclick="window.location='ReturnSearchView.aspx'">
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
                        <img src="Image/person.png" /><p>進退貨資料新增</p>
                    </h3>
                </div>

                <div class="frame-content-div">
                    <div id="tab" class="tab-style1">
                        <ul class="tab-items">
                            <%--prohibited--%>
                            <li class='tab-item select' id="tab1" onclick="returnInsertView.fnTitleTabEvent(this);">退貨資訊</li>
                            <li class='tab-item prohibited' id="tab2" onclick="returnInsertView.fnTitleTabEvent(this);">材料資訊</li>
                        </ul>
                        <form class='tab-content content-style1' id="tab1_content" onsubmit="returnInsertView.fnTab1Insert(event);">
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*退貨單號</label>
                                </div>
                                <div class="col-10-right">
                                    <label id="lab_return_id">自動取得</label>
                                </div>
                            </div>
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*進貨單號</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_order_id" list="order_list" maxlength="13" pattern="?[0-9]{12}" required="required" placeholder="進貨單號" class="input-data-required" />
                                </div>
                            </div>
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*ID</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_id" list="id_list" maxlength="9" pattern="[0-9]" required="required" placeholder="ID" class="input-data-required" />
                                </div>
                                <datalist id="id_list"></datalist>
                            </div>
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*退貨日期</label>
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

                            <div class="general-right">
                                <input type="submit" value="下一步" class="col-2 button-style1" />
                            </div>
                             <datalist id="order_list"></datalist>
                        </form>

                        <form class='tab-content content-style1 hide' id="tab2_content" onsubmit="returnInsertView.fnTab2Inserts(event);">
                            <div class="frame-style2">
                                <div class="frame-title-div">
                                    <div class="left-div">
                                        <h3 class="title-h3-style1">
                                            <img src="Image/person.png" />材料資訊
                                        </h3>
                                    </div>
                                    <div class="right-div">
                                        <div class="action">
                                            <button type='button' class='btn-img-style1' onclick='returnInsertView.fnTab2AppendInsert();'>
                                                <img src='Image/insert.png' /></button>
                                        </div>
                                    </div>
                                </div>

                                <div class="frame-content-div">
                                    <div class="list-style1">
                                        <div class="list-data-div">
                                            <div>
                                                顯示筆數：
                                                <select class="drop-style1" id="select_page_size" onchange="returnInsertView.fnMaxPageSizeChange(this);">
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
                                                    <td class='general'>材料 ID</td>
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
                                        <datalist id="material_list"></datalist>
                                        <datalist id="warehouse_list"></datalist>
                                    </div>
                                </div>
                            </div>
                            <div class="general-right">
                                <input type="submit" class="col-2 button-style1" />
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
