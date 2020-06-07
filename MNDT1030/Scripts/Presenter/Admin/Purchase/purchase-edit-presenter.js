

function PurchaseEditPresenter(purchaseEditView) {
    this.g_purchaseEditView = purchaseEditView;
    this.g_sOrderId = '';
}

PurchaseEditPresenter.prototype = {
    TAG: 'PurchaseEditPresenter',

    fnInitialization: function () {
        this.g_sOrderId = fnGetQuery("order_id", "");
        this.g_iMaxPageSize = 8;
        this.fnInitializationTab1();
        this.g_purchaseEditView.fnInitialization();
    },

    fnResultSelectList: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));

        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_purchaseEditView.fnPushSelectList(jsonValue);
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
                name: fnFixMNDT(fnGetQuery("filter_datetime", "")),
                order: fnGetQuery("order", "order_id"),
                NUM: sNUM
            };
            var that = this;

            $.ajax({
                url: 'ADMIN/Handler/PurchaseHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectOrderId(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'PurchaseSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：NUM錯誤，跳往查詢頁面。');
            window.location = 'PurchaseSearchView.aspx';
        }
    },

    fnResultSelectOrderId: function (data) {
        if (data != null) {
            var jsonValue = $.parseJSON(JSON.stringify(data));
            if (jsonValue != null) {
                if (jsonValue.msg == 'Y') {
                    var sArg = fnGetUpdateQuery('order_id', jsonValue.order_id);
                    sArg = fnUpdateQuery(sArg, 'NUM', jsonValue.NUM);
                    window.location = 'PurchaseEditView.aspx?' + sArg;
                } else {
                    this.g_purchaseEditView.fnGeneralMessage(jsonValue.msg);
                    fnLoaded();
                }
            } else {
                alert('錯誤訊息：資料錯誤，跳往查詢頁面。');
                window.location = 'PurchaseSearchView.aspx';
            }
        } else {
            alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
            window.location = 'PurchaseSearchView.aspx';
        }
    },

    fnChange: function () {
        if (confirm("確定要轉到進貨單嗎?")) {
            var that = this;
            var sArg = {
                "method": "fnChange"
                , "order_id": this.g_sOrderId
            };
            $.ajax({
                url: 'ADMIN/Handler/PurchaseHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultChange(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'PurchaseSearchView.aspx';
                }
            });
        }
    },

    fnResultChange: function (data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            window.location = 'ReceiveEditView.aspx?order_id=' + this.g_sOrderId + '&NUM=1&filter_order_id=' + this.g_sOrderId;
            //this.g_purchaseEditView.fnGeneralMessage("更新成功");
        } else {
            this.g_purchaseEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    /*---------------------------------Tab1-----------------------*/

    fnInitializationTab1: function () {
        fnLoading();
        this.g_purchaseEditView.fnInitializationTab1();
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
        this.g_purchaseEditView.fnShowAccountList();
    },

    fnTab1Update: function (update) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/PurchaseHandler.ashx',
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
            window.location = 'PurchaseSearchView.aspx?filter_order_id=' + this.g_sOrderId;
            //this.g_purchaseEditView.fnGeneralMessage("更新成功");
        } else {
            this.g_purchaseEditView.fnErrorMessage(jsonValue.msg);
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
                url: 'ADMIN/Handler/PurchaseHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectTab1(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'PurchaseSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'PurchaseSearchView.aspx';
        }
    },

    fnResultSelectTab1: function (data) {
        if (data != null) {
            var jsonValue = $.parseJSON(JSON.stringify($.parseJSON(JSON.stringify(data))[0]));
            if (jsonValue != null) {
                this.g_bComplete = (jsonValue.complete == 'Y');
                this.g_purchaseEditView.fnSetTab1View(jsonValue);
                this.g_purchaseEditView.fnTab1Event();
                fnLoaded();
            } else {
                alert('錯誤訊息：資料錯誤，跳往查詢頁面。');
                window.location = 'PurchaseSearchView.aspx';
            }
        } else {
            alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
            window.location = 'PurchaseSearchView.aspx';
        }
    },

    /*---------------------------------Tab2-----------------------*/

    fnInitializationTab2: function () {
        fnLoading();
        this.g_purchaseEditView.fnInitializationTab2();
        this.fnSelectProduct();
        this.fnSelectMaterial();
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
        this.g_purchaseEditView.fnShowProductList();
    },

    fnSelectMaterial: function () {
        var sArg = {
            "method": "fnSelectList"
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/MaterialHandler.ashx',
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
        this.g_purchaseEditView.fnShowMaterialList();
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
                url: 'ADMIN/Handler/PurchaseHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectTab2(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'PurchaseSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'PurchaseSearchView.aspx';
        }
    },

    fnResultSelectTab2: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));
        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_purchaseEditView.fnPushTab2Columns(jsonValue);
            iIndex++;
        }

        if (jsonValues.length == 0) {
            this.g_purchaseEditView.fnPushTab2EmptyColumns();
        }
        this.g_purchaseEditView.fnShowTab2List();
        this.fnCountTab2();
    },

    fnCountTab2: function () {
        var sArg = {
            "method": "fnCountD"
            , "order_id": this.g_sOrderId
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
                that.fnResultCountTab2(data);
                fnLoaded();
            },
            error: function (sError) {
            }
        });
    },

    fnResultCountTab2: function (data) {
        if (this.g_iPage != 1) {
            this.g_purchaseEditView.fnPushTab2PageNumber('|<<', 1, '');
        }

        var iLastPage = this.g_iPage - 2; // 若是第一頁則不顯示
        if (iLastPage > 0) {
            this.g_purchaseEditView.fnPushTab2PageNumber('<<', iLastPage, '');
        }

        var iCount = 1;
        var iMinPage = (this.g_iPage - 5) < 2 ? 1 : (this.g_iPage - 5); // 最小為1頁
        for (var iIndex = iMinPage ; iIndex < this.g_iPage; iIndex++) {
            this.g_purchaseEditView.fnPushTab2PageNumber(iIndex, iIndex, '');
            iCount++;
        }

        this.g_purchaseEditView.fnPushTab2PageNumber(this.g_iPage, this.g_iPage, 'select');

        var jsonValue = $.parseJSON(JSON.stringify(data));
        var iPage = parseInt((jsonValue.page_size / this.g_iMaxPageSize));
        if (jsonValue.page_size % this.g_iMaxPageSize != 0 || iPage == 0) {
            iPage += 1;
        }
        for (var iIndex = (this.g_iPage + 1) ; iIndex <= iPage && iCount < 10; iIndex++) {
            this.g_purchaseEditView.fnPushTab2PageNumber(iIndex, iIndex, '');
            iCount++;
        }

        var iNextPage = this.g_iPage + 1;
        if (iNextPage < iPage) {
            this.g_purchaseEditView.fnPushTab2PageNumber('>>', iNextPage, '');
        }

        if (this.g_iPage != iPage) {
            this.g_purchaseEditView.fnPushTab2PageNumber('>>|', iPage, '');
        }
        this.g_purchaseEditView.fnShowTab2PageNumber();
    },

    fnTab2Insert: function (tr, insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/PurchaseHandler.ashx',
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
            this.g_purchaseEditView.fnGeneralMessage("新增成功");
            this.g_purchaseEditView.fnChangeReadOnly(tr, data)
        } else {
            this.g_purchaseEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab2Inserts: function (insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/PurchaseHandler.ashx',
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
            this.g_purchaseEditView.fnGeneralMessage("新增成功");
            this.fnInitializationTab2();
        } else {
            this.g_purchaseEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab2Update: function (tr, update) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/PurchaseHandler.ashx',
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
            this.g_purchaseEditView.fnGeneralMessage("更新成功");
            this.g_purchaseEditView.fnChangeReadOnly(tr, update)
        } else {
            this.g_purchaseEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab2Updates: function (update) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/PurchaseHandler.ashx',
            type: 'GET',
            data: update,
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

    fnResultTab2Updates: function (data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            this.g_purchaseEditView.fnGeneralMessage("更新成功");
            this.fnInitializationTab2();
        } else {
            this.g_purchaseEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab2Delete: function (material_id) {
        var that = this;
        var sArg = {
            "method": "fnDeleteD"
             , "order_id": this.g_sOrderId
             , "material_id": material_id
        };
        $.ajax({
            url: 'ADMIN/Handler/PurchaseHandler.ashx',
            data: sArg,
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
            this.g_purchaseEditView.fnGeneralMessage("刪除成功");
            this.fnInitializationTab2();
        } else {
            this.g_purchaseEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab2SelectPrice: function (tr, select, type) {
        var that = this;

        if (!isNaN(parseFloat(select.amount))) {

            $.ajax({
                url: 'ADMIN/Handler/MaterialHandler.ashx',
                data: select,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnTab2ResultSelectPrice(tr, data, type);
                },
                error: function (sError) {
                }
            });
        }
    },

    fnTab2ResultSelectPrice: function (tr, data, type) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            if (type == 'I') {
                this.g_purchaseEditView.fnTab2ShowInsertPrice(tr, jsonValue.price);
            } else if (type == 'E') {
                this.g_purchaseEditView.fnTab2ShowEditPrice(tr, jsonValue.price);
            }
        } else {
        }
    },

    fnTab2PageNumberChange: function (page) {
        var sArg = '?' + fnGetUpdateQuery('page', page);
        this.g_purchaseEditView.fnTab2ChangeUrl(sArg);
    },

    fnTab2MaxPageSizeChange: function (page) {
        this.g_iMaxPageSize = page;
        var sArg = '?' + fnGetUpdateQuery('page', '1');
        this.g_purchaseEditView.fnTab2ChangeUrl(sArg);
    },

    /*---------------------------tab3----------------------*/
    fnInitializationTab3: function () {
        fnLoading();
        var sPage = fnGetQuery("page", "1");
        var iPage = parseInt(sPage);

        this.g_iPage = iPage;
        this.g_purchaseEditView.fnInitializationTab3();
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
                url: 'ADMIN/Handler/PurchaseHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectTab3(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'PurchaseSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'PurchaseSearchView.aspx';
        }
    },

    fnResultSelectTab3: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));
        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_purchaseEditView.fnPushTranColumns(jsonValue);
            iIndex++;
        }
        this.g_purchaseEditView.fnShowTranList();
        if (jsonValues.length == 0) {
            this.g_purchaseEditView.fnShowTranEmptyColumns();
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
            url: 'ADMIN/Handler/PurchaseHandler.ashx',
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
            this.g_purchaseEditView.fnPushTranPageNumber('|<<', 1, '');
        }

        var iLastPage = this.g_iPage - 2; // 若是第一頁則不顯示
        if (iLastPage > 0) {
            this.g_purchaseEditView.fnPushTranPageNumber('<<', iLastPage, '');
        }

        var iCount = 1;
        var iMinPage = (this.g_iPage - 5) < 2 ? 1 : (this.g_iPage - 5); // 最小為1頁
        for (var iIndex = iMinPage ; iIndex < this.g_iPage; iIndex++) {
            this.g_purchaseEditView.fnPushTranPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        this.g_purchaseEditView.fnPushTranPageNumber(this.g_iPage, this.g_iPage, 'select');

        var jsonValue = $.parseJSON(JSON.stringify(data));
        var iPage = parseInt((jsonValue.page_size / this.g_iMaxPageSize));
        if (jsonValue.page_size % this.g_iMaxPageSize != 0 || iPage == 0) {
            iPage += 1;
        }
        for (var iIndex = (this.g_iPage + 1) ; iIndex <= iPage && iCount < 10; iIndex++) {
            this.g_purchaseEditView.fnPushTranPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        var iNextPage = this.g_iPage + 1;
        if (iNextPage < iPage) {
            this.g_purchaseEditView.fnPushTranPageNumber('>>', iNextPage, '');
        }

        if (this.g_iPage != iPage) {
            this.g_purchaseEditView.fnPushTranPageNumber('>>|', iPage, '');
        }
        this.g_purchaseEditView.fnShowTranPageNumber();
    },

    fnTab3PageNumberChange: function (page) {
        var sArg = '?' + fnGetUpdateQuery('page', page);
        this.g_purchaseEditView.fnTab3ChangeUrl(sArg);
    },

    fnTab3MaxPageSizeChange: function (page) {
        this.g_iMaxPageSize = page;
        var sArg = '?' + fnGetUpdateQuery('page', '1');
        this.g_purchaseEditView.fnTab3ChangeUrl(sArg);
    }
};