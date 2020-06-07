

function ShopItemEditPresenter(shopItemEditView) {
    this.g_shopItemEditView = shopItemEditView;
    this.g_sProductId = '';
}

ShopItemEditPresenter.prototype = {
    TAG: 'ShopItemEditPresenter',

    fnInitialization: function () {
        this.g_iMaxPageSize = 8;
        this.g_sProductId = fnGetQuery("product_id", "");
        this.fnInitializationTab1();
        this.g_shopItemEditView.fnInitialization();
    },

    fnSelectId: function (value) {
        var sNUM = fnGetQuery("NUM", "");
        if (sNUM.length > 0) {
            fnLoading();
            sNUM = (parseInt(sNUM) + value).toString();
            var sArg = {
                "method": "fnSelectId",
                product_id: fnFixMNDT(fnGetQuery("filter_product_id", "")),
                status: fnGetQuery("filter_status", ""),
                order: fnGetQuery("order", "product_id"),
                NUM: sNUM
            };
            var that = this;

            $.ajax({
                url: 'ADMIN/Handler/ShopItemHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectId(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'ShopItemSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'ShopItemSearchView.aspx';
        }
    },

    fnResultSelectId: function (data) {
        if (data != null) {
            var jsonValue = $.parseJSON(JSON.stringify(data));
            if (jsonValue != null) {
                if (jsonValue.msg == 'Y') {
                    var sArg = fnGetUpdateQuery('product_id', jsonValue.product_id);
                    sArg = fnUpdateQuery(sArg, 'NUM', jsonValue.NUM);
                    window.location = 'ShopItemEditView.aspx?' + sArg;
                } else {
                    this.g_shopItemEditView.fnGeneralMessage(jsonValue.msg);
                    fnLoaded();
                }
            } else {
                alert('錯誤訊息：資料錯誤，跳往查詢頁面。');
                window.location = 'ShopItemSearchView.aspx';
            }
        } else {
            alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
            window.location = 'ShopItemSearchView.aspx';
        }
    },

    /*-----------------------------tab1-------------------------------*/

    fnInitializationTab1: function () {
        fnLoading();
        this.fnSelectCategory();
        this.fnSelectType();
        this.g_shopItemEditView.fnInitializationTab1();
        this.g_shopItemEditView.fnInitializationTab2();
        this.fnSelectTab1();
    },


    fnSelectCategory: function () {
        this.fnSelectList("SIC");
        this.g_shopItemEditView.fnShowCategoryList();
    },

    fnSelectType: function () {
        this.fnSelectList("SIT");
        this.g_shopItemEditView.fnShowTypeList();
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

    fnResultSelectList: function (data) {
        var iIndex = 0;
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));

        while (iIndex < jsonValues.length) {
            var jsonValue = $.parseJSON(JSON.stringify(jsonValues[iIndex]));
            this.g_shopItemEditView.fnPushSelectList(jsonValue);
            iIndex++;
        }
    },

    fnUpdate: function (update) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/ShopItemHandler.ashx',
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
            this.g_shopItemEditView.fnGeneralMessage("更新成功");
        } else {
            this.g_shopItemEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnSelectTab1: function () {

        if (this.g_sProductId.length > 0) {
            var that = this;
            var sArg = {
                "method": "fnSelect"
                , "product_id": this.g_sProductId
            };

            $.ajax({
                url: 'ADMIN/Handler/ShopItemHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectTab1(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'ShopItemSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'ShopItemSearchView.aspx';
        }
    },

    fnResultSelectTab1: function (data) {
        if (data != null) {
            var jsonValue = $.parseJSON(JSON.stringify($.parseJSON(JSON.stringify(data))[0]));
            if (jsonValue != null) {
                this.g_shopItemEditView.fnSetDataView(jsonValue);
                fnLoaded();
            } else {
                alert('錯誤訊息：資料錯誤，跳往查詢頁面。');
                window.location = 'ShopItemSearchView.aspx';
            }
        } else {
            alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
            window.location = 'ShopItemSearchView.aspx';
        }
    },

    fnUpdate: function (update) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/ShopItemHandler.ashx',
            data: update,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResult2Update(data);
            },
            error: function (sError) {
            }
        });
    },

    fnResult2Update: function (data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            this.g_shopItemEditView.fnGeneralMessage("更新成功");
        } else {
            this.g_shopItemInsertView.fnErrorMessage(jsonValue.msg);
        }
    },

    /*-----------------------------tab2-------------------------------*/

    fnInitializationTab2: function () {
        //fnLoading();
        //this.g_shopItemEditView.fnInitializationTab2();
        //var sPage = fnGetQuery("page", "1");
        //this.g_iPage = parseInt(sPage);
        //this.fnSelectTab2();
    },

    /*-----------------------------tab2-------------------------------*/


    /*-----------------------------tab3-------------------------------*/

    fnInitializationTab3: function () {
        fnLoading();
        this.fnSelectTab3();
        this.g_shopItemEditView.fnInitializationTab3();
        fnLoaded();
    },

    fnSelectTab3: function () {

        if (this.g_sProductId.length > 0) {
            var that = this;
            var sArg = {
                "method": "fnSelectImage"
                , "product_id": this.g_sProductId
            };

            $.ajax({
                url: 'ADMIN/Handler/ShopItemHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectTab3(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'ShopItemSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'ShopItemSearchView.aspx';
        }
    },

    fnResultSelectTab3: function (data) {
        if (data != null) {
            var jsonValues = jQuery.parseJSON(JSON.stringify(data));
            for (var index = 0; index < jsonValues.length; index++) {
                var jsonValue = jQuery.parseJSON(JSON.stringify(jsonValues[index]));
                this.g_shopItemEditView.fnPushShowImage(jsonValue);
            }
            this.g_shopItemEditView.fnShowShowImage();
        } else {
            alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
            window.location = 'ShopItemSearchView.aspx';
        }
    },

    fnDeleteImg: function (arg, obj) {
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/ShopItemHandler.ashx',
            data: arg,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultDeleteImg(data, obj);
            },
            error: function (sError) {
                alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                window.location = 'ShopItemSearchView.aspx';
            }
        });
    },

    fnResultDeleteImg: function (data, obj) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == "Y") {
            $(obj).remove();
            this.g_shopItemEditView.fnGeneralMessage("刪除成功");
        } else {
            this.g_shopItemEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnUploadFirstImage: function (formData) {
        var that = this;
        var result = true;
        $.ajax({
            type: 'post',
            url: 'ADMIN/Handler/ShopItemHandler.ashx',
            data: formData,
            dataType: 'json',
            contentType: false,
            processData: false,
            async: false,
            success: function (data) {
                that.fnResultUploadFirstImage(data);
            },
            error: function (error) {
                alert("errror");
            }
        });

    },

    fnResultUploadFirstImage: function (data) {
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));

        if (jsonValues != null) {
            if (jsonValues.msg == 'Y') {
                this.g_shopItemEditView.fnGeneralMessage("上傳成功。");
                this.g_shopItemEditView.fnInitFirstImage();
            } else {
                this.g_shopItemEditView.fnErrorMessage(jsonValues.msg);
            }
        } else {
            this.g_shopItemEditView.fnErrorMessage("錯誤訊息：不知名錯誤。");
        }
    },

    fnUploadImage: function (formData) {
        var that = this;
        $.ajax({
            type: 'post',
            url: 'ADMIN/Handler/ShopItemHandler.ashx',
            data: formData,
            dataType: 'json',
            contentType: false,
            processData: false,
            async: false,
            success: function (data) {
                that.fnResultUploadImage(data);
            },
            error: function (error) {
                alert("errror");
            }
        });

    },

    fnResultUploadImage: function (data) {
        var jsonValues = jQuery.parseJSON(JSON.stringify(data));

        if (jsonValues != null) {
            if (jsonValues.msg == 'Y') {
                this.g_shopItemEditView.fnGeneralMessage("上傳成功。");
                this.fnSelectTab3();
            } else {
                this.g_shopItemEditView.fnErrorMessage(jsonValues.msg);
            }
        } else {
            this.g_shopItemEditView.fnErrorMessage("錯誤訊息：不知名錯誤。");
        }
    },
    /*-----------------------------tab3-------------------------------*/
};




