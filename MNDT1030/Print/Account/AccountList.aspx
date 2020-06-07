<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AccountList.aspx.cs" Inherits="Print_Account_AccountList" %>

<script src="../../Scripts/jquery-1.7.1.js"></script>
<script src="../../Scripts/public-api.js"></script>
<link href="../../Css/print.css" rel="stylesheet" />
<script src="../../Scripts/public-api.js"></script>
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;">

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script type="text/javascript">
        var g_arrayHtml = [];
        $(function () {
            fnPrint();
        });

        function fnPrint() {
            fnLoading();
            var sArg = {
                "method": "fnPrint"
                , "order": fnFixMNDT(fnGetQuery("order", "id"))
                , "id": fnFixMNDT(fnGetQuery("filter_id", ""))
                , "account": fnFixMNDT(fnGetQuery("filter_account", ""))
                , "name": fnFixMNDT(fnGetQuery("filter_name", ""))
                , "status": fnFixMNDT(fnGetQuery("filter_status", ""))
            };

            $.ajax({
                url: '../../ADMIN/Handler/AccountHandler.ashx',
                type: 'GET',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    fnResultPrint(data);
                    fnLoaded();
                },
                error: function (sError) {
                }
            });
        }

        function fnResultPrint(data) {
            var iIndex = 0;
            var jsonValues = jQuery.parseJSON(JSON.stringify(data));

            while (iIndex < jsonValues.length) {
                var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
                fnPushColumns(jsonValue);
                iIndex++;
            }
            //if (jsonValues.length == 0) {
            //    this.g_accountSearchView.fnShowEmptyColumns();
            //}
            fnShowList();
            fnLoaded();
            window.print();
        }

        function fnPushColumns(jsonValue) {
            this.g_arrayHtml.push("   <tr> ");
            this.g_arrayHtml.push("      <td> " + jsonValue.id + "</td> ");
            this.g_arrayHtml.push("      <td>" + jsonValue.account + "</td> ");
            this.g_arrayHtml.push("      <td>" + jsonValue.name + "</td> ");
            this.g_arrayHtml.push("      <td>" + jsonValue.phone + "</td> ");
            this.g_arrayHtml.push("      <td>" + jsonValue.address + "</td> ");
            this.g_arrayHtml.push("   </tr> ");
        }

        function fnShowList() {
            $('#accout_list').find('tbody').html(this.g_arrayHtml.join(''));
            this.g_arrayHtml = [];
        }

    </script>
    <title></title>
</head>
<body>
    <div id="print_frame">
        <div id='loading'>
            正在載入頁面資料...
        </div>
        <h3>帳號清單</h3>
        <table id="accout_list" class="list-general">
            <thead>
                <tr>
                    <td class='general-short'>ID</td>
                    <td class='general'>帳號</td>
                    <td class='general'>名稱</td>
                    <td class='general'>電話</td>
                    <td class='general'>地址</td>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>
</body>
</html>
