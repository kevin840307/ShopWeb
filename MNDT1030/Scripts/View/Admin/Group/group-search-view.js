function GroupSearchView(groupSearchPresenter) {
    this.g_groupSearchPresenter = groupSearchPresenter;
    this.g_sListID = '#list';
    this.g_sPageID = '#list_page';
    this.g_sFilterIdID = '#filter_id';
    this.g_sFilterAccountID = '#filter_account';
    this.g_sFilterNameID = '#filter_name';
    this.g_sFilterGroupIdID = '#filter_group_id';
    this.g_arrayHtml = [];
}

GroupSearchView.prototype = {
    TAG: 'GroupSearchView',

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
            that.g_groupSearchPresenter.fnInitList();
        }, 300);
    },

    fnShowFilterView: function (filter) {
        $(this.g_sFilterIdID).val(filter.id.toString());
        $(this.g_sFilterGroupIdID).val(filter.group_id.toString());
        $(this.g_sFilterAccountID).val(filter.account.toString());
        $(this.g_sFilterNameID).val(filter.name.toString());
    },

    fnPushColumns: function (jsonValue) {
        this.g_arrayHtml.push("   <tr> ");
        this.g_arrayHtml.push("      <td class='key'>" + jsonValue.group_id + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.name + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.create_datetime + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.modify_datetime + "</td> ");
        this.g_arrayHtml.push("      <td class='action'> ");
        this.g_arrayHtml.push("          <div> ");
        this.g_arrayHtml.push("               <button type='button' class='btn-img-style1' onclick='groupSearchView.fnOpenEdit(\"" + jsonValue.group_id + "\", \"" + jsonValue.NUM + "\")' ><img src='Image/edit.png' /></button> ");
        this.g_arrayHtml.push("               <button type='button' class='btn-img-style2' onclick='groupSearchView.fnDetele(\"" + jsonValue.group_id + "\")'><img src='Image/delete.png' /></button> ");
        this.g_arrayHtml.push("          </div> ");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("   </tr> ");
    },

    fnPushPageNumber: function (name, page, select) {
        this.g_arrayHtml.push("  <li><a class='" + select + "' onclick='groupSearchView.fnPageNumberChange(\"" + page + "\")' >" + name + "</a></li> ");
    },

    fnShowEmptyColumns: function () {
        $(this.g_sListID).find('tbody').html(" <tr> <td colspan='5' >無資料顯示</td> </tr> ");
    },

    fnShowList: function () {
        $(this.g_sListID).find('tbody').html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnShowPageNumber: function (name, page, select) {
        $(this.g_sPageID).find('ul').html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnFilterChange: function() {
        var filter = {
            group_id: $(this.g_sFilterGroupIdID).val(),
            id: $(this.g_sFilterIdID).val(),
            account: $(this.g_sFilterAccountID).val(),
            name: $(this.g_sFilterNameID).val()
        };
        this.g_groupSearchPresenter.fnFilterChange(filter);
    },

    fnMaxPageSizeChange: function (item) {
        this.g_groupSearchPresenter.fnMaxPageSizeChange(item.value);
    },

    fnOrderChange: function (value) {
        this.g_groupSearchPresenter.fnOrderChange(value);
    },

    fnPageNumberChange: function (value) {
        this.g_groupSearchPresenter.fnPageNumberChange(value);
    },

    fnDetele: function (id) {
        if (confirm("確定要刪除嗎!")) {
            groupSearchPresenter.fnDelete(id);
        }
    },

    fnOpenEdit: function (group_id, NUM) {
        var filter = window.location.search.substring(1);
        filter = (filter.length > 0) ? '&' + filter : filter;
        window.location = 'GroupEditView.aspx?group_id=' + group_id + '&NUM=' + NUM + filter;
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