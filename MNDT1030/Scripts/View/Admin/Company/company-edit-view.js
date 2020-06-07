

function CompanyEditView(companyEditPresenter) {
    this.g_companyEditPresenter = companyEditPresenter;
    this.g_sCompanyIdID = '#lab_company_id';
    this.g_sNameID = '#text_name';
    this.g_sTaxIdID = '#text_tax_id';
    this.g_sPayID = '#text_pay';
    this.g_sEmailID = '#text_email';
    this.g_sTelID = '#text_tel';
    this.g_sPhoneID = '#text_phone';
    this.g_sAddressID = '#text_address';
    this.g_sDescriptionID = '#text_description';
    this.g_sStatusID = "#select_status";

    this.g_sPayListID = '#pay_list';
    this.g_sTabID = "#tab";
    this.g_sTitleTabSelectID = '#tab1';
    this.g_arrayHtml = [];
}

CompanyEditView.prototype = {
    TAG: 'CompanyEditView',

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
                //this.g_companyEditPresenter.fnInitializationTab1();
                break;
            case 'tab2':
                if (this.g_bTab2FirstInit) {
                    this.g_companyEditPresenter.fnInitializationTab2();
                    this.g_bTab2FirstInit = false;
                }
                break;
        }
    },

    fnLast: function () {
        this.g_companyEditPresenter.fnSelectId(-1);
    },

    fnNext: function () {
        this.g_companyEditPresenter.fnSelectId(1);
    },

    //-------------------------------Tab1----------------------

    fnInitializationTab1: function () {
        this.g_bTab2FirstInit = true;
    },

    fnSetDataView: function (jsonValue) {
        $(this.g_sCompanyIdID).text(jsonValue.company_id);
        $(this.g_sNameID).val(jsonValue.name);
        $(this.g_sTaxIdID).val(jsonValue.tax_id);
        $(this.g_sPayID).val(jsonValue.pay);
        $(this.g_sEmailID).val(jsonValue.email);
        $(this.g_sTelID).val(jsonValue.tel);
        $(this.g_sPhoneID).val(jsonValue.phone);
        $(this.g_sAddressID).val(jsonValue.address);
        $(this.g_sDescriptionID).val(jsonValue.description);
        $(this.g_sStatusID + ' option[value=' + jsonValue.status + ']').attr('selected', 'selected');
    },

    fnPushSelectList: function (jsonValue) {
        this.g_arrayHtml.push(" <option label='" + jsonValue.name + "' value='" + jsonValue.value + "' /> ");
    },

    fnShowPayList: function () {
        $(this.g_sPayListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnTab1Update: function (event) {
        event.preventDefault();
        var update = {
            method: "fnUpdate",
            company_id: $(this.g_sCompanyIdID).text(),
            name: $(this.g_sNameID).val(),
            tax_id: $(this.g_sTaxIdID).val(),
            pay: $(this.g_sPayID).val(),
            email: $(this.g_sEmailID).val(),
            tel: $(this.g_sTelID).val(),
            phone: $(this.g_sPhoneID).val(),
            address: $(this.g_sAddressID).val(),
            description: $(this.g_sDescriptionID).val(),
            status: $(this.g_sStatusID).find('option:selected').val()
        }
        this.g_companyEditPresenter.fnTab1Update(update);
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
            that.g_companyEditPresenter.fnInitializationTab2();
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
        this.g_arrayHtml.push("  <li><a class='" + select + "' onclick='companyEditView.fnPageNumberChange(\"" + page + "\")' >" + name + "</a></li> ");
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
        this.g_companyEditPresenter.fnMaxPageSizeChange(item.value);
    },

    fnPageNumberChange: function (value) {
        this.g_companyEditPresenter.fnPageNumberChange(value);
    },

    fnTab2Refresh: function () {
        this.g_companyEditPresenter.fnInitializationTab2();
    }

};

