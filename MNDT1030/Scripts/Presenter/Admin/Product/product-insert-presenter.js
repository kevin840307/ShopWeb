

function ProductInsertPresenter(productInsertView) {
    this.g_productInsertView = productInsertView;
}

ProductInsertPresenter.prototype = {
    TAG: 'ProductInsertPresenter',

    fnInitialization: function () {
        fnLoading();
        this.fnSelectCompany();
        this.fnSelectUnit();
        this.fnSelectCurrency();
        fnLoaded();
    },

    fnSelectCompany: function () {
        this.fnSelectCompanyList();
        this.g_productInsertView.fnShowCompanyList();
    },

    fnSelectUnit: function () {
        this.fnSelectList("U1");
        this.g_productInsertView.fnShowUnitList();
    },

    fnSelectCurrency: function () {
        this.fnSelectList("C2");
        this.g_productInsertView.fnShowCurrencyList();
    },

    fnSelectCompanyList: function () {
        var that = this;
        var sArg = {
            "method": "fnSelectList"
        };

        $.ajax({
            url: 'ADMIN/Handler/CompanyHandler.ashx',
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

    fnSelectList: function (value) {
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

    fnResultSelectList: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));

        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_productInsertView.fnPushSelectList(jsonValue);
            iIndex++;
        }
    },

    fnInsert: function (insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/ProductHandler.ashx',
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
            window.location = 'ProductSearchView.aspx?filter_product_id=' + jsonValue.product_id;
        } else {
            this.g_productInsertView.fnErrorMessage(jsonValue.msg);
        }
    }
};