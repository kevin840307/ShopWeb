

function MaterialEditView(materialEditPresenter) {
    this.g_materialEditPresenter = materialEditPresenter;
    this.g_bTab2FirstInit = true;
    this.g_sTabID = "#tab";
    this.g_sTitleTabSelectID = '#tab1';
    this.g_arrayHtml = [];
}

MaterialEditView.prototype = {
    TAG: 'MaterialEditView',

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
        this.g_materialEditPresenter.fnSelectMaterialId(-1);
    },

    fnNext: function () {
        this.g_materialEditPresenter.fnSelectMaterialId(1);
    },

    //-------------------------------Tab1----------------------

    fnInitializationTab1: function () {
        this.g_sMaterialIdID = '#lab_material_id';
        this.g_sNameID = '#text_name';
        this.g_sCompanyIdID = '#text_company_id';
        this.g_sUnitID = '#text_unit';
        this.g_sCurrencyID = '#text_currency';
        this.g_sPriceID = '#text_price';
        this.g_sShelfLifeID = '#text_shelf_life';
        this.g_sDescriptionID = '#text_description';
        this.g_sStatusID = '#select_status'

        this.g_sCompanyListID = '#company_list';
        this.g_sUnitListID = '#unit_list';
        this.g_sCurrencyListID = '#currency_list';
    },

    fnSetDataView: function (jsonValue) {
        $(this.g_sMaterialIdID).text(jsonValue.material_id);
        $(this.g_sNameID).val(jsonValue.name);
        $(this.g_sCompanyIdID).val(jsonValue.company_id);
        $(this.g_sUnitID).val(jsonValue.unit);
        $(this.g_sCurrencyID).val(jsonValue.currency);
        $(this.g_sPriceID).val(jsonValue.price);
        $(this.g_sShelfLifeID).val(jsonValue.shelf_life);
        $(this.g_sDescriptionID).val(jsonValue.description);
        $(this.g_sStatusID + ' option[value=' + jsonValue.status + ']').attr('selected', 'selected');
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
            material_id: $(this.g_sMaterialIdID).text(),
            name: $(this.g_sNameID).val(),
            company_id: $(this.g_sCompanyIdID).val(),
            unit: $(this.g_sUnitID).val(),
            currency: $(this.g_sCurrencyID).val(),
            price: $(this.g_sPriceID).val(),
            shelf_life: $(this.g_sShelfLifeID).val(),
            description: $(this.g_sDescriptionID).val(),
            status: $(this.g_sStatusID).find('option:selected').val()
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
        this.g_arrayHtml.push("      <td>" + jsonValue.create_id + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.status + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.ip + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.create_datetime + "</td> ");
        this.g_arrayHtml.push("   </tr> ");
    },

    fnPushTranPageNumber: function (name, page, select) {
        this.g_arrayHtml.push("  <li><a class='" + select + "' onclick='materialEditView.fnPageNumberChange(\"" + page + "\")' >" + name + "</a></li> ");
    },

    fnShowTranList: function () {
        $(this.g_sTab2ListID).find('tbody').html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnShowTranEmptyColumns: function () {
        $(this.g_sTab2ListID).find('tbody').html(" <tr> <td colspan='4' >無資料顯示</td> </tr> ");
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

