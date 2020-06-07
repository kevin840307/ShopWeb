
Date.prototype.Formate = function (format) {
    var sMonth = this.getMonth() + 1; 
    var sDay = this.getDate();

    return format.replace('yyyy', this.getFullYear())
          .replace('MM', (sMonth > 9 ? '' : '0') + sMonth)
          .replace('DD', (sDay > 9 ? '' : '0') + sDay)
};

function fnGetQuery(name, empty) {
    var sallvars = window.location.search.substring(1);
    var svars = sallvars.split("&");
    for (i = 0; i < svars.length; i++) {
        var svar = svars[i].split("=");
        if (svar[0] == name) return decodeURI(svar[1]);
    }
    return empty;
    //var reg = new regexp("(^|&)" + name + "=([^&]*)(&|$)");
    //var r = window.location.search.substr(1).match(reg);
    //if (r != null)
    //    return decodeuri(r[2]);
    //return "";

}

function fnGetUpdateQuery(name, arg) {
    var sQuery = "";
    var bHasName = false;
    var sAllVars = window.location.search.substring(1);
    var sVars = sAllVars.split("&");

    for (i = 0; i < sVars.length; i++) {
        var sVar = sVars[i].split("=");
        if (sVar[0].length > 0) {
            if (sVar[0] == name) {
                sQuery += sVar[0] + "=" + arg + "&";
                bHasName = true;
            } else {
                sQuery += sVar[0] + "=" + sVar[1] + "&";
            }
        }
    }

    if (!bHasName) {
        sQuery += name + "=" + arg;
    } else {
        sQuery = sQuery.substring(0, sQuery.length - 1);
    }

    return sQuery;
}

function fnUpdateQuery(args, name, arg) {
    var sQuery = "";
    var bHasName = false;
    var sVars = args.split("&");

    for (i = 0; i < sVars.length; i++) {
        var sVar = sVars[i].split("=");
        if (sVar[0].length > 0) {
            if (sVar[0] == name) {
                sQuery += sVar[0] + "=" + arg + "&";
                bHasName = true;
            } else {
                sQuery += sVar[0] + "=" + sVar[1] + "&";
            }
        }
    }

    if (!bHasName) {
        sQuery += name + "=" + arg;
    } else {
        sQuery = sQuery.substring(0, sQuery.length - 1);
    }

    return sQuery;
}

function fnEmptyChange(value, empty) {
    if (value.length > 0) {
        return value;
    } else {
        return empty;
    }
}

function fnToMNDT(value) {
    return value.toString().replace('%', 'MNDT');
}

function fnFixMNDT(value) {
    return value.toString().replace('MNDT', '%');
}

/*--------------------------------ScrollEvent-----------------------------------------*/

// scrollID 註冊此滾輪
// moveID 要移動的ID
// exceedDivID 超過此ID則移動
// offset 離上方距離
function addScrollTopEvent(scrollID, moveID, exceedDivID, offset) {

    $(scrollID).scroll(function () {

        var that = $(this);
        if (that.width() > 720) {
            clearTimeout($.data(this, 'scrollTimer'));
            var iexceedTop = $(exceedDivID).offset().top;
            if (iexceedTop < that.scrollTop()) {
                $.data(this, 'scrollTimer', setTimeout(function () {
                    $(moveID).animate({ 'margin-top': that.scrollTop() - iexceedTop + offset }, 600, 'swing');
                }, 250));
            } else {
                $.data(this, 'scrollTimer', setTimeout(function () {
                    $(moveID).animate({ 'margin-top': 0 }, 600, 'swing');
                }, 250));
            }
        }
    });
}

/*------------------------------------------PublicView-------------------------------*/
function fnLoading() {
    $('#loading').fadeIn(300);
}

function fnLoaded() {
    $('#loading').fadeOut(600);
}

function fnOpenView(id) {
    $(id).fadeIn();
}

function fnCloseView(id) {
    $(id).fadeOut();
}

/*-------------------------------------------CheckBox--------------------------------*/

function fnBoolToCheckBox(value) {
    return (value.toString() == 'true') ? "checked" : "";
}