

function CompanyEditPresenter(companyEditView) {
    this.g_companyEditView = companyEditView;
    this.g_sCompanyId = '';
}

CompanyEditPresenter.prototype = {
    TAG: 'CompanyEditPresenter',

    fnInitialization: function () {
        this.g_iMaxPageSize = 8;
        this.g_sCompanyId = fnGetQuery("company_id", "");
        this.fnInitializationTab1();
        this.g_companyEditView.fnInitialization();
    },

    fnResultSelectList: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));

        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_companyEditView.fnPushSelectList(jsonValue);
            iIndex++;
        }
    },

    fnSelectId: function (value) {
        var sNUM = fnGetQuery("NUM", "");
        if (sNUM.length > 0) {
            fnLoading();
            sNUM = (parseInt(sNUM) + value).toString();
            var sArg = {
                "method": "fnSelectCompanyId",
                company_id: fnFixMNDT(fnGetQuery("filter_company_id", "")),
                phone: fnFixMNDT(fnGetQuery("filter_phone", "")),
                name: fnFixMNDT(fnGetQuery("filter_name", "")),
                status: fnGetQuery("filter_status", ""),
                order: fnGetQuery("order", "company_id"),
                NUM: sNUM
            };
            var that = this;

            $.ajax({
                url: 'ADMIN/Handler/CompanyHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectId(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'CompanySearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'CompanySearchView.aspx';
        }
    },

    fnResultSelectId: function (data) {
        if (data != null) {
            var jsonValue = $.parseJSON(JSON.stringify(data));
            if (jsonValue != null) {
                if (jsonValue.msg == 'Y') {
                    var sArg = fnGetUpdateQuery('company_id', jsonValue.company_id);
                    sArg = fnUpdateQuery(sArg, 'NUM', jsonValue.NUM);
                    window.location = 'CompanyEditView.aspx?' + sArg;
                } else {
                    this.g_companyEditView.fnGeneralMessage(jsonValue.msg);
                    fnLoaded();
                }
            } else {
                alert('錯誤訊息：資料錯誤，跳往查詢頁面。');
                window.location = 'CompanySearchView.aspx';
            }
        } else {
            alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
            window.location = 'CompanySearchView.aspx';
        }
    },

    /*----------------------------------------------tab1---------------------------*/

    fnInitializationTab1: function () {
        fnLoading();
        this.g_companyEditView.fnInitializationTab1();
        this.fnSelectPay();
        this.fnSelectTab1();
    },


    fnSelectPay: function () {
        this.fnSelectList("PAY");
        this.g_companyEditView.fnShowPayList();
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

    fnTab1Update: function (update) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/CompanyHandler.ashx',
            data: update,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultTab1Update(data);
            },
            error: function (sError) {
            }
        });
    },

    fnResultTab1Update: function (data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            this.g_companyEditView.fnGeneralMessage("更新成功");
        } else {
            this.g_companyEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnSelectTab1: function () {

        if (this.g_sCompanyId.length > 0) {
            var that = this;
            var sArg = {
                "method": "fnSelect"
                , "company_id": this.g_sCompanyId
            };

            $.ajax({
                url: 'ADMIN/Handler/CompanyHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectTab1(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'CompanySearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'CompanySearchView.aspx';
        }
    },

    fnResultSelectTab1: function (data) {
        if (data != null) {
            var jsonValue = $.parseJSON(JSON.stringify($.parseJSON(JSON.stringify(data))[0]));
            if (jsonValue != null) {
                this.g_companyEditView.fnSetDataView(jsonValue);
                fnLoaded();
            } else {
                alert('錯誤訊息：資料錯誤，跳往查詢頁面。');
                window.location = 'CompanySearchView.aspx';
            }
        } else {
            alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
            window.location = 'CompanySearchView.aspx';
        }
    },

    /*--------------------------------------Tab2--------------------------------*/

    fnInitializationTab2: function () {
        fnLoading();
        this.g_companyEditView.fnInitializationTab2();
        var sPage = fnGetQuery("page", "1");
        this.g_iPage = parseInt(sPage);
        this.fnSelectTab2();
    },

    fnSelectTab2: function () {
        if (this.g_sCompanyId.length > 0) {
            var that = this;
            var sArg = {
                "method": "fnSelectsTran"
                , "page": this.g_iPage.toString()
                , "page_max_size": this.g_iMaxPageSize.toString()
                , "company_id": this.g_sCompanyId
            };
            $.ajax({
                url: 'ADMIN/Handler/CompanyHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectTab2(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'CompanySearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'CompanySearchView.aspx';
        }
    },

    fnResultSelectTab2: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));
        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_companyEditView.fnPushTranColumns(jsonValue);
            iIndex++;
        }
        this.g_companyEditView.fnShowTranList();
        if (jsonValues.length == 0) {
            this.g_companyEditView.fnShowTranEmptyColumns();
        }
        this.fnCountTab2();
    },

    fnCountTab2: function () {
        var sArg = {
            "method": "fnCountTran"
            , "company_id": this.g_sCompanyId.toString()
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/CompanyHandler.ashx',
            type: 'GET',
            data: sArg,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultCountTab2(data);
                fnLoaded();
            },
            error: function (sError) {
            }
        });
    },

    fnResultCountTab2: function (data) {
        if (this.g_iPage != 1) {
            this.g_companyEditView.fnPushTranPageNumber('|<<', 1, '');
        }

        var iLastPage = this.g_iPage - 2; // 若是第一頁則不顯示
        if (iLastPage > 0) {
            this.g_companyEditView.fnPushTranPageNumber('<<', iLastPage, '');
        }

        var iCount = 1;
        var iMinPage = (this.g_iPage - 5) < 2 ? 1 : (this.g_iPage - 5); // 最小為1頁
        for (var iIndex = iMinPage ; iIndex < this.g_iPage; iIndex++) {
            this.g_companyEditView.fnPushTranPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        this.g_companyEditView.fnPushTranPageNumber(this.g_iPage, this.g_iPage, 'select');

        var jsonValue = $.parseJSON(JSON.stringify(data));
        var iPage = parseInt((jsonValue.page_size / this.g_iMaxPageSize));
        if (jsonValue.page_size % this.g_iMaxPageSize != 0 || iPage == 0) {
            iPage += 1;
        }
        for (var iIndex = (this.g_iPage + 1) ; iIndex <= iPage && iCount < 10; iIndex++) {
            this.g_companyEditView.fnPushTranPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        var iNextPage = this.g_iPage + 1;
        if (iNextPage < iPage) {
            this.g_companyEditView.fnPushTranPageNumber('>>', iNextPage, '');
        }

        if (this.g_iPage != iPage) {
            this.g_companyEditView.fnPushTranPageNumber('>>|', iPage, '');
        }
        this.g_companyEditView.fnShowTranPageNumber();
    },

    fnPageNumberChange: function (page) {
        var sArg = '?' + fnGetUpdateQuery('page', page);
        this.g_companyEditView.fnTab2ChangeUrl(sArg);
    },

    fnMaxPageSizeChange: function (page) {
        this.g_iMaxPageSize = page;
        var sArg = '?' + fnGetUpdateQuery('page', '1');
        this.g_companyEditView.fnTab2ChangeUrl(sArg);
    },
};