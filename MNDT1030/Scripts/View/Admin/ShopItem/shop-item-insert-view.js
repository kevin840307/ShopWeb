

function ShopItemInsertView(shopItemInsertPresenter) {
    this.g_shopItemInsertPresenter = shopItemInsertPresenter;
    this.g_sProductIdID = '#text_product_id';
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

    this.g_sProductIdListID = '#product_id_list';
    this.g_sCategoryListID = '#category_list';
    this.g_sTypeListID = '#type_list';

    this.g_sTabID = "#tab";
    this.g_sTitleTabSelectID = '#tab1';
    this.g_bFirstInit = true;
    this.g_bTab2FirstInit = true;
    this.g_bTab3FirstInit = true;
    this.g_arrayHtml = [];
}

ShopItemInsertView.prototype = {
    TAG: 'ShopItemInsertView',

    fnErrorMessage: function (msg) {
        fnErrorMessage(msg);
    },

    fnGeneralMessage: function (msg) {
        fnGeneralMessage(msg);
    },

    fnRemoveProhibited: function (select) {
        $(select).removeClass('prohibited');
    },

    fnTitleTabEvent: function (item) {
        if (!$(item).hasClass('prohibited')) {
            $(this.g_sTitleTabSelectID).removeClass('select');
            $(item).addClass('select');

            $(this.g_sTitleTabSelectID + '_content').addClass('hide');
            $('#' + $(item).attr("id") + '_content').removeClass('hide');

            this.g_sTitleTabSelectID = '#' + $(item).attr("id");
            this.fnTabChangeEvent($(item).attr("id"))
        }
    },

    fnTabChangeEvent: function (type) {
        switch (type) {
            case 'tab1':
                break;
            case 'tab2':
                if (this.g_bTab2FirstInit) {
                    this.g_shopItemInsertPresenter.fnInitializationTab2();
                    this.g_bTab2FirstInit = false;
                }
                break;
            case 'tab3':
                if (this.g_bTab3FirstInit) {
                    this.g_shopItemInsertPresenter.fnInitializationTab3();
                    this.g_bTab3FirstInit = false;
                }
                break;
        }
    },

    fnPushSelectList: function (jsonValue) {
        this.g_arrayHtml.push(" <option label='" + jsonValue.name + "' value='" + jsonValue.value + "' /> ");
    },

    fnShowProductIdList: function () {
        $(this.g_sProductIdListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnShowCategoryList: function () {
        $(this.g_sCategoryListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnShowTypeList: function () {
        $(this.g_sTypeListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    /*-------------------------tab1--------------------------------*/
    fnTab1Insert: function (event) {
        event.preventDefault();

        var insert = {
            method: "fnInsert",
            product_id: $(this.g_sProductIdID).val(),
            category: $(this.g_sCategoryID).val(),
            content: "",
            description: $(this.g_sDescriptionID).val(),
            remarks: $(this.g_sRemarksID).val(),
            type: $(this.g_sTypeID).val(),
            fold: $(this.g_sFoldID).val(),
        };
        this.g_shopItemInsertPresenter.fnTab1Insert(insert);
    },

    /*-------------------------tab1--------------------------------*/


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

    fnTab2Update: function (event) {
        event.preventDefault();

        var update = {
            method: "fnUpdate",
            product_id: $(this.g_sProductIdID).val(),
            category: $(this.g_sCategoryID).val(),
            content: tinymce.activeEditor.getContent().replace(/</g, "SSS0").replace(/>/g, "SSS1").replace(/"/g, "''"),
            description: $(this.g_sDescriptionID).val(),
            remarks: $(this.g_sRemarksID).val(),
            type: $(this.g_sTypeID).val(),
            fold: $(this.g_sFoldID).val(),
        };
        this.g_shopItemInsertPresenter.fnTab2Update(update);
    },

    /*-------------------------tab2--------------------------------*/



    /*-------------------------tab3--------------------------------*/
    fnInitializationTab3: function () {

    },

    fnFileFirst: function () {
        $(this.g_sHindFileFirstID).click();
    },

    fnFileFirstChange: function (item) {
        $(this.g_sFirstFileID).text(item.value);
    },

    //fnFileFirstChange: function (item) {
    //    var formData = new FormData(this);
    //    var files = $(this.g_sHindFileFirstID).get(0).files;

    //    formData.append("method", "fnUploadFirstImage");
    //    formData.append("product_id", $(this.g_sProductIdID).val());
    //    formData.append("FileUpload", files[0]);
    //    this.g_shopItemInsertPresenter.fnUploadFirstImage(formData);
    //},

    fnFile: function () {
        $(this.g_sHindFileID).click();
    },

    fnFileChange: function (item) {
        var paths = []
        var formData = new FormData();
        var files = $(this.g_sHindFileID).get(0).files;
        for (var index = 0; index < files.length; index++) {
            paths.push((index + 1) + "." + files[index].name);
        }
        $(this.g_sFileID).text(paths.join("　　"));
    },

    fnTab3Update: function (event) {
        event.preventDefault();
        var formData1 = new FormData(this);
        var files1 = $(this.g_sHindFileFirstID).get(0).files;

        formData1.append("method", "fnUploadFirstImage");
        formData1.append("product_id", $(this.g_sProductIdID).val());
        formData1.append("FileUpload", files1[0]);

        var formData2 = new FormData();
        var files2 = $(this.g_sHindFileID).get(0).files;
        formData2.append("method", "fnUploadImage");
        formData2.append("product_id", $(this.g_sProductIdID).val());
        for (var index = 0; index < files2.length; index++) {
            formData2.append("FileUpload" + index, files2[index]);
        }
        console.log(formData1);
        if (files2 == null || files1 == null || files1.length < 1 || files2.length < 1) {
            this.g_shopItemInsertView.fnErrorMessage("請選擇上傳圖片");
        } else {
            this.g_shopItemInsertPresenter.fnUpload(formData1, formData2, $(this.g_sProductIdID).val());
        }

    },

    //fnFileChange: function (item) {
    //    var formData = new FormData(this);
    //    var files = $(this.g_sHindFileID).get(0).files;
    //    console.log(files.length);
    //    formData.append("method", "fnUploadImage");
    //    formData.append("product_id", $(this.g_sProductIdID).val());
    //    for (var index = 0; index < files.length; index++) {
    //        formData.append("FileUpload" + index, files[index]);
    //    }
    //    this.g_shopItemInsertPresenter.fnUploadImage(formData);
    //},
    /*-------------------------tab3--------------------------------*/
};

