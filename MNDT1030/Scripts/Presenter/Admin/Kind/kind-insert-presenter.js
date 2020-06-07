

function KindInsertPresenter(kindInsertView) {
    this.g_kindInsertView = kindInsertView;
}

KindInsertPresenter.prototype = {
    TAG: 'KindInsertPresenter',

    fnInitialization: function () {
    },

    fnInsert: function (insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/KindHandler.ashx',
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
            window.location = 'KindSearchView.aspx?filter_kind_id=' + jsonValue.kind_id;
        } else {
            this.g_kindInsertView.fnErrorMessage(jsonValue.msg);
        }
    }
};