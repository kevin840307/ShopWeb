

function ProductEditPresenter(productEditView) {
    this.g_productEditView = productEditView;
    this.g_sProductId = '';
}

ProductEditPresenter.prototype = {
    TAG: 'ProductEditPresenter',

    fnInitialization: function () {
        this.g_sProductId = fnGetQuery("product_id", "");
        this.g_iMaxPageSize = 8;
        this.fnInitializationTab1();
        this.g_productEditView.fnInitialization();
    },

    fnResultSelectList: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));

        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_productEditView.fnPushSelectList(jsonValue);
            iIndex++;
        }
    },

    fnSelectProductId: function (value) {
        var sNUM = fnGetQuery("NUM", "");
        if (sNUM.length > 0) {
            fnLoading();
            sNUM = (parseInt(sNUM) + value).toString();
            var sArg = {
                "method": "fnSelectProductId",
                product_id: fnFixMNDT(fnGetQuery("filter_product_id", "")),
                company_id: fnFixMNDT(fnGetQuery("filter_company_id", "")),
                name: fnFixMNDT(fnGetQuery("filter_name", "")),
                order: fnGetQuery("order", "product_id"),
                NUM: sNUM
            };
            var that = this;

            $.ajax({
                url: 'ADMIN/Handler/ProductHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectProductId(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'ProductSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：NUM錯誤，跳往查詢頁面。');
            window.location = 'ProductSearchView.aspx';
        }
    },

    fnResultSelectProductId: function (data) {
        if (data != null) {
            var jsonValue = $.parseJSON(JSON.stringify(data));
            if (jsonValue != null) {
                if (jsonValue.msg == 'Y') {
                    var sArg = fnGetUpdateQuery('product_id', jsonValue.product_id);
                    sArg = fnUpdateQuery(sArg, 'NUM', jsonValue.NUM);
                    window.location = 'ProductEditView.aspx?' + sArg;
                } else {
                    this.g_productEditView.fnGeneralMessage(jsonValue.msg);
                    fnLoaded();
                }
            } else {
                alert('錯誤訊息：資料錯誤，跳往查詢頁面。');
                window.location = 'ProductSearchView.aspx';
            }
        } else {
            alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
            window.location = 'ProductSearchView.aspx';
        }
    },

    fnTab1Update: function (update) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/ProductHandler.ashx',
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
            this.g_productEditView.fnGeneralMessage("更新成功");
        } else {
            this.g_productEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    /*-----------------------------------------tab1-------------------------------------*/

    fnInitializationTab1: function () {
        fnLoading();
        this.g_productEditView.fnInitializationTab1();
        this.fnSelectCompany();
        this.fnSelectUnit();
        this.fnSelectCurrency();
        this.fnSelectTab1();
    },

    fnSelectUnit: function () {
        this.fnSelectList("U1");
        this.g_productEditView.fnShowUnitList();
    },

    fnSelectCurrency: function () {
        this.fnSelectList("C2");
        this.g_productEditView.fnShowCurrencyList();
    },

    fnSelectCompany: function () {
        var that = this;
        var sArg = {
            "method": "fnSelectList"
        };

        $.ajax({
            url: 'ADMIN/Handler/CompanyHandler.ashx',
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
        this.g_productEditView.fnShowCompanyList();
    },

    fnSelectList: function (value) {
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

    fnSelectTab1: function () {
        if (this.g_sProductId.length > 0) {
            var that = this;
            var sArg = {
                "method": "fnSelect"
                , "product_id": this.g_sProductId
            };
            $.ajax({
                url: 'ADMIN/Handler/ProductHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectTab1(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'ProductSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'ProductSearchView.aspx';
        }
    },

    fnResultSelectTab1: function (data) {
        if (data != null) {
            var jsonValue = $.parseJSON(JSON.stringify($.parseJSON(JSON.stringify(data))[0]));
            if (jsonValue != null) {
                this.g_productEditView.fnSetTab1View(jsonValue);
                fnLoaded();
            } else {
                alert('錯誤訊息：資料錯誤，跳往查詢頁面。');
                window.location = 'ProductSearchView.aspx';
            }
        } else {
            alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
            window.location = 'ProductSearchView.aspx';
        }
    },

    /*-----------------------------------------tab2-------------------------------------*/

    fnInitializationTab2: function () {
        fnLoading();
        this.g_productEditView.fnInitializationTab2();
        var sPage = fnGetQuery("page", "1");
        var iPage = parseInt(sPage);
        this.g_iPage = iPage;
        this.fnSelectTab2();
    },

    fnSelectTab2: function () {
        if (this.g_sProductId.length > 0) {
            var that = this;
            var sArg = {
                "method": "fnSelectsTran"
                , "page": this.g_iPage.toString()
                , "page_max_size": this.g_iMaxPageSize.toString()
                , "product_id": this.g_sProductId.toString()
            };
            $.ajax({
                url: 'ADMIN/Handler/ProductHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectTab2(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'ProductSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'ProductSearchView.aspx';
        }
    },

    fnResultSelectTab2: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));

        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_productEditView.fnPushTab2Columns(jsonValue);
            iIndex++;
        }
        this.g_productEditView.fnShowTab2List();
        if (jsonValues.length == 0) {
            this.g_productEditView.fnShowTab2EmptyColumns();
        }
        this.fnCountTab2();
    },

    fnCountTab2: function () {
        var sArg = {
            "method": "fnCountTran"
            , "product_id": this.g_sProductId
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
                that.fnResultCountTab2(data);
                fnLoaded();
            },
            error: function (sError) {
            }
        });
    },

    fnResultCountTab2: function (data) {
        if (this.g_iPage != 1) {
            this.g_productEditView.fnPushTab2PageNumber('|<<', 1, '');
        }

        var iLastPage = this.g_iPage - 2; // 若是第一頁則不顯示
        if (iLastPage > 0) {
            this.g_productEditView.fnPushTab2PageNumber('<<', iLastPage, '');
        }

        var iCount = 1;
        var iMinPage = (this.g_iPage - 5) < 2 ? 1 : (this.g_iPage - 5); // 最小為1頁
        for (var iIndex = iMinPage ; iIndex < this.g_iPage; iIndex++) {
            this.g_productEditView.fnPushTab2PageNumber(iIndex, iIndex, '');
            iCount++;
        }

        this.g_productEditView.fnPushTab2PageNumber(this.g_iPage, this.g_iPage, 'select');

        var jsonValue = $.parseJSON(JSON.stringify(data));
        var iPage = parseInt((jsonValue.page_size / this.g_iMaxPageSize));
        if (jsonValue.page_size % this.g_iMaxPageSize != 0 || iPage == 0) {
            iPage += 1;
        }
        for (var iIndex = (this.g_iPage + 1) ; iIndex <= iPage && iCount < 10; iIndex++) {
            this.g_productEditView.fnPushTab2PageNumber(iIndex, iIndex, '');
            iCount++;
        }

        var iNextPage = this.g_iPage + 1;
        if (iNextPage < iPage) {
            this.g_productEditView.fnPushTab2PageNumber('>>', iNextPage, '');
        }

        if (this.g_iPage != iPage) {
            this.g_productEditView.fnPushTab2PageNumber('>>|', iPage, '');
        }
        this.g_productEditView.fnShowTab2PageNumber();
    },

    fnTab2Insert: function (insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/ProductHandler.ashx',
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
            this.g_productEditView.fnGeneralMessage("新增成功");
            this.fnInitializationTab2();
        } else {
            this.g_productEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnPageNumberChange: function (page) {
        var sArg = '?' + fnGetUpdateQuery('page', page);
        this.g_productEditView.fnTab2ChangeUrl(sArg);
    },

    fnMaxPageSizeChange: function (page) {
        this.g_iMaxPageSize = page;
        var sArg = '?' + fnGetUpdateQuery('page', '1');
        this.g_productEditView.fnTab2ChangeUrl(sArg);
    },

    /*---------------------------------Tab3--------------------------------*/

    fnInitializationTab3: function () {
        fnLoading();
        this.g_productEditView.fnInitializationTab3();
        this.fnSelectTab3();
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
        this.g_productEditView.fnShowMaterialList();
    },

    fnSelectTab3: function () {
        fnLoading();
        var sArg = {
            "method": "fnSelectsD",
            "product_id": this.g_sProductId
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
                that.fnResultSelectTab3(data);
                that.fnSelectMaterial();
            },
            error: function (sError) {
            }
        });
    },

    fnResultSelectTab3: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));
        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_productEditView.fnTab3PushItem(jsonValue);
            this.g_productEditView.fnTab3PushContent(jsonValue);
            iIndex++;
        }
        this.g_productEditView.fnTab3ShowItem();
        this.g_productEditView.fnTab3ShowContent();
        fnLoaded();
    },

    fnTab3Insert: function (insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/ProductHandler.ashx',
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
            this.g_productEditView.fnGeneralMessage("新增成功");
            this.fnInitializationTab3();
        } else {
            this.g_productEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab3SelectPrice:function(ID, select) {
        var that = this;

        if (!isNaN(parseFloat(select.amount))) {

            $.ajax({
                url: 'ADMIN/Handler/MaterialHandler.ashx',
                data: select,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnTab3ResultSelectPrice(ID, data);
                },
                error: function (sError) {
                }
            });
        }
    },

    fnTab3ResultSelectPrice: function (ID, data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            this.g_productEditView.fnTab3ShowPrice(ID, jsonValue.price);
            //this.fnInitializationTab3();
        } else {
            //this.g_productEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab3Update: function (update) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/ProductHandler.ashx',
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
            this.g_productEditView.fnGeneralMessage("更新成功");
            //this.fnInitializationTab3();
        } else {
            this.g_productEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnTab3Delete: function (material_id) {
        var that = this;
        var sArg = {
            "method": "fnDeleteD"
             , "product_id": this.g_sProductId
             , "material_id": material_id
        };
        $.ajax({
            url: 'ADMIN/Handler/ProductHandler.ashx',
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
            this.g_productEditView.fnGeneralMessage("刪除成功");
            this.fnInitializationTab3();
        } else {
            this.g_productEditView.fnErrorMessage(jsonValue.msg);
        }
    }
};