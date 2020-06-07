

function BillSearchPresenter(viewPage) {
    this.g_billSearchView = viewPage;
    this.g_iPage = 1;
    this.g_iMaxPageSize = 8;
}

BillSearchPresenter.prototype = {
    TAG: 'BillReadOnlyPresenter',

    fnInitialization: function () {
        this.g_billSearchView.fnInitialization();
        this.fnInitList();
    },

    fnPageNumberChange: function (page) {
        var sArg = '?' + fnGetUpdateQuery('page', page);
        this.g_billSearchView.fnChangeUrl(sArg);
    },

    fnOrderChange: function (order) {
        var sArg = '?' + fnGetUpdateQuery('order', order);
        this.g_billSearchView.fnChangeUrl(sArg);
    },

    fnFilterChange: function (filter) {
        var sArg = '?';

        if (filter.company_id.length > 0) {
            sArg += 'filter_company_id=' + fnToMNDT(filter.company_id) + '&';
        }

        if (filter.date_S.length > 0) {
            sArg += 'filter_date_S=' + fnToMNDT(filter.date_S) + '&';
        }

        if (filter.date_E.length > 0) {
            sArg += 'filter_date_E=' + fnToMNDT(filter.date_E) + '&';
        }

        if (sArg[sArg.length - 1] == '&') {
            sArg = sArg.substring(0, sArg.length - 1);
        }

        this.g_billSearchView.fnChangeUrl(sArg);
    },

    fnMaxPageSizeChange: function (page) {
        this.g_iMaxPageSize = page;
        var sArg = '?' + fnGetUpdateQuery('page', '1');
        this.g_billSearchView.fnChangeUrl(sArg);
    },

    fnImport: function (formData) {
        var that = this;
        $.ajax({
            type: 'post',
            url: 'ADMIN/Handler/BillHandler.ashx',
            data: formData,
            dataType: 'json',
            contentType: false,
            processData: false,
            success: function (data) {
                that.fnResultImport(data);
            },
            error: function (error) {
                alert("errror");
            }
        });

    },

    fnResultImport: function (data) {
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));

        if (jsonValues != null) {
            if (jsonValues.msg == 'Y') {
                this.g_billSearchView.fnGeneralMessage("匯入成功。");
            } else {
                this.g_billSearchView.fnErrorMessage(jsonValues.msg);
            }
        } else {
            this.g_billSearchView.fnErrorMessage("錯誤訊息：不知名錯誤。");
        }
    },

    fnExport: function () {
        fnLoading();
        var sArg = {
            "method": "fnExport"
            , "order": this.g_order.toString()
            , "company_id": this.filter.company_id.toString()
            , "date_S": this.filter.date_S.toString()
            , "date_E": this.filter.date_E.toString()
        };
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/BillHandler.ashx',
            type: 'GET',
            data: sArg,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultExport(data);
                fnLoaded();
            },
            error: function (sError) {
            }
        });
    },

    fnResultExport: function (data) {
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));

        if (jsonValues != null) {
            if (jsonValues.msg == 'Y') {
                window.location.href = "Download.aspx?path=ExcelFile\\\\&name=User.xls";
                this.g_billSearchView.fnGeneralMessage("匯出成功。");
            } else {
                this.g_billSearchView.fnErrorMessage(jsonValues.msg);
            }
        } else {
            this.g_billSearchView.fnErrorMessage("錯誤訊息：不知名錯誤。");
        }
    },

    fnReport: function () {
        fnLoading();
        var sArg = {
            "method": "fnReport"
            , "order": this.g_order.toString()
            , "company_id": this.filter.company_id.toString()
            , "date_S": this.filter.date_S.toString()
            , "date_E": this.filter.date_E.toString()
        };
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/BillHandler.ashx',
            type: 'GET',
            data: sArg,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultReport(data);
                fnLoaded();
            },
            error: function (sError) {
            }
        });
    },

    fnResultReport: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));

        if (jsonValues != null) {
            if (jsonValues.msg == 'Y') {
                window.open("ReportPage.aspx?ReportName=BillList.rpt", '', 'resizable=yes,location=no');
                this.g_billSearchView.fnGeneralMessage("報表產生成功。");
            } else {
                this.g_billSearchView.fnErrorMessage(jsonValues.msg);
            }
        } else {
            this.g_billSearchView.fnErrorMessage("錯誤訊息：不知名錯誤。");
        }
    },

    fnPrint: function () {
        window.open('Print\\Bill\\BillList.aspx?' + window.location.search.substring(1));
    },

    fnInitList: function () {
        var sPage = fnGetQuery("page", "1");
        var iPage = parseInt(sPage);
        var filter_company_id = fnGetQuery("filter_company_id", "");
        var filter_date_S = fnGetQuery("filter_date_S", "");
        var filter_date_E = fnGetQuery("filter_date_E", "");
        var order = fnGetQuery("order", "company_id");

        this.filter = {
            company_id: fnFixMNDT(filter_company_id),
            date_S: fnFixMNDT(filter_date_S),
            date_E: fnFixMNDT(filter_date_E)
        };
        this.g_order = order;
        this.g_iPage = iPage;
        this.g_billSearchView.fnShowFilterView(this.filter);
        this.fnSelects();
    },

    fnSelects: function () {

        fnLoading();
        var sArg = {
            "method": "fnSelects"
            , "page": this.g_iPage.toString()
            , "page_max_size": this.g_iMaxPageSize.toString()
            , "order": this.g_order.toString()
            , "company_id": this.filter.company_id.toString()
            , "date_S": this.filter.date_S.toString()
            , "date_E": this.filter.date_E.toString()
        };
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/BillHandler.ashx',
            type: 'GET',
            data: sArg,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultSelect(data);
            },
            error: function (sError) {
            }
        });
    },

    fnResultSelect: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));
        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_billSearchView.fnPushColumns(jsonValue);
            iIndex++;
        }
        this.g_billSearchView.fnShowList();
        if (jsonValues.length == 0) {
            this.g_billSearchView.fnShowEmptyColumns();
        }
        this.fnCount();
    },

    fnCount: function () {
        var sArg = {
            "method": "fnCount"
            , "company_id": this.filter.company_id.toString()
            , "date_S": this.filter.date_S.toString()
            , "date_E": this.filter.date_E.toString()
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/BillHandler.ashx',
            type: 'GET',
            data: sArg,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultCount(data);
                fnLoaded();
            },
            error: function (sError) {
            }
        });
    },

    fnResultCount: function (data) {

        if (this.g_iPage != 1) {
            this.g_billSearchView.fnPushPageNumber('|<<', 1, '');
        }

        var iLastPage = this.g_iPage - 2; // 若是第一頁則不顯示
        if (iLastPage > 0) {
            this.g_billSearchView.fnPushPageNumber('<<', iLastPage, '');
        }

        var iCount = 1;
        var iMinPage = (this.g_iPage - 5) < 2 ? 1 : (this.g_iPage - 5); // 最小為1頁
        for (var iIndex = iMinPage ; iIndex < this.g_iPage; iIndex++) {
            this.g_billSearchView.fnPushPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        this.g_billSearchView.fnPushPageNumber(this.g_iPage, this.g_iPage, 'select');

        var jsonValue = $.parseJSON(JSON.stringify(data));
        var iPage = parseInt((jsonValue.page_size / this.g_iMaxPageSize));
        if (jsonValue.page_size % this.g_iMaxPageSize != 0 || iPage == 0) {
            iPage += 1;
        }
        for (var iIndex = (this.g_iPage + 1) ; iIndex <= iPage && iCount < 10; iIndex++) {
            this.g_billSearchView.fnPushPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        var iNextPage = this.g_iPage + 1;
        if (iNextPage < iPage) {
            this.g_billSearchView.fnPushPageNumber('>>', iNextPage, '');
        }

        if (this.g_iPage != iPage) {
            this.g_billSearchView.fnPushPageNumber('>>|', iPage, '');
        }
        this.g_billSearchView.fnShowPageNumber();
    }
};
