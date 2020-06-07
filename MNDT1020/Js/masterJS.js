//function hide() {
//    $(".search_panel").slideUp(2000);
//}

var g_vPrevRow = null;
function select_row(row, sOver, sOut) {
    if (g_vPrevRow != null) {
        g_vPrevRow.style.backgroundColor = sOut;
    }
    row.style.backgroundColor = sOver;
    g_vPrevRow = row;
}

function HideError() {
    $("#errors").hide(3000);
}

function ShowError2() {

    location.href = location.href.toString().substring(location.href.indexOf("MNDT"), location.href.indexOf("MNDT") + 13) + "#errors";
    //$("#errors").show(1000);
    //setTimeout(HideError, 5000);
}

function ShowError(msg) {
    document.getElementById('lab_m_error').innerHTML = msg;
    location.href = location.href.toString().substring(location.href.indexOf("MNDT"), location.href.indexOf("MNDT") + 13) + "#errors";
    //$("#errors").show(1000);
    //setTimeout(HideError, 5000);
}

function save_move_bottom() {
    $('.div-scroll').animate({ scrollTop: 2000 }, 'slow');
}

function save_move_select(value) {
    $('.div-scroll').animate({ scrollTop: value }, 'fast');
}

function HideMessage() {
    $("#message").hide(1500);
}

function ShowMessage2() {
    $("#message").show(1000);
    setTimeout("HideMessage()", 4000);
}

function ShowMessage(msg) {
    document.getElementById('lab_message').innerText = msg;
    $("#message").show(1000);
    setTimeout("HideMessage()", 4000);
}

function auto_move() {
    var scrollVal = $('.div-scroll').scrollTop();
    setTimeout("save_move_select('" + scrollVal + "')", 600);
}

function set_scroll() {
    //$(".div-scroll").css("height", screen.height - (screen.height * 231 / screen.height));
    $(".div-scroll-size1").css("height", screen.height - (screen.height * 231 / screen.height));
    $(".div-scroll-size5").css("height", screen.height - (screen.height * 240 / screen.height));
    $(".div-scroll-size2").css("height", screen.height - (screen.height * 275 / screen.height));
    $(".div-scroll-size4").css("height", screen.height - (screen.height * 305 / screen.height));
    $(".div-scroll-size3").css("height", screen.height / 2.95);
    $(".div-scroll-size6").css("height", screen.height / 2.1);
}

$(function () {
    //$(".ss").css('height', $('html').height() - $(".search-table").height() - 200);
    $(window).keydown(function (e) {
        switch (e.keyCode) {
            case 113: //F2
                $('[id$=btn_insert]').click();
                break;
            case 114: //F3
                $('[id$=btn_print]').click();
                break;
            case 115: //F4
                $('[id$=btn_export]').click();
                break;
            case 118: //F7
                $('[id$=btn_cancel]').click();
                $("#ContentPlaceHolder1_fv_master_form_btn_master_cancel").click();
                $("#ContentPlaceHolder1_btn_detail_cancel").click();
                break;
        }
    });


    //$(window).resize(function () {
    //    var scrollVal = $(this).scrollTop();
    //    var s = $(window).height() + scrollVal + "px";
    //    $('html').css('height', s);
    //    $('body').css('height', s);
    //});
    //$(window).scroll(function () {
    //    var scrollVal = $(this).scrollTop();
    //    var s = $(window).height() + scrollVal + "px";
    //    $('html').css('height', s);
    //    $('body').css('height', s);
    //});
});



//$(function () {
//    setTimeout(show_title());
//});
//function show_title() {
//    $(".table-size4").slideDown(500)
//};
