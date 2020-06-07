
function ProductSearchPresenter(productSearchView) {
    this.g_productSearchView = productSearchView;
    this.g_iPage = 1;
    this.g_iMaxPageSize = 8;
}

ProductSearchPresenter.prototype = {
    TAG: 'ProductSearchPresenter',

    fnInitialization: function () {
        this.g_productSearchView.fnInitialization();
        this.fnInitList();
    },

    fnPageNumberChange: function (page) {
        var sArg = '?' + fnGetUpdateQuery('page', page);
        this.g_productSearchView.fnChangeUrl(sArg);
    },

    fnOrderChange: function (order) {
        var sArg = '?' + fnGetUpdateQuery('order', order);
        this.g_productSearchView.fnChangeUrl(sArg);
    },

    fnFilterChange: function (filter) {
        var sArg = '?';

        if (filter.product_id.length > 0) {
            sArg += 'filter_product_id=' + fnToMNDT(filter.product_id) + '&';
        }

        if (filter.company_id.length > 0) {
            sArg += 'filter_company_id=' + fnToMNDT(filter.company_id) + '&';
        }

        if (filter.name.length > 0) {
            sArg += 'filter_name=' + fnToMNDT(filter.name) + '&';
        }

        if (sArg[sArg.length - 1] == '&') {
            sArg = sArg.substring(0, sArg.length - 1);
        }

        this.g_productSearchView.fnChangeUrl(sArg);
    },

    fnMaxPageSizeChange: function (page) {
        this.g_iMaxPageSize = page;
        var sArg = '?' + fnGetUpdateQuery('page', '1');
        this.g_productSearchView.fnChangeUrl(sArg);
    },

    fnInitList: function () {
        var sPage = fnGetQuery("page", "1");
        var iPage = parseInt(sPage);
        var filter_product_id = fnGetQuery("filter_product_id", "");
        var filter_company_id = fnGetQuery("company_id", "");
        var filter_name = fnGetQuery("filter_name", "");
        var order = fnGetQuery("order", "product_id");

        this.filter = {
            product_id: fnFixMNDT(filter_product_id),
            company_id: fnFixMNDT(filter_company_id),
            name: fnFixMNDT(filter_name)
        };

        this.g_order = order;
        this.g_iPage = iPage;
        this.g_productSearchView.fnShowFilterView(this.filter);
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
            , "company_id": this.filter.company_id.toString()
            , "name": this.filter.name.toString()
        };
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/ProductHandler.ashx',
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
            this.g_productSearchView.fnPushColumns(jsonValue);
            iIndex++;
        }
        this.g_productSearchView.fnShowList();
        if (jsonValues.length == 0) {
            this.g_productSearchView.fnShowEmptyColumns();
        }
        this.fnCount();
    },

    fnCount: function () {
        var sArg = {
            "method": "fnCount"
            , "product_id": this.filter.product_id.toString()
            , "company_id": this.filter.company_id.toString()
            , "name": this.filter.name.toString()
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/ProductHandler.ashx',
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
            this.g_productSearchView.fnPushPageNumber('|<<', 1, '');
        }

        var iLastPage = this.g_iPage - 2; // 若是第一頁則不顯示
        if (iLastPage > 0) {
            this.g_productSearchView.fnPushPageNumber('<<', iLastPage, '');
        }

        var iCount = 1;
        var iMinPage = (this.g_iPage - 5) < 2 ? 1 : (this.g_iPage - 5); // 最小為1頁
        for (var iIndex = iMinPage ; iIndex < this.g_iPage; iIndex++) {
            this.g_productSearchView.fnPushPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        this.g_productSearchView.fnPushPageNumber(this.g_iPage, this.g_iPage, 'select');

        var jsonValue = $.parseJSON(JSON.stringify(data));
        var iPage = parseInt((jsonValue.page_size / this.g_iMaxPageSize));
        if (jsonValue.page_size % this.g_iMaxPageSize != 0 || iPage == 0) {
            iPage += 1;
        }
        for (var iIndex = (this.g_iPage + 1) ; iIndex <= iPage && iCount < 10; iIndex++) {
            this.g_productSearchView.fnPushPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        var iNextPage = this.g_iPage + 1;
        if (iNextPage < iPage) {
            this.g_productSearchView.fnPushPageNumber('>>', iNextPage, '');
        }

        if (this.g_iPage != iPage) {
            this.g_productSearchView.fnPushPageNumber('>>|', iPage, '');
        }
        this.g_productSearchView.fnShowPageNumber();
        this.g_productSearchView.fnInitListEvent();
    },

    fnDelete: function (product_id) {
        var that = this;
        if (product_id.length > 0) {
            var sArg = {
                "method": "fnDelete"
                 , "product_id": product_id.toString()
            };
            $.ajax({
                url: 'ADMIN/Handler/ProductHandler.ashx',
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
            this.g_productSearchView.fnGeneralMessage("刪除成功");
        } else {
            this.g_productSearchView.fnErrorMessage(jsonValue.msg);
        }
    }
}
