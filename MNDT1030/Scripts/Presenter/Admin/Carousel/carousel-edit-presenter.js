

function CarouselEditPresenter(carouselEditView) {
    this.g_carouselEditView = carouselEditView;
    this.g_sCarouselId = '';
}

CarouselEditPresenter.prototype = {
    TAG: 'CarouselEditPresenter',

    fnInitialization: function () {
        this.g_iMaxPageSize = 8;
        this.g_sCarouselId = fnGetQuery("carousel_id", "");
        this.fnInitializationTab1();
        this.g_carouselEditView.fnInitialization();
    },

    fnSelectId: function (value) {
        var sNUM = fnGetQuery("NUM", "");
        if (sNUM.length > 0) {
            fnLoading();
            sNUM = (parseInt(sNUM) + value).toString();
            var sArg = {
                "method": "fnSelectId",
                carousel_id: fnFixMNDT(fnGetQuery("filter_carousel_id", "")),
                status: fnGetQuery("filter_status", ""),
                order: fnGetQuery("order", "carousel_id"),
                NUM: sNUM
            };
            var that = this;

            $.ajax({
                url: 'ADMIN/Handler/CarouselHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectId(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'CarouselSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'CarouselSearchView.aspx';
        }
    },

    fnResultSelectId: function (data) {
        if (data != null) {
            var jsonValue = $.parseJSON(JSON.stringify(data));
            if (jsonValue != null) {
                if (jsonValue.msg == 'Y') {
                    var sArg = fnGetUpdateQuery('carousel_id', jsonValue.carousel_id);
                    sArg = fnUpdateQuery(sArg, 'NUM', jsonValue.NUM);
                    window.location = 'CarouselEditView.aspx?' + sArg;
                } else {
                    this.g_carouselEditView.fnGeneralMessage(jsonValue.msg);
                    fnLoaded();
                }
            } else {
                alert('錯誤訊息：資料錯誤，跳往查詢頁面。');
                window.location = 'CarouselSearchView.aspx';
            }
        } else {
            alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
            window.location = 'CarouselSearchView.aspx';
        }
    },

    /*-----------------------------tab1-------------------------------*/

    fnInitializationTab1: function () {
        fnLoading();
        this.fnSelectCategory();
        this.fnSelectType();
        this.g_carouselEditView.fnInitializationTab1();
        this.g_carouselEditView.fnInitializationTab2();
        this.fnSelectTab1();
    },


    fnSelectCategory: function () {
        this.fnSelectList("SIC");
        this.g_carouselEditView.fnShowCategoryList();
    },

    fnSelectType: function () {
        this.fnSelectList("SIT");
        this.g_carouselEditView.fnShowTypeList();
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
            this.g_carouselEditView.fnPushSelectList(jsonValue);
            iIndex++;
        }
    },

    fnUpdate: function (update) {
        var that = this;

        $.ajax({
            url: 'ADMIN/Handler/CarouselHandler.ashx',
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
            this.g_carouselEditView.fnGeneralMessage("更新成功");
        } else {
            this.g_carouselEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnSelectTab1: function () {

        if (this.g_sCarouselId.length > 0) {
            var that = this;
            var sArg = {
                "method": "fnSelect"
                , "carousel_id": this.g_sCarouselId
            };

            $.ajax({
                url: 'ADMIN/Handler/CarouselHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectTab1(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'CarouselSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'CarouselSearchView.aspx';
        }
    },

    fnResultSelectTab1: function (data) {
        if (data != null) {
            var jsonValue = $.parseJSON(JSON.stringify($.parseJSON(JSON.stringify(data))[0]));
            if (jsonValue != null) {
                this.g_carouselEditView.fnSetDataView(jsonValue);
                fnLoaded();
            } else {
                alert('錯誤訊息：資料錯誤，跳往查詢頁面。');
                window.location = 'CarouselSearchView.aspx';
            }
        } else {
            alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
            window.location = 'CarouselSearchView.aspx';
        }
    },


    /*-----------------------------tab2-------------------------------*/

    fnInitializationTab2: function () {
        fnLoading();
        this.fnSelectTab2();
        this.g_carouselEditView.fnInitializationTab2();
        fnLoaded();
    },

    fnSelectTab2: function () {

        if (this.g_sCarouselId.length > 0) {
            var that = this;
            var sArg = {
                "method": "fnSelectImage"
                , "carousel_id": this.g_sCarouselId
            };

            $.ajax({
                url: 'ADMIN/Handler/CarouselHandler.ashx',
                data: sArg,
                async: true,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (data) {
                    that.fnResultSelectTab2(data);
                },
                error: function (sError) {
                    alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                    window.location = 'CarouselSearchView.aspx';
                }
            });
        } else {
            alert('錯誤訊息：ID錯誤，跳往查詢頁面。');
            window.location = 'CarouselSearchView.aspx';
        }
    },

    fnResultSelectTab2: function (data) {
        if (data != null) {
            var jsonValues = jQuery.parseJSON(JSON.stringify(data));
            for (var index = 0; index < jsonValues.length; index++) {
                var jsonValue = jQuery.parseJSON(JSON.stringify(jsonValues[index]));
                this.g_carouselEditView.fnPushShowImage(jsonValue);
            }
            this.g_carouselEditView.fnShowShowImage();
        } else {
            alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
            window.location = 'CarouselSearchView.aspx';
        }
    },

    fnDeleteImg: function (arg, obj) {
        var that = this;
        $.ajax({
            url: 'ADMIN/Handler/CarouselHandler.ashx',
            data: arg,
            async: true,
            contentType: 'application/json; charset=UTF-8',
            dataType: "json",
            success: function (data) {
                that.fnResultDeleteImg(data, obj);
            },
            error: function (sError) {
                alert('錯誤訊息：不知名錯誤，跳往查詢頁面。');
                window.location = 'CarouselSearchView.aspx';
            }
        });
    },

    fnResultDeleteImg: function (data, obj) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        if (jsonValue.msg == "Y") {
            $(obj).remove();
            this.g_carouselEditView.fnGeneralMessage("刪除成功");
        } else {
            this.g_carouselEditView.fnErrorMessage(jsonValue.msg);
        }
    },

    fnUploadImage: function (formData) {
        var that = this;
        $.ajax({
            type: 'post',
            url: 'ADMIN/Handler/CarouselHandler.ashx',
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
                this.g_carouselEditView.fnGeneralMessage("上傳成功。");
                this.fnSelectTab2();
            } else {
                this.g_carouselEditView.fnErrorMessage(jsonValues.msg);
            }
        } else {
            this.g_carouselEditView.fnErrorMessage("錯誤訊息：不知名錯誤。");
        }
    },
    /*-----------------------------tab2-------------------------------*/
};




