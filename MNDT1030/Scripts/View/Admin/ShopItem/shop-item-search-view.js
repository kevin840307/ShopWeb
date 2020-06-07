

function ShopItemSearchView(shopItemSearchPresenter) {
    this.g_shopItemSearchPresenter = shopItemSearchPresenter;
    this.g_sHindFileID = '#file';
    this.g_sFileID = '#btn_file';
    this.g_sListID = '#list';
    this.g_sPageID = '#list_page';
    this.g_sFilterIdProductID = '#filter_product_id';
    this.g_sFilterNameID = '#filter_name';
    this.g_sFilterStatusID = '#filter_status';
    this.g_arrayHtml = [];
}

ShopItemSearchView.prototype = {

    TAG: 'ShopItemSearchView',

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
            that.g_shopItemSearchPresenter.fnInitList();
        }, 300);
    },

    fnGoUrl: function (arg) {
        window.location = 'MNDT1010.aspx' + arg;
    },

    fnShowFilterView: function (filter) {
        $(this.g_sFilterIdProductID).val(filter.product_id.toString());
        $(this.g_sFilterStatusID + ' option[value=' + filter.status.toString() + ']').attr('selected', 'selected');
    },


    fnPushColumns: function (jsonValue) {
        this.g_arrayHtml.push("   <tr> ");
        this.g_arrayHtml.push("      <td><input type='checkbox' class='checkbox-style1' name='checkbox_delete' /> </td> ");
        this.g_arrayHtml.push("      <td class='key'>" + jsonValue.product_id + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.category + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.type + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.fold + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.status + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.create_datetime + "</td> ");
        this.g_arrayHtml.push("      <td class='action'> ");
        this.g_arrayHtml.push("          <div> ");
        this.g_arrayHtml.push("               <button type='button' class='btn-img-style1' onclick='shopItemSearchView.fnOpenEdit(\"" + jsonValue.product_id + "\", \"" + jsonValue.NUM + "\")' ><img src='Image/edit.png' /></button> ");
        this.g_arrayHtml.push("               <button type='button' class='btn-img-style2' onclick='shopItemSearchView.fnDetele(\"" + jsonValue.product_id + "\")'><img src='Image/delete.png' /></button> ");
        this.g_arrayHtml.push("          </div> ");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("   </tr> ");
    },

    fnPushPageNumber: function (name, page, select) {
        this.g_arrayHtml.push("  <li><a class='" + select + "' onclick='shopItemSearchView.fnPageNumberChange(\"" + page + "\")' >" + name + "</a></li> ");
    },

    fnShowEmptyColumns: function () {
        $(this.g_sListID).find('tbody').html(" <tr> <td colspan='7' >無資料顯示</td> </tr> ");
    },

    fnShowList: function () {
        $(this.g_sListID).find('tbody').html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnShowPageNumber: function (name, page, select) {
        $(this.g_sPageID).find('ul').html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnFile: function () {
        $(this.g_sHindFileID).click();
    },

    fnFileChange: function (item) {
        $(this.g_sFileID).text(item.value);
    },

    fnImport: function () {
        var formData = new FormData();
        var files = $(this.g_sHindFileID).get(0).files;

        if (files.length > 0) {
            formData.append("method", "fnImport");
            formData.append("FileUpload", files[0]);
            this.g_shopItemSearchPresenter.fnImport(formData);
        }
    },

    fnMaxPageSizeChange: function (item) {
        this.g_shopItemSearchPresenter.fnMaxPageSizeChange(item.value);
    },

    fnOrderChange: function (value) {
        this.g_shopItemSearchPresenter.fnOrderChange(value);
    },

    fnPageNumberChange: function (value) {
        this.g_shopItemSearchPresenter.fnPageNumberChange(value);
    },

    fnFilterChange: function () {
        var filter = {
            product_id: $(this.g_sFilterIdProductID).val(),
            status: $(this.g_sFilterStatusID).find('option:selected').val(),
        };
        this.g_shopItemSearchPresenter.fnFilterChange(filter);
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
    },

    fnOpenEdit: function (product_id, NUM) {
        var filter = window.location.search.substring(1);
        filter = (filter.length > 0) ? '&' + filter : filter;
        window.location = 'ShopItemEditView.aspx?product_id=' + product_id + '&NUM=' + NUM + filter;
    },

    fnDeteles: function () {
        if (confirm("確定要刪除嗎!")) {
            var sIds = [];
            $(this.g_sListID + ' > tbody > tr').each(function () {
                var sCheck = $(this).find('input[name=\'checkbox_delete\']').attr('checked');
                if (sCheck == 'checked') {
                    sIds.push($(this).find('.key').text());
                }
            });
            shopItemSearchPresenter.fnDeletes(sIds);
        }
    },

    fnDetele: function (key) {
        if (confirm("確定要刪除嗎!")) {
            shopItemSearchPresenter.fnDelete(key);
        }
    }
};

