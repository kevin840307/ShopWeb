

function KindInsertView(kindInsertPresenter) {
    this.g_kindInsertPresenter = kindInsertPresenter;
    this.g_sKindIdID = '#text_kind_id';
    this.g_sNameID = '#text_name';
    this.g_sDescriptionID = '#text_description';
    this.g_sTabID = "#tab";
    this.g_sTitleTabSelectID = '#tab1';
    this.g_bFirstInit = true;
}

KindInsertView.prototype = {
    TAG: 'KindInsertView',

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
            kind_id: $(this.g_sKindIdID).val(),
            name: $(this.g_sNameID).val(),
            description: $(this.g_sDescriptionID).val()
        };
        this.g_kindInsertPresenter.fnInsert(insert);
    },
    
    
};

