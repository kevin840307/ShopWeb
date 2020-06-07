

function MaterialStockEditPresenter(materialStockEditView) {
    this.g_materialStockEditView = materialStockEditView;
}

MaterialStockEditPresenter.prototype = {
    TAG: 'MaterialStockEditPresenter',

    fnInitialization: function () {
        this.g_iMaxPageSize = 8;
        this.g_sMaterialId = fnGetQuery("material_id", "");
        this.g_sWarehouseId = fnGetQuery("warehouse_id", "");
        this.fnInitializationTab1();
        this.g_materialStockEditView.fnInitialization();
    },

    fnResultSelectList: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));

        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_materialStockEditView.fnPushSelectList(jsonValue);
            iIndex++;
        }
    },

    fnSelectNextId: function (value) {
        var sNUM = fnGetQuery("NUM", "");
        if (sNUM.length > 0) {
            fnLoading();
            sNUM = (parseInt(sNUM) + value).toString();
            var sArg = {
                "method": "fnSelectNextId",
                material_id: fnFixMNDT(fnGetQuery("filter_material_id", "")),
                warehouse_id: fnFixMNDT(fnGetQuery("filter_warehouse_id", "")),
                order: fnGetQuery("order", "material_id"),
                NUM: sNUM
            };
            var that = this;

            $.ajax({
                url: 'ADMIN/Handler/MaterialStockHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectId(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'MaterialStockSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'MaterialStockSearchView.aspx';
        }
    },

    fnResultSelectId: function (data) {
        if (data != null) {
            var jsonValue = $.parseJSON(JSON.stringify(data));
            if (jsonValue != null) {
                if (jsonValue.msg == 'Y') {
                    var sArg = fnGetUpdateQuery('material_id', jsonValue.material_id);
                    sArg = fnUpdateQuery(sArg, 'warehouse_id', jsonValue.warehouse_id);
                    sArg = fnUpdateQuery(sArg, 'NUM', jsonValue.NUM);
                    window.location = 'MaterialStockEditView.aspx?' + sArg;
                } else {
                    this.g_materialStockEditView.fnGeneralMessage(jsonValue.msg);
                    fnLoaded();
                }
            } else {
                alert('錯誤訊息：資料錯誤，跳往查詢頁面。');
                window.location = 'MaterialStockSearchView.aspx';
            }
        } else {
            alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
            window.location = 'MaterialStockSearchView.aspx';
        }
    },

    /*-----------------------------------------------tab1----------------------*/

    fnInitializationTab1: function () {
        fnLoading();
        this.g_materialStockEditView.fnInitializationTab1();
        this.fnSelectTab1();
    },

    fnSelectTab1: function () {
        var that = this;
        var sArg = {
            "method": "fnSelect"
            , "material_id": this.g_sMaterialId
            , "warehouse_id": this.g_sWarehouseId
        };

        $.ajax({
            url: 'ADMIN/Handler/MaterialStockHandler.ashx',
            data: sArg,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultSelectTab1(data);
            },
            error: function (sError) {
                alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                window.location = 'MaterialStockSearchView.aspx';
            }
        });
    },

    fnResultSelectTab1: function (data) {
        if (data != null) {
            var jsonValue = $.parseJSON(JSON.stringify($.parseJSON(JSON.stringify(data))[0]));
            if (jsonValue != null) {
                this.g_materialStockEditView.fnSetDataView(jsonValue);
                fnLoaded();
            } else {
                alert('錯誤訊息：資料錯誤，跳往查詢頁面。');
                window.location = 'MaterialStockSearchView.aspx';
            }
        } else {
            alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
            window.location = 'MaterialStockSearchView.aspx';
        }
    },

    fnTab1Update: function (update) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/MaterialStockHandler.ashx',
            data: update,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultfnTab1Update(data);
            },
            error: function (sError) {
            }
        });
    },

    fnResultfnTab1Update: function (data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            this.g_materialStockEditView.fnGeneralMessage("更新成功");
        } else {
            this.g_materialStockEditView.fnErrorMessage(jsonValue.msg);
        }
    },


    /*-------------------------------------------Tab2----------------------------*/

    fnInitializationTab2: function () {
        fnLoading();
        this.g_materialStockEditView.fnInitializationTab2();
        var sPage = fnGetQuery("page", "1");
        this.g_iPage = parseInt(sPage);
        this.fnSelectTab2();
    },

    fnSelectTab2: function () {
        if (this.g_sMaterialId.length > 0) {
            var that = this;
            var sArg = {
                "method": "fnSelectsTran"
                , "page": this.g_iPage.toString()
                , "page_max_size": this.g_iMaxPageSize.toString()
                , "material_id": this.g_sMaterialId
                , "warehouse_id": this.g_sWarehouseId
            };
            $.ajax({
                url: 'ADMIN/Handler/MaterialStockHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectTab2(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'MaterialStockSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'MaterialStockSearchView.aspx';
        }
    },

    fnResultSelectTab2: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));
        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_materialStockEditView.fnPushTranColumns(jsonValue);
            iIndex++;
        }
        this.g_materialStockEditView.fnShowTranList();
        if (jsonValues.length == 0) {
            this.g_materialStockEditView.fnShowTranEmptyColumns();
        }
        this.fnCountTab2();
    },

    fnCountTab2: function () {
        var sArg = {
            "method": "fnCountTran"
            , "material_id": this.g_sMaterialId.toString()
            , "warehouse_id": this.g_sWarehouseId
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/MaterialStockHandler.ashx',
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
            this.g_materialStockEditView.fnPushTranPageNumber('|<<', 1, '');
        }

        var iLastPage = this.g_iPage - 2; // 若是第一頁則不顯示
        if (iLastPage > 0) {
            this.g_materialStockEditView.fnPushTranPageNumber('<<', iLastPage, '');
        }

        var iCount = 1;
        var iMinPage = (this.g_iPage - 5) < 2 ? 1 : (this.g_iPage - 5); // 最小為1頁
        for (var iIndex = iMinPage ; iIndex < this.g_iPage; iIndex++) {
            this.g_materialStockEditView.fnPushTranPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        this.g_materialStockEditView.fnPushTranPageNumber(this.g_iPage, this.g_iPage, 'select');

        var jsonValue = $.parseJSON(JSON.stringify(data));
        var iPage = parseInt((jsonValue.page_size / this.g_iMaxPageSize));
        if (jsonValue.page_size % this.g_iMaxPageSize != 0 || iPage == 0) {
            iPage += 1;
        }
        for (var iIndex = (this.g_iPage + 1) ; iIndex <= iPage && iCount < 10; iIndex++) {
            this.g_materialStockEditView.fnPushTranPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        var iNextPage = this.g_iPage + 1;
        if (iNextPage < iPage) {
            this.g_materialStockEditView.fnPushTranPageNumber('>>', iNextPage, '');
        }

        if (this.g_iPage != iPage) {
            this.g_materialStockEditView.fnPushTranPageNumber('>>|', iPage, '');
        }
        this.g_materialStockEditView.fnShowTranPageNumber();
    },

    fnPageNumberChange: function (page) {
        var sArg = '?' + fnGetUpdateQuery('page', page);
        this.g_materialStockEditView.fnTab2ChangeUrl(sArg);
    },

    fnMaxPageSizeChange: function (page) {
        this.g_iMaxPageSize = page;
        var sArg = '?' + fnGetUpdateQuery('page', '1');
        this.g_materialStockEditView.fnTab2ChangeUrl(sArg);
    },
};