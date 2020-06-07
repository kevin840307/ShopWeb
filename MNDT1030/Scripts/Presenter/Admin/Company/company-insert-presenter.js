

function CompanyInsertPresenter(companyInsertView) {
    this.g_companyInsertView = companyInsertView;


}

CompanyInsertPresenter.prototype = {
    TAG: 'CompanyInsertPresenter',

    fnInitialization: function () {
        this.fnSelectPay();
    },

    fnSelectPay: function () {
        this.fnSelectList("PAY");
        this.g_companyInsertView.fnShowPayList();
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
            this.g_companyInsertView.fnPushSelectList(jsonValue);
            iIndex++;
        }
    },

    fnInsert: function (insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/CompanyHandler.ashx',
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
            window.location = 'CompanySearchView.aspx?filter_company_id=' + jsonValue.company_id;
        } else {
            this.g_companyInsertView.fnErrorMessage(jsonValue.msg);
        }
    }
};