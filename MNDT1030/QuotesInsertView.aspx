<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="QuotesInsertView.aspx.cs" Inherits="QuotesInsertView" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="Css/content-header.css" rel="stylesheet" />
    <link href="Css/content-view.css" rel="stylesheet" />
    <link href="Css/tab-style1.css" rel="stylesheet" />
    <link href="Css/frame-style3.css" rel="stylesheet" />
    <link href="Css/frame-style2.css" rel="stylesheet" />
    <link href="Css/list-style1.css" rel="stylesheet" />
    <link href="Css/content-style1.css" rel="stylesheet" />
    <script src="Scripts/View/Admin/Quotes/quotes-insert-view.js"></script>
    <script src="Scripts/Presenter/Admin/Quotes/quotes-insert-presenter.js"></script>
    <script type="text/javascript">
        var quotesInsertView = {};
        $(function () {

            function fnInitialization() {
                var quotesInsertPresenter = {};
                quotesInsertView.__proto__ = QuotesInsertView.prototype;
                quotesInsertPresenter.__proto__ = QuotesInsertPresenter.prototype;
                QuotesInsertView.call(quotesInsertView, quotesInsertPresenter);
                QuotesInsertPresenter.call(quotesInsertPresenter, quotesInsertView);
                quotesInsertPresenter.fnInitialization();
            }

            fnInitialization();
        });
    </script>
    <div id="content_header_div">
        <h2>報價資料維護</h2>
        <ul>
            <li>
                <a href="Menu.aspx">首頁</a>
            </li>
            <li>
                <a href="QuotesSearchView.aspx?page=1">報價資料維護</a>
            </li>
        </ul>
        <div class="content-header-right">
            <button type="button" class="btn-img-style1" id="btn_back" onclick="window.location='QuotesSearchView.aspx'">
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
                        <img src="Image/person.png" /><p>報價資料新增</p>
                    </h3>
                </div>

                <div class="frame-content-div">
                    <div id="tab" class="tab-style1">
                        <ul class="tab-items">
                            <%--prohibited--%>
                            <li class='tab-item select' id="tab1" onclick="quotesInsertView.fnTitleTabEvent(this);">報價資訊</li>
                            <li class='tab-item prohibited' id="tab2" onclick="quotesInsertView.fnTitleTabEvent(this);">材料資訊</li>
                        </ul>
                        <form class='tab-content content-style1' id="tab1_content" onsubmit="quotesInsertView.fnTab1Insert(event);">
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*單號 ID</label>
                                </div>
                                <div class="col-10-right">
                                    <label id="lab_order_id">自動取得</label>
                                </div>
                            </div>
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*ID</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_id" list="id_list" maxlength="5" pattern="[0-9]" required="required" placeholder="ID" class="input-data-required" />
                                </div>
                                <datalist id="id_list"></datalist>
                            </div>
                             <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*客戶 ID</label>
                                </div>
                                <div class="col-10-right">
                                    <input type="text" id="text_client_id" list="client_id_list" maxlength="13" required="required" placeholder="客戶 ID" class="input-data-required" />
                                </div>
                                <datalist id="client_id_list"></datalist>
                            </div>
                            <div class="general">
                                <div class="col-2-left-r">
                                    <label class="font-red">*報價日期</label>
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
                        </form>

                        <form class='tab-content content-style1 hide' id="tab2_content" onsubmit="quotesInsertView.fnTab2Inserts(event);">
                            <div class="frame-style2">
                                <div class="frame-title-div">
                                    <div class="left-div">
                                        <h3 class="title-h3-style1">
                                            <img src="Image/person.png" />報價資訊
                                        </h3>
                                    </div>
                                    <div class="right-div">
                                        <div class="action">
                                            <button type='button' class='btn-img-style1' onclick='quotesInsertView.fnTab2AppendInsert();'>
                                                <img src='Image/insert.png' /></button>
                                        </div>
                                    </div>
                                </div>

                                <div class="frame-content-div">
                                    <div class="list-style1">
                                        <div class="list-data-div">
                                            <div>
                                                顯示筆數：
                                                <select class="drop-style1" id="select_page_size" onchange="quotesInsertView.fnMaxPageSizeChange(this);">
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
                                                    <td class='general'>產品 ID</td>
                                                    <td class='general'>數量</td>
                                                    <td class='general'>價錢</td>
                                                    <td class='general'>修訂數量</td>
                                                    <td class='general'>修訂價錢</td>
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
