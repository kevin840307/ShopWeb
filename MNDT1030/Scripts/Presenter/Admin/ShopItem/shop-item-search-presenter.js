

function ShopItemSearchPresenter(viewPage) {
    this.g_shopItemSearchView = viewPage;
    this.g_iPage = 1;
    this.g_iMaxPageSize = 8;
}

ShopItemSearchPresenter.prototype = {
    TAG: 'ShopItemReadOnlyPresenter',

    fnInitialization: function () {
        this.g_shopItemSearchView.fnInitialization();
        this.fnInitList();
    },

    fnPageNumberChange: function (page) {
        var sArg = '?' + fnGetUpdateQuery('page', page);
        this.g_shopItemSearchView.fnChangeUrl(sArg);
    },

    fnOrderChange: function (order) {
        var sArg = '?' + fnGetUpdateQuery('order', order);
        this.g_shopItemSearchView.fnChangeUrl(sArg);
    },

    fnFilterChange: function (filter) {
        var sArg = '?';

        if (filter.product_id.length > 0) {
            sArg += 'filter_product_id=' + fnToMNDT(filter.product_id) + '&';
        }

        if (filter.status.length > 0) {
            sArg += 'filter_status=' + fnToMNDT(filter.status);
        }

        if (sArg[sArg.length - 1] == '&') {
            sArg = sArg.substring(0, sArg.length - 1);
        }

        this.g_shopItemSearchView.fnChangeUrl(sArg);
    },

    fnMaxPageSizeChange: function (page) {
        this.g_iMaxPageSize = page;
        var sArg = '?' + fnGetUpdateQuery('page', '1');
        this.g_shopItemSearchView.fnChangeUrl(sArg);
    },

    fnImport: function (formData) {
        var that = this;
        $.ajax({
            type: 'post',
            url: 'ADMIN/Handler/ShopItemHandler.ashx',
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
                this.g_shopItemSearchView.fnGeneralMessage("匯入成功。");
            } else {
                this.g_shopItemSearchView.fnErrorMessage(jsonValues.msg);
            }
        } else {
            this.g_shopItemSearchView.fnErrorMessage("錯誤訊息：不知名錯誤。");
        }
    },

    fnExport: function () {
        fnLoading();
        var sArg = {
            "method": "fnExport"
            , "order": this.g_order.toString()
            , "product_id": this.filter.product_id.toString()
            , "status": this.filter.status.toString()
        };
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/ShopItemHandler.ashx',
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
                this.g_shopItemSearchView.fnGeneralMessage("匯出成功。");
            } else {
                this.g_shopItemSearchView.fnErrorMessage(jsonValues.msg);
            }
        } else {
            this.g_shopItemSearchView.fnErrorMessage("錯誤訊息：不知名錯誤。");
        }
    },

    fnReport: function () {
        fnLoading();
        var sArg = {
            "method": "fnReport"
            , "order": this.g_order.toString()
            , "product_id": this.filter.product_id.toString()
            , "status": this.filter.status.toString()
        };
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/ShopItemHandler.ashx',
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
                window.open("ReportPage.aspx?ReportName=ShopItemList.rpt", '', 'resizable=yes,location=no');
                this.g_shopItemSearchView.fnGeneralMessage("報表產生成功。");
            } else {
                this.g_shopItemSearchView.fnErrorMessage(jsonValues.msg);
            }
        } else {
            this.g_shopItemSearchView.fnErrorMessage("錯誤訊息：不知名錯誤。");
        }
    },

    fnPrint: function () {
        window.open('Print\\ShopItem\\ShopItemList.aspx?' + window.location.search.substring(1));
    },

    fnInitList: function () {
        var sPage = fnGetQuery("page", "1");
        var iPage = parseInt(sPage);
        var filter_product_id = fnGetQuery("filter_product_id", "");
        var filter_status = fnGetQuery("filter_status", "");
        var order = fnGetQuery("order", "product_id");

        this.filter = {
            product_id: fnFixMNDT(filter_product_id),
            status: fnFixMNDT(filter_status)
        };
        this.g_order = order;
        this.g_iPage = iPage;
        this.g_shopItemSearchView.fnShowFilterView(this.filter);
        this.fnSelects();
    },

    fnSelects: function () {

        fnLoading();
        var sArg = {
            "method": "fnSelects"
            , "page": this.g_iPage.toString()
            , "page_max_size": this.g_iMaxPageSize.toString()
            , "order": this.g_order.toString()
            , "product_id": this.filter.product_id.toString()
            , "status": this.filter.status.toString()
        };
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/ShopItemHandler.ashx',
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
            this.g_shopItemSearchView.fnPushColumns(jsonValue);
            iIndex++;
        }
        this.g_shopItemSearchView.fnShowList();
        if (jsonValues.length == 0) {
            this.g_shopItemSearchView.fnShowEmptyColumns();
        }
        this.fnCount();
    },

    fnCount: function () {
        var sArg = {
            "method": "fnCount"
            , "product_id": this.filter.product_id.toString()
            , "status": this.filter.status.toString()
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/ShopItemHandler.ashx',
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
            this.g_shopItemSearchView.fnPushPageNumber('|<<', 1, '');
        }

        var iLastPage = this.g_iPage - 2; // 若是第一頁則不顯示
        if (iLastPage > 0) {
            this.g_shopItemSearchView.fnPushPageNumber('<<', iLastPage, '');
        }

        var iCount = 1;
        var iMinPage = (this.g_iPage - 5) < 2 ? 1 : (this.g_iPage - 5); // 最小為1頁
        for (var iIndex = iMinPage ; iIndex < this.g_iPage; iIndex++) {
            this.g_shopItemSearchView.fnPushPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        this.g_shopItemSearchView.fnPushPageNumber(this.g_iPage, this.g_iPage, 'select');

        var jsonValue = $.parseJSON(JSON.stringify(data));
        var iPage = parseInt((jsonValue.page_size / this.g_iMaxPageSize));
        if (jsonValue.page_size % this.g_iMaxPageSize != 0 || iPage == 0) {
            iPage += 1;
        }
        for (var iIndex = (this.g_iPage + 1) ; iIndex <= iPage && iCount < 10; iIndex++) {
            this.g_shopItemSearchView.fnPushPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        var iNextPage = this.g_iPage + 1;
        if (iNextPage < iPage) {
            this.g_shopItemSearchView.fnPushPageNumber('>>', iNextPage, '');
        }

        if (this.g_iPage != iPage) {
            this.g_shopItemSearchView.fnPushPageNumber('>>|', iPage, '');
        }
        this.g_shopItemSearchView.fnShowPageNumber();
        this.g_shopItemSearchView.fnInitListEvent();
    },

    fnDelete: function (product_id) {
        var that = this;
        if (product_id.length > 0) {
            var sArg = {
                "method": "fnDelete"
                 , "product_id": product_id.toString()
            };
            $.ajax({
                url: 'ADMIN/Handler/ShopItemHandler.ashx',
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

    fnDeletes: function (product_ids) {
        var that = this;
        if (product_ids.length > 0) {
            var sArg = {
                "method": "fnDeletes"
                 , "product_id": product_ids.toString()
            };
            $.ajax({
                url: 'ADMIN/Handler/ShopItemHandler.ashx',
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
            this.g_shopItemSearchView.fnGeneralMessage("刪除成功");
        } else {
            this.g_shopItemSearchView.fnErrorMessage(jsonValue.msg);
        }
    }
};
