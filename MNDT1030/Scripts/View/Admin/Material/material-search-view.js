

function MaterialSearchView(materialSearchPresenter) {
    this.g_materialSearchPresenter = materialSearchPresenter;
    this.g_sHindFileID = '#file';
    this.g_sFileID = '#btn_file';
    this.g_sListID = '#list';
    this.g_sPageID = '#list_page';
    this.g_sFilterMaterialIdID = '#filter_material_id';
    this.g_sFilterNameID = '#filter_name';
    this.g_sFilterStatusID = '#filter_status';
    this.g_arrayHtml = [];
}

MaterialSearchView.prototype = {

    TAG: 'MaterialSearchView',

    fnInitialization: function () {
    },

    fnErrorMessage: function (msg) {
        fnErrorMessage(msg);
    },

    fnGeneralMessage: function (msg) {
        fnGeneralMessage(msg);
    },

    fnChangeUrl: function (arg) {
        var that = this;
        fnLoading();
        window.history.pushState('', 'uselessTitle', arg);
        setTimeout(function () {
            that.g_materialSearchPresenter.fnInitList();
        }, 300);
    },

    fnGoUrl: function (arg) {
        window.location = 'MNDT1010.aspx' + arg;
    },

    fnShowFilterView: function (filter) {
        $(this.g_sFilterMaterialIdID).val(filter.material_id.toString());
        $(this.g_sFilterNameID).val(filter.name.toString());
        $(this.g_sFilterStatusID + ' option[value=' + filter.status.toString() + ']').attr('selected', 'selected');
    },

    fnPushColumns: function (jsonValue) {
        this.g_arrayHtml.push("   <tr> ");
        this.g_arrayHtml.push("      <td><input type='checkbox' class='checkbox-style1' name='checkbox_delete' /> </td> ");
        this.g_arrayHtml.push("      <td class='key'>" + jsonValue.material_id + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.name + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.company_id + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.status + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.create_datetime + "</td> ");
        this.g_arrayHtml.push("      <td class='action'> ");
        this.g_arrayHtml.push("          <div> ");
        this.g_arrayHtml.push("               <button type='button' class='btn-img-style1' onclick='materialSearchView.fnOpenEdit(\"" + jsonValue.material_id + "\", \"" + jsonValue.NUM + "\")' ><img src='Image/edit.png' /></button> ");
        this.g_arrayHtml.push("               <button type='button' class='btn-img-style2' onclick='materialSearchView.fnDetele(\"" + jsonValue.material_id + "\")'><img src='Image/delete.png' /></button> ");
        this.g_arrayHtml.push("          </div> ");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("   </tr> ");
    },

    fnPushPageNumber: function (name, page, select) {
        this.g_arrayHtml.push("  <li><a class='" + select + "' onclick='materialSearchView.fnPageNumberChange(\"" + page + "\")' >" + name + "</a></li> ");
    },

    fnShowEmptyColumns: function () {
        $(this.g_sListID).find('tbody').html(" <tr> <td colspan='7' >無資料顯示</td> </tr> ");
    },

    fnShowList: function () {
        $(this.g_sListID).find('tbody').html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnShowPageNumber: function (name, page, select) {
        $(this.g_sPageID).find('ul').html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnFile: function () {
        $(this.g_sHindFileID).click();
    },

    fnFileChange: function (item) {
        $(this.g_sFileID).text(item.value);
    },

    fnImport: function () {
        var formData = new FormData();
        var files = $(this.g_sHindFileID).get(0).files;

        if (files.length > 0) {
            formData.append("method", "fnImport");
            formData.append("FileUpload", files[0]);
            this.g_materialSearchPresenter.fnImport(formData);
        }
    },

    fnMaxPageSizeChange: function (item) {
        this.g_materialSearchPresenter.fnMaxPageSizeChange(item.value);
    },

    fnOrderChange: function (value) {
        this.g_materialSearchPresenter.fnOrderChange(value);
    },

    fnPageNumberChange: function (value) {
        this.g_materialSearchPresenter.fnPageNumberChange(value);
    },

    fnFilterChange: function () {
        var filter = {
            material_id: $(this.g_sFilterMaterialIdID).val(),
            name: $(this.g_sFilterNameID).val(),
            status: $(this.g_sFilterStatusID).find('option:selected').val(),
        };
        this.g_materialSearchPresenter.fnFilterChange(filter);
    },

    fnInitListEvent: function () {
        var that = this;
        var bClose = true;

        // List其他下拉
        $('.drop-other').focus(function () {
            $(this).parent().find('> ul').slideDown(200);
        });

        $('.drop-other').focusout(function () {
            if (bClose) {
                $(this).parent().find('> ul').slideUp(50);
            }
        });

        $('.action li').mouseover(function () {
            bClose = false;
        });

        $('.action li').mouseout(function () {
            bClose = true;
        });

        $('.action li').click(function () {
            $(this).parent().slideUp(50);
        });
    },

    fnOpenEdit: function (material_id, NUM) {
        var filter = window.location.search.substring(1);
        filter = (filter.length > 0) ? '&' + filter : filter;
        window.location = 'MaterialEditView.aspx?material_id=' + material_id + '&NUM=' + NUM + filter;
    },

    fnDeteles: function () {
        if (confirm("確定要刪除嗎!")) {
            var sIds = [];
            $(this.g_sListID + ' > tbody > tr').each(function () {
                var sCheck = $(this).find('input[name=\'checkbox_delete\']').attr('checked');
                if (sCheck == 'checked') {
                    sIds.push($(this).find('.key').text());
                }
            });
            materialSearchPresenter.fnDeletes(sIds);
        }
    },

    fnDetele: function (key) {
        if (confirm("確定要刪除嗎!")) {
            materialSearchPresenter.fnDelete(key);
        }
    }
};

