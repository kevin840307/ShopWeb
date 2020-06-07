

function KindEditPresenter(kindEditView) {
    this.g_kindEditView = kindEditView;
    this.g_sKindId = '';
}

KindEditPresenter.prototype = {
    TAG: 'KindEditPresenter',

    fnInitialization: function () {
        this.g_sKindId = fnGetQuery("kind_id", "");
        this.g_iMaxPageSize = 8;
        this.fnInitializationTab1();
        this.g_kindEditView.fnInitialization();
    },

    fnSelectKindId: function (value) {
        var sNUM = fnGetQuery("NUM", "");
        if (sNUM.length > 0) {
            fnLoading();
            sNUM = (parseInt(sNUM) + value).toString();
            var sArg = {
                "method": "fnSelectKindId",
                id: fnFixMNDT(fnGetQuery("filter_id", "")),
                kind_id: fnFixMNDT(fnGetQuery("filter_kind_id", "")),
                account: fnFixMNDT(fnGetQuery("filter_account", "")),
                name: fnFixMNDT(fnGetQuery("filter_name", "")),
                order: fnGetQuery("order", "kind_id"),
                NUM: sNUM
            };
            var that = this;

            $.ajax({
                url: 'ADMIN/Handler/KindHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectKindId(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'KindSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：NUM錯誤，跳往查詢頁面。');
            window.location = 'KindSearchView.aspx';
        }
    },

    fnResultSelectKindId: function (data) {
        if (data != null) {
            var jsonValue = $.parseJSON(JSON.stringify(data));
            if (jsonValue != null) {
                if (jsonValue.msg == 'Y') {
                    var sArg = fnGetUpdateQuery('kind_id', jsonValue.kind_id);
                    sArg = fnUpdateQuery(sArg, 'NUM', jsonValue.NUM);
                    window.location = 'KindEditView.aspx?' + sArg;
                } else {
                    this.g_kindEditView.fnGeneralMessage(jsonValue.msg);
                    fnLoaded();
                }
            } else {
                alert('錯誤訊息：資料錯誤，跳往查詢頁面。');
                window.location = 'KindSearchView.aspx';
            }
        } else {
            alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
            window.location = 'KindSearchView.aspx';
        }
    },

    /*---------------------------------Tab1-----------------------*/

    fnInitializationTab1: function () {
        fnLoading();
        this.g_kindEditView.fnInitializationTab1();
        this.fnSelectTab1();
    },

    fnTab1Update: function (update) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/KindHandler.ashx',
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
            this.g_kindEditView.fnGeneralMessage("更新成功");
        } else {
            this.g_kindEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnSelectTab1: function () {
        if (this.g_sKindId.length > 0) {
            var that = this;
            var sArg = {
                "method": "fnSelect"
                , "kind_id": this.g_sKindId
            };
            $.ajax({
                url: 'ADMIN/Handler/KindHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectTab1(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'KindSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'KindSearchView.aspx';
        }
    },

    fnResultSelectTab1: function (data) {
        if (data != null) {
            var jsonValue = $.parseJSON(JSON.stringify($.parseJSON(JSON.stringify(data))[0]));
            if (jsonValue != null) {
                this.g_kindEditView.fnSetTab1View(jsonValue);
                this.g_kindEditView.fnTab1Event();
                fnLoaded();
            } else {
                alert('錯誤訊息：資料錯誤，跳往查詢頁面。');
                window.location = 'KindSearchView.aspx';
            }
        } else {
            alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
            window.location = 'KindSearchView.aspx';
        }
    },

    /*---------------------------------Tab2-----------------------*/

    fnInitializationTab2: function () {
        fnLoading();
        this.g_kindEditView.fnInitializationTab2();
        var sPage = fnGetQuery("page", "1");
        var iPage = parseInt(sPage);
        this.g_iPage = iPage;
        this.fnSelectTab2();
    },

    fnSelectTab2: function () {
        if (this.g_sKindId.length > 0) {
            var that = this;
            var sArg = {
                "method": "fnSelectsD"
                , "page": this.g_iPage.toString()
                , "page_max_size": this.g_iMaxPageSize.toString()
                , "kind_id": this.g_sKindId.toString()
            };
            $.ajax({
                url: 'ADMIN/Handler/KindHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectTab2(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'KindSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'KindSearchView.aspx';
        }
    },

    fnResultSelectTab2: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));
        this.g_kindEditView.fnClearTab2List();
        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_kindEditView.fnPushTab2Columns(jsonValue);
            iIndex++;
        }

        if (jsonValues.length == 0) {
            this.g_kindEditView.fnPushTab2EmptyColumns();
        }
        this.g_kindEditView.fnShowTab2List();
        this.fnCountTab2();
    },

    fnCountTab2: function () {
        var sArg = {
            "method": "fnCountD"
            , "kind_id": this.g_sKindId
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
                that.fnResultCountTab2(data);
                fnLoaded();
            },
            error: function (sError) {
            }
        });
    },

    fnResultCountTab2: function (data) {
        if (this.g_iPage != 1) {
            this.g_kindEditView.fnPushTab2PageNumber('|<<', 1, '');
        }

        var iLastPage = this.g_iPage - 2; // 若是第一頁則不顯示
        if (iLastPage > 0) {
            this.g_kindEditView.fnPushTab2PageNumber('<<', iLastPage, '');
        }

        var iCount = 1;
        var iMinPage = (this.g_iPage - 5) < 2 ? 1 : (this.g_iPage - 5); // 最小為1頁
        for (var iIndex = iMinPage ; iIndex < this.g_iPage; iIndex++) {
            this.g_kindEditView.fnPushTab2PageNumber(iIndex, iIndex, '');
            iCount++;
        }

        this.g_kindEditView.fnPushTab2PageNumber(this.g_iPage, this.g_iPage, 'select');

        var jsonValue = $.parseJSON(JSON.stringify(data));
        var iPage = parseInt((jsonValue.page_size / this.g_iMaxPageSize));
        if (jsonValue.page_size % this.g_iMaxPageSize != 0 || iPage == 0) {
            iPage += 1;
        }
        for (var iIndex = (this.g_iPage + 1) ; iIndex <= iPage && iCount < 10; iIndex++) {
            this.g_kindEditView.fnPushTab2PageNumber(iIndex, iIndex, '');
            iCount++;
        }

        var iNextPage = this.g_iPage + 1;
        if (iNextPage < iPage) {
            this.g_kindEditView.fnPushTab2PageNumber('>>', iNextPage, '');
        }

        if (this.g_iPage != iPage) {
            this.g_kindEditView.fnPushTab2PageNumber('>>|', iPage, '');
        }
        this.g_kindEditView.fnShowTab2PageNumber();
        this.g_kindEditView.fnInitListEvent();
    },

    fnTab2Insert: function (tr, insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/KindHandler.ashx',
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
            this.g_kindEditView.fnGeneralMessage("新增成功");
            this.g_kindEditView.fnChangeReadOnly(tr, data)
        } else {
            this.g_kindEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab2Inserts: function (insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/KindHandler.ashx',
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
            this.g_kindEditView.fnGeneralMessage("新增成功");
            this.fnInitializationTab2();
        } else {
            this.g_kindEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab2Update: function (tr, update) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/KindHandler.ashx',
            data: update,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultTab2Update(tr, data);
            },
            error: function (sError) {
            }
        });
    },

    fnResultTab2Update: function (tr, data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            this.g_kindEditView.fnGeneralMessage("更新成功");
            this.g_kindEditView.fnChangeReadOnly(tr, data)
        } else {
            this.g_kindEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab2Updates: function (update) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/KindHandler.ashx',
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
            this.g_kindEditView.fnGeneralMessage("更新成功");
            this.fnInitializationTab2();
        } else {
            this.g_kindEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab2Delete: function (code_id) {
        var that = this;
        var sArg = {
            "method": "fnDeleteD"
             , "kind_id": this.g_sKindId
             , "code_id": code_id
        };
        $.ajax({
            url: 'ADMIN/Handler/KindHandler.ashx',
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
            this.g_kindEditView.fnGeneralMessage("刪除成功");
            this.fnInitializationTab2();
        } else {
            this.g_kindEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnPageNumberChange: function (page) {
        var sArg = '?' + fnGetUpdateQuery('page', page);
        this.g_kindEditView.fnTab2ChangeUrl(sArg);
    },

    fnMaxPageSizeChange: function (page) {
        this.g_iMaxPageSize = page;
        var sArg = '?' + fnGetUpdateQuery('page', '1');
        this.g_kindEditView.fnTab2ChangeUrl(sArg);
    },

 /*---------------------------float----------------------*/
    fnInitializationFloat: function (code_id) {
        fnLoading();
        this.g_kindEditView.fnInitializationFloat();
        this.fnSelectsFloat(code_id);
    },

    fnSelectsFloat: function (code_id) {
        if (this.g_sKindId.length > 0) {
            var that = this;
            var sArg = {
                "method": "fnSelectsDTran"
                , "kind_id": this.g_sKindId.toString()
                , "code_id": code_id
            };
            $.ajax({
                url: 'ADMIN/Handler/KindHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectsFloat(data, code_id);
                    fnLoaded();
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'KindSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'KindSearchView.aspx';
        }
    },

    fnResultSelectsFloat : function (data, code_id) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));

        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_kindEditView.fnPushFloatColumns(jsonValue);
            iIndex++;
        }

        if (jsonValues.length == 0) {
            this.g_kindEditView.fnPushFloatEmptyColumns();
        }

        this.g_kindEditView.fnShowFloatColumns(code_id);
    }
};