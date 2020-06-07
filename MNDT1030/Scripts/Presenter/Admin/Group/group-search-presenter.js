
function GroupSearchPresenter(groupSearchView) {
    this.g_groupSearchView = groupSearchView;
    this.g_iPage = 1;
    this.g_iMaxPageSize = 8;
}

GroupSearchPresenter.prototype = {
    TAG: 'GroupSearchPresenter',

    fnInitialization: function () {
        this.g_groupSearchView.fnInitialization();
        this.fnInitList();
    },

    fnPageNumberChange: function (page) {
        var sArg = '?' + fnGetUpdateQuery('page', page);
        this.g_groupSearchView.fnChangeUrl(sArg);
    },

    fnOrderChange: function (order) {
        var sArg = '?' + fnGetUpdateQuery('order', order);
        this.g_groupSearchView.fnChangeUrl(sArg);
    },

    fnFilterChange: function (filter) {
        var sArg = '?';

        if (filter.group_id.length > 0) {
            sArg += 'filter_group_id=' + fnToMNDT(filter.group_id) + '&';
        }

        if (filter.id.length > 0) {
            sArg += 'filter_id=' + fnToMNDT(filter.id) + '&';
        }

        if (filter.account.length > 0) {
            sArg += 'filter_account=' + fnToMNDT(filter.account) + '&';
        }

        if (filter.name.length > 0) {
            sArg += 'filter_name=' + fnToMNDT(filter.name) + '&';
        }

        if (sArg[sArg.length - 1] == '&') {
            sArg = sArg.substring(0, sArg.length - 1);
        }

        this.g_groupSearchView.fnChangeUrl(sArg);
    },

    fnMaxPageSizeChange: function (page) {
        this.g_iMaxPageSize = page;
        var sArg = '?' + fnGetUpdateQuery('page', '1');
        this.g_groupSearchView.fnChangeUrl(sArg);
    },

    fnInitList: function () {
        var sPage = fnGetQuery("page", "1");
        var iPage = parseInt(sPage);
        var filter_id = fnGetQuery("filter_id", "");
        var filter_group_id = fnGetQuery("filter_group_id", "");
        var filter_account = fnGetQuery("filter_account", "");
        var filter_name = fnGetQuery("filter_name", "");
        var order = fnGetQuery("order", "group_id");

        this.filter = {
            id: fnFixMNDT(filter_id),
            group_id: fnFixMNDT(filter_group_id),
            account: fnFixMNDT(filter_account),
            name: fnFixMNDT(filter_name)
        };

        this.g_order = order;
        this.g_iPage = iPage;
        this.g_groupSearchView.fnShowFilterView(this.filter);
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
            , "group_id": this.filter.group_id.toString()
            , "account": this.filter.account.toString()
            , "name": this.filter.name.toString()
        };
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/GroupHandler.ashx',
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
            this.g_groupSearchView.fnPushColumns(jsonValue);
            iIndex++;
        }
        this.g_groupSearchView.fnShowList();
        if (jsonValues.length == 0) {
            this.g_groupSearchView.fnShowEmptyColumns();
        }
        this.fnCount();
    },

    fnCount: function () {
        var sArg = {
            "method": "fnCount"
            , "id": this.filter.id.toString()
            , "group_id": this.filter.group_id.toString()
            , "account": this.filter.account.toString()
            , "name": this.filter.name.toString()
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/GroupHandler.ashx',
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
            this.g_groupSearchView.fnPushPageNumber('|<<', 1, '');
        }

        var iLastPage = this.g_iPage - 2; // 若是第一頁則不顯示
        if (iLastPage > 0) {
            this.g_groupSearchView.fnPushPageNumber('<<', iLastPage, '');
        }

        var iCount = 1;
        var iMinPage = (this.g_iPage - 5) < 2 ? 1 : (this.g_iPage - 5); // 最小為1頁
        for (var iIndex = iMinPage ; iIndex < this.g_iPage; iIndex++) {
            this.g_groupSearchView.fnPushPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        this.g_groupSearchView.fnPushPageNumber(this.g_iPage, this.g_iPage, 'select');

        var jsonValue = $.parseJSON(JSON.stringify(data));
        var iPage = parseInt((jsonValue.page_size / this.g_iMaxPageSize));
        if (jsonValue.page_size % this.g_iMaxPageSize != 0 || iPage == 0) {
            iPage += 1;
        }
        for (var iIndex = (this.g_iPage + 1) ; iIndex <= iPage && iCount < 10; iIndex++) {
            this.g_groupSearchView.fnPushPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        var iNextPage = this.g_iPage + 1;
        if (iNextPage < iPage) {
            this.g_groupSearchView.fnPushPageNumber('>>', iNextPage, '');
        }

        if (this.g_iPage != iPage) {
            this.g_groupSearchView.fnPushPageNumber('>>|', iPage, '');
        }
        this.g_groupSearchView.fnShowPageNumber();
        this.g_groupSearchView.fnInitListEvent();
    },

    fnDelete: function (group_id) {
        var that = this;
        if (group_id.length > 0) {
            var sArg = {
                "method": "fnDelete"
                 , "group_id": group_id.toString()
            };
            $.ajax({
                url: 'ADMIN/Handler/GroupHandler.ashx',
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
            this.g_groupSearchView.fnGeneralMessage("刪除成功");
        } else {
            this.g_groupSearchView.fnErrorMessage(jsonValue.msg);
        }
    }
}
