<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MNDTShop.aspx.cs" Inherits="MNDTShop" %>

<!DOCTYPE html>
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;">
<link href="Css/home.css" rel="stylesheet" />
<script src="Js/jquery-1.8.0.js"></script>
<script src="Js/jquery-1.8.3.min.js"></script>
<script src="Js/Rotation.js"></script>
<link href="Css/rotation.css" rel="stylesheet" />
<link href="Css/title_menu.css" rel="stylesheet" />
<link href="Css/show_pictrue.css" rel="stylesheet" />
<link href="Css/rotation_sponsor.css" rel="stylesheet" />
<link href="Css/title_item_menu.css" rel="stylesheet" />
<link href="Css/item-data.css" rel="stylesheet" />
<script src="Js/tab.js"></script>
<link href="Css/tab.css" rel="stylesheet" />
<link href="Css/item_right.css" rel="stylesheet" />
<link href="Css/title_cart.css" rel="stylesheet" />
<link href="Css/client_login.css" rel="stylesheet" />
<script type="text/javascript">

    function ShowFocus() {
        $(".shop-cart-list").slideDown(100);
    }

    function HideFocus() {
        setTimeout(Hide, 100);
    }

    function Hide() {
        $(".shop-cart-list").slideUp(100);
    }

    function close_show_pictrue() {
        $(".show-pictrue").slideUp(1000);
    }
    function show_pictrue(src) {
        $(".show-pictrue > div > img").css("content", "url(/" + src + ")");
        $(".show-pictrue").slideDown(1000);
    }

    function sleep(milliseconds) {
        var start = new Date().getTime();
        for (var i = 0; i < 1e7; i++) {
            if ((new Date().getTime() - start) > milliseconds) {
                break;
            }
        }
    }

    $(document).ready(fn);

    function fn() {
        $("#wait").show(2000);


    }

    $(function () {

        
        var down = false;
        var close = true;
        $(".menu-down").focusin(function () {
            $(this).find("> a").addClass("memu-1-select");
            $(this).find(".menu-down-hide").slideDown(1000);
        });

        $(".menu-down").mouseover(function () {
            if (!$(this).find("> a").hasClass("memu-1-select")) {
                $(this).find(".menu-down-hide").show();
            }
        });

        $(".menu-down").mouseout(function () {
            if (!$(this).find("> a").hasClass("memu-1-select")) {
                $(this).find(".menu-down-hide").hide();
            }
        });

        $(".menu-down").focusout(function () {
            if (!close) {
                $(this).find("> a").removeClass("memu-1-select");
                $(this).find(".menu-down-hide").slideUp();
            }
        });

        $(".memu-2 > li > a").focusout(function () {
            close = false;
        });

        $(".menu_botton").click(function () {
            if (down) {
                $(".content-title > ul").slideUp(100);
                down = false;
            }
            else {
                $(".content-title > ul").slideDown(100);
                down = true;
                close = true;
            }
        });

        $('#title_rotation').rotation({
            speed: 2000,
            dot: '#title_dot'
        });

        $('#bottom_rotation').rotation({
            speed: 2000,
            dot: '#bottom_dot'
        });

        $('.search-text-style1').focusout(function () {
            if (this.value == '') {
                this.value = '查詢';
                $('.search-text-style1').addClass('gray');
            }
        })

        $('.search-text-style1').focusin(function () {
            if ($('.search-text-style1').hasClass('gray')) {
                this.value = '';
                $('.search-text-style1').removeClass('gray');
            }
        })

    })

    var isFly = false;
    function deleteObg(obg) {
        obg.remove();
        isFly = false;
    }

    $(function () {
        $('.fly-shop-item-buy').click(function () {
            if (!isFly) {
                isFly = true;
                var item_id = '.hot-item-img-' + this.id.replace("buy", "");
                var flyElm = $(item_id).clone().css('opacity', '0.7');
                flyElm.css({
                    'z-index': 9000,
                    'display': 'block',
                    'position': 'absolute',
                    'top': $(item_id).offset().top + 'px',
                    'left': $(item_id).offset().left + 'px',
                    'width': $(item_id).width() + 'px',
                    'height': $(item_id).height() + 'px'
                });
                $('body').append(flyElm);
                flyElm.stop(true, false).animate({
                    top: $('.buy').offset().top,
                    left: $('.buy').offset().left,
                    width: 50,
                    height: 50,
                }, 'slow').clearQueue();
                setTimeout(function () { deleteObg(flyElm); }, 500);
            }
        });

        $('.fly-shop-item-like').click(function () {
            if (!isFly) {
                isFly = true;
                var item_id = '.hot-item-img-' + this.id.replace("like", "");
                var flyElm = $(item_id).clone().css('opacity', '0.7');
                flyElm.css({
                    'z-index': 9000,
                    'display': 'block',
                    'position': 'absolute',
                    'top': $(item_id).offset().top + 'px',
                    'left': $(item_id).offset().left + 'px',
                    'width': $(item_id).width() + 'px',
                    'height': $(item_id).height() + 'px'
                });
                $('body').append(flyElm);
                flyElm.stop(true, false).animate({
                    top: $('.love').offset().top,
                    left: $('.love').offset().left,
                    width: 50,
                    height: 50,
                }, 'slow').clearQueue();
                setTimeout(function () { deleteObg(flyElm); }, 500);
            }
        });

        $("#btn_login").click(function () {
            $.ajax({
                type: 'post',
                url: 'ActionService.asmx/fnClientLogin',
                data: {
                    sAccount: $('#text_id').val(),
                    sPassword: $('#text_password').val()
                },
                success: function (domXml) {
                    var xmlDom = domXml;
                    var result = xmlDom.childNodes[0].firstChild.nodeValue;
                    if (result == 'true') {
                        document.location.href = "MNDTShop.aspx";
                    } else {
                        alert('登入失敗');
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert(XMLHttpRequest.readyState + XMLHttpRequest.status + XMLHttpRequest.responseText);
                }
            });
        });

        $("#logout").click(function () {
            $.ajax({
                type: 'post',
                url: 'ActionService.asmx/fnClientLogin',
                data: {
                    sAccount: '1',
                    sPassword: '1'
                },
                success: function () {
                    document.getElementById('login_sCId').innerHTML = '';
                    document.getElementById('logout').innerHTML = '';
                    alert('登出成功');
                },
                error: function () { }
            });
        });

        $(document).ready(function () {
            var sCId = "<%= Session["sCId"] == null ? "" : Session["sCId"].ToString() %>";
            if (sCId.length > 0) {
                document.getElementById('login_sCId').innerHTML = '歡迎' + sCId;
                document.getElementById('logout').innerHTML = '登出';

            } else {
                document.getElementById('login_sCId').innerHTML = '';
                document.getElementById('logout').innerHTML = '';
            }
            $("#wait").hide(2000);
        });
    });

    function delete_cart(productNo) {
        $.ajax({
            type: 'post',
            url: 'ActionService.asmx/fnDeleteCartShop',
            data: {
                sProductCode: productNo,
            },
            success: function (domXml) {
                var xmlDom = domXml;
                var result = xmlDom.childNodes[0].firstChild.nodeValue;
                if (result == 'Y') {
                    alert('已刪除成功');
                    Postback();
                } else if (result == 'Login') {
                    alert('請登入');
                    document.location.href = "MNDTShop.aspx?Client=1";
                }
            },
            error: function () { }
        });
    }

    function hide_msg() {
        document.getElementById('show_msg').innerHTML = '';
        $("#show_msg").hide(1000);
    }

    function show_msg() {
        document.getElementById('show_msg').innerHTML = '請登入';
        $("#show_msg").show(1000);
        setTimeout(hide_msg, 3000);
    }

    function add_cart(productNo) {
        $.ajax({
            type: 'post',
            url: 'ActionService.asmx/fnAddCartShop',
            data: {
                sProductCode: productNo,
                sAmount: $("#cart_amount").val()
            },
            success: function (domXml) {
                var xmlDom = domXml;
                var result = xmlDom.childNodes[0].firstChild.nodeValue;
                if (result == 'Y') {
                    alert('已加入購物車');
                    Postback();
                } else if (result == 'Login') {
                    alert('請登入');
                    document.location.href = "MNDTShop.aspx?Client=1";
                }
            },
            error: function () { }
        });
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <div id="wait" style=" display:none; z-index:10000; position :fixed; width:100%; height:100%; background:red;"></div>
    <form id="form1" runat="server">
        
        <div class="title">
            <div class="title-content">

                <p class="title-text-p-left">MNDT</p>

                <a class="title-text-p-right" href="MNDTShop.aspx?Client=1" title="會員中心">
                    <i class="client"></i>
                    <span class="hide-title-text">會員中心</span></a>
                <a class="title-text-p-right" href="MNDTShop.aspx" title="購物車">
                    <i class="buy"></i>
                    <span class="hide-title-text">購物車</span></a>
                <a class="title-text-p-right" href="MNDTShop.aspx" title="我的最愛">
                    <i class="love"></i>
                    <span class="hide-title-text">我的最愛</span></a>
                <p class="title-text-right" id="login_sCId"></p>
                <a class="title-logout" href="#" id="logout"></a>
            </div>
        </div>
        <div class="content">

            <div class="logo">
                <a href="MNDTShop.aspx">
                    <img src="Image/logo.png" /></a>
            </div>
            <div class="search">
                <asp:TextBox runat="server" CssClass="search-text-style1  gray" Text="查詢" />
                <asp:Button runat="server" CssClass="search-button-style1" Text="查詢" />
            </div>
            <div class="shop-cart">
                <asp:Button runat="server" CssClass="shop-cart-button" Text="已選商品" OnClientClick="return false;" onfocus="ShowFocus()" onblur="HideFocus()" />
                <div class="shop-cart-list">
                    <asp:Literal runat="server" ID="lt_html_cart_list"></asp:Literal>
                </div>
            </div>

            <%--<div id="show_msg" style="float:left; width:100%; display:none; ">5555</div>--%>

            <asp:Literal runat="server" ID="lt_html_title"></asp:Literal>

            <asp:Literal runat="server" ID="lt_html_title_rotation"></asp:Literal>

            <asp:Literal runat="server" ID="lt_item_title_html"></asp:Literal>

            <asp:Literal runat="server" ID="lt_item_data_html"></asp:Literal>

            <asp:Literal runat="server" ID="lt_hot_item_html"></asp:Literal>

            <asp:Literal runat="server" ID="lt_html_bottom_rotation"></asp:Literal>

            <asp:Literal runat="server" ID="lt_client_data"></asp:Literal>

        </div>
        <div class="bottom">
            <div class="bottom-div">
                <div class="bottom-div-content">
                    <h4>商品訊息</h4>
                    <ul>
                        <li><a href="#">MNDT1</a></li>
                        <li><a href="#">MNDT2</a></li>
                        <li><a href="#">MNDT3</a></li>
                        <li><a href="#">MNDT4</a></li>
                        <li><a href="#">MNDT5</a></li>
                    </ul>
                </div>

                <div class="bottom-div-content">
                    <h4>客戶服務</h4>
                    <ul>
                        <li><a href="#">MNDT1</a></li>
                        <li><a href="#">MNDT2</a></li>
                        <li><a href="#">MNDT3</a></li>
                        <li><a href="#">MNDT4</a></li>
                        <li><a href="#">MNDT5</a></li>
                    </ul>
                </div>

                <div class="bottom-div-content">
                    <h4>其他服務</h4>
                    <ul>
                        <li><a href="#">MNDT1</a></li>
                        <li><a href="#">MNDT2</a></li>
                        <li><a href="#">MNDT3</a></li>
                        <li><a href="#">MNDT4</a></li>
                        <li><a href="#">MNDT5</a></li>
                    </ul>
                </div>

                <div class="bottom-div-content">
                    <h4>會員中心</h4>
                    <ul>
                        <li><a href="#">MNDT1</a></li>
                        <li><a href="#">MNDT2</a></li>
                        <li><a href="#">MNDT3</a></li>
                        <li><a href="#">MNDT4</a></li>
                        <li><a href="#">MNDT5</a></li>
                    </ul>
                </div>

                <div class="bottom-div-last">
                    <hr color="#FFFFFF" size="1" width="100%" align="center">
                    <span style="color: #b6ff00">@MNDT Ghost參考著作</span>
                </div>
            </div>
        </div>
       <%-- <embed src="123.amr" autostart="false" loop="false">--%>

        <div class="show-pictrue">
            <%--<h2>
                <img src="Image/next.png" onmouseover="this.src='/Image/next_1.png'" onmouseout="this.src='/Image/next.png'" /></h2>
            <h3>
                <img src="Image/last.png" onmouseover="this.src='/Image/last_1.png'" onmouseout="this.src='/Image/last.png'" /></h3>
            --%>
            <h4>
                <img src="Image/close.png" onmouseover="this.src='/Image/close_1.png'" onmouseout="this.src='/Image/close.png'" onclick="close_show_pictrue()" />
            </h4>
            <div class="show-pictrue-img">
                <img />
            </div>
        </div>
    </form>
</body>
</html>
