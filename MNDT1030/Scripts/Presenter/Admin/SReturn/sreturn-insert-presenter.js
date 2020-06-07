

function SReturnInsertPresenter(sreturnInsertView) {
    this.g_sreturnInsertView = sreturnInsertView;
    this.g_sReturnId = "";
}

SReturnInsertPresenter.prototype = {
    TAG: 'SReturnInsertPresenter',

    fnInitialization: function () {
        this.fnInitializationTab1();
    },

    fnResultSelectList: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));

        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_sreturnInsertView.fnPushSelectList(jsonValue);
            iIndex++;
        }
    },

    /*-----------------------------------------tab1---------------------------*/

    fnInitializationTab1: function () {
        this.fnSelectAccount();
        this.fnSelectOrder();
        this.g_sreturnInsertView.fnInitializationTab1();
    },

    fnSelectOrder: function () {
        var sArg = {
            "method": "fnSelectList"
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/ReceiveHandler.ashx',
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
        this.g_sreturnInsertView.fnShowOrderList();
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
        this.g_sreturnInsertView.fnShowAccountList();
    },

    fnTab1Insert: function (insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/SReturnHandler.ashx',
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
            this.g_sReturnId = jsonValue.return_id;
            this.g_sreturnInsertView.fnSetReturnId(jsonValue.return_id);
            this.g_sreturnInsertView.fnRemoveProhibited('#tab2');
            this.g_sreturnInsertView.fnTitleTabEvent('#tab2');
        } else {
            this.g_sreturnInsertView.fnErrorMessage(jsonValue.msg);
        }
    },

    /*-----------------------------------------tab2---------------------------*/

    fnInitializationTab2: function () {
        this.g_sreturnInsertView.fnInitializationTab2();
        this.fnSelectProduct();
        this.fnSelectWarehouse();
    },

    fnSelectWarehouse: function () {
        var that = this;
        var sArg = {
            "method": "fnSelectList"
            , "kind_id": "WAR"
        };

        $.ajax({
            url: 'ADMIN/Handler/KindHandler.ashx',
            data: sArg,
            async: false,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultSelectList(data);
            },
            error: function (sError) {
                alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                window.location = 'ProductSearchView.aspx';
            }
        });
        this.g_sreturnInsertView.fnShowWarehouseList();
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
        this.g_sreturnInsertView.fnShowProductList();
    },

    fnTab2Insert: function (tr, insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/SReturnHandler.ashx',
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
            this.g_sreturnInsertView.fnGeneralMessage("新增成功");
            this.g_sreturnInsertView.fnChangeReadOnly(tr, data)
        } else {
            this.g_sreturnInsertView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab2Inserts: function (insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/SReturnHandler.ashx',
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
            //window.location = 'SReturnSearchView.aspx?filter_return_id=' + jsonValue.return_id;
        } else {
            alert('錯誤訊息：新增中有錯誤請往編輯查詢。')
        }
        window.location = 'SReturnSearchView.aspx?filter_return_id=' + this.g_sReturnId;
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
            this.g_sreturnInsertView.fnTab2ShowPrice(tr, jsonValue.price);
        } else {
            this.g_sreturnInsertView.fnTab2ShowPrice(tr, '0');
        }
    },
};