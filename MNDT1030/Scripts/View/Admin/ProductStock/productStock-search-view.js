

function ProductStockSearchView(productStockSearchPresenter) {
    this.g_productStockSearchPresenter = productStockSearchPresenter;
    this.g_sHindFileID = '#file';
    this.g_sFileID = '#btn_file';
    this.g_sListID = '#list';
    this.g_sPageID = '#list_page';
    this.g_sFilterProductIdID = '#filter_product_id';
    this.g_sFilterWarehouseIdID = '#filter_warehouse_id';
    this.g_arrayHtml = [];
}

ProductStockSearchView.prototype = {

    TAG: 'ProductStockSearchView',

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
            that.g_productStockSearchPresenter.fnInitList();
        }, 300);
    },

    fnGoUrl: function (arg) {
        window.location = 'MNDT1010.aspx' + arg;
    },

    fnShowFilterView: function (filter) {
        $(this.g_sFilterProductIdID).val(filter.product_id.toString());
        $(this.g_sFilterNameID).val(filter.warehouse_id.toString());
    },

    fnPushColumns: function (jsonValue) {
        this.g_arrayHtml.push("   <tr> ");
        this.g_arrayHtml.push("      <td class='key'>" + jsonValue.warehouse_id + "</td> ");
        this.g_arrayHtml.push("      <td class='key'>" + jsonValue.product_id + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.amount + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.safe_amount + "</td> ");
        this.g_arrayHtml.push("      <td class='action'> ");
        this.g_arrayHtml.push("          <div> ");
        this.g_arrayHtml.push("               <button type='button' class='btn-img-style1' onclick='productStockSearchView.fnOpenEdit(\"" + jsonValue.product_id + "\", \"" + jsonValue.warehouse_id + "\", \"" + jsonValue.NUM + "\")' ><img src='Image/edit.png' /></button> ");
        this.g_arrayHtml.push("          </div> ");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("   </tr> ");
    },

    fnPushPageNumber: function (name, page, select) {
        this.g_arrayHtml.push("  <li><a class='" + select + "' onclick='productStockSearchView.fnPageNumberChange(\"" + page + "\")' >" + name + "</a></li> ");
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
            this.g_productStockSearchPresenter.fnImport(formData);
        }
    },

    fnMaxPageSizeChange: function (item) {
        this.g_productStockSearchPresenter.fnMaxPageSizeChange(item.value);
    },

    fnOrderChange: function (value) {
        this.g_productStockSearchPresenter.fnOrderChange(value);
    },

    fnPageNumberChange: function (value) {
        this.g_productStockSearchPresenter.fnPageNumberChange(value);
    },

    fnFilterChange: function () {
        var filter = {
            product_id: $(this.g_sFilterProductIdID).val(),
            warehouse_id: $(this.g_sFilterWarehouseIdID).val()
        };
        this.g_productStockSearchPresenter.fnFilterChange(filter);
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

    fnOpenEdit: function (product_id, warehouse_id, NUM) {
        var filter = window.location.search.substring(1);
        filter = (filter.length > 0) ? '&' + filter : filter;
        window.location = 'ProductStockEditView.aspx?warehouse_id=' + warehouse_id + '&product_id=' + product_id + '&NUM=' + NUM + filter;
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
            productStockSearchPresenter.fnDeletes(sIds);
        }
    },

    fnDetele: function (key) {
        if (confirm("確定要刪除嗎!")) {
            productStockSearchPresenter.fnDelete(key);
        }
    }
};

