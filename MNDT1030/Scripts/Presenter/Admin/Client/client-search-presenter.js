

function ClientSearchPresenter(viewPage) {
    this.g_clientSearchView = viewPage;
    this.g_iPage = 1;
    this.g_iMaxPageSize = 8;
}

ClientSearchPresenter.prototype = {
    TAG: 'ClientReadOnlyPresenter',

    fnInitialization: function () {
        this.g_clientSearchView.fnInitialization();
        this.fnInitList();
    },

    fnPageNumberChange: function (page) {
        var sArg = '?' + fnGetUpdateQuery('page', page);
        this.g_clientSearchView.fnChangeUrl(sArg);
    },

    fnOrderChange: function (order) {
        var sArg = '?' + fnGetUpdateQuery('order', order);
        this.g_clientSearchView.fnChangeUrl(sArg);
    },

    fnFilterChange: function (filter) {
        var sArg = '?';

        if (filter.client_id.length > 0) {
            sArg += 'filter_client_id=' + fnToMNDT(filter.client_id) + '&';
        }

        if (filter.name.length > 0) {
            sArg += 'filter_name=' + fnToMNDT(filter.name) + '&';
        }

        if (filter.phone.length > 0) {
            sArg += 'filter_phone=' + fnToMNDT(filter.phone) + '&';
        }

        if (filter.status.length > 0) {
            sArg += 'filter_status=' + fnToMNDT(filter.status);
        }

        if (sArg[sArg.length - 1] == '&') {
            sArg = sArg.substring(0, sArg.length - 1);
        }

        this.g_clientSearchView.fnChangeUrl(sArg);
    },

    fnMaxPageSizeChange: function (page) {
        this.g_iMaxPageSize = page;
        var sArg = '?' + fnGetUpdateQuery('page', '1');
        this.g_clientSearchView.fnChangeUrl(sArg);
    },

    fnImport: function (formData) {
        var that = this;
        $.ajax({
            type: 'post',
            url: 'ADMIN/Handler/ClientHandler.ashx',
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
                this.g_clientSearchView.fnGeneralMessage("匯入成功。");
            } else {
                this.g_clientSearchView.fnErrorMessage(jsonValues.msg);
            }
        } else {
            this.g_clientSearchView.fnErrorMessage("錯誤訊息：不知名錯誤。");
        }
    },

    fnExport: function () {
        fnLoading();
        var sArg = {
            "method": "fnExport"
            , "order": this.g_order.toString()
            , "client_id": this.filter.client_id.toString()
            , "phone": this.filter.phone.toString()
            , "name": this.filter.name.toString()
            , "status": this.filter.status.toString()
        };
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/ClientHandler.ashx',
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
                this.g_clientSearchView.fnGeneralMessage("匯出成功。");
            } else {
                this.g_clientSearchView.fnErrorMessage(jsonValues.msg);
            }
        } else {
            this.g_clientSearchView.fnErrorMessage("錯誤訊息：不知名錯誤。");
        }
    },

    fnReport: function () {
        fnLoading();
        var sArg = {
            "method": "fnReport"
            , "order": this.g_order.toString()
            , "client_id": this.filter.client_id.toString()
            , "phone": this.filter.phone.toString()
            , "name": this.filter.name.toString()
            , "status": this.filter.status.toString()
        };
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/ClientHandler.ashx',
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
                window.open("ReportPage.aspx?ReportName=ClientList.rpt", '', 'resizable=yes,location=no');
                this.g_clientSearchView.fnGeneralMessage("報表產生成功。");
            } else {
                this.g_clientSearchView.fnErrorMessage(jsonValues.msg);
            }
        } else {
            this.g_clientSearchView.fnErrorMessage("錯誤訊息：不知名錯誤。");
        }
    },

    fnPrint: function () {
        window.open('Print\\Client\\ClientList.aspx?' + window.location.search.substring(1));
    },

    fnInitList: function () {
        var sPage = fnGetQuery("page", "1");
        var iPage = parseInt(sPage);
        var filter_client_id = fnGetQuery("filter_client_id", "");
        var filter_phone = fnGetQuery("filter_phone", "");
        var filter_name = fnGetQuery("filter_name", "");
        var filter_status = fnGetQuery("filter_status", "");
        var order = fnGetQuery("order", "client_id");

        this.filter = {
            client_id: fnFixMNDT(filter_client_id),
            name: fnFixMNDT(filter_name),
            phone: fnFixMNDT(filter_phone),
            status: fnFixMNDT(filter_status)
        };
        this.g_order = order;
        this.g_iPage = iPage;
        this.g_clientSearchView.fnShowFilterView(this.filter);
        this.fnSelects();
    },

    fnSelects: function () {

        fnLoading();
        var sArg = {
            "method": "fnSelects"
            , "page": this.g_iPage.toString()
            , "page_max_size": this.g_iMaxPageSize.toString()
            , "order": this.g_order.toString()
            , "client_id": this.filter.client_id.toString()
            , "phone": this.filter.phone.toString()
            , "name": this.filter.name.toString()
            , "status": this.filter.status.toString()
        };
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/ClientHandler.ashx',
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
            this.g_clientSearchView.fnPushColumns(jsonValue);
            iIndex++;
        }
        this.g_clientSearchView.fnShowList();
        if (jsonValues.length == 0) {
            this.g_clientSearchView.fnShowEmptyColumns();
        }
        this.fnCount();
    },

    fnCount: function () {
        var sArg = {
            "method": "fnCount"
            , "client_id": this.filter.client_id.toString()
            , "phone": this.filter.phone.toString()
            , "name": this.filter.name.toString()
            , "status": this.filter.status.toString()
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/ClientHandler.ashx',
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
            this.g_clientSearchView.fnPushPageNumber('|<<', 1, '');
        }

        var iLastPage = this.g_iPage - 2; // 若是第一頁則不顯示
        if (iLastPage > 0) {
            this.g_clientSearchView.fnPushPageNumber('<<', iLastPage, '');
        }

        var iCount = 1;
        var iMinPage = (this.g_iPage - 5) < 2 ? 1 : (this.g_iPage - 5); // 最小為1頁
        for (var iIndex = iMinPage ; iIndex < this.g_iPage; iIndex++) {
            this.g_clientSearchView.fnPushPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        this.g_clientSearchView.fnPushPageNumber(this.g_iPage, this.g_iPage, 'select');

        var jsonValue = $.parseJSON(JSON.stringify(data));
        var iPage = parseInt((jsonValue.page_size / this.g_iMaxPageSize));
        if (jsonValue.page_size % this.g_iMaxPageSize != 0 || iPage == 0) {
            iPage += 1;
        }
        for (var iIndex = (this.g_iPage + 1) ; iIndex <= iPage && iCount < 10; iIndex++) {
            this.g_clientSearchView.fnPushPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        var iNextPage = this.g_iPage + 1;
        if (iNextPage < iPage) {
            this.g_clientSearchView.fnPushPageNumber('>>', iNextPage, '');
        }

        if (this.g_iPage != iPage) {
            this.g_clientSearchView.fnPushPageNumber('>>|', iPage, '');
        }
        this.g_clientSearchView.fnShowPageNumber();
        this.g_clientSearchView.fnInitListEvent();
    },

    fnDelete: function (client_id) {
        var that = this;
        if (client_id.length > 0) {
            var sArg = {
                "method": "fnDelete"
                 , "client_id": client_id.toString()
            };
            $.ajax({
                url: 'ADMIN/Handler/ClientHandler.ashx',
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

    fnDeletes: function (sClientIds) {
        var that = this;
        if (sClientIds.length > 0) {
            var sArg = {
                "method": "fnDeletes"
                 , "client_id": sClientIds.toString()
            };
            $.ajax({
                url: 'ADMIN/Handler/ClientHandler.ashx',
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
            this.g_clientSearchView.fnGeneralMessage("刪除成功");
        } else {
            this.g_clientSearchView.fnErrorMessage(jsonValue.msg);
        }
    }
};
