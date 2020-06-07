

function SalesInsertPresenter(salesInsertView) {
    this.g_salesInsertView = salesInsertView;
    this.g_sOrderId = "";
}

SalesInsertPresenter.prototype = {
    TAG: 'SalesInsertPresenter',

    fnInitialization: function () {
        this.fnInitializationTab1();
    },

    fnResultSelectList: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));

        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_salesInsertView.fnPushSelectList(jsonValue);
            iIndex++;
        }
    },

    /*-----------------------------------------tab1---------------------------*/

    fnInitializationTab1: function () {
        fnLoading();
        this.g_salesInsertView.fnInitializationTab1();
        this.fnSelectAccount();
        this.fnSelectPay();
        this.fnSelectOrderStatus();
        fnLoaded();
    },

    fnSelectPay: function () {
        this.fnSelectCode("CPAY");
        this.g_salesInsertView.fnShowPayList();
    },
    fnSelectOrderStatus: function () {
        this.fnSelectCode("OSTA");
        this.g_salesInsertView.fnShowOrderStatusList();
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
        this.g_salesInsertView.fnShowAccountList();
    },

    fnSelectCode: function (value) {
        var that = this;
        var sArg = {
            "method": "fnSelectList"
            , "kind_id": value
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
                window.location = 'MaterialSearchView.aspx';
            }
        });
    },

    fnTab1Insert: function (insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/SalesHandler.ashx',
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
            this.g_salesInsertView.fnSetOrderId(jsonValue.order_id);
            this.g_salesInsertView.fnRemoveProhibited('#tab2');
            this.g_salesInsertView.fnTitleTabEvent('#tab2');
        } else {
            this.g_salesInsertView.fnErrorMessage(jsonValue.msg);
        }
    },

    /*-----------------------------------------tab2---------------------------*/

    fnInitializationTab2: function () {
        this.g_salesInsertView.fnInitializationTab2();
        this.fnSelectProduct();
        this.fnSelectWarehouse();
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
        this.g_salesInsertView.fnShowProductList();
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
        this.g_salesInsertView.fnShowWarehouseList();
    },

    fnTab2Insert: function (tr, insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/SalesHandler.ashx',
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
            this.g_salesInsertView.fnGeneralMessage("新增成功");
            this.g_salesInsertView.fnChangeReadOnly(tr, data)
        } else {
            this.g_salesInsertView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab2Inserts: function (insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/SalesHandler.ashx',
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
            //window.location = 'SalesSearchView.aspx?filter_order_id=' + jsonValue.order_id;
        } else {
            alert('錯誤訊息：新增中有錯誤請往編輯查詢。')
        }
        window.location = 'SalesSearchView.aspx?filter_order_id=' + this.g_sOrderId;
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
            this.g_salesInsertView.fnTab2ShowPrice(tr, jsonValue.price);
        } else {
            this.g_salesInsertView.fnTab2ShowPrice(tr, '0');
        }
    },
};