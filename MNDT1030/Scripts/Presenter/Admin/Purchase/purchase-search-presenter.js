
function PurchaseSearchPresenter(purchaseSearchView) {
    this.g_purchaseSearchView = purchaseSearchView;
    this.g_iPage = 1;
    this.g_iMaxPageSize = 8;
}

PurchaseSearchPresenter.prototype = {
    TAG: 'PurchaseSearchPresenter',

    fnInitialization: function () {
        this.g_purchaseSearchView.fnInitialization();
        this.fnInitList();
    },

    fnPageNumberChange: function (page) {
        var sArg = '?' + fnGetUpdateQuery('page', page);
        this.g_purchaseSearchView.fnChangeUrl(sArg);
    },

    fnOrderChange: function (order) {
        var sArg = '?' + fnGetUpdateQuery('order', order);
        this.g_purchaseSearchView.fnChangeUrl(sArg);
    },

    fnFilterChange: function (filter) {
        var sArg = '?';

        if (filter.order_id.length > 0) {
            sArg += 'filter_order_id=' + fnToMNDT(filter.order_id) + '&';
        }

        if (filter.id.length > 0) {
            sArg += 'filter_id=' + fnToMNDT(filter.id) + '&';
        }

        if (filter.datetime.length > 0) {
            sArg += 'filter_datetime=' + fnToMNDT(filter.datetime) + '&';
        }

        if (sArg[sArg.length - 1] == '&') {
            sArg = sArg.substring(0, sArg.length - 1);
        }

        this.g_purchaseSearchView.fnChangeUrl(sArg);
    },

    fnMaxPageSizeChange: function (page) {
        this.g_iMaxPageSize = page;
        var sArg = '?' + fnGetUpdateQuery('page', '1');
        this.g_purchaseSearchView.fnChangeUrl(sArg);
    },

    fnInitList: function () {
        var sPage = fnGetQuery("page", "1");
        var iPage = parseInt(sPage);
        var filter_order_id = fnGetQuery("filter_order_id", "");
        var filter_id = fnGetQuery("filter_id", "");
        var filter_datetime = fnGetQuery("filter_datetime", "");
        var order = fnGetQuery("order", "order_id");

        this.filter = {
            order_id: fnFixMNDT(filter_order_id),
            id: fnFixMNDT(filter_id),
            datetime: fnFixMNDT(filter_datetime)
        };

        this.g_order = order;
        this.g_iPage = iPage;
        this.g_purchaseSearchView.fnShowFilterView(this.filter);
        this.fnSelects();
    },

    fnSelects: function () {

        fnLoading();
        var sArg = {
            "method": "fnSelects"
            , "page": this.g_iPage.toString()
            , "page_max_size": this.g_iMaxPageSize.toString()
            , "order": this.g_order.toString()
            , "order_id": this.filter.order_id.toString()
            , "id": this.filter.id.toString()
            , "datetime": this.filter.datetime.toString()
        };
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/PurchaseHandler.ashx',
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
            this.g_purchaseSearchView.fnPushColumns(jsonValue);
            iIndex++;
        }
        this.g_purchaseSearchView.fnShowList();
        if (jsonValues.length == 0) {
            this.g_purchaseSearchView.fnShowEmptyColumns();
        }
        this.fnCount();
    },

    fnCount: function () {
        var sArg = {
            "method": "fnCount"
            , "order_id": this.filter.order_id.toString()
            , "id": this.filter.id.toString()
            , "datetime": this.filter.datetime.toString()
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/PurchaseHandler.ashx',
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
            this.g_purchaseSearchView.fnPushPageNumber('|<<', 1, '');
        }

        var iLastPage = this.g_iPage - 2; // 若是第一頁則不顯示
        if (iLastPage > 0) {
            this.g_purchaseSearchView.fnPushPageNumber('<<', iLastPage, '');
        }

        var iCount = 1;
        var iMinPage = (this.g_iPage - 5) < 2 ? 1 : (this.g_iPage - 5); // 最小為1頁
        for (var iIndex = iMinPage ; iIndex < this.g_iPage; iIndex++) {
            this.g_purchaseSearchView.fnPushPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        this.g_purchaseSearchView.fnPushPageNumber(this.g_iPage, this.g_iPage, 'select');

        var jsonValue = $.parseJSON(JSON.stringify(data));
        var iPage = parseInt((jsonValue.page_size / this.g_iMaxPageSize));
        if (jsonValue.page_size % this.g_iMaxPageSize != 0 || iPage == 0) {
            iPage += 1;
        }
        for (var iIndex = (this.g_iPage + 1) ; iIndex <= iPage && iCount < 10; iIndex++) {
            this.g_purchaseSearchView.fnPushPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        var iNextPage = this.g_iPage + 1;
        if (iNextPage < iPage) {
            this.g_purchaseSearchView.fnPushPageNumber('>>', iNextPage, '');
        }

        if (this.g_iPage != iPage) {
            this.g_purchaseSearchView.fnPushPageNumber('>>|', iPage, '');
        }
        this.g_purchaseSearchView.fnShowPageNumber();
        this.g_purchaseSearchView.fnInitListEvent();
    },

    fnDelete: function (order_id) {
        var that = this;
        if (order_id.length > 0) {
            var sArg = {
                "method": "fnDelete"
                 , "order_id": order_id.toString()
            };
            $.ajax({
                url: 'ADMIN/Handler/PurchaseHandler.ashx',
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
            this.g_purchaseSearchView.fnGeneralMessage("刪除成功");
        } else {
            this.g_purchaseSearchView.fnErrorMessage(jsonValue.msg);
        }
    }
}
