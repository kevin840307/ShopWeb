

function ShopItemEditView(shopItemEditPresenter) {
    this.g_shopItemEditPresenter = shopItemEditPresenter;
    this.g_sProductIdID = '#lab_product_id';
    this.g_sCategoryID = '#text_category';
    this.g_sContentID = '#text_content';
    this.g_sDescriptionID = '#text_description';
    this.g_sRemarksID = '#text_remarks';
    this.g_sTypeID = '#text_type';
    this.g_sFoldID = '#text_fold';
    this.g_sHindFileID = '#file';
    this.g_sFileID = '#btn_file';
    this.g_sFirstFileID = '#btn_first_file';
    this.g_sHindFileFirstID = '#file_first';

    this.g_sCategoryListID = '#category_list';
    this.g_sTypeListID = '#type_list';

    this.g_sCoverImgDivID = '#cover_img_div';
    this.g_sShowImgDivID = '#show_img_div';

    this.g_sTabID = "#tab";
    this.g_sTitleTabSelectID = '#tab1';
    this.g_bFirstInit = true;
    this.g_bTab2FirstInit = true;
    this.g_bTab3FirstInit = true;
    this.g_arrayHtml = [];
    this.uploadCount = 0;
}

ShopItemEditView.prototype = {
    TAG: 'ShopItemEditView',

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
                //this.g_shopItemEditPresenter.fnInitializationTab1();
                break;
            case 'tab2':
                //if (this.g_bTab2FirstInit) {
                //    this.g_shopItemEditPresenter.fnInitializationTab2();
                //    this.g_bTab2FirstInit = false;
                //}
                break;
            case 'tab3':
                if (this.g_bTab3FirstInit) {
                    this.g_shopItemEditPresenter.fnInitializationTab3();
                    this.g_bTab3FirstInit = false;
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
        this.g_shopItemEditPresenter.fnSelectId(-1);
    },

    fnNext: function () {
        this.g_shopItemEditPresenter.fnSelectId(1);
    },

    //-------------------------------Tab1----------------------

    fnInitializationTab1: function () {
        this.g_bTab2FirstInit = true;
    },

    fnSetDataView: function (jsonValue) {
        $(this.g_sProductIdID).text(jsonValue.product_id);
        $(this.g_sCategoryID).val(jsonValue.category);
        $(this.g_sContentID).val(jsonValue.content.replace(/SSS0/g, "<").replace(/SSS1/g, ">").replace(/''/g, "\""));
        $(this.g_sDescriptionID).val(jsonValue.description);
        $(this.g_sRemarksID).val(jsonValue.remarks);
        $(this.g_sTypeID).val(jsonValue.type);
        $(this.g_sFoldID).val(jsonValue.fold);
    },

    fnUpdate: function (event) {
        event.preventDefault();

        var update = {
            method: "fnUpdate",
            product_id: this.g_shopItemEditPresenter.g_sProductId,
            category: $(this.g_sCategoryID).val(),
            content: tinymce.activeEditor.getContent().replace(/</g, "SSS0").replace(/>/g, "SSS1").replace(/"/g, "''"),
            description: $(this.g_sDescriptionID).val(),
            remarks: $(this.g_sRemarksID).val(),
            type: $(this.g_sTypeID).val(),
            fold: $(this.g_sFoldID).val(),
        };
        this.g_shopItemEditPresenter.fnUpdate(update);
    },

    /*-------------------------tab2--------------------------------*/
    fnInitializationTab2: function () {
        this.show_editor();
    },

    show_editor: function () {
        tinymce.remove();
        tinymce.init({
            selector: '.editor',
            language: 'zh_TW',
            width: "100%",
            height: 350,
            plugins: ['advlist autolink lists link image charmap print preview anchor',
                      'searchreplace visualblocks code fullscreen textcolor colorpicker',
                      'insertdatetime media table contextmenu paste code hr pagebreak nonbreaking'],
            toolbar: ['newdocument preview fullscreen code print searchreplace selectall | bold italic underline strikethrough superscript subscript removeformat forecolor backcolor | alignleft aligncenter alignright alignjustify |',
            'undo redo cut copy paste pastetext pasteword | bullist numlist outdent indent | blockquote nonbreaking hr pagebreak charmap anchor link unlink image table']
        })
    },
    /*-------------------------tab2--------------------------------*/


    /*-------------------------tab3--------------------------------*/
    fnInitializationTab3: function () {
        this.fnInitFirstImage();
    },

    fnInitFirstImage() {
        this.uploadCount++;
        $(this.g_sCoverImgDivID).html("<img src='ShopItem/" + this.g_shopItemEditPresenter.g_sProductId + "/first.png?id=" + this.uploadCount + "' class='item-data-small-img' />");
        //this.g_sShowImgDivID = '#show_img_div';

    },

    fnShowShowImage: function (jsonValue) {
        $(this.g_sShowImgDivID).html(this.g_arrayHtml.join(""));
        this.g_arrayHtml = [];
    },

    fnPushShowImage: function (jsonValue) {
        this.uploadCount++;
        this.g_arrayHtml.push("<img src='ShopItem/" + this.g_shopItemEditPresenter.g_sProductId + "/" + jsonValue.filename + "?id=" + this.uploadCount + "' class='item-data-small-img' onclick='shopItemEditView.fnDeleteImg(\"" + jsonValue.filename + "\", this)' />");
    },

    fnDeleteImg: function (filename, that) {
        if (confirm("確認要刪除?!")) {
            var data = {
                method: "fnDeleteImage",
                product_id: this.g_shopItemEditPresenter.g_sProductId,
                filename: filename
            }
            this.g_shopItemEditPresenter.fnDeleteImg(data, that);
        }
    },

    fnFileFirst: function () {
        $(this.g_sHindFileFirstID).click();
    },

    fnFileFirstChange: function (item) {
        var formData = new FormData(this);
        var files = $(this.g_sHindFileFirstID).get(0).files;

        formData.append("method", "fnUploadFirstImage");
        formData.append("product_id", this.g_shopItemEditPresenter.g_sProductId);
        formData.append("FileUpload", files[0]);
        this.g_shopItemEditPresenter.fnUploadFirstImage(formData);
    },

    fnFile: function () {
        $(this.g_sHindFileID).click();
    },

    fnFileChange: function (item) {
        var formData = new FormData(this);
        var files = $(this.g_sHindFileID).get(0).files;
        formData.append("method", "fnUploadImage");
        formData.append("product_id", this.g_shopItemEditPresenter.g_sProductId);
        for (var index = 0; index < files.length; index++) {
            formData.append("FileUpload" + index, files[index]);
        }
        this.g_shopItemEditPresenter.fnUploadImage(formData);
    },



    /*-------------------------tab3--------------------------------*/
};

