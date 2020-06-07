function ProductSearchView(productSearchPresenter) {
    this.g_productSearchPresenter = productSearchPresenter;
    this.g_sListID = '#list';
    this.g_sPageID = '#list_page';
    this.g_sFilterCompanyIdID = '#filter_company_id';
    this.g_sFilterNameID = '#filter_name';
    this.g_sFilterProductIdID = '#filter_product_id';
    this.g_arrayHtml = [];
}

ProductSearchView.prototype = {
    TAG: 'ProductSearchView',

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
            that.g_productSearchPresenter.fnInitList();
        }, 300);
    },

    fnShowFilterView: function (filter) {
        $(this.g_sFilterCompanyIdID).val(filter.company_id.toString());
        $(this.g_sFilterProductIdID).val(filter.product_id.toString());
        $(this.g_sFilterNameID).val(filter.name.toString());
    },

    fnPushColumns: function (jsonValue) {
        this.g_arrayHtml.push("   <tr> ");
        this.g_arrayHtml.push("      <td class='key'>" + jsonValue.product_id + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.company_id + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.name + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.create_datetime + "</td> ");
        this.g_arrayHtml.push("      <td class='action'> ");
        this.g_arrayHtml.push("          <div> ");
        this.g_arrayHtml.push("               <button type='button' class='btn-img-style1' onclick='productSearchView.fnOpenEdit(\"" + jsonValue.product_id + "\", \"" + jsonValue.NUM + "\")' ><img src='Image/edit.png' /></button> ");
        this.g_arrayHtml.push("               <button type='button' class='btn-img-style2' onclick='productSearchView.fnDetele(\"" + jsonValue.product_id + "\")'><img src='Image/delete.png' /></button> ");
        this.g_arrayHtml.push("          </div> ");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("   </tr> ");
    },

    fnPushPageNumber: function (name, page, select) {
        this.g_arrayHtml.push("  <li><a class='" + select + "' onclick='productSearchView.fnPageNumberChange(\"" + page + "\")' >" + name + "</a></li> ");
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
            product_id: $(this.g_sFilterProductIdID).val(),
            company_id: $(this.g_sFilterCompanyIdID).val(),
            name: $(this.g_sFilterNameID).val()
        };
        this.g_productSearchPresenter.fnFilterChange(filter);
    },

    fnMaxPageSizeChange: function (item) {
        this.g_productSearchPresenter.fnMaxPageSizeChange(item.value);
    },

    fnOrderChange: function (value) {
        this.g_productSearchPresenter.fnOrderChange(value);
    },

    fnPageNumberChange: function (value) {
        this.g_productSearchPresenter.fnPageNumberChange(value);
    },

    fnDetele: function (id) {
        if (confirm("確定要刪除嗎!")) {
            productSearchPresenter.fnDelete(id);
        }
    },

    fnOpenEdit: function (product_id, NUM) {
        var filter = window.location.search.substring(1);
        filter = (filter.length > 0) ? '&' + filter : filter;
        window.location = 'ProductEditView.aspx?product_id=' + product_id + '&NUM=' + NUM + filter;
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