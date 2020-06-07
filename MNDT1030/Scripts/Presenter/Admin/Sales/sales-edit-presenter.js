

function SalesEditPresenter(salesEditView) {
    this.g_salesEditView = salesEditView;
    this.g_sOrderId = '';
}

SalesEditPresenter.prototype = {
    TAG: 'SalesEditPresenter',

    fnInitialization: function () {
        this.g_sOrderId = fnGetQuery("order_id", "");
        this.g_iMaxPageSize = 8;
        this.g_salesEditView.fnInitialization();
        this.fnInitializationTab1();
    },

    fnResultSelectList: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));

        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_salesEditView.fnPushSelectList(jsonValue);
            iIndex++;
        }
    },

    fnSelectOrderId: function (value) {
        var sNUM = fnGetQuery("NUM", "");
        if (sNUM.length > 0) {
            fnLoading();
            sNUM = (parseInt(sNUM) + value).toString();
            var sArg = {
                "method": "fnSelectOrderId",
                id: fnFixMNDT(fnGetQuery("filter_id", "")),
                order_id: fnFixMNDT(fnGetQuery("filter_order_id", "")),
                account: fnFixMNDT(fnGetQuery("filter_account", "")),
                name: fnFixMNDT(fnGetQuery("filter_name", "")),
                datetime: fnFixMNDT(fnGetQuery("filter_datetime", "")),
                order: fnGetQuery("order", "order_id"),
                NUM: sNUM
            };
            var that = this;

            $.ajax({
                url: 'ADMIN/Handler/SalesHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectOrderId(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'SalesSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：NUM錯誤，跳往查詢頁面。');
            window.location = 'SalesSearchView.aspx';
        }
    },

    fnResultSelectOrderId: function (data) {
        if (data != null) {
            var jsonValue = $.parseJSON(JSON.stringify(data));
            if (jsonValue != null) {
                if (jsonValue.msg == 'Y') {
                    var sArg = fnGetUpdateQuery('order_id', jsonValue.order_id);
                    sArg = fnUpdateQuery(sArg, 'NUM', jsonValue.NUM);
                    window.location = 'SalesEditView.aspx?' + sArg;
                } else {
                    this.g_salesEditView.fnGeneralMessage(jsonValue.msg);
                    fnLoaded();
                }
            } else {
                alert('錯誤訊息：資料錯誤，跳往查詢頁面。');
                window.location = 'SalesSearchView.aspx';
            }
        } else {
            alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
            window.location = 'SalesSearchView.aspx';
        }
    },

    fnJumpReturn: function (arg) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/SalesHandler.ashx',
            data: arg,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultJumpReturn(data);
            },
            error: function (sError) {
            }
        });
    },

    fnResultJumpReturn: function (data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            window.open('SReturnEditView.aspx?return_id=' + jsonValue.return_id + '&NUM=1&filter_return_id=' + jsonValue.return_id);
        } else {
            this.g_salesEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    /*---------------------------------Tab1-----------------------*/

    fnInitializationTab1: function () {
        fnLoading();
        this.g_salesEditView.fnInitializationTab1();
        this.fnSelectAccount();
        this.fnSelectPay();
        this.fnSelectOrderStatus();
        this.fnSelectTab1();
    },

    fnSelectPay: function () {
        this.fnSelectCode("CPAY");
        this.g_salesEditView.fnShowPayList();
    },

    fnSelectOrderStatus: function () {
        this.fnSelectCode("OSTA");
        this.g_salesEditView.fnShowOrderStatusList();
    },

    fnSelectAccount: function () {
        var sArg = {
            "method": "fnSelectList"
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/AccountHandler.ashx',
            type: 'GET',
            data: sArg,
            async: false,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultSelectList(data);
            },
            error: function (sError) {
            }
        });
        this.g_salesEditView.fnShowAccountList();
    },

    fnSelectCode: function (value) {
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
            url: 'ADMIN/Handler/SalesHandler.ashx',
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
            window.location = 'SalesSearchView.aspx?filter_order_id=' + this.g_sOrderId;
            //this.g_salesEditView.fnGeneralMessage("更新成功");
        } else {
            this.g_salesEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnSelectTab1: function () {
        if (this.g_sOrderId.length > 0) {
            var that = this;
            var sArg = {
                "method": "fnSelect"
                , "order_id": this.g_sOrderId
            };
            $.ajax({
                url: 'ADMIN/Handler/SalesHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectTab1(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'SalesSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'SalesSearchView.aspx';
        }
    },

    fnResultSelectTab1: function (data) {
        if (data != null) {
            var jsonValue = $.parseJSON(JSON.stringify($.parseJSON(JSON.stringify(data))[0]));
            if (jsonValue != null) {
                this.g_bComplete = (jsonValue.complete == 'Y');
                this.g_salesEditView.fnSetTab1View(jsonValue);
                this.g_salesEditView.fnTab1Event();
                fnLoaded();
            } else {
                alert('錯誤訊息：資料錯誤，跳往查詢頁面。');
                window.location = 'SalesSearchView.aspx';
            }
        } else {
            alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
            window.location = 'SalesSearchView.aspx';
        }
    },

    /*---------------------------------Tab2-----------------------*/

    fnInitializationTab2: function () {
        fnLoading();
        this.g_salesEditView.fnInitializationTab2();
        this.fnSelectProduct();
        this.fnSelectWarehouse();
        var sPage = fnGetQuery("page", "1");
        var iPage = parseInt(sPage);
        this.g_iPage = iPage;
        this.fnSelectTab2();
    },

    fnSelectProduct: function () {
        var sArg = {
            "method": "fnSelectList"
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/ProductHandler.ashx',
            type: 'GET',
            data: sArg,
            async: false,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultSelectList(data);
            },
            error: function (sError) {
            }
        });
        this.g_salesEditView.fnShowProductList();
    },

    fnSelectWarehouse: function () {
        var that = this;
        var sArg = {
            "method": "fnSelectList"
            , "kind_id": "WAR"
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
                window.location = 'ProductSearchView.aspx';
            }
        });
        this.g_salesEditView.fnShowWarehouseList();
    },

    fnTab2SelectPrice: function (tr, select) {
        var that = this;

        if (!isNaN(parseFloat(select.amount))) {

            $.ajax({
                url: 'ADMIN/Handler/ProductHandler.ashx',
                data: select,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnTab2ResultSelectPrice(tr, data);
                },
                error: function (sError) {
                }
            });
        }
    },

    fnTab2ResultSelectPrice: function (tr, data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            this.g_salesEditView.fnTab2ShowPrice(tr, jsonValue.price);
        } else {
        }
    },

    fnSelectTab2: function () {
        if (this.g_sOrderId.length > 0) {
            var that = this;
            var sArg = {
                "method": "fnSelectsD"
                , "page": this.g_iPage.toString()
                , "page_max_size": this.g_iMaxPageSize.toString()
                , "order_id": this.g_sOrderId.toString()
            };
            $.ajax({
                url: 'ADMIN/Handler/SalesHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectTab2(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'SalesSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'SalesSearchView.aspx';
        }
    },

    fnResultSelectTab2: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));
        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_salesEditView.fnPushTab2Columns(jsonValue);
            iIndex++;
        }

        if (jsonValues.length == 0) {
            this.g_salesEditView.fnPushTab2EmptyColumns();
        }
        this.g_salesEditView.fnShowTab2List();
        this.fnCountTab2();
    },

    fnCountTab2: function () {
        var sArg = {
            "method": "fnCountD"
            , "order_id": this.g_sOrderId
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/SalesHandler.ashx',
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
            this.g_salesEditView.fnPushTab2PageNumber('|<<', 1, '');
        }

        var iLastPage = this.g_iPage - 2; // 若是第一頁則不顯示
        if (iLastPage > 0) {
            this.g_salesEditView.fnPushTab2PageNumber('<<', iLastPage, '');
        }

        var iCount = 1;
        var iMinPage = (this.g_iPage - 5) < 2 ? 1 : (this.g_iPage - 5); // 最小為1頁
        for (var iIndex = iMinPage ; iIndex < this.g_iPage; iIndex++) {
            this.g_salesEditView.fnPushTab2PageNumber(iIndex, iIndex, '');
            iCount++;
        }

        this.g_salesEditView.fnPushTab2PageNumber(this.g_iPage, this.g_iPage, 'select');

        var jsonValue = $.parseJSON(JSON.stringify(data));
        var iPage = parseInt((jsonValue.page_size / this.g_iMaxPageSize));
        if (jsonValue.page_size % this.g_iMaxPageSize != 0 || iPage == 0) {
            iPage += 1;
        }
        for (var iIndex = (this.g_iPage + 1) ; iIndex <= iPage && iCount < 10; iIndex++) {
            this.g_salesEditView.fnPushTab2PageNumber(iIndex, iIndex, '');
            iCount++;
        }

        var iNextPage = this.g_iPage + 1;
        if (iNextPage < iPage) {
            this.g_salesEditView.fnPushTab2PageNumber('>>', iNextPage, '');
        }

        if (this.g_iPage != iPage) {
            this.g_salesEditView.fnPushTab2PageNumber('>>|', iPage, '');
        }
        this.g_salesEditView.fnShowTab2PageNumber();
    },

    fnTab2Insert: function (tr, insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/SalesHandler.ashx',
            type: 'GET',
            data: insert,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultTab2Insert(tr, data);
            },
            error: function (sError) {
            }
        });
    },

    fnResultTab2Insert: function (tr, data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            this.g_salesEditView.fnGeneralMessage("新增成功");
            this.g_salesEditView.fnChangeReadOnly(tr, data)
        } else {
            this.g_salesEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab2Inserts: function (insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/SalesHandler.ashx',
            type: 'GET',
            data: insert,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultTab2Inserts(data);
            },
            error: function (sError) {
            }
        });
    },

    fnResultTab2Inserts: function (data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            this.g_salesEditView.fnGeneralMessage("新增成功");
            this.fnInitializationTab2();
        } else {
            this.g_salesEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab2Update: function (tr, update) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/SalesHandler.ashx',
            data: update,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultTab2Update(tr, data, update);
            },
            error: function (sError) {
            }
        });
    },

    fnResultTab2Update: function (tr, data, update) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            this.g_salesEditView.fnGeneralMessage("更新成功");
            this.g_salesEditView.fnChangeReadOnly(tr, update)
        } else {
            this.g_salesEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab2Updates: function (update) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/SalesHandler.ashx',
            type: 'GET',
            data: update,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultTab2Updates(data);
            },
            error: function (sError) {
            }
        });
    },

    fnResultTab2Updates: function (data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            this.g_salesEditView.fnGeneralMessage("更新成功");
            this.fnInitializationTab2();
        } else {
            this.g_salesEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab2Delete: function (arg) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/SalesHandler.ashx',
            data: arg,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultTab2Delete(data);
            },
            error: function (sError) {
            }
        });
    },

    fnResultTab2Delete: function (data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            this.g_salesEditView.fnGeneralMessage("刪除成功");
            this.fnInitializationTab2();
        } else {
            this.g_salesEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab2Change: function (arg) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/SalesHandler.ashx',
            data: arg,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultTab2Change(data);
            },
            error: function (sError) {
            }
        });
    },

    fnResultTab2Change: function (data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            this.g_salesEditView.fnGeneralMessage("退貨建立成功");
        } else {
            this.g_salesEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab2PageNumberChange: function (page) {
        var sArg = '?' + fnGetUpdateQuery('page', page);
        this.g_salesEditView.fnTab2ChangeUrl(sArg);
    },

    fnTab2MaxPageSizeChange: function (page) {
        this.g_iMaxPageSize = page;
        var sArg = '?' + fnGetUpdateQuery('page', '1');
        this.g_salesEditView.fnTab2ChangeUrl(sArg);
    },

    /*---------------------------tab3----------------------*/
    fnInitializationTab3: function () {
        fnLoading();
        var sPage = fnGetQuery("page", "1");
        var iPage = parseInt(sPage);

        this.g_iPage = iPage;
        this.g_salesEditView.fnInitializationTab3();
        this.fnSelectTab3();
    },

    fnSelectTab3: function () {
        if (this.g_sOrderId.length > 0) {
            var that = this;
            var sArg = {
                "method": "fnSelectsTran"
                , "page": this.g_iPage.toString()
                , "page_max_size": this.g_iMaxPageSize.toString()
                , "order_id": this.g_sOrderId.toString()
            };
            $.ajax({
                url: 'ADMIN/Handler/SalesHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectTab3(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'SalesSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'SalesSearchView.aspx';
        }
    },

    fnResultSelectTab3: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));
        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_salesEditView.fnPushTranColumns(jsonValue);
            iIndex++;
        }
        this.g_salesEditView.fnShowTranList();
        if (jsonValues.length == 0) {
            this.g_salesEditView.fnShowTranEmptyColumns();
        }
        this.fnCountTab3();
    },

    fnCountTab3: function () {
        var sArg = {
            "method": "fnCountTran"
            , "order_id": this.g_sOrderId.toString()
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/SalesHandler.ashx',
            type: 'GET',
            data: sArg,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultCountTab3(data);
                fnLoaded();
            },
            error: function (sError) {
            }
        });
    },

    fnResultCountTab3: function (data) {
        if (this.g_iPage != 1) {
            this.g_salesEditView.fnPushTranPageNumber('|<<', 1, '');
        }

        var iLastPage = this.g_iPage - 2; // 若是第一頁則不顯示
        if (iLastPage > 0) {
            this.g_salesEditView.fnPushTranPageNumber('<<', iLastPage, '');
        }

        var iCount = 1;
        var iMinPage = (this.g_iPage - 5) < 2 ? 1 : (this.g_iPage - 5); // 最小為1頁
        for (var iIndex = iMinPage ; iIndex < this.g_iPage; iIndex++) {
            this.g_salesEditView.fnPushTranPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        this.g_salesEditView.fnPushTranPageNumber(this.g_iPage, this.g_iPage, 'select');

        var jsonValue = $.parseJSON(JSON.stringify(data));
        var iPage = parseInt((jsonValue.page_size / this.g_iMaxPageSize));
        if (jsonValue.page_size % this.g_iMaxPageSize != 0 || iPage == 0) {
            iPage += 1;
        }
        for (var iIndex = (this.g_iPage + 1) ; iIndex <= iPage && iCount < 10; iIndex++) {
            this.g_salesEditView.fnPushTranPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        var iNextPage = this.g_iPage + 1;
        if (iNextPage < iPage) {
            this.g_salesEditView.fnPushTranPageNumber('>>', iNextPage, '');
        }

        if (this.g_iPage != iPage) {
            this.g_salesEditView.fnPushTranPageNumber('>>|', iPage, '');
        }
        this.g_salesEditView.fnShowTranPageNumber();
    },

    fnTab3PageNumberChange: function (page) {
        var sArg = '?' + fnGetUpdateQuery('page', page);
        this.g_salesEditView.fnTab3ChangeUrl(sArg);
    },

    fnTab3MaxPageSizeChange: function (page) {
        this.g_iMaxPageSize = page;
        var sArg = '?' + fnGetUpdateQuery('page', '1');
        this.g_salesEditView.fnTab3ChangeUrl(sArg);
    }
};