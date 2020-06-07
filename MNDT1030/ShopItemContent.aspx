<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShopItemContent.aspx.cs" Inherits="ShopItemContent" %>

<!DOCTYPE html>
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;">
<link href="Css/index.css" rel="stylesheet" />
<link href="Css/rotation.css" rel="stylesheet" />
<link href="Css/rotation_sponsor.css" rel="stylesheet" />
<link href="Css/index-title-menu.css" rel="stylesheet" />
<link href="Css/title_item_menu.css" rel="stylesheet" />
<link href="Css/show_pictrue.css" rel="stylesheet" />
<link href="Css/item-data.css" rel="stylesheet" />
<link href="Css/item_right.css" rel="stylesheet" />
<link href="Css/tab.css" rel="stylesheet" />
<link href="Css/title_cart.css" rel="stylesheet" />
<script src="Scripts/jquery-1.7.1.js"></script>
<script src="Scripts/Rotation.js"></script>
<script src="Scripts/public-api.js"></script>

<script type="text/javascript">
    var product_id = "";
    var name = "";
    var category = "";
    var category_name = "";


    $(function () {
        product_id = fnGetQuery("product_id", "");
        name = fnGetQuery("name", "");
        category = fnGetQuery("category", "");
        category_name = fnGetQuery("category_name", "");


        InitTitleView();
        InitTopRotation();
        InitCart();
        InitItemTitle();
        InitItemContent();
        InitBottomRotation();
    })

    function InitTitleView() {
        let html = [];
        html.push(" <div class='title-href-div'> ");
        html.push("     <spwn class='menu_text'>選單</spwn> ");
        html.push("     <input type='button' class='menu_botton'> ");
        html.push(" </div> ");
        html.push(" <div class='content-title'> ");
        html.push("     <ul class='memu-1'> ");
        html.push("         <li class='menu-down'> ");
        html.push("             <a class='content-href' href='#none'>熱門商品</a> ");
        html.push("             <ul class='memu-2 menu-down-hide'> ");
        html.push("                 <li> <a href='MNDT6020.aspx'>產品1</a> </li> ");
        html.push("                 <li> <a href='MNDT6030.aspx'>產品2</a> </li> ");
        html.push("             </ul> ");
        html.push("         </li> ");
        html.push("         <li> <a class='content-href' href='#none'>最新商品</a> </li> ");
        html.push("    </ul> ");
        html.push(" </div> ");
        $('#html_title').html(html.join(''));
    }

    function InitTopRotation() {
        var sArg = {
            "method": "fnSelectImage"
                , "carousel_id": "title"
        };

        $.ajax({
            url: 'ADMIN/Handler/CarouselHandler.ashx',
            data: sArg,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                ResultTopRotation(data);
                TitleRotationEvent();
            },
            error: function (sError) {
                alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                window.location = 'CarouselSearchView.aspx';
            }
        });
    }

    function ResultTopRotation(data) {
        let html = [];
        html.push(" <div id='title_rotation' class='wrapper'> ");
        html.push("    <h2> <img src='Image/next_b.png' onmouseover='this.src='/Image/next_b_1.png'' onmouseout='this.src='/Image/next_b.png'' /> </h2> ");
        html.push("    <h3> <img src='Image/last_b.png' onmouseover='this.src='/Image/last_b_1.png'' onmouseout='this.src='/Image/last_b.png'' /> </h3> ");
        html.push("    <ul class='pic'> ");

        var jsonValues = jQuery.parseJSON(JSON.stringify(data));
        for (var index = 0; index < jsonValues.length; index++) {
            var jsonValue = jQuery.parseJSON(JSON.stringify(jsonValues[index]));
            html.push(" <li> ");
            html.push("    <div class='img-div'> ");
            html.push("        <img src='Rotation\\title\\" + jsonValue.filename + "' onclick=\"show_pictrue('Rotation/title/" + jsonValue.filename + "')\" /> ");
            html.push("    </div> ");
            html.push(" </li> ");
        }

        html.push("    </ul> ");
        html.push(" </div> ");
        html.push(" <ul class='page_dot' id='title_dot'></ul>");
        $('#html_title_rotation').html(html.join(''));
    }

    function InitCart() {
        var arg = {
            "method": "SelectCart",
            "type": "1"
        };

        $.ajax({
            url: 'User/Handler/ClientHandler.ashx',
            data: arg,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                ResultCart(data);
                ComputeCartTotal();
            },
            error: function (sError) {
                alert('錯誤訊息：不知名錯誤，重整頁面。');
                window.location = 'ShopUser.aspx';
            }
        });
    }

    function ResultCart(data) {
        var index = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));
        while (index < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[index]));
            AddCartView(jsonValue);
            index++;
        }
    }

    function InitItemTitle() {
        var html = [];
        html.push(" <div class='item-title'> ");
        html.push("     <ul class='item-1'> ");
        html.push("             <li> <a href='index.aspx'><img class='home'><img></a> </li> ");
        html.push("             <li> <a class='item-href' href='ShopItemSearch.aspx?category_name=" + category_name + "&category=" + category + "'>" + category_name + "</a> </li> ");
        html.push("             <li> <a class='item-href' href='#none'>" + name + "</a> </li> ");
        html.push("     </ul> ");
        html.push(" </div> ");
        $('#html_item_title').html(html.join(''));
    }

    function InitItemContent() {

        var sArg = {
            "method": "fnSelectShopItem",
            "product_id": product_id
        };

        $.ajax({
            url: 'ADMIN/Handler/ShopItemHandler.ashx',
            type: 'GET',
            data: sArg,
            async: false,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                ResultItemContent(data);
            },
            error: function (sError) {
            }
        });
    }

    function ResultItemContent(data) {
        var jsonValue = $.parseJSON(JSON.stringify(jQuery.parseJSON(JSON.stringify(data))[0]));
        let html = [];
        html.push(" <div class='item-data-div'> ");
        html.push("     <div class='item-data-div-left'> ");
        html.push(" <div> ");
        html.push("    <ul> ");
        html.push("        <li class='item-data-big-img'> <a onclick=\"show_pictrue('ShopItem/" + this.product_id + "/first.png')\" > <div><img class='hot-item-img-0' src='ShopItem\\" + this.product_id + "\\first.png'><img></div></a>  </li> ");
        html.push(" <li class='item-data-small-img'> ");
        html.push("     <a onclick=\"show_pictrue('ShopItem/" + this.product_id + "/first.png')\" > <img src='ShopItem\\" + this.product_id + "\\first.png'></img></a>  ");
        html.push(" </li> ");
        html.push(InitShopItemShowImage());
        html.push("     </ul> ");
        html.push(" </div> ");
        html.push("         <div class='item-tab'> ");
        html.push("             <ul> ");
        html.push("                 <li class='tab select-tab'><a href='#tab1' >商品說明</a></li> ");
        html.push("                 <li class='tab'><a href='#tab2'>評論</a></li> ");
        html.push("             </ul> ");
        html.push("         </div> ");
        html.push("         <div class='item-tab-content'> ");
        html.push("             <div class='tab1-div'>" + jsonValue.content.replace(/SSS0/g, "<").replace(/SSS1/g, ">").replace(/''/g, "\""));
        html.push("             </div> ");
        html.push("             <div class='tab2-div hide'> ");
        html.push("             </div> ");
        html.push("         </div> ");
        html.push("     </div> ");
        html.push("     <div class='item-data-div-right'> ");
        html.push(" <div> ");
        html.push("    <button class='btn-like fly-shop-item-like' id='like0' type='button' onclick='AddLove(\"" + jsonValue.product_id + "\",\"" + jsonValue.category + "\",\"" + jsonValue.category_name + "\",\"" + jsonValue.name + "\",\"" + jsonValue.price + "\",\"1\")' title='我的最愛' />");
        html.push(" </div> ");
        html.push(" <div> ");
        html.push("    <ul> ");
        html.push("        <li> <h1>" + jsonValue.name + "</h1> </li>");
        html.push("        <li> <p>規格：無</p> </li>");
        html.push("        <li> <p>庫存數量：" + jsonValue.amount + "</p> </li>");
        html.push("        <li> <h1>NT$ " + jsonValue.price + "</h1> </li>");
        html.push("        <li> <p>數量：</p> </li>");
        html.push("        <li> <input class='input-buy' type='text' id='cart_amount' value='1' /></li>");
        html.push("        <li> <button type='button' id='buy0' class='btn-item-buy fly-shop-item-buy' title='購買' onclick='AddCart(\"" + jsonValue.product_id + "\",\"" + jsonValue.category + "\",\"" + jsonValue.category_name + "\",\"" + jsonValue.name + "\",\"" + jsonValue.price + "\",\"N\")' >購買</button></li>");
        html.push("    </ul> ");
        html.push(" </div> ");
        html.push("     </div> ");
        html.push(" </div> ");
        $('#html_item_data').html(html.join(''));
    }

    function InitShopItemShowImage() {
        var result = "";
        if (this.product_id.length > 0) {
            var that = this;
            var sArg = {
                "method": "fnSelectImage"
                , "product_id": this.product_id
            };

            $.ajax({
                url: 'ADMIN/Handler/ShopItemHandler.ashx',
                data: sArg,
                async: false,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    result = that.ResultShopItemShowImage(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往主頁面。');
                    window.location = 'index.aspx';
                }
            });

        } else {
            alert('錯誤訊息：ID錯誤，跳往主頁面。');
            window.location = 'index.aspx';
        }
        return result;
    }

    function ResultShopItemShowImage(data) {
        var html = [];
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));
        for (var index = 0; index < jsonValues.length; index++) {
            var jsonValue = jQuery.parseJSON(JSON.stringify(jsonValues[index]));
            html.push(" <li class='item-data-small-img'> ");
            html.push("     <a onclick=\"show_pictrue('ShopItem/" + this.product_id + "/" + jsonValue.filename + "')\" > <img src='ShopItem\\" + this.product_id + "\\" + jsonValue.filename + "'></img></a>  ");
            html.push(" </li> ");
        }
        return html.join("");
    }

    function InitBottomRotation() {
        var sArg = {
            "method": "fnSelectImage"
        , "carousel_id": "bottom"
        };

        $.ajax({
            url: 'ADMIN/Handler/CarouselHandler.ashx',
            data: sArg,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                ResultBottomRotation(data);
                BottomRotationEvent();
            },
            error: function (sError) {
                alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                window.location = 'CarouselSearchView.aspx';
            }
        });
    }

    function ResultBottomRotation(data) {
        let html = [];
        html.push(" <div id='bottom_rotation' class='sponsor'> ");
        html.push("    <h2> <img src='Image/next_b.png' onmouseover='this.src='/Image/next_b_1.png'' onmouseout='this.src='/Image/next_b.png'' /> </h2> ");
        html.push("    <h3> <img src='Image/last_b.png' onmouseover='this.src='/Image/last_b_1.png'' onmouseout='this.src='/Image/last_b.png'' /> </h3> ");
        html.push("    <ul class='pic'> ");

        var jsonValues = jQuery.parseJSON(JSON.stringify(data));
        for (var index = 0; index < jsonValues.length; index++) {
            var jsonValue = jQuery.parseJSON(JSON.stringify(jsonValues[index]));
            html.push(" <li> ");
            html.push("    <div class='img-div'> ");
            html.push("        <img src='Rotation\\bottom\\" + jsonValue.filename + "' onclick=\"show_pictrue('Rotation/bottom/" + jsonValue.filename + "')\" /> ");
            html.push("    </div> ");
            html.push(" </li> ");
        }

        html.push("    </ul> ");
        html.push(" </div> ");
        html.push(" <ul class='page_dot' id='bottom_dot'></ul>");
        $('#html_bottom_rotation').html(html.join(''));
    }

</script>

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
        console.log(src);
        $(".show-pictrue > div > img").css("content", "url(" + src + ")");
        //$(".show-pictrue > div > img").attr("src", src);
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

    function TitleRotationEvent() {
        $('#title_rotation').rotation({
            speed: 2000,
            dot: '#title_dot'
        });
    }

    function BottomRotationEvent() {
        $('#bottom_rotation').rotation({
            speed: 2000,
            dot: '#bottom_dot'
        });
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
                    'z-ShopItemContent': 9000,
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
                    'z-ShopItemContent': 9000,
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

    });


    function hide_msg() {
        document.getElementById('show_msg').innerHTML = '';
        $("#show_msg").hide(1000);
    }

    function show_msg() {
        document.getElementById('show_msg').innerHTML = '請登入';
        $("#show_msg").show(1000);
        setTimeout(hide_msg, 3000);
    }

    function DeleteCart(product_id) {
        var arg = {
            "method": "fnDeleteCart",
            "product_id": product_id
        };

        $.ajax({
            url: 'User/Handler/ClientHandler.ashx',
            data: arg,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                ResultDeleteCart(product_id, data);
                ComputeCartTotal();
            },
            error: function (sError) {
                alert('錯誤訊息：不知名錯誤，重整頁面。');
                window.location = 'ShopUser.aspx';
            }
        });
    }

    function ResultDeleteCart(product_id, data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg != "Y") {
            alert(jsonValue.msg);
            return;
        }
        $("#cart_" + product_id).remove();
    }

    function DeleteLove(product_id) {
        var arg = {
            "method": "fnDeleteLove",
            "product_id": product_id
        };

        $.ajax({
            url: 'User/Handler/ClientHandler.ashx',
            data: arg,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                ResultDeleteLove(data);
            },
            error: function (sError) {
                alert('錯誤訊息：不知名錯誤，重整頁面。');
                window.location = 'ShopUser.aspx';
            }
        });
    }

    function ResultDeleteLove(data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        //if (jsonValue.msg != "Y") {
        //    alert(jsonValue.msg);
        //    return;
        //}
    }

    function AddLove(product_id, category, category_name, name, price, amount) {
        var arg = {
            "method": "fnAddLove",
            "product_id": product_id
        };

        $.ajax({
            url: 'User/Handler/ClientHandler.ashx',
            data: arg,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                ResultAddLove(data);
            },
            error: function (sError) {
                alert('錯誤訊息：不知名錯誤，重整頁面。');
                window.location = 'ShopUser.aspx';
            }
        });
    }

    function ResultAddLove(data) {
        //var jsonValue = $.parseJSON(JSON.stringify(data));
        //if (jsonValue.msg != "Y") {
        //    alert(jsonValue.msg);
        //    return;
        //}
        //if (jsonValue.type == "1") {
        //    AddCartView(info);
        //} else if (jsonValue.type == "2") {
        //    UpdateCartView(info, "1");
        //}
    }

    function AddCart(product_id, category, category_name, name, price, amount) {
        if (amount == "N") {
            amount = $('#cart_amount').val();
        }
        var arg = {
            "method": "fnAddCart",
            "product_id": product_id,
            "amount": amount
        };

        $.ajax({
            url: 'User/Handler/ClientHandler.ashx',
            data: arg,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                var info = {
                    "product_id": product_id,
                    "category": category,
                    "category_name": category,
                    "name": name,
                    "price": price,
                    "amount": amount
                };
                ResultAddCart(info, data);
                ComputeCartTotal();
            },
            error: function (sError) {
                alert('錯誤訊息：不知名錯誤，重整頁面。');
                window.location = 'ShopUser.aspx';
            }
        });
    }

    function ResultAddCart(info, data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg != "Y") {
            alert(jsonValue.msg);
            return;
        }
        if (jsonValue.type == "1") {
            AddCartView(info);
        } else if (jsonValue.type == "2") {
            UpdateCartView(info, "1");
        }
    }

    function AddCartView(data) {
        var href = "ShopItemContent.aspx?product_id=" + data.product_id + "&category=" + data.category + "&category_name=" + data.category_name + "&name=" + data.name;
        var html = [];
        html.push("<tr style='border: solid 1px #000;' id='cart_" + data.product_id + "'>");
        html.push("<td class='table-img'>");
        html.push("<a href='" + href + "'>");
        html.push("<img src='ShopItem\\" + data.product_id + "\\first.png' />");
        html.push("</a>");
        html.push("</td>");
        html.push("<td class='table-str'>");
        html.push("<a href='" + href + "'>" + data.name + "</a>");
        html.push("</td>");
        html.push("<td class='table-num amount'>X " + data.amount + "</td>");
        html.push("<td class='table-num price'>NT$ " + data.price + "</td>");
        html.push("<td class='table-btn'>");
        html.push("<button type='button' onclick='DeleteCart(\"" + data.product_id + "\")'></button>");
        html.push("</td>");
        html.push("</tr>");
        $('#shop_cart_table > tbody:last-child').append(html.join(""));
    }

    function UpdateCartView(data, type) {
        if (type == "1") {
            var amount = $("#cart_" + data.product_id).find(".amount");
            var modAmount = parseInt(amount.text().replace("X ", "")) + parseInt(data.amount);
            amount.text("X " + modAmount);
        }
    }

    function ComputeCartTotal() {
        var length = $('#shop_cart_table tr').length;
        var total = 0;
        for (var index = 0; index < length; index++) {
            var tr = $($('#shop_cart_table tr')[index]);
            var amount = tr.find('.amount').text().replace("X ", "");
            var print = tr.find('.price').text().replace("NT$ ", "");
            total += parseInt(amount) * parseInt(print)
        }
        $('#cart_total').text("NT$ " + total);
        $('#shop_cart_button').val("已選商品(" + length + ") " + "NT$ " + total);
    }

    function ShopItemSearch() {
        window.location = "ShopItemSearch.aspx?category_name=" + $('#search_input').val() + "";
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">

        <div class="title">
            <div class="title-content">

                <p class="title-text-p-left">MNDT</p>

                <a class="title-text-p-right" href="ShopUser.aspx" title="會員中心">
                    <i class="client"></i>
                    <span class="hide-title-text">會員中心</span></a>
                <a class="title-text-p-right" href="ShopCart.aspx" title="購物車">
                    <i class="buy"></i>
                    <span class="hide-title-text">購物車</span></a>
                <a class="title-text-p-right" href="ShopUser.aspx" title="我的最愛">
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
                <input type="text" placeholder="查詢" class="search-text-style1" id="search_input" />
                <input type="button" class="search-button-style1" value="查詢" onclick="ShopItemSearch();" />
            </div>
            <div class="shop-cart">

                <input type="button" class="shop-cart-button" value="已選商品" id="shop_cart_button" onfocus="ShowFocus()" onblur="HideFocus()" />
                <%--                <div class="shop-cart-list">
                </div>--%>
                <div class="shop-cart-list">
                    <div>
                        <ul>
                            <li>
                                <table id="shop_cart_table">
                                    <tbody>
                                    </tbody>
                                </table>
                            </li>
                            <li>
                                <div class="col-12">
                                    <div class="col-3-left" style="font-family: 'Microsoft JhengHei'; color: #494949; font-size: 13px;">總金額</div>
                                    <div class="col-9-right" style="font-family: 'Microsoft JhengHei'; color: #494949; font-size: 13px;" id="cart_total">NT$ 0</div>
                                </div>
                            </li>
                            <li>
                                <input type="button" class="btn-go-cart" value="前往購物車" onclick="window.location = 'ShopCart.aspx';" />
                            </li>
                        </ul>
                    </div>
                </div>
            </div>

            <%--<div id="show_msg" style="float:left; width:100%; display:none; ">5555</div>--%>

            <div id="html_title"></div>

            <div id="html_title_rotation"></div>
            <div id="html_item_title"></div>
            <%--<div class="item-title">
                <ul class="item-1">
                    <li><a href="MNDTShop.aspx">
                        <img class="home"><img></a> </li>
                    <li><a class="item-href" href="#none">最新商品</a> </li>
                </ul>
            </div>

            <asp:Literal runat="server" ID="lt_item_title_html"></asp:Literal>--%>

            <div id="html_item_data"></div>

            <asp:Literal runat="server" ID="lt_hot_item_html"></asp:Literal>

            <div id="html_bottom_rotation"></div>

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
<script src="Scripts/tab.js"></script>
</html>
