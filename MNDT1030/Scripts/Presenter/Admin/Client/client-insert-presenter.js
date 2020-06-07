

function ClientInsertPresenter(clientInsertView) {
    this.g_clientInsertView = clientInsertView;


}

ClientInsertPresenter.prototype = {
    TAG: 'ClientInsertPresenter',

    fnInitialization: function () {
    },

    fnInsert: function (insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/ClientHandler.ashx',
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
            window.location = 'ClientSearchView.aspx?filter_client_id=' + jsonValue.client_id;
        } else {
            this.g_clientInsertView.fnErrorMessage(jsonValue.msg);
        }
    }
};