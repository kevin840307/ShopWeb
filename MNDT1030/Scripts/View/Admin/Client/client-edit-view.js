

function ClientEditView(clientEditPresenter) {
    this.g_clientEditPresenter = clientEditPresenter;
    this.g_sClientIdID = '#lab_client_id';
    this.g_sNameID = '#text_name';
    this.g_sPasswordID = '#text_password';
    this.g_sCheckPasswordID = '#text_check_password';
    this.g_sEmailID = '#text_email';
    this.g_sTelID = '#text_tel';
    this.g_sPhoneID = '#text_phone';
    this.g_sAddressID = '#text_address';
    this.g_sDescriptionID = '#text_description';
    this.g_sStatusID = "#select_status";

    this.g_sTabID = "#tab";
    this.g_sTitleTabSelectID = '#tab1';
    this.g_arrayHtml = [];
}

ClientEditView.prototype = {
    TAG: 'ClientEditView',

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
                //this.g_clientEditPresenter.fnInitializationTab1();
                break;
            case 'tab2':
                if (this.g_bTab2FirstInit) {
                    this.g_clientEditPresenter.fnInitializationTab2();
                    this.g_bTab2FirstInit = false;
                }
                break;
        }
    },

    fnLast: function () {
        this.g_clientEditPresenter.fnSelectId(-1);
    },

    fnNext: function () {
        this.g_clientEditPresenter.fnSelectId(1);
    },

    //-------------------------------Tab1----------------------

    fnInitializationTab1: function () {
        this.g_bTab2FirstInit = true;
    },

    fnSetDataView: function (jsonValue) {
        $(this.g_sClientIdID).text(jsonValue.client_id);
        $(this.g_sNameID).val(jsonValue.name);
        $(this.g_sPasswordID).val(jsonValue.password);
        $(this.g_sEmailID).val(jsonValue.email);
        $(this.g_sTelID).val(jsonValue.tel);
        $(this.g_sPhoneID).val(jsonValue.phone);
        $(this.g_sAddressID).val(jsonValue.address);
        $(this.g_sDescriptionID).val(jsonValue.description);
        $(this.g_sStatusID + ' option[value=' + jsonValue.status + ']').attr('selected', 'selected');
    },

    fnTab1Update: function (event) {
        event.preventDefault();
        var update = {
            method: "fnUpdate",
            client_id: $(this.g_sClientIdID).text(),
            name: $(this.g_sNameID).val(),
            password: $(this.g_sPasswordID).val(),
            check_password: $(this.g_sCheckPasswordID).val(),
            email: $(this.g_sEmailID).val(),
            tel: $(this.g_sTelID).val(),
            phone: $(this.g_sPhoneID).val(),
            address: $(this.g_sAddressID).val(),
            description: $(this.g_sDescriptionID).val(),
            status: $(this.g_sStatusID).find('option:selected').val()
        }
        this.g_clientEditPresenter.fnTab1Update(update);
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
            that.g_clientEditPresenter.fnInitializationTab2();
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
        this.g_arrayHtml.push("  <li><a class='" + select + "' onclick='clientEditView.fnPageNumberChange(\"" + page + "\")' >" + name + "</a></li> ");
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
        this.g_clientEditPresenter.fnMaxPageSizeChange(item.value);
    },

    fnPageNumberChange: function (value) {
        this.g_clientEditPresenter.fnPageNumberChange(value);
    },

    fnTab2Refresh: function () {
        this.g_clientEditPresenter.fnInitializationTab2();
    }

};

