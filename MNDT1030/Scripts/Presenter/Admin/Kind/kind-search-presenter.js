
function KindSearchPresenter(kindSearchView) {
    this.g_kindSearchView = kindSearchView;
    this.g_iPage = 1;
    this.g_iMaxPageSize = 8;
}

KindSearchPresenter.prototype = {
    TAG: 'KindSearchPresenter',

    fnInitialization: function () {
        this.g_kindSearchView.fnInitialization();
        this.fnInitList();
    },

    fnPageNumberChange: function (page) {
        var sArg = '?' + fnGetUpdateQuery('page', page);
        this.g_kindSearchView.fnChangeUrl(sArg);
    },

    fnOrderChange: function (order) {
        var sArg = '?' + fnGetUpdateQuery('order', order);
        this.g_kindSearchView.fnChangeUrl(sArg);
    },

    fnFilterChange: function (filter) {
        var sArg = '?';

        if (filter.kind_id.length > 0) {
            sArg += 'filter_kind_id=' + fnToMNDT(filter.kind_id) + '&';
        }

        if (filter.name.length > 0) {
            sArg += 'filter_name=' + fnToMNDT(filter.name) + '&';
        }

        if (sArg[sArg.length - 1] == '&') {
            sArg = sArg.substring(0, sArg.length - 1);
        }

        this.g_kindSearchView.fnChangeUrl(sArg);
    },

    fnMaxPageSizeChange: function (page) {
        this.g_iMaxPageSize = page;
        var sArg = '?' + fnGetUpdateQuery('page', '1');
        this.g_kindSearchView.fnChangeUrl(sArg);
    },

    fnInitList: function () {
        var sPage = fnGetQuery("page", "1");
        var iPage = parseInt(sPage);
        var filter_kind_id = fnGetQuery("filter_kind_id", "");
        var filter_name = fnGetQuery("filter_name", "");
        var order = fnGetQuery("order", "kind_id");

        this.filter = {
            kind_id: fnFixMNDT(filter_kind_id),
            name: fnFixMNDT(filter_name)
        };

        this.g_order = order;
        this.g_iPage = iPage;
        this.g_kindSearchView.fnShowFilterView(this.filter);
        this.fnSelects();
    },

    fnSelects: function () {

        fnLoading();
        var sArg = {
            "method": "fnSelects"
            , "page": this.g_iPage.toString()
            , "page_max_size": this.g_iMaxPageSize.toString()
            , "order": this.g_order.toString()
            , "kind_id": this.filter.kind_id.toString()
            , "name": this.filter.name.toString()
        };
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/KindHandler.ashx',
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
            this.g_kindSearchView.fnPushColumns(jsonValue);
            iIndex++;
        }
        this.g_kindSearchView.fnShowList();
        if (jsonValues.length == 0) {
            this.g_kindSearchView.fnShowEmptyColumns();
        }
        this.fnCount();
    },

    fnCount: function () {
        var sArg = {
            "method": "fnCount"
            , "kind_id": this.filter.kind_id.toString()
            , "name": this.filter.name.toString()
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/KindHandler.ashx',
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
            this.g_kindSearchView.fnPushPageNumber('|<<', 1, '');
        }

        var iLastPage = this.g_iPage - 2; // 若是第一頁則不顯示
        if (iLastPage > 0) {
            this.g_kindSearchView.fnPushPageNumber('<<', iLastPage, '');
        }

        var iCount = 1;
        var iMinPage = (this.g_iPage - 5) < 2 ? 1 : (this.g_iPage - 5); // 最小為1頁
        for (var iIndex = iMinPage ; iIndex < this.g_iPage; iIndex++) {
            this.g_kindSearchView.fnPushPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        this.g_kindSearchView.fnPushPageNumber(this.g_iPage, this.g_iPage, 'select');

        var jsonValue = $.parseJSON(JSON.stringify(data));
        var iPage = parseInt((jsonValue.page_size / this.g_iMaxPageSize));
        if (jsonValue.page_size % this.g_iMaxPageSize != 0 || iPage == 0) {
            iPage += 1;
        }
        for (var iIndex = (this.g_iPage + 1) ; iIndex <= iPage && iCount < 10; iIndex++) {
            this.g_kindSearchView.fnPushPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        var iNextPage = this.g_iPage + 1;
        if (iNextPage < iPage) {
            this.g_kindSearchView.fnPushPageNumber('>>', iNextPage, '');
        }

        if (this.g_iPage != iPage) {
            this.g_kindSearchView.fnPushPageNumber('>>|', iPage, '');
        }
        this.g_kindSearchView.fnShowPageNumber();
        this.g_kindSearchView.fnInitListEvent();
    },

    fnDelete: function (kind_id) {
        var that = this;
        if (kind_id.length > 0) {
            var sArg = {
                "method": "fnDelete"
                 , "kind_id": kind_id.toString()
            };
            $.ajax({
                url: 'ADMIN/Handler/KindHandler.ashx',
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
            this.g_kindSearchView.fnGeneralMessage("刪除成功");
        } else {
            this.g_kindSearchView.fnErrorMessage(jsonValue.msg);
        }
    }
}
