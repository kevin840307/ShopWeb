// 初始化menu 
(function ($) {

    $.fn.menu = function (options) {
        var settings = $.extend({
            menu_div: '#menu-div',
            data: null
        }, options);
        var sMenuHtml = "";

        fnInitMenu();

        function fnInitMenu() {
            var refParam = {
                iIndex: 0,
                jsonValues: jQuery.parseJSON(JSON.stringify(settings.data))
            };
            sMenuHtml += " <ul id='menu'> ";
            sMenuHtml += fnGetNextMenu(refParam, "ROOT");
            sMenuHtml += " </ul> ";
            document.getElementById(settings.menu_div).innerHTML = sMenuHtml;
            fnInitEvent();
        }

        function fnGetNextMenu(refParam, sParent) {
            var sHtml = "";
            while (refParam.iIndex < refParam.jsonValues.length) {
                var jsonValue = $.parseJSON(JSON.stringify(refParam.jsonValues[refParam.iIndex]));
                if (jsonValue.parent == sParent) {
                    sHtml += " <li> ";
                    refParam.iIndex += 1;
                    sHtml += fnGetMenuStyle11Html(jsonValue);
                    if (jsonValue.url.indexOf('#') > -1) {
                        sHtml += "  <ul class='u-up'> ";
                        sHtml += fnGetNextMenu(refParam, jsonValue.program_id)
                        sHtml += "  </ul> ";
                    }
                    sHtml += " </li> ";
                } else {
                    return sHtml;
                }
            }
            return sHtml;
        }


        function fnGetMenuStyle11Html(jsonValue) {
            var sHtml = "";
            var sIcon = "icon-" + jsonValue.program_id.substring(1, 2);
            sHtml += " <a id='" + jsonValue.url.toString().replace('.aspx', '') + "' href='" + jsonValue.url + "' class='parent up'> ";
            sHtml += "  <i class='" + sIcon + "'></i> ";
            sHtml += "  <span>" + jsonValue.name + "</span> ";
            sHtml += " </a> ";
            return sHtml;
        }

        function fnInitEvent() {
            $(".parent").click(function () {
                if ($(this).hasClass("up")) {
                    $(this).addClass("down");
                    $(this).removeClass("up");
                    $(this).parent().find(" > ul").slideDown('fast');
                } else if ($(this).hasClass("down")) {
                    $(this).addClass("up");
                    $(this).removeClass("down");
                    $(this).parent().find(" > ul").slideUp('fast');
                }
            });

            var selectId = '#' + window.location.pathname.substring(1, window.location.pathname.length - 5);
            var perent = $(selectId).parent().parent().parent();
            $(selectId).addClass('select');
            perent.find(" > .parent").addClass("down");
            perent.find(" > .parent").removeClass("up");
            perent.find(" > ul").slideDown('fast');
        }
    };
}(jQuery));