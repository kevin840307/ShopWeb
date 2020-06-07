<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html>
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="Scripts/jquery-1.7.1.min.js"></script>
    <script src="Scripts/jquery-1.7.1.js"></script>
    <link href="Css/login.css" rel="stylesheet" />
    <link href="Css/public.css" rel="stylesheet" />
    <link href="Css/content-view.css" rel="stylesheet" />
    <script type="text/javascript">
        $(function () {
            $("#content-div").on("submit", function (event) {
                event.preventDefault();
                fnLogin();
            });

            $('#message-div').find('.close').click(function () {
                $('#message-div').slideUp(500);
            });
        });

        function fnLogin() {
            var sArg = {
                "method": "fnLogin"
                    , "account": $('#text_account_id').val().toString()
                    , "password": $('#text_password').val().toString()
            };

            $.ajax({
                url: 'ADMIN/Handler/AccountHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    fnResultLogin(data);
                },
                error: function (sError) {
                    fnShowMessage(sError.toString());
                }
            });
        }

        function fnResultLogin(data) {
            var jsonValue = $.parseJSON(JSON.stringify(data));
            if (jsonValue.msg == 'Y') {
                window.location = 'Menu.aspx';
            } else {
                fnShowMessage(jsonValue.msg);
            }
        }

        function fnShowMessage(msg) {
            $('#message-div').find('p').html(msg);
            $('#message-div').slideDown(500);
        }

        function fnShowPassword() {
            $('#text_password').prop('type', 'text');
        }

        function fnHidePassword() {
            $('#text_password').prop('type', 'password');
        }
    </script>
    <title></title>
</head>
<body>
    <div id="block">
        <header>
            <img src="Image/logo.png" class="logo-div" />
        </header>
        <form id="content-div" class="gray-background" method="post">
            <div id="message-div" class="msg-div">
                <img src="Image/close-out.png" onmouseout="this.src='Image/close-out.png'" onmouseover="this.src='Image/close-in.png'" class="close" />

                <p>錯誤訊息:測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示測試顯示</p>
            </div>
            <div class="login-div">
                <div id="login-title-div" class="title-h3-style1">
                    <h3>
                        <img src="Image/person.png" /><p>登入</p>
                    </h3>
                </div>

                <div id="login-content-div" class="white-background">
                    <div class="general">
                        <div class="col-2-left">
                            <label>帳號</label>
                        </div>
                        <div class="col-10-right">
                            <input type="text" id="text_account_id" maxlength="15" placeholder="帳號" required="required" class="input-data" />
                        </div>
                    </div>
                    <div class="general">
                        <div class="col-2-left">
                            <label>密碼</label>
                        </div>
                        <div class="col-10-right">
                            <input type="password" id="text_password" maxlength="15" pattern="[a-zA-Z0-9]{1,15}" placeholder="密碼" required="required" class="input-data" />
                            <span class="password-view" onmousedown="fnShowPassword()" onclick="fnShowPassword()" onmouseout="fnHidePassword()" onmouseover="fnShowPassword()"></span>
                        </div>
                    </div>
                    <div class="general-end">
                        <input type="submit" class="col-12 button-style1" value="登入" />
                    </div>
                </div>
            </div>
        </form>
    </div>
</body>
</html>
