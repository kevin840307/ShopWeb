

function MaterialStockEditView(materialEditPresenter) {
    this.g_materialEditPresenter = materialEditPresenter;
    this.g_bTab2FirstInit = true;
    this.g_sTabID = "#tab";
    this.g_sTitleTabSelectID = '#tab1';
    this.g_arrayHtml = [];
}

MaterialStockEditView.prototype = {
    TAG: 'MaterialStockEditView',

    fnInitialization: function () {
        this.g_bTab2FirstInit = true;
    },

    fnErrorMessage: function (msg) {
        fnErrorMessage(msg);
    },

    fnGeneralMessage: function (msg) {
        fnGeneralMessage(msg);
    },

    fnTitleTabEvent: function (item) {
        $(this.g_sTitleTabSelectID).removeClass('select');
        $(item).addClass('select');

        $(this.g_sTitleTabSelectID + '_content').addClass('hide');
        $('#' + item.id + '_content').removeClass('hide');

        this.g_sTitleTabSelectID = '#' + item.id;
        this.fnTabChangeEvent(item.id)
    },

    fnTabChangeEvent: function (type) {
        switch (type) {
            case 'tab1':
                //this.g_materialEditPresenter.fnInitializationTab1();
                break;
            case 'tab2':
                if (this.g_bTab2FirstInit) {
                    this.g_materialEditPresenter.fnInitializationTab2();
                    this.g_bTab2FirstInit = false;
                }
                break;
        }
    },

    fnLast: function () {
        this.g_materialEditPresenter.fnSelectNextId(-1);
    },

    fnNext: function () {
        this.g_materialEditPresenter.fnSelectNextId(1);
    },

    //-------------------------------Tab1----------------------

    fnInitializationTab1: function () {
        this.g_sWarehouseIdID = '#lab_warehouse_id';
        this.g_sMaterialIdID = '#lab_material_id';
        this.g_sSafeAmountID = '#text_safe_amount';
        this.g_sAmountID = '#text_amount';
        this.g_sDescriptionID = '#text_description';

    },

    fnSetDataView: function (jsonValue) {
        $(this.g_sMaterialIdID).text(jsonValue.material_id);
        $(this.g_sWarehouseIdID).text(jsonValue.warehouse_id);
        $(this.g_sSafeAmountID).val(jsonValue.safe_amount);
        $(this.g_sAmountID).val(jsonValue.amount);
        $(this.g_sDescriptionID).val(jsonValue.description);
    },

    fnPushSelectList: function (jsonValue) {
        this.g_arrayHtml.push(" <option label='" + jsonValue.name + "' value='" + jsonValue.value + "' /> ");
    },

    fnShowCompanyList: function () {
        $(this.g_sCompanyListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnShowUnitList: function () {
        $(this.g_sUnitListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnShowCurrencyList: function () {
        $(this.g_sCurrencyListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnTab1Update: function (event) {
        event.preventDefault();

        var update = {
            method: "fnUpdate",
            warehouse_id: $(this.g_sWarehouseIdID).text(),
            material_id: $(this.g_sMaterialIdID).text(),
            safe_amount: $(this.g_sSafeAmountID).val(),
            amount: $(this.g_sAmountID).val(),
            description: $(this.g_sDescriptionID).val()
        }
        this.g_materialEditPresenter.fnTab1Update(update);
    },


    //--------------------------------------Tab2------------------------------


    fnInitializationTab2: function () {
        this.g_sTab2ListID = '#list';
        this.g_sTab2PageID = '#list_page';
    },

    fnTab2ChangeUrl: function (arg) {
        fnLoading();
        var that = this;
        window.history.pushState('', 'uselessTitle', arg);
        setTimeout(function () {
            that.g_materialEditPresenter.fnInitializationTab2();
        }, 300);
    },

    fnPushTranColumns: function (jsonValue) {
        this.g_arrayHtml.push("   <tr> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.tran_amount + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.description + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.create_datetime + "</td> ");
        this.g_arrayHtml.push("   </tr> ");
    },

    fnPushTranPageNumber: function (name, page, select) {
        this.g_arrayHtml.push("  <li><a class='" + select + "' onclick='materialStockEditView.fnPageNumberChange(\"" + page + "\")' >" + name + "</a></li> ");
    },

    fnShowTranList: function () {
        $(this.g_sTab2ListID).find('tbody').html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnShowTranEmptyColumns: function () {
        $(this.g_sTab2ListID).find('tbody').html(" <tr> <td colspan='3' >無資料顯示</td> </tr> ");
    },

    fnShowTranPageNumber: function (name, page, select) {
        $(this.g_sTab2PageID).find('ul').html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnMaxPageSizeChange: function (item) {
        this.g_materialEditPresenter.fnMaxPageSizeChange(item.value);
    },

    fnPageNumberChange: function (value) {
        this.g_materialEditPresenter.fnPageNumberChange(value);
    },

    fnTab2Refresh: function () {
        this.g_materialEditPresenter.fnInitializationTab2();
    }

};

