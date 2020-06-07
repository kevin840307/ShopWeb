function SReturnSearchView(sreturnSearchPresenter) {
    this.g_sreturnSearchPresenter = sreturnSearchPresenter;
    this.g_sListID = '#list';
    this.g_sPageID = '#list_page';
    this.g_sFilterReturnIdID = '#filter_return_id';
    this.g_sFilterOrderIdID = '#filter_order_id';
    this.g_sFilterIdID = '#filter_id';
    this.g_sFilterDateTimeID = '#filter_datetime';

    this.g_arrayHtml = [];
}

SReturnSearchView.prototype = {
    TAG: 'SReturnSearchView',

    fnInitialization: function () {

    },

    fnErrorMessage: function (msg) {
        fnErrorMessage(msg);
    },

    fnGeneralMessage: function (msg) {
        fnGeneralMessage(msg);
    },

    fnChangeUrl: function (arg) {
        var that = this;
        fnLoading();
        window.history.pushState('', 'uselessTitle', arg);
        setTimeout(function () {
            that.g_sreturnSearchPresenter.fnInitList();
        }, 300);
    },

    fnShowFilterView: function (filter) {
        $(this.g_sFilterReturnIdID).val(filter.return_id.toString());
        $(this.g_sFilterOrderIdID).val(filter.order_id.toString());
        $(this.g_sFilterIdID).val(filter.id.toString());
        $(this.g_sFilterDateTimeID).val(filter.datetime.toString());
    },

    fnPushColumns: function (jsonValue) {
        this.g_arrayHtml.push("   <tr> ");
        this.g_arrayHtml.push("      <td class='key'>" + jsonValue.return_id + "</td> ");
        this.g_arrayHtml.push("      <td class='key'>" + jsonValue.order_id + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.id + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.datetime + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.complete + "</td> ");
        this.g_arrayHtml.push("      <td class='action'> ");
        this.g_arrayHtml.push("          <div> ");
        this.g_arrayHtml.push("               <button type='button' class='btn-img-style1' onclick='sreturnSearchView.fnOpenEdit(\"" + jsonValue.return_id + "\", \"" + jsonValue.NUM + "\")' ><img src='Image/edit.png' /></button> ");
        this.g_arrayHtml.push("               <button type='button' class='btn-img-style2' onclick='sreturnSearchView.fnDetele(\"" + jsonValue.return_id + "\")'><img src='Image/delete.png' /></button> ");
        this.g_arrayHtml.push("          </div> ");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("   </tr> ");
    },

    fnPushPageNumber: function (name, page, select) {
        this.g_arrayHtml.push("  <li><a class='" + select + "' onclick='sreturnSearchView.fnPageNumberChange(\"" + page + "\")' >" + name + "</a></li> ");
    },

    fnShowEmptyColumns: function () {
        $(this.g_sListID).find('tbody').html(" <tr> <td colspan='6' >無資料顯示</td> </tr> ");
    },

    fnShowList: function () {
        $(this.g_sListID).find('tbody').html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnShowPageNumber: function (name, page, select) {
        $(this.g_sPageID).find('ul').html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnFilterChange: function () {
        var filter = {
            return_id: $(this.g_sFilterReturnIdID).val(),
            order_id: $(this.g_sFilterOrderIdID).val(),
            id: $(this.g_sFilterIdID).val(),
            datetime: $(this.g_sFilterDateTimeID).val()
        };

        this.g_sreturnSearchPresenter.fnFilterChange(filter);
    },

    fnMaxPageSizeChange: function (item) {
        this.g_sreturnSearchPresenter.fnMaxPageSizeChange(item.value);
    },

    fnOrderChange: function (value) {
        this.g_sreturnSearchPresenter.fnOrderChange(value);
    },

    fnPageNumberChange: function (value) {
        this.g_sreturnSearchPresenter.fnPageNumberChange(value);
    },

    fnDetele: function (id) {
        if (confirm("確定要刪除嗎!")) {
            sreturnSearchPresenter.fnDelete(id);
        }
    },

    fnOpenEdit: function (return_id, NUM) {
        var filter = window.location.search.substring(1);
        filter = (filter.length > 0) ? '&' + filter : filter;
        window.location = 'SReturnEditView.aspx?return_id=' + return_id + '&NUM=' + NUM + filter;
    },

    fnInitListEvent: function () {
        var that = this;
        var bClose = true;

        // List其他下拉
        $('.drop-other').focus(function () {
            $(this).parent().find('> ul').slideDown(200);
        });

        $('.drop-other').focusout(function () {
            if (bClose) {
                $(this).parent().find('> ul').slideUp(50);
            }
        });

        $('.action li').mouseover(function () {
            bClose = false;
        });

        $('.action li').mouseout(function () {
            bClose = true;
        });

        $('.action li').click(function () {
            $(this).parent().slideUp(50);
        });
    }
}