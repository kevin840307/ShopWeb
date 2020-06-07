

function ClientEditPresenter(clientEditView) {
    this.g_clientEditView = clientEditView;
    this.g_sClientId = '';
}

ClientEditPresenter.prototype = {
    TAG: 'ClientEditPresenter',

    fnInitialization: function () {
        this.g_iMaxPageSize = 8;
        this.g_sClientId = fnGetQuery("client_id", "");
        this.fnInitializationTab1();
        this.g_clientEditView.fnInitialization();
    },

    fnSelectId: function (value) {
        var sNUM = fnGetQuery("NUM", "");
        if (sNUM.length > 0) {
            fnLoading();
            sNUM = (parseInt(sNUM) + value).toString();
            var sArg = {
                "method": "fnSelectClientId",
                client_id: fnFixMNDT(fnGetQuery("filter_client_id", "")),
                phone: fnFixMNDT(fnGetQuery("filter_phone", "")),
                name: fnFixMNDT(fnGetQuery("filter_name", "")),
                status: fnGetQuery("filter_status", ""),
                order: fnGetQuery("order", "client_id"),
                NUM: sNUM
            };
            var that = this;

            $.ajax({
                url: 'ADMIN/Handler/ClientHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectId(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'ClientSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'ClientSearchView.aspx';
        }
    },

    fnResultSelectId: function (data) {
        if (data != null) {
            var jsonValue = $.parseJSON(JSON.stringify(data));
            if (jsonValue != null) {
                if (jsonValue.msg == 'Y') {
                    var sArg = fnGetUpdateQuery('client_id', jsonValue.client_id);
                    sArg = fnUpdateQuery(sArg, 'NUM', jsonValue.NUM);
                    window.location = 'ClientEditView.aspx?' + sArg;
                } else {
                    this.g_clientEditView.fnGeneralMessage(jsonValue.msg);
                    fnLoaded();
                }
            } else {
                alert('錯誤訊息：資料錯誤，跳往查詢頁面。');
                window.location = 'ClientSearchView.aspx';
            }
        } else {
            alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
            window.location = 'ClientSearchView.aspx';
        }
    },

    /*--------------------------tab1-------------------------*/

    fnInitializationTab1: function () {
        fnLoading();
        this.g_clientEditView.fnInitializationTab1();
        this.fnSelectTab1();
    },

    fnTab1Update: function (update) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/ClientHandler.ashx',
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
            this.g_clientEditView.fnGeneralMessage("更新成功");
        } else {
            this.g_clientEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnSelectTab1: function () {

        if (this.g_sClientId.length > 0) {
            var that = this;
            var sArg = {
                "method": "fnSelect"
                , "client_id": this.g_sClientId
            };

            $.ajax({
                url: 'ADMIN/Handler/ClientHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectTab1(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'ClientSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'ClientSearchView.aspx';
        }
    },

    fnResultSelectTab1: function (data) {
        if (data != null) {
            var jsonValue = $.parseJSON(JSON.stringify($.parseJSON(JSON.stringify(data))[0]));
            if (jsonValue != null) {
                this.g_clientEditView.fnSetDataView(jsonValue);
                fnLoaded();
            } else {
                alert('錯誤訊息：資料錯誤，跳往查詢頁面。');
                window.location = 'ClientSearchView.aspx';
            }
        } else {
            alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
            window.location = 'ClientSearchView.aspx';
        }
    },

    /*------------------------------------tab2-----------------------*/

    fnInitializationTab2: function () {
        fnLoading();
        this.g_clientEditView.fnInitializationTab2();
        var sPage = fnGetQuery("page", "1");
        this.g_iPage = parseInt(sPage);
        this.fnSelectTab2();
    },

    fnSelectTab2: function () {
        if (this.g_sClientId.length > 0) {
            var that = this;
            var sArg = {
                "method": "fnSelectsTran"
                , "page": this.g_iPage.toString()
                , "page_max_size": this.g_iMaxPageSize.toString()
                , "client_id": this.g_sClientId
            };
            $.ajax({
                url: 'ADMIN/Handler/ClientHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectTab2(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'ClientSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'ClientSearchView.aspx';
        }
    },

    fnResultSelectTab2: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));
        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_clientEditView.fnPushTranColumns(jsonValue);
            iIndex++;
        }
        this.g_clientEditView.fnShowTranList();
        if (jsonValues.length == 0) {
            this.g_clientEditView.fnShowTranEmptyColumns();
        }
        this.fnCountTab2();
    },

    fnCountTab2: function () {
        var sArg = {
            "method": "fnCountTran"
            , "client_id": this.g_sClientId.toString()
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/ClientHandler.ashx',
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
            this.g_clientEditView.fnPushTranPageNumber('|<<', 1, '');
        }

        var iLastPage = this.g_iPage - 2; // 若是第一頁則不顯示
        if (iLastPage > 0) {
            this.g_clientEditView.fnPushTranPageNumber('<<', iLastPage, '');
        }

        var iCount = 1;
        var iMinPage = (this.g_iPage - 5) < 2 ? 1 : (this.g_iPage - 5); // 最小為1頁
        for (var iIndex = iMinPage ; iIndex < this.g_iPage; iIndex++) {
            this.g_clientEditView.fnPushTranPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        this.g_clientEditView.fnPushTranPageNumber(this.g_iPage, this.g_iPage, 'select');

        var jsonValue = $.parseJSON(JSON.stringify(data));
        var iPage = parseInt((jsonValue.page_size / this.g_iMaxPageSize));
        if (jsonValue.page_size % this.g_iMaxPageSize != 0 || iPage == 0) {
            iPage += 1;
        }
        for (var iIndex = (this.g_iPage + 1) ; iIndex <= iPage && iCount < 10; iIndex++) {
            this.g_clientEditView.fnPushTranPageNumber(iIndex, iIndex, '');
            iCount++;
        }

        var iNextPage = this.g_iPage + 1;
        if (iNextPage < iPage) {
            this.g_clientEditView.fnPushTranPageNumber('>>', iNextPage, '');
        }

        if (this.g_iPage != iPage) {
            this.g_clientEditView.fnPushTranPageNumber('>>|', iPage, '');
        }
        this.g_clientEditView.fnShowTranPageNumber();
    },

    fnPageNumberChange: function (page) {
        var sArg = '?' + fnGetUpdateQuery('page', page);
        this.g_clientEditView.fnTab2ChangeUrl(sArg);
    },

    fnMaxPageSizeChange: function (page) {
        this.g_iMaxPageSize = page;
        var sArg = '?' + fnGetUpdateQuery('page', '1');
        this.g_clientEditView.fnTab2ChangeUrl(sArg);
    },
};