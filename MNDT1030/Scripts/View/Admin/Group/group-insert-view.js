

function GroupInsertView(groupInsertPresenter) {
    this.g_groupInsertPresenter = groupInsertPresenter;
    this.g_sGroupIdID = '#text_group_id';
    this.g_sNameID = '#text_name';
    this.g_sDescriptionID = '#text_description';
    this.g_sTabID = "#tab";
    this.g_bFirstInit = true;
    this.g_sTitleTabSelectID = '#tab1';
}

GroupInsertView.prototype = {
    TAG: 'GroupInsertView',

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
            group_id: $(this.g_sGroupIdID).val(),
            name: $(this.g_sNameID).val(),
            description: $(this.g_sDescriptionID).val()
        };
        this.g_groupInsertPresenter.fnInsert(insert);
    },
    
    
};

