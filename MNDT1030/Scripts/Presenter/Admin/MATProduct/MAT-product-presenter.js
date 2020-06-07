

function MATProductPresenter(MATProductView) {
    this.g_MATProductView = MATProductView;

    this.g_sProductId = "";
    this.g_sWarehouseId = "";
    this.g_sAmount = "";
}

MATProductPresenter.prototype = {
    TAG: 'MATProductPresenter',

    fnInitialization: function () {
        this.fnInitializationTab1();
    },

    fnResultSelectList: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));

        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_MATProductView.fnPushSelectList(jsonValue);
            iIndex++;
        }
    },

    /*-----------------------------------------tab1---------------------------*/

    fnInitializationTab1: function () {
        fnLoading();
        this.g_MATProductView.fnInitializationTab1();
        this.fnSelectProduct();
        this.fnSelectWarehouse();
        fnLoaded();
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
                window.location = 'MaterialSearchView.aspx';
            }
        });
        this.g_MATProductView.fnShowWarehouseList();
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
        this.g_MATProductView.fnShowProductList();
    },

    fnTab1Next: function (data) {
        this.g_sProductId = data.product_id;
        this.g_sAmount = data.amount;
        this.g_sWarehouseId = data.warehouse_id;
        this.fnInitializationTab2();
    },

    /*-----------------------------------------tab2---------------------------*/

    fnInitializationTab2: function () {
        fnLoading();
        this.g_MATProductView.fnInitializationTab2();
        this.fnSelectMaterial();
        this.fnTab2Select();
        fnLoaded();
    },

    fnSelectMaterial: function () {
        var sArg = {
            "method": "fnSelectList"
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/MaterialHandler.ashx',
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
        this.g_MATProductView.fnShowMaterialList();
    },

    fnTab2Select: function () {
        var that = this;
        var select = {
            method: "fnSelect",
            product_id: this.g_sProductId,
            amount: this.g_sAmount
        };

        $.ajax({
            url: 'ADMIN/Handler/MATProductHandler.ashx',
            data: select,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultTab2Select(data);
            },
            error: function (sError) {
            }
        });
    },

    fnResultTab2Select: function (data) {
        if (data == null) {
            this.g_MATProductView.fnErrorMessage("錯誤訊息：可能庫存數量不足。");
            return;
        }

        this.g_MATProductView.fnRemoveProhibited('#tab2');
        this.g_MATProductView.fnTitleTabEvent('#tab2');

        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));

        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_MATProductView.fnTab2PushColumns(jsonValue);
            iIndex++;
        }
        this.g_MATProductView.fnTab2ShowList();
        this.fnTab2SelectTotal();
    },

    fnTab2SelectTotal: function () {
        var that = this;
        var select = {
            method: "fnSelectTotal",
            product_id: this.g_sProductId,
            amount: this.g_sAmount
        };

        $.ajax({
            url: 'ADMIN/Handler/MATProductHandler.ashx',
            data: select,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultTab2SelectTotal(data);
            },
            error: function (sError) {
            }
        });
    },

    fnResultTab2SelectTotal: function (data) {
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));

        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_MATProductView.fnTab2PushNeedColumns(jsonValue);
            iIndex++;
        }
        this.g_MATProductView.fnTab2ShowNeedList();
    },

    fnTab2Change: function (formData) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/MATProductHandler.ashx',
            type: 'post',
            data: formData,
            contentType: false,
            processData: false,
            dataType: "json",
            success: function (data) {
                that.fnResultTab2Change(data);
            },
            error: function (sError) {
                alert("errror");
            }
        });
    },

    fnResultTab2Change: function (data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            alert("轉換成功");
            window.location = 'MATProductView.aspx';
        } else {
            this.g_MATProductView.fnErrorMessage(jsonValue.msg);
        }
    }
};