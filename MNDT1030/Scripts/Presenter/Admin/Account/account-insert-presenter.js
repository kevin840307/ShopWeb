

function AccountInsertPresenter(accountInsertView) {
    this.g_accountInsertView = accountInsertView;


}

AccountInsertPresenter.prototype = {
    TAG: 'AccountInsertPresenter',

    fnInitialization: function () {
    },

    fnInsert: function (insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/AccountHandler.ashx',
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
            window.location = 'AccountSearchView.aspx?filter_account=' + jsonValue.account;
        } else {
            this.g_accountInsertView.fnErrorMessage(jsonValue.msg);
        }
    }
};