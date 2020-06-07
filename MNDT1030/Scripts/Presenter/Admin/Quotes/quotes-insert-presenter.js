

function QuotesInsertPresenter(quotesInsertView) {
    this.g_quotesInsertView = quotesInsertView;
    this.g_sOrderId = "";
}

QuotesInsertPresenter.prototype = {
    TAG: 'QuotesInsertPresenter',

    fnInitialization: function () {
        this.fnInitializationTab1();
    },

    fnResultSelectList: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));

        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_quotesInsertView.fnPushSelectList(jsonValue);
            iIndex++;
        }
    },

    /*-----------------------------------------tab1---------------------------*/

    fnInitializationTab1: function () {
        this.g_quotesInsertView.fnInitializationTab1();
        this.fnSelectAccount();
        this.fnSelectClient();
    },

    fnSelectAccount: function () {
        var sArg = {
            "method": "fnSelectList"
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/AccountHandler.ashx',
            type: 'GET',
            data: sArg,
            async: false,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultSelectList(data);
            },
            error: function (sError) {
            }
        });
        this.g_quotesInsertView.fnShowAccountList();
    },

    fnSelectClient: function () {
        var sArg = {
            "method": "fnSelectList"
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/ClientHandler.ashx',
            type: 'GET',
            data: sArg,
            async: false,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultSelectList(data);
            },
            error: function (sError) {
            }
        });
        this.g_quotesInsertView.fnShowClientList();
    },

    fnTab1Insert: function (insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/QuotesHandler.ashx',
            data: insert,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultTab1Insert(data);
            },
            error: function (sError) {
            }
        });
    },

    fnResultTab1Insert: function (data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            this.g_sOrderId = jsonValue.order_id;
            this.g_quotesInsertView.fnSetOrderId(jsonValue.order_id);
            this.g_quotesInsertView.fnRemoveProhibited('#tab2');
            this.g_quotesInsertView.fnTitleTabEvent('#tab2');
        } else {
            this.g_quotesInsertView.fnErrorMessage(jsonValue.msg);
        }
    },

    /*-----------------------------------------tab2---------------------------*/

    fnInitializationTab2: function () {
        this.g_quotesInsertView.fnInitializationTab2();
        this.fnSelectProduct();
    },

    fnSelectProduct: function () {
        var sArg = {
            "method": "fnSelectList"
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/ProductHandler.ashx',
            type: 'GET',
            data: sArg,
            async: false,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultSelectList(data);
            },
            error: function (sError) {
            }
        });
        this.g_quotesInsertView.fnShowProductList();
    },

    fnTab2Insert: function (tr, insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/QuotesHandler.ashx',
            type: 'GET',
            data: insert,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultTab2Insert(tr, data);
            },
            error: function (sError) {
            }
        });
    },

    fnResultTab2Insert: function (tr, data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            this.g_quotesInsertView.fnGeneralMessage("新增成功");
            this.g_quotesInsertView.fnChangeReadOnly(tr, data)
        } else {
            this.g_quotesInsertView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab2Inserts: function (insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/QuotesHandler.ashx',
            type: 'GET',
            data: insert,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultTab2Inserts(data);
            },
            error: function (sError) {
            }
        });
    },

    fnResultTab2Inserts: function (data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            //window.location = 'QuotesSearchView.aspx?filter_order_id=' + jsonValue.order_id;
        } else {
            alert('錯誤訊息：新增中有錯誤請往編輯查詢。')
        }
        window.location = 'QuotesSearchView.aspx?filter_order_id=' + this.g_sOrderId;
    },

    fnTab2SelectPrice: function (tr, select) {
        var that = this;

        if (!isNaN(parseFloat(select.amount))) {

            $.ajax({
                url: 'ADMIN/Handler/ProductHandler.ashx',
                data: select,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnTab2ResultSelectPrice(tr, data);
                },
                error: function (sError) {
                }
            });
        }
    },

    fnTab2ResultSelectPrice: function (tr, data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            this.g_quotesInsertView.fnTab2ShowPrice(tr, jsonValue.price);
        } else {
            this.g_quotesInsertView.fnTab2ShowPrice(tr, '0');
        }
    },
};