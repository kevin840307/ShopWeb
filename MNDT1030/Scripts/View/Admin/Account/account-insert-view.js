

function AccountInsertView(shopItemInsertPresenter) {
    this.g_shopItemInsertPresenter = shopItemInsertPresenter;
    this.g_sAccountID = '#text_shopItem';
    this.g_sNameID = '#text_name';
    this.g_sPasswordID = '#text_password';
    this.g_sCheckPasswordID = '#text_check_password';
    this.g_sPhoneID = '#text_phone';
    this.g_sAddressID = '#text_address';
    this.g_sTabID = "#tab";
    this.g_sTitleTabSelectID = '#tab1';
}

AccountInsertView.prototype = {
    TAG: 'AccountInsertView',

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
            shopItem: $(this.g_sAccountID).val(),
            name: $(this.g_sNameID).val(),
            password: $(this.g_sPasswordID).val(),
            check_password: $(this.g_sCheckPasswordID).val(),
            phone: $(this.g_sPhoneID).val(),
            address: $(this.g_sAddressID).val()
        };
        this.g_shopItemInsertPresenter.fnInsert(insert);
    },


};

