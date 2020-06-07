

function ShopItemInsertPresenter(shopItemInsertView) {
    this.g_shopItemInsertView = shopItemInsertView;


}

ShopItemInsertPresenter.prototype = {
    TAG: 'ShopItemInsertPresenter',

    fnInitialization: function () {
        fnLoading();
        this.fnSelectProductId();
        this.fnSelectCategory();
        this.fnSelectType();
        fnLoaded();

    },


    fnSelectProductId: function () {
        var that = this;
        var sArg = {
            "method": "fnSelectList"
        };

        $.ajax({
            url: 'ADMIN/Handler/ProductHandler.ashx',
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
        this.g_shopItemInsertView.fnShowProductIdList();
    },

    fnSelectCategory: function () {
        this.fnSelectList("SIC");
        this.g_shopItemInsertView.fnShowCategoryList();
    },

    fnSelectType: function () {
        this.fnSelectList("SIT");
        this.g_shopItemInsertView.fnShowTypeList();
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
            this.g_shopItemInsertView.fnPushSelectList(jsonValue);
            iIndex++;
        }
    },

    /*-------------------------tab1--------------------------------*/
    fnTab1Insert: function (insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/ShopItemHandler.ashx',
            data: insert,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultTab1Insert(data);
            },
            error: function (sError) {
            }
        });
    },

    fnResultTab1Insert: function (data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            //this.g_sProductId = jsonValue.product_id;
            this.g_shopItemInsertView.fnRemoveProhibited('#tab2');
            this.g_shopItemInsertView.fnTitleTabEvent('#tab2');
            //window.location = 'ShopItemSearchView.aspx?filter_shopItem=' + jsonValue.shopItem;
        } else {
            this.g_shopItemInsertView.fnErrorMessage(jsonValue.msg);
        }
    },
    /*-------------------------tab1--------------------------------*/


    /*-----------------------------------------tab2---------------------------*/

    fnInitializationTab2: function () {
        this.g_shopItemInsertView.fnInitializationTab2();
    },

    fnTab2Update: function (insert) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/ShopItemHandler.ashx',
            data: insert,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultTab2Update(data);
            },
            error: function (sError) {
            }
        });
    },

    fnResultTab2Update: function (data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == 'Y') {
            this.g_shopItemInsertView.fnRemoveProhibited('#tab3');
            this.g_shopItemInsertView.fnTitleTabEvent('#tab3');
        } else {
            this.g_shopItemInsertView.fnErrorMessage(jsonValue.msg);
        }
    },

    /*-----------------------------------------tab2---------------------------*/



    /*-----------------------------------------tab3---------------------------*/

    fnInitializationTab3: function () {
        this.g_shopItemInsertView.fnInitializationTab3();
    },

    fnUpload: function (formData1, formData2, product_id) {
        this.fnUploadFirstImage(formData1);
        this.fnUploadImage(formData2);
        window.location = 'ShopItemSearchView.aspx?filter_product_id=' + product_id;
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
                this.g_shopItemInsertView.fnGeneralMessage("上傳成功。");
            } else {
                this.g_shopItemInsertView.fnErrorMessage(jsonValues.msg);
            }
        } else {
            this.g_shopItemInsertView.fnErrorMessage("錯誤訊息：不知名錯誤。");
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
                this.g_shopItemInsertView.fnGeneralMessage("上傳成功。");
            } else {
                this.g_shopItemInsertView.fnErrorMessage(jsonValues.msg);
            }
        } else {
            this.g_shopItemInsertView.fnErrorMessage("錯誤訊息：不知名錯誤。");
        }
    },
    /*-----------------------------------------tab3---------------------------*/

};