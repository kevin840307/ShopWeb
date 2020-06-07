

function CarouselEditView(carouselEditPresenter) {
    this.g_carouselEditPresenter = carouselEditPresenter;
    this.g_sCarouselIdID = '#lab_carousel_id';
    this.g_sName = '#text_name';
    this.g_sRemarksID = '#text_remarks';

    this.g_sHindFileID = '#file';
    this.g_sFileID = '#btn_file';

    this.g_sShowImgDivID = '#show_img_div';

    this.g_sTabID = "#tab";
    this.g_sTitleTabSelectID = '#tab1';
    this.g_bFirstInit = true;
    this.g_bTab2FirstInit = true;
    this.g_arrayHtml = [];
    this.uploadCount = 0;
}

CarouselEditView.prototype = {
    TAG: 'CarouselEditView',

    fnInitialization: function () {
    },

    fnErrorMessage: function (msg) {
        fnErrorMessage(msg);
    },

    fnGeneralMessage: function (msg) {
        fnGeneralMessage(msg);
    },

    fnTitleTabEvent: function (item) {
        $(this.g_sTitleTabSelectID).removeClass('select');
        $(item).addClass('select');

        $(this.g_sTitleTabSelectID + '_content').addClass('hide');
        $('#' + item.id + '_content').removeClass('hide');

        this.g_sTitleTabSelectID = '#' + item.id;
        this.fnTabChangeEvent(item.id)
    },

    fnTabChangeEvent: function (type) {
        switch (type) {
            case 'tab1':
                //this.g_carouselEditPresenter.fnInitializationTab1();
                break;
            case 'tab2':
                if (this.g_bTab2FirstInit) {
                    this.g_carouselEditPresenter.fnInitializationTab2();
                    this.g_bTab2FirstInit = false;
                }
                break;
        }
    },

    fnPushSelectList: function (jsonValue) {
        this.g_arrayHtml.push(" <option label='" + jsonValue.name + "' value='" + jsonValue.value + "' /> ");
    },


    fnShowCategoryList: function () {
        $(this.g_sCategoryListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnShowTypeList: function () {
        $(this.g_sTypeListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnLast: function () {
        this.g_carouselEditPresenter.fnSelectId(-1);
    },

    fnNext: function () {
        this.g_carouselEditPresenter.fnSelectId(1);
    },

    //-------------------------------Tab1----------------------

    fnInitializationTab1: function () {
        this.g_bTab2FirstInit = true;
    },

    fnSetDataView: function (jsonValue) {
        $(this.g_sCarouselIdID).text(jsonValue.carousel_id);
        $(this.g_sName).val(jsonValue.name);
        $(this.g_sRemarksID).val(jsonValue.remarks);
    },

    fnUpdate: function (event) {
        event.preventDefault();

        var update = {
            method: "fnUpdate",
            carousel_id: this.g_carouselEditPresenter.g_sCarouselId,
            name: $(this.g_sName).val(),
            remarks: $(this.g_sRemarksID).val(),
        };
        this.g_carouselEditPresenter.fnUpdate(update);
    },

    /*-------------------------tab2--------------------------------*/
    fnInitializationTab2: function () {

    },


    fnShowShowImage: function (jsonValue) {
        $(this.g_sShowImgDivID).html(this.g_arrayHtml.join(""));
        this.g_arrayHtml = [];
    },

    fnPushShowImage: function (jsonValue) {
        console.log(jsonValue);
        this.uploadCount++;
        this.g_arrayHtml.push("<img src='Rotation/" + this.g_carouselEditPresenter.g_sCarouselId + "/" + jsonValue.filename + "?id=" + this.uploadCount + "' class='item-data-small-img' onclick='carouselEditView.fnDeleteImg(\"" + jsonValue.filename + "\", this)' />");
    },

    fnDeleteImg: function (filename, that) {
        if (confirm("確認要刪除?!")) {
            var data = {
                method: "fnDeleteImage",
                carousel_id: this.g_carouselEditPresenter.g_sCarouselId,
                filename: filename
            }
            this.g_carouselEditPresenter.fnDeleteImg(data, that);
        }
    },

    fnFile: function () {
        $(this.g_sHindFileID).click();
    },

    fnFileChange: function (item) {
        var formData = new FormData(this);
        var files = $(this.g_sHindFileID).get(0).files;
        formData.append("method", "fnUploadImage");
        formData.append("carousel_id", this.g_carouselEditPresenter.g_sCarouselId);
        for (var index = 0; index < files.length; index++) {
            formData.append("FileUpload" + index, files[index]);
        }
        this.g_carouselEditPresenter.fnUploadImage(formData);
    }



    /*-------------------------tab2--------------------------------*/
};

