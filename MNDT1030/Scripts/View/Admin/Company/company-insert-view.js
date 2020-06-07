

function CompanyInsertView(companyInsertPresenter) {
    this.g_companyInsertPresenter = companyInsertPresenter;
    this.g_sCompanyIdID = '#text_company_id';
    this.g_sNameID = '#text_name';
    this.g_sTaxIdID = '#text_tax_id';
    this.g_sPayID = '#text_pay';
    this.g_sEmailID = '#text_email';
    this.g_sTelID = '#text_tel';
    this.g_sPhoneID = '#text_phone';
    this.g_sAddressID = '#text_address';
    this.g_sDescriptionID = '#text_description';
    this.g_sTabID = "#tab";
    this.g_sTitleTabSelectID = '#tab1';

    this.g_sPayListID = '#pay_list';
    this.g_arrayHtml = [];
}

CompanyInsertView.prototype = {
    TAG: 'CompanyInsertView',

    fnErrorMessage: function (msg) {
        fnErrorMessage(msg);
    },

    fnGeneralMessage: function (msg) {
        fnGeneralMessage(msg);
    },

    fnPushSelectList: function (jsonValue) {
        this.g_arrayHtml.push(" <option label='" + jsonValue.name + "' value='" + jsonValue.value + "' /> ");
    },

    fnShowPayList: function () {
        $(this.g_sPayListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
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

    fnInsert: function (event) {
        event.preventDefault();
        var insert = {
            method: "fnInsert",
            company_id: $(this.g_sCompanyIdID).val(),
            name: $(this.g_sNameID).val(),
            tax_id: $(this.g_sTaxIdID).val(),
            pay: $(this.g_sPayID).val(),
            email: $(this.g_sEmailID).val(),
            tel: $(this.g_sTelID).val(),
            phone: $(this.g_sPhoneID).val(),
            address: $(this.g_sAddressID).val(),
            description: $(this.g_sDescriptionID).val()
        };
        this.g_companyInsertPresenter.fnInsert(insert);
    },


};

