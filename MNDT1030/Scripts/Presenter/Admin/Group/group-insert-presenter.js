

function GroupInsertPresenter(groupInsertView) {
    this.g_groupInsertView = groupInsertView;
}

GroupInsertPresenter.prototype = {
    TAG: 'GroupInsertPresenter',

    fnInitialization: function () {
    },

    fnInsert: function (insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/GroupHandler.ashx',
            data: insert,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultInsert(data);
            },
            error: function (sError) {
            }
        });
    },

    fnResultInsert: function (data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            window.location = 'GroupSearchView.aspx?filter_group_id=' + jsonValue.group_id;
        } else {
            this.g_groupInsertView.fnErrorMessage(jsonValue.msg);
        }
    }
};