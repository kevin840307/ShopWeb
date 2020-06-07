

function AccountSearchPresenter(viewPage) {
    this.g_accountSearchView = viewPage;
    this.g_iPage = 1;
    this.g_iMaxPageSize = 8;
}

AccountSearchPresenter.prototype = {
    TAG: 'AccountReadOnlyPresenter',

    fnInitialization: function () {
        this.g_accountSearchView.fnInitialization();
        this.fnInitList();
    },

    fnPageNumberChange: function (page) {
        var sArg = '?' + fnGetUpdateQuery('page', page);
        this.g_accountSearchView.fnChangeUrl(sArg);
    },

    fnOrderChange: function (order) {
        var sArg = '?' + fnGetUpdateQuery('order', order);
        this.g_accountSearchView.fnChangeUrl(sArg);
    },

    fnFilterChange: function (filter) {
        var sArg = '?';

        if (filter.id.length > 0) {
            sArg += 'filter_id=' + fnToMNDT(filter.id) + '&';
        }

        if (filter.account.length > 0) {
            sArg += 'filter_account=' + fnToMNDT(filter.account) + '&';
        }

        if (filter.name.length > 0) {
            sArg += 'filter_name=' + fnToMNDT(filter.name) + '&';
        }

        if (filter.status.length > 0) {
            sArg += 'filter_status=' + fnToMNDT(filter.status);
        }

        if (sArg[sArg.length - 1] == '&') {
            sArg = sArg.substring(0, sArg.length - 1);
        }

        this.g_accountSearchView.fnChangeUrl(sArg);
    },

    fnMaxPageSizeChange: function (page) {
        this.g_iMaxPageSize = page;
        var sArg = '?' + fnGetUpdateQuery('page', '1');
        this.g_accountSearchView.fnChangeUrl(sArg);
    },

    fnImport: function (formData) {
        var that = this;
        $.ajax({
            type: 'post',
            url: 'ADMIN/Handler/AccountHandler.ashx',
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
                this.g_accountSearchView.fnGeneralMessage("匯入成功。");
            } else {
                this.g_accountSearchView.fnErrorMessage(jsonValues.msg);
            }
        } else {
            this.g_accountSearchView.fnErrorMessage("錯誤訊息：不知名錯誤。");
        }
    },

    fnExport: function () {
        fnLoading();
        var sArg = {
            "method": "fnExport"
            , "order": this.g_order.toString()
            , "id": this.filter.id.toString()
            , "account": this.filter.account.toString()
            , "name": this.filter.name.toString()
            , "status": this.filter.status.toString()
        };
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/AccountHandler.ashx',
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
                this.g_accountSearchView.fnGeneralMessage("匯出成功。");
            } else {
                this.g_accountSearchView.fnErrorMessage(jsonValues.msg);
            }
        } else {
            this.g_accountSearchView.fnErrorMessage("錯誤訊息：不知名錯誤。");
        }
    },

    fnReport: function () {
        fnLoading();
        var sArg = {
            "method": "fnReport"
            , "order": this.g_order.toString()
            , "id": this.filter.id.toString()
            , "account": this.filter.account.toString()
            , "name": this.filter.name.toString()
            , "status": this.filter.status.toString()
        };
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/AccountHandler.ashx',
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
                window.open("ReportPage.aspx?ReportName=AccountList.rpt", '', 'resizable=yes,location=no');
                this.g_accountSearchView.fnGeneralMessage("報表產生成功。");
            } else {
                this.g_accountSearchView.fnErrorMessage(jsonValues.msg);
            }
        } else {
            this.g_accountSearchView.fnErrorMessage("錯誤訊息：不知名錯誤。");
        }
    },

    fnPrint: function () {
        window.open('Print\\Account\\AccountList.aspx?' + window.location.search.substring(1));
    },

    fnInitList: function () {
        var sPage = fnGetQuery("page", "1");
        var iPage = parseInt(sPage);
        var filter_id = fnGetQuery("filter_id", "");
        var filter_account = fnGetQuery("filter_account", "");
        var filter_name = fnGetQuery("filter_name", "");
        var filter_status = fnGetQuery("filter_status", "");
        var order = fnGetQuery("order", "id");

        this.filter = {
            id: fnFixMNDT(filter_id),
            account: fnFixMNDT(filter_account),
            name: fnFixMNDT(filter_name),
            status: fnFixMNDT(filter_status)
        };
        this.g_order = order;
        this.g_iPage = iPage;
        this.g_accountSearchView.fnShowFilterView(this.filter);
        this.fnSelects();
    },

    fnSelects: function () {

        fnLoading();
        var sArg = {
            "method": "fnSelects"
            , "page": this.g_iPage.toString()
            , "page_max_size": this.g_iMaxPageSize.toString()
            , "order": this.g_order.toString()
            , "id": this.filter.id.toString()
            , "account": this.filter.account.toString()
            , "name": this.filter.name.toString()
            , "status": this.filter.status.toString()
        };
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/AccountHandler.ashx',
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
            this.g_accountSearchView.fnPushColumns(jsonValue);
            iIndex++;
        }
        this.g_accountSearchView.fnShowList();
        if (jsonValues.length == 0) {
            this.g_accountSearchView.fnShowEmptyColumns();
        }
        this.fnCount();
    },

    fnCount: function () {
        var sArg = {
            "method": "fnCount"
            , "id": this.filter.id.toString()
            , "account": this.filter.account.toString()
            , "name": this.filter.name.toString()
            , "status": this.filter.status.toString()
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/AccountHandler.ashx',
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
            this.g_accountSearchView.fnPushPageNumber('|<<', 1, '');
        }

        var iLastPage = this.g_iPage - 2; // 若是第一頁則不顯示
        if (iLastPage > 0) {
            this.g_accountSearchView.fnPushPageNumber('<<', iLastPage, '');
        }

        var iCount = 1;
        var iMinPage = (this.g_iPage - 5) < 2 ? 1 : (this.g_iPage - 5); // 最小為1頁
        for (var iIndex = iMinPage ; iIndex < this.g_iPage; iIndex++) {
            this.g_accountSearchView.fnPushPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        this.g_accountSearchView.fnPushPageNumber(this.g_iPage, this.g_iPage, 'select');

        var jsonValue = $.parseJSON(JSON.stringify(data));
        var iPage = parseInt((jsonValue.page_size / this.g_iMaxPageSize));
        if (jsonValue.page_size % this.g_iMaxPageSize != 0 || iPage == 0) {
            iPage += 1;
        }
        for (var iIndex = (this.g_iPage + 1) ; iIndex <= iPage && iCount < 10; iIndex++) {
            this.g_accountSearchView.fnPushPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        var iNextPage = this.g_iPage + 1;
        if (iNextPage < iPage) {
            this.g_accountSearchView.fnPushPageNumber('>>', iNextPage, '');
        }

        if (this.g_iPage != iPage) {
            this.g_accountSearchView.fnPushPageNumber('>>|', iPage, '');
        }
        this.g_accountSearchView.fnShowPageNumber();
        this.g_accountSearchView.fnInitListEvent();
    },

    fnDelete: function (id) {
        var that = this;
        if (id.length > 0) {
            var sArg = {
                "method": "fnDelete"
                 , "id": id.toString()
            };
            $.ajax({
                url: 'ADMIN/Handler/AccountHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultDelete(data);
                },
                error: function (sError) {
                }
            });
        }
    },

    fnDeletes: function (sIds) {
        var that = this;
        if (sIds.length > 0) {
            var sArg = {
                "method": "fnDeletes"
                 , "id": sIds.toString()
            };
            $.ajax({
                url: 'ADMIN/Handler/AccountHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultDelete(data);
                },
                error: function (sError) {
                }
            });
        }
    },

    fnResultDelete: function (data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            this.fnPageNumberChange('1');
            this.g_accountSearchView.fnGeneralMessage("刪除成功");
        } else {
            this.g_accountSearchView.fnErrorMessage(jsonValue.msg);
        }
    }
};
