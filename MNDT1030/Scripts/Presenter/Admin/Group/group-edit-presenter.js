

function GroupEditPresenter(groupEditView) {
    this.g_groupEditView = groupEditView;
    this.g_sGroupId = '';
}

GroupEditPresenter.prototype = {
    TAG: 'GroupEditPresenter',

    fnInitialization: function () {
        this.g_sGroupId = fnGetQuery("group_id", "");
        this.g_iMaxPageSize = 8;
        this.fnInitializationTab1();
        this.g_groupEditView.fnInitialization();
    },

    fnSelectGroupId: function (value) {
        var sNUM = fnGetQuery("NUM", "");
        if (sNUM.length > 0) {
            fnLoading();
            sNUM = (parseInt(sNUM) + value).toString();
            var sArg = {
                "method": "fnSelectGroupId",
                id: fnFixMNDT(fnGetQuery("filter_id", "")),
                group_id: fnFixMNDT(fnGetQuery("filter_group_id", "")),
                account: fnFixMNDT(fnGetQuery("filter_account", "")),
                name: fnFixMNDT(fnGetQuery("filter_name", "")),
                order: fnGetQuery("order", "group_id"),
                NUM: sNUM
            };
            var that = this;

            $.ajax({
                url: 'ADMIN/Handler/GroupHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectGroupId(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'GroupSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：NUM錯誤，跳往查詢頁面。');
            window.location = 'GroupSearchView.aspx';
        }
    },

    fnResultSelectGroupId: function (data) {
        if (data != null) {
            var jsonValue = $.parseJSON(JSON.stringify(data));
            if (jsonValue != null) {
                if (jsonValue.msg == 'Y') {
                    var sArg = fnGetUpdateQuery('group_id', jsonValue.group_id);
                    sArg = fnUpdateQuery(sArg, 'NUM', jsonValue.NUM);
                    window.location = 'GroupEditView.aspx?' + sArg;
                } else {
                    this.g_groupEditView.fnGeneralMessage(jsonValue.msg);
                    fnLoaded();
                }
            } else {
                alert('錯誤訊息：資料錯誤，跳往查詢頁面。');
                window.location = 'GroupSearchView.aspx';
            }
        } else {
            alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
            window.location = 'GroupSearchView.aspx';
        }
    },

    /*-----------------------------tab1--------------------*/

    fnInitializationTab1: function () {
        fnLoading();
        this.g_groupEditView.fnInitializationTab1();
        this.fnSelectTab1();
    },

    fnTab1Update: function (update) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/GroupHandler.ashx',
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
            this.g_groupEditView.fnGeneralMessage("更新成功");
        } else {
            this.g_groupEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnSelectTab1: function () {
        if (this.g_sGroupId.length > 0) {
            var that = this;
            var sArg = {
                "method": "fnSelect"
                , "group_id": this.g_sGroupId
            };
            $.ajax({
                url: 'ADMIN/Handler/GroupHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectTab1(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'GroupSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'GroupSearchView.aspx';
        }
    },

    fnResultSelectTab1: function (data) {
        if (data != null) {
            var jsonValue = $.parseJSON(JSON.stringify($.parseJSON(JSON.stringify(data))[0]));
            if (jsonValue != null) {
                this.g_groupEditView.fnSetTab1View(jsonValue);
                fnLoaded();
            } else {
                alert('錯誤訊息：資料錯誤，跳往查詢頁面。');
                window.location = 'GroupSearchView.aspx';
            }
        } else {
            alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
            window.location = 'GroupSearchView.aspx';
        }
    },

    /*------------------------------------tab2------------------------------*/

    fnInitializationTab2: function () {
        fnLoading();
        this.g_groupEditView.fnInitializationTab2();
        var sPage = fnGetQuery("page", "1");
        var iPage = parseInt(sPage);
        this.g_iPage = iPage;
        this.fnSelectTab2();
        this.fnSelectAccount();
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
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultSelectAccount(data);
            },
            error: function (sError) {
            }
        });
    },

    fnResultSelectAccount: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));
        this.g_groupEditView.fnClearAccountList();
        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_groupEditView.fnPushSelectAccount(jsonValue);
            iIndex++;
        }
        this.g_groupEditView.fnShowAccountList();
    },

    fnSelectTab2: function () {
        if (this.g_sGroupId.length > 0) {
            var that = this;
            var sArg = {
                "method": "fnSelectsD"
                , "page": this.g_iPage.toString()
                , "page_max_size": this.g_iMaxPageSize.toString()
                , "group_id": this.g_sGroupId.toString()
            };
            $.ajax({
                url: 'ADMIN/Handler/GroupHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectTab2(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'GroupSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'GroupSearchView.aspx';
        }
    },

    fnResultSelectTab2: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));
        this.g_groupEditView.fnClearTab2List();
        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_groupEditView.fnPushTab2Columns(jsonValue);
            iIndex++;
        }
        this.g_groupEditView.fnShowTab2List();
        if (jsonValues.length == 0) {
            this.g_groupEditView.fnShowTab2EmptyColumns();
        }
        this.fnCountTab2();
    },

    fnCountTab2: function () {
        var sArg = {
            "method": "fnCountD"
            , "group_id": this.g_sGroupId
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
                that.fnResultCountTab2(data);
                fnLoaded();
            },
            error: function (sError) {
            }
        });
    },

    fnResultCountTab2: function (data) {
        if (this.g_iPage != 1) {
            this.g_groupEditView.fnPushTab2PageNumber('|<<', 1, '');
        }

        var iLastPage = this.g_iPage - 2; // 若是第一頁則不顯示
        if (iLastPage > 0) {
            this.g_groupEditView.fnPushTab2PageNumber('<<', iLastPage, '');
        }

        var iCount = 1;
        var iMinPage = (this.g_iPage - 5) < 2 ? 1 : (this.g_iPage - 5); // 最小為1頁
        for (var iIndex = iMinPage ; iIndex < this.g_iPage; iIndex++) {
            this.g_groupEditView.fnPushTab2PageNumber(iIndex, iIndex, '');
            iCount++;
        }

        this.g_groupEditView.fnPushTab2PageNumber(this.g_iPage, this.g_iPage, 'select');

        var jsonValue = $.parseJSON(JSON.stringify(data));
        var iPage = parseInt((jsonValue.page_size / this.g_iMaxPageSize));
        if (jsonValue.page_size % this.g_iMaxPageSize != 0 || iPage == 0) {
            iPage += 1;
        }
        for (var iIndex = (this.g_iPage + 1) ; iIndex <= iPage && iCount < 10; iIndex++) {
            this.g_groupEditView.fnPushTab2PageNumber(iIndex, iIndex, '');
            iCount++;
        }

        var iNextPage = this.g_iPage + 1;
        if (iNextPage < iPage) {
            this.g_groupEditView.fnPushTab2PageNumber('>>', iNextPage, '');
        }

        if (this.g_iPage != iPage) {
            this.g_groupEditView.fnPushTab2PageNumber('>>|', iPage, '');
        }
        this.g_groupEditView.fnShowTab2PageNumber();
    },

    fnTab2Insert: function (insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/GroupHandler.ashx',
            type: 'GET',
            data: insert,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultTab2Insert(data);
            },
            error: function (sError) {
            }
        });
    },

    fnResultTab2Insert: function (data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            this.g_groupEditView.fnGeneralMessage("新增成功");
            this.fnInitializationTab2();
        } else {
            this.g_groupEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab2Delete: function (id) {
        var that = this;
        var sArg = {
            "method": "fnDeleteD"
             , "group_id": this.g_sGroupId
             , "id": id
        };
        $.ajax({
            url: 'ADMIN/Handler/GroupHandler.ashx',
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
            this.g_groupEditView.fnGeneralMessage("刪除成功");
            this.fnInitializationTab2();
        } else {
            this.g_groupEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnPageNumberChange: function (page) {
        var sArg = '?' + fnGetUpdateQuery('page', page);
        this.g_groupEditView.fnTab2ChangeUrl(sArg);
    },

    fnMaxPageSizeChange: function (page) {
        this.g_iMaxPageSize = page;
        var sArg = '?' + fnGetUpdateQuery('page', '1');
        this.g_groupEditView.fnTab2ChangeUrl(sArg);
    },

    /*---------------------------------Tab3--------------------------------*/

    fnInitializationTab3: function () {
        fnLoading();
        this.g_groupEditView.fnInitializationTab3();
        this.fnSelectTab3();
    },

    fnSelectProgram: function () {
        var sArg = {
            "method": "fnSelectList"
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/ProgramHandler.ashx',
            type: 'GET',
            data: sArg,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultSelectProgram(data);
            },
            error: function (sError) {
            }
        });
    },

    fnResultSelectProgram: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));
        this.g_groupEditView.fnClearAccountList();
        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_groupEditView.fnPushSelectProgram(jsonValue);
            iIndex++;
        }
        this.g_groupEditView.fnShowProgramList();
    },

    fnSelectTab3: function () {
        fnLoading();
        var sArg = {
            "method": "fnSelectsD",
            "group_id": this.g_sGroupId
        };
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/ProgramHandler.ashx',
            type: 'GET',
            data: sArg,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultSelectTab3(data);
                that.fnSelectProgram();
            },
            error: function (sError) {
            }
        });
    },

    fnResultSelectTab3: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));
        this.g_groupEditView.fnClearAccountList();
        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_groupEditView.fnTab3PushItem(jsonValue);
            this.g_groupEditView.fnTab3PushContent(jsonValue);
            iIndex++;
        }
        this.g_groupEditView.fnTab3ShowItem();
        this.g_groupEditView.fnTab3ShowContent();
        fnLoaded();
    },

    fnTab3Insert: function (insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/ProgramHandler.ashx',
            type: 'GET',
            data: insert,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultTab3Insert(data);
            },
            error: function (sError) {
            }
        });
    },

    fnResultTab3Insert: function (data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            this.g_groupEditView.fnGeneralMessage("新增成功");
            this.fnInitializationTab3();
        } else {
            this.g_groupEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab3Update: function (update) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/ProgramHandler.ashx',
            data: update,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultTab3Update(data);
            },
            error: function (sError) {
            }
        });
    },

    fnResultTab3Update: function (data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            this.g_groupEditView.fnGeneralMessage("更新成功");
            //this.fnInitializationTab3();
        } else {
            this.g_groupEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab3Delete: function (program_id) {
        var that = this;
        var sArg = {
            "method": "fnDeleteD"
             , "group_id": this.g_sGroupId
             , "program_id": program_id
        };
        $.ajax({
            url: 'ADMIN/Handler/ProgramHandler.ashx',
            data: sArg,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultTab3Delete(data);
            },
            error: function (sError) {
            }
        });
    },

    fnResultTab3Delete: function (data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            this.g_groupEditView.fnGeneralMessage("刪除成功");
            this.fnInitializationTab3();
        } else {
            this.g_groupEditView.fnErrorMessage(jsonValue.msg);
        }
    }
};