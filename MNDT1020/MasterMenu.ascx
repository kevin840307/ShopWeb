<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MasterMenu.ascx.cs" Inherits="MasterMenu" %>

<link href="Css/menu.css" rel="stylesheet" />
<link href="Css/size.css" rel="stylesheet" />
<script>
    //function hide_show_menu() {
    //    var sCheck = $("#a_show_hide").text();
    //    if (sCheck == '顯示') {
    //        $(".menu").show(1000);
    //        $("#a_show_hide").text('隱藏');
    //    }
    //    else if (sCheck == '隱藏') {
    //        $(".menu").hide(1000);
    //        $("#a_show_hide").text('顯示');
    //    }
    //}

    function menu_hide() {
        $(".menu").hide(1000);
    }

    function menu_show() {
        $(".menu").show(1000);
    }

    $(function () {

        //var sSelect = "";
        //var sNowHref = location.href.toString().substring(location.href.indexOf("MNDT"), location.href.indexOf("MNDT") + 8);
        //if (location.href.indexOf("MNDT10") > 0) {
        //    sSelect = ".MNDT0001";
        //} else if (location.href.indexOf("MNDT20") > 0) {
        //    sSelect = ".MNDT0002";
        //}
        //if (sSelect != "") {
        //    $(sSelect + " > a").find('i').addClass('down')   //小箭头向下样式
        //        .parent().next().slideDown('fast');  //下一个元素显示
        //    $("." + sNowHref + "").addClass('select_style1');
        //    $("." + sNowHref + "").find('a').addClass('select_style1');
        //}

        $(".level1 > a").click(function () {
            if ($(this).hasClass('current')) {
                $(this).find('i').removeClass('down').parent().next().slideUp('slow');
                $(this).removeClass('current');
            } else {
                $(this).addClass('current')   //给当前元素添加"current"样式
                .find('i').addClass('down')   //小箭头向下样式
                .parent().next().slideDown('slow')  //下一个元素显示
                .parent().siblings().removeClass('current').children('a').removeClass('current')//父元素的兄弟元素的子元素去除"current"样式
                .find('i').removeClass('down').parent().next().slideUp('slow');//隐藏
            }

            return false; //阻止默认时间
        });
    })
</script>
<div class="treebox">

    <asp:Literal ID="lt_html" runat="server"></asp:Literal>
    <%--    <div class="hide">
        <a id="a_show_hide" onclick="hide_show_menu()">隱藏</a>
    </div>--%>
    <div class="hide">
        <asp:UpdatePanel runat="server">
            <ContentTemplate>
                <asp:LinkButton runat="server" ID="link_show_hide" OnClick="link_show_hide_Click" Text="隱藏"></asp:LinkButton>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</div>
<asp:Literal ID="Literal1" runat="server"></asp:Literal>


