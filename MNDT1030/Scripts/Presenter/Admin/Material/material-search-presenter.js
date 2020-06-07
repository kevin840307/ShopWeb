

function MaterialSearchPresenter(viewPage) {
    this.g_materialSearchView = viewPage;
    this.g_iPage = 1;
    this.g_iMaxPageSize = 8;
}

MaterialSearchPresenter.prototype = {
    TAG: 'MaterialReadOnlyPresenter',

    fnInitialization: function () {
        this.g_materialSearchView.fnInitialization();
        this.fnInitList();
    },

    fnPageNumberChange: function (page) {
        var sArg = '?' + fnGetUpdateQuery('page', page);
        this.g_materialSearchView.fnChangeUrl(sArg);
    },

    fnOrderChange: function (order) {
        var sArg = '?' + fnGetUpdateQuery('order', order);
        this.g_materialSearchView.fnChangeUrl(sArg);
    },

    fnFilterChange: function (filter) {
        var sArg = '?';

        if (filter.material_id.length > 0) {
            sArg += 'filter_material_id=' + fnToMNDT(filter.material_id) + '&';
        }

        if (filter.name.length > 0) {
            sArg += 'filter_name=' + fnToMNDT(filter.name) + '&';
        }

        if (filter.status.length > 0) {
            sArg += 'filter_status=' + fnToMNDT(filter.status);
        }

        if (sArg[sArg.length - 1] == '&') {
            sArg = sArg.substring(0, sArg.length - 1);
        }

        this.g_materialSearchView.fnChangeUrl(sArg);
    },

    fnMaxPageSizeChange: function (page) {
        this.g_iMaxPageSize = page;
        var sArg = '?' + fnGetUpdateQuery('page', '1');
        this.g_materialSearchView.fnChangeUrl(sArg);
    },

    fnImport: function (formData) {
        var that = this;
        $.ajax({
            type: 'post',
            url: 'ADMIN/Handler/MaterialHandler.ashx',
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
                this.g_materialSearchView.fnGeneralMessage("匯入成功。");
            } else {
                this.g_materialSearchView.fnErrorMessage(jsonValues.msg);
            }
        } else {
            this.g_materialSearchView.fnErrorMessage("錯誤訊息：不知名錯誤。");
        }
    },

    fnExport: function () {
        fnLoading();
        var sArg = {
            "method": "fnExport"
            , "order": this.g_order.toString()
            , "material_id": this.filter.material_id.toString()
            , "name": this.filter.name.toString()
            , "status": this.filter.status.toString()
        };
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/MaterialHandler.ashx',
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
                window.location.href = "Download.aspx?path=ExcelFile\\\\&name=Material.xls";
                this.g_materialSearchView.fnGeneralMessage("匯出成功。");
            } else {
                this.g_materialSearchView.fnErrorMessage(jsonValues.msg);
            }
        } else {
            this.g_materialSearchView.fnErrorMessage("錯誤訊息：不知名錯誤。");
        }
    },

    fnReport: function () {
        fnLoading();
        var sArg = {
            "method": "fnReport"
            , "order": this.g_order.toString()
            , "material_id": this.filter.material_id.toString()
            , "material": this.filter.material.toString()
            , "name": this.filter.name.toString()
            , "status": this.filter.status.toString()
        };
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/MaterialHandler.ashx',
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
                window.open("ReportPage.aspx?ReportName=MaterialList.rpt", '', 'resizable=yes,location=no');
                this.g_materialSearchView.fnGeneralMessage("報表產生成功。");
            } else {
                this.g_materialSearchView.fnErrorMessage(jsonValues.msg);
            }
        } else {
            this.g_materialSearchView.fnErrorMessage("錯誤訊息：不知名錯誤。");
        }
    },

    fnPrint: function () {
        window.open('Print\\Material\\MaterialList.aspx?' + window.location.search.substring(1));
    },

    fnInitList: function () {
        var sPage = fnGetQuery("page", "1");
        var iPage = parseInt(sPage);
        var filter_material_id = fnGetQuery("filter_material_id", "");
        var filter_name = fnGetQuery("filter_name", "");
        var filter_status = fnGetQuery("filter_status", "");
        var order = fnGetQuery("order", "material_id");

        this.filter = {
            material_id: fnFixMNDT(filter_material_id),
            name: fnFixMNDT(filter_name),
            status: fnFixMNDT(filter_status)
        };
        this.g_order = order;
        this.g_iPage = iPage;
        this.g_materialSearchView.fnShowFilterView(this.filter);
        this.fnSelects();
    },

    fnSelects: function () {

        fnLoading();
        var sArg = {
            "method": "fnSelects"
            , "page": this.g_iPage.toString()
            , "page_max_size": this.g_iMaxPageSize.toString()
            , "order": this.g_order.toString()
            , "material_id": this.filter.material_id.toString()
            , "name": this.filter.name.toString()
            , "status": this.filter.status.toString()
        };
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/MaterialHandler.ashx',
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
            this.g_materialSearchView.fnPushColumns(jsonValue);
            iIndex++;
        }
        this.g_materialSearchView.fnShowList();
        if (jsonValues.length == 0) {
            this.g_materialSearchView.fnShowEmptyColumns();
        }
        this.fnCount();
    },

    fnCount: function () {
        var sArg = {
            "method": "fnCount"
            , "material_id": this.filter.material_id.toString()
            , "name": this.filter.name.toString()
            , "status": this.filter.status.toString()
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/MaterialHandler.ashx',
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
            this.g_materialSearchView.fnPushPageNumber('|<<', 1, '');
        }

        var iLastPage = this.g_iPage - 2; // 若是第一頁則不顯示
        if (iLastPage > 0) {
            this.g_materialSearchView.fnPushPageNumber('<<', iLastPage, '');
        }

        var iCount = 1;
        var iMinPage = (this.g_iPage - 5) < 2 ? 1 : (this.g_iPage - 5); // 最小為1頁
        for (var iIndex = iMinPage ; iIndex < this.g_iPage; iIndex++) {
            this.g_materialSearchView.fnPushPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        this.g_materialSearchView.fnPushPageNumber(this.g_iPage, this.g_iPage, 'select');

        var jsonValue = $.parseJSON(JSON.stringify(data));
        var iPage = parseInt((jsonValue.page_size / this.g_iMaxPageSize));
        if (jsonValue.page_size % this.g_iMaxPageSize != 0 || iPage == 0) {
            iPage += 1;
        }
        for (var iIndex = (this.g_iPage + 1) ; iIndex <= iPage && iCount < 10; iIndex++) {
            this.g_materialSearchView.fnPushPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        var iNextPage = this.g_iPage + 1;
        if (iNextPage < iPage) {
            this.g_materialSearchView.fnPushPageNumber('>>', iNextPage, '');
        }

        if (this.g_iPage != iPage) {
            this.g_materialSearchView.fnPushPageNumber('>>|', iPage, '');
        }
        this.g_materialSearchView.fnShowPageNumber();
        this.g_materialSearchView.fnInitListEvent();
    },

    fnDelete: function (sMaterialId) {
        var that = this;
        if (sMaterialId.length > 0) {
            var sArg = {
                "method": "fnDelete"
                 , "material_id": sMaterialId.toString()
            };
            $.ajax({
                url: 'ADMIN/Handler/MaterialHandler.ashx',
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

    fnDeletes: function (sMaterialIds) {
        var that = this;
        if (sMaterialIds.length > 0) {
            var sArg = {
                "method": "fnDeletes"
                 , "material_id": sMaterialIds.toString()
            };
            $.ajax({
                url: 'ADMIN/Handler/MaterialHandler.ashx',
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
            this.g_materialSearchView.fnGeneralMessage("刪除成功");
        } else {
            this.g_materialSearchView.fnErrorMessage(jsonValue.msg);
        }
    }
};
