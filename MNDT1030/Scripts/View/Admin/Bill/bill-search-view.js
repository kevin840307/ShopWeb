

function BillSearchView(billSearchPresenter) {
    this.g_billSearchPresenter = billSearchPresenter;
    this.g_sHindFileID = '#file';
    this.g_sFileID = '#btn_file';
    this.g_sListID = '#list';
    this.g_sPageID = '#list_page';
    this.g_sFilterCompanyIdID = '#filter_company_id';
    this.g_sFilterDateSID = '#filter_date_S';
    this.g_sFilterDateEID = '#filter_date_E';
    this.g_arrayHtml = [];
}

BillSearchView.prototype = {

    TAG: 'BillSearchView',

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
            that.g_billSearchPresenter.fnInitList();
        }, 300);
    },

    fnGoUrl: function (arg) {
        window.location = 'MNDT1010.aspx' + arg;
    },

    fnShowFilterView: function (filter) {
        var date = new Date();

        $(this.g_sFilterCompanyIdID).val(filter.company_id.toString());

        if (filter.date_S.toString().length > 0) {
            $(this.g_sFilterDateSID).val(filter.date_S.toString());
        } else {
            $(this.g_sFilterDateSID).val(date.Formate("yyyy-MM-DD"));
        }

        if (filter.date_E.toString().length > 0) {
            $(this.g_sFilterDateEID).val(filter.date_E.toString());
        } else {
            $(this.g_sFilterDateEID).val(date.Formate("yyyy-MM-DD"));
        }
    },

    fnPushColumns: function (jsonValue) {
        this.g_arrayHtml.push("   <tr> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.company_id + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.material_id + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.amount + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.price + "</td> ");
        this.g_arrayHtml.push("   </tr> ");
    },

    fnPushPageNumber: function (name, page, select) {
        this.g_arrayHtml.push("  <li><a class='" + select + "' onclick='billSearchView.fnPageNumberChange(\"" + page + "\")' >" + name + "</a></li> ");
    },

    fnShowEmptyColumns: function () {
        $(this.g_sListID).find('tbody').html(" <tr> <td colspan='4' >無資料顯示</td> </tr> ");
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
            this.g_billSearchPresenter.fnImport(formData);
        }
    },

    fnMaxPageSizeChange: function (item) {
        this.g_billSearchPresenter.fnMaxPageSizeChange(item.value);
    },

    fnOrderChange: function (value) {
        this.g_billSearchPresenter.fnOrderChange(value);
    },

    fnPageNumberChange: function (value) {
        this.g_billSearchPresenter.fnPageNumberChange(value);
    },

    fnFilterChange: function () {
        var filter = {
            company_id: $(this.g_sFilterCompanyIdID).val(),
            date_S: $(this.g_sFilterDateSID).val(),
            date_E: $(this.g_sFilterDateEID).val()
        };
        this.g_billSearchPresenter.fnFilterChange(filter);
    }
};

