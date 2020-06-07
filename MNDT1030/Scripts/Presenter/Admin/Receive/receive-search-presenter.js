
function ReceiveSearchPresenter(receiveSearchView) {
    this.g_receiveSearchView = receiveSearchView;
    this.g_iPage = 1;
    this.g_iMaxPageSize = 8;
}

ReceiveSearchPresenter.prototype = {
    TAG: 'ReceiveSearchPresenter',

    fnInitialization: function () {
        this.g_receiveSearchView.fnInitialization();
        this.fnInitList();
    },

    fnPageNumberChange: function (page) {
        var sArg = '?' + fnGetUpdateQuery('page', page);
        this.g_receiveSearchView.fnChangeUrl(sArg);
    },

    fnOrderChange: function (order) {
        var sArg = '?' + fnGetUpdateQuery('order', order);
        this.g_receiveSearchView.fnChangeUrl(sArg);
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

        this.g_receiveSearchView.fnChangeUrl(sArg);
    },

    fnMaxPageSizeChange: function (page) {
        this.g_iMaxPageSize = page;
        var sArg = '?' + fnGetUpdateQuery('page', '1');
        this.g_receiveSearchView.fnChangeUrl(sArg);
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
        this.g_receiveSearchView.fnShowFilterView(this.filter);
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
            url: 'ADMIN/Handler/ReceiveHandler.ashx',
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
            this.g_receiveSearchView.fnPushColumns(jsonValue);
            iIndex++;
        }
        this.g_receiveSearchView.fnShowList();
        if (jsonValues.length == 0) {
            this.g_receiveSearchView.fnShowEmptyColumns();
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
            url: 'ADMIN/Handler/ReceiveHandler.ashx',
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
            this.g_receiveSearchView.fnPushPageNumber('|<<', 1, '');
        }

        var iLastPage = this.g_iPage - 2; // 若是第一頁則不顯示
        if (iLastPage > 0) {
            this.g_receiveSearchView.fnPushPageNumber('<<', iLastPage, '');
        }

        var iCount = 1;
        var iMinPage = (this.g_iPage - 5) < 2 ? 1 : (this.g_iPage - 5); // 最小為1頁
        for (var iIndex = iMinPage ; iIndex < this.g_iPage; iIndex++) {
            this.g_receiveSearchView.fnPushPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        this.g_receiveSearchView.fnPushPageNumber(this.g_iPage, this.g_iPage, 'select');

        var jsonValue = $.parseJSON(JSON.stringify(data));
        var iPage = parseInt((jsonValue.page_size / this.g_iMaxPageSize));
        if (jsonValue.page_size % this.g_iMaxPageSize != 0 || iPage == 0) {
            iPage += 1;
        }
        for (var iIndex = (this.g_iPage + 1) ; iIndex <= iPage && iCount < 10; iIndex++) {
            this.g_receiveSearchView.fnPushPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        var iNextPage = this.g_iPage + 1;
        if (iNextPage < iPage) {
            this.g_receiveSearchView.fnPushPageNumber('>>', iNextPage, '');
        }

        if (this.g_iPage != iPage) {
            this.g_receiveSearchView.fnPushPageNumber('>>|', iPage, '');
        }
        this.g_receiveSearchView.fnShowPageNumber();
        this.g_receiveSearchView.fnInitListEvent();
    },

    fnDelete: function (order_id) {
        var that = this;
        if (order_id.length > 0) {
            var sArg = {
                "method": "fnDelete"
                 , "order_id": order_id.toString()
            };
            $.ajax({
                url: 'ADMIN/Handler/ReceiveHandler.ashx',
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
            this.g_receiveSearchView.fnGeneralMessage("刪除成功");
        } else {
            this.g_receiveSearchView.fnErrorMessage(jsonValue.msg);
        }
    }
}
