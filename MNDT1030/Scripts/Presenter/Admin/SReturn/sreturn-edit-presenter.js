

function SReturnEditPresenter(sreturnEditView) {
    this.g_sreturnEditView = sreturnEditView;
    this.g_sReturnId = '';
}

SReturnEditPresenter.prototype = {
    TAG: 'SReturnEditPresenter',

    fnInitialization: function () {
        this.g_sReturnId = fnGetQuery("return_id", "");
        this.g_iMaxPageSize = 8;
        this.fnInitializationTab1();
        this.g_sreturnEditView.fnInitialization();
    },

    fnResultSelectList: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));

        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_sreturnEditView.fnPushSelectList(jsonValue);
            iIndex++;
        }
    },

    fnSelectReturnId: function (value) {
        var sNUM = fnGetQuery("NUM", "");
        if (sNUM.length > 0) {
            fnLoading();
            sNUM = (parseInt(sNUM) + value).toString();
            var sArg = {
                "method": "fnSelectReturnId",
                id: fnFixMNDT(fnGetQuery("filter_id", "")),
                return_id: fnFixMNDT(fnGetQuery("filter_return_id", "")),
                order_id: fnFixMNDT(fnGetQuery("filter_order_id", "")),
                account: fnFixMNDT(fnGetQuery("filter_account", "")),
                datetime: fnFixMNDT(fnGetQuery("filter_datetime", "")),
                name: fnFixMNDT(fnGetQuery("filter_name", "")),
                order: fnGetQuery("order", "return_id"),
                NUM: sNUM
            };
            var that = this;

            $.ajax({
                url: 'ADMIN/Handler/SReturnHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectReturnId(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'SReturnSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：NUM錯誤，跳往查詢頁面。');
            window.location = 'SReturnSearchView.aspx';
        }
    },

    fnResultSelectReturnId: function (data) {
        if (data != null) {
            var jsonValue = $.parseJSON(JSON.stringify(data));
            if (jsonValue != null) {
                if (jsonValue.msg == 'Y') {
                    var sArg = fnGetUpdateQuery('return_id', jsonValue.return_id);
                    sArg = fnUpdateQuery(sArg, 'NUM', jsonValue.NUM);
                    window.location = 'SReturnEditView.aspx?' + sArg;
                } else {
                    this.g_sreturnEditView.fnGeneralMessage(jsonValue.msg);
                    fnLoaded();
                }
            } else {
                alert('錯誤訊息：資料錯誤，跳往查詢頁面。');
                window.location = 'SReturnSearchView.aspx';
            }
        } else {
            alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
            window.location = 'SReturnSearchView.aspx';
        }
    },

    /*---------------------------------Tab1-----------------------*/

    fnInitializationTab1: function () {
        fnLoading();
        this.g_sreturnEditView.fnInitializationTab1();
        this.fnSelectAccount();
        this.fnSelectTab1();
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
        this.g_sreturnEditView.fnShowAccountList();
    },

    fnTab1Update: function (update) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/SReturnHandler.ashx',
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
            window.location = 'SReturnSearchView.aspx?filter_return_id=' + this.g_sReturnId;
            //this.g_sreturnEditView.fnGeneralMessage("更新成功");
        } else {
            this.g_sreturnEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnSelectTab1: function () {
        if (this.g_sReturnId.length > 0) {
            var that = this;
            var sArg = {
                "method": "fnSelect"
                , "return_id": this.g_sReturnId
            };
            $.ajax({
                url: 'ADMIN/Handler/SReturnHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectTab1(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'SReturnSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'SReturnSearchView.aspx';
        }
    },

    fnResultSelectTab1: function (data) {
        if (data != null) {
            var jsonValue = $.parseJSON(JSON.stringify($.parseJSON(JSON.stringify(data))[0]));
            if (jsonValue != null) {
                this.g_bComplete = (jsonValue.complete == 'Y');
                this.g_sreturnEditView.fnSetTab1View(jsonValue);
                this.g_sreturnEditView.fnTab1Event();
                fnLoaded();
            } else {
                alert('錯誤訊息：資料錯誤，跳往查詢頁面。');
                window.location = 'SReturnSearchView.aspx';
            }
        } else {
            alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
            window.location = 'SReturnSearchView.aspx';
        }
    },

    /*---------------------------------Tab2-----------------------*/

    fnInitializationTab2: function () {
        fnLoading();
        this.g_sreturnEditView.fnInitializationTab2();
        this.fnSelectProduct();
        this.fnSelectWarehouse();
        var sPage = fnGetQuery("page", "1");
        var iPage = parseInt(sPage);
        this.g_iPage = iPage;
        this.fnSelectTab2();
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
            this.g_sreturnEditView.fnTab2ShowPrice(tr, jsonValue.price);
        } else {
        }
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
        this.g_sreturnEditView.fnShowProductList();
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
        this.g_sreturnEditView.fnShowWarehouseList();
    },

    fnSelectTab2: function () {
        if (this.g_sReturnId.length > 0) {
            var that = this;
            var sArg = {
                "method": "fnSelectsD"
                , "page": this.g_iPage.toString()
                , "page_max_size": this.g_iMaxPageSize.toString()
                , "return_id": this.g_sReturnId.toString()
            };
            $.ajax({
                url: 'ADMIN/Handler/SReturnHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectTab2(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'SReturnSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'SReturnSearchView.aspx';
        }
    },

    fnResultSelectTab2: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));
        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_sreturnEditView.fnPushTab2Columns(jsonValue);
            iIndex++;
        }

        if (jsonValues.length == 0) {
            this.g_sreturnEditView.fnPushTab2EmptyColumns();
        }
        this.g_sreturnEditView.fnShowTab2List();
        this.fnCountTab2();
    },

    fnCountTab2: function () {
        var sArg = {
            "method": "fnCountD"
            , "return_id": this.g_sReturnId
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/SReturnHandler.ashx',
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
            this.g_sreturnEditView.fnPushTab2PageNumber('|<<', 1, '');
        }

        var iLastPage = this.g_iPage - 2; // 若是第一頁則不顯示
        if (iLastPage > 0) {
            this.g_sreturnEditView.fnPushTab2PageNumber('<<', iLastPage, '');
        }

        var iCount = 1;
        var iMinPage = (this.g_iPage - 5) < 2 ? 1 : (this.g_iPage - 5); // 最小為1頁
        for (var iIndex = iMinPage ; iIndex < this.g_iPage; iIndex++) {
            this.g_sreturnEditView.fnPushTab2PageNumber(iIndex, iIndex, '');
            iCount++;
        }

        this.g_sreturnEditView.fnPushTab2PageNumber(this.g_iPage, this.g_iPage, 'select');

        var jsonValue = $.parseJSON(JSON.stringify(data));
        var iPage = parseInt((jsonValue.page_size / this.g_iMaxPageSize));
        if (jsonValue.page_size % this.g_iMaxPageSize != 0 || iPage == 0) {
            iPage += 1;
        }
        for (var iIndex = (this.g_iPage + 1) ; iIndex <= iPage && iCount < 10; iIndex++) {
            this.g_sreturnEditView.fnPushTab2PageNumber(iIndex, iIndex, '');
            iCount++;
        }

        var iNextPage = this.g_iPage + 1;
        if (iNextPage < iPage) {
            this.g_sreturnEditView.fnPushTab2PageNumber('>>', iNextPage, '');
        }

        if (this.g_iPage != iPage) {
            this.g_sreturnEditView.fnPushTab2PageNumber('>>|', iPage, '');
        }
        this.g_sreturnEditView.fnShowTab2PageNumber();
    },

    fnTab2Insert: function (tr, insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/SReturnHandler.ashx',
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
            this.g_sreturnEditView.fnGeneralMessage("新增成功");
            this.g_sreturnEditView.fnChangeReadOnly(tr, data)
        } else {
            this.g_sreturnEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab2Inserts: function (insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/SReturnHandler.ashx',
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
            this.g_sreturnEditView.fnGeneralMessage("新增成功");
            this.fnInitializationTab2();
        } else {
            this.g_sreturnEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab2Update: function (tr, update) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/SReturnHandler.ashx',
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
            this.g_sreturnEditView.fnGeneralMessage("更新成功");
            this.g_sreturnEditView.fnChangeReadOnly(tr, update)
        } else {
            this.g_sreturnEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab2Updates: function (update) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/SReturnHandler.ashx',
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
            this.g_sreturnEditView.fnGeneralMessage("更新成功");
            this.fnInitializationTab2();
        } else {
            this.g_sreturnEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab2Delete: function (arg) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/SReturnHandler.ashx',
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
            this.g_sreturnEditView.fnGeneralMessage("刪除成功");
            this.fnInitializationTab2();
        } else {
            this.g_sreturnEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab2PageNumberChange: function (page) {
        var sArg = '?' + fnGetUpdateQuery('page', page);
        this.g_sreturnEditView.fnTab2ChangeUrl(sArg);
    },

    fnTab2MaxPageSizeChange: function (page) {
        this.g_iMaxPageSize = page;
        var sArg = '?' + fnGetUpdateQuery('page', '1');
        this.g_sreturnEditView.fnTab2ChangeUrl(sArg);
    },

    /*---------------------------tab3----------------------*/
    fnInitializationTab3: function () {
        fnLoading();
        var sPage = fnGetQuery("page", "1");
        var iPage = parseInt(sPage);

        this.g_iPage = iPage;
        this.g_sreturnEditView.fnInitializationTab3();
        this.fnSelectTab3();
    },

    fnSelectTab3: function () {
        if (this.g_sReturnId.length > 0) {
            var that = this;
            var sArg = {
                "method": "fnSelectsTran"
                , "page": this.g_iPage.toString()
                , "page_max_size": this.g_iMaxPageSize.toString()
                , "return_id": this.g_sReturnId.toString()
            };
            $.ajax({
                url: 'ADMIN/Handler/SReturnHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectTab3(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'SReturnSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'SReturnSearchView.aspx';
        }
    },

    fnResultSelectTab3: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));
        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_sreturnEditView.fnPushTranColumns(jsonValue);
            iIndex++;
        }
        this.g_sreturnEditView.fnShowTranList();
        if (jsonValues.length == 0) {
            this.g_sreturnEditView.fnShowTranEmptyColumns();
        }
        this.fnCountTab3();
    },

    fnCountTab3: function () {
        var sArg = {
            "method": "fnCountTran"
            , "return_id": this.g_sReturnId.toString()
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/SReturnHandler.ashx',
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
            this.g_sreturnEditView.fnPushTranPageNumber('|<<', 1, '');
        }

        var iLastPage = this.g_iPage - 2; // 若是第一頁則不顯示
        if (iLastPage > 0) {
            this.g_sreturnEditView.fnPushTranPageNumber('<<', iLastPage, '');
        }

        var iCount = 1;
        var iMinPage = (this.g_iPage - 5) < 2 ? 1 : (this.g_iPage - 5); // 最小為1頁
        for (var iIndex = iMinPage ; iIndex < this.g_iPage; iIndex++) {
            this.g_sreturnEditView.fnPushTranPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        this.g_sreturnEditView.fnPushTranPageNumber(this.g_iPage, this.g_iPage, 'select');

        var jsonValue = $.parseJSON(JSON.stringify(data));
        var iPage = parseInt((jsonValue.page_size / this.g_iMaxPageSize));
        if (jsonValue.page_size % this.g_iMaxPageSize != 0 || iPage == 0) {
            iPage += 1;
        }
        for (var iIndex = (this.g_iPage + 1) ; iIndex <= iPage && iCount < 10; iIndex++) {
            this.g_sreturnEditView.fnPushTranPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        var iNextPage = this.g_iPage + 1;
        if (iNextPage < iPage) {
            this.g_sreturnEditView.fnPushTranPageNumber('>>', iNextPage, '');
        }

        if (this.g_iPage != iPage) {
            this.g_sreturnEditView.fnPushTranPageNumber('>>|', iPage, '');
        }
        this.g_sreturnEditView.fnShowTranPageNumber();
    },

    fnTab3PageNumberChange: function (page) {
        var sArg = '?' + fnGetUpdateQuery('page', page);
        this.g_sreturnEditView.fnTab3ChangeUrl(sArg);
    },

    fnTab3MaxPageSizeChange: function (page) {
        this.g_iMaxPageSize = page;
        var sArg = '?' + fnGetUpdateQuery('page', '1');
        this.g_sreturnEditView.fnTab3ChangeUrl(sArg);
    }
};