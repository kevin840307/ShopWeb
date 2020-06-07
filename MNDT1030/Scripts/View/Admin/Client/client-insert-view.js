

function ClientInsertView(clientInsertPresenter) {
    this.g_clientInsertPresenter = clientInsertPresenter;
    this.g_sClientIdID = '#text_client_id';
    this.g_sNameID = '#text_name';
    this.g_sPasswordID = '#text_password';
    this.g_sCheckPasswordID = '#text_check_password';
    this.g_sEmailID = '#text_email';
    this.g_sTelID = '#text_tel';
    this.g_sPhoneID = '#text_phone';
    this.g_sAddressID = '#text_address';
    this.g_sDescriptionID = '#text_description';
    this.g_sTabID = "#tab";
    this.g_sTitleTabSelectID = '#tab1';
}

ClientInsertView.prototype = {
    TAG: 'ClientInsertView',

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

    fnInsert: function (event) {
        event.preventDefault();
        var insert = {
            method: "fnInsert",
            client_id: $(this.g_sClientIdID).val(),
            name: $(this.g_sNameID).val(),
            password: $(this.g_sPasswordID).val(),
            check_password: $(this.g_sCheckPasswordID).val(),
            email: $(this.g_sEmailID).val(),
            tel: $(this.g_sTelID).val(),
            phone: $(this.g_sPhoneID).val(),
            address: $(this.g_sAddressID).val(),
            description: $(this.g_sDescriptionID).val()
        };
        this.g_clientInsertPresenter.fnInsert(insert);
    },


};

