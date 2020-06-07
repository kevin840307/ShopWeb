

function ProductInsertView(productInsertPresenter) {
    this.g_productInsertPresenter = productInsertPresenter;
    this.g_sProductIdID = '#text_product_id';
    this.g_sNameID = '#text_name';
    this.g_sCompanyIdID = '#text_company_id';
    this.g_sUnitID = '#text_unit';
    this.g_sCurrencyID = '#text_currency';
    this.g_sCostID = '#text_cost';
    this.g_sPriceID = '#text_price';
    this.g_sShelfLifeID = '#text_shelf_life';
    this.g_sDescriptionID = '#text_description';

    this.g_sCompanyListID = '#company_list';
    this.g_sUnitListID = '#unit_list';
    this.g_sCurrencyListID = '#currency_list';

    this.g_sTabID = "#tab";
    this.g_bFirstInit = true;
    this.g_sTitleTabSelectID = '#tab1';
    this.g_arrayHtml = [];
}

ProductInsertView.prototype = {
    TAG: 'ProductInsertView',

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
                break;
        }
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

    fnInsert: function (event) {
        event.preventDefault();
        var insert = {
            method: "fnInsert",
            product_id: $(this.g_sProductIdID).val(),
            name: $(this.g_sNameID).val(),
            company_id: $(this.g_sCompanyIdID).val(),
            unit: $(this.g_sUnitID).val(),
            currency: $(this.g_sCurrencyID).val(),
            cost: $(this.g_sCostID).val(),
            price: $(this.g_sPriceID).val(),
            shelf_life: $(this.g_sShelfLifeID).val(),
            description: $(this.g_sDescriptionID).val()
        };
        this.g_productInsertPresenter.fnInsert(insert);
    }
};

