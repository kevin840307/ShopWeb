

function GroupEditView(groupEditPresenter) {
    this.g_groupEditPresenter = groupEditPresenter;
    this.g_sTabID = "#tab";
    this.g_sTitleTabSelectID = '#tab1';
    this.g_arrayHtml = [];
}

GroupEditView.prototype = {
    TAG: 'GroupEditView',

    fnInitialization: function () {
        this.g_bTab2FirstInit = true;
        this.g_bTab3FirstInit = true;
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
                //this.g_groupEditPresenter.fnInitializationTab1();
                break;
            case 'tab2':
                if (this.g_bTab2FirstInit) {
                    this.g_groupEditPresenter.fnInitializationTab2();
                    this.g_bTab2FirstInit = false;
                }
                break;
            case 'tab3':
                if (this.g_bTab3FirstInit) {
                    this.g_groupEditPresenter.fnInitializationTab3();
                    this.g_bTab3FirstInit = false;
                }
                break;
        }
    },

    fnLast: function () {
        this.g_groupEditPresenter.fnSelectGroupId(-1);
    },

    fnNext: function () {
        this.g_groupEditPresenter.fnSelectGroupId(1);
    },

    //-------------------------------Tab1----------------------

    fnInitializationTab1: function () {
        this.g_sTab1GroupIdID = '#lab_group_id';
        this.g_sTab1NameID = '#text_name';
        this.g_sTab1DescriptionID = '#text_description';
    },

    fnSetTab1View: function (jsonValue) {
        $(this.g_sTab1GroupIdID).text(jsonValue.group_id);
        $(this.g_sTab1NameID).val(jsonValue.name);
        $(this.g_sTab1DescriptionID).val(jsonValue.description);
    },

    fnTab1Update: function (event) {
        event.preventDefault();
        var update = {
            method: "fnUpdate",
            group_id: $(this.g_sTab1GroupIdID).text(),
            name: $(this.g_sTab1NameID).val(),
            description: $(this.g_sTab1DescriptionID).val()
        };

        this.g_groupEditPresenter.fnTab1Update(update);
    },


    //-------------------------------Tab2---------------------------------

    fnInitializationTab2: function () {
        this.g_sTab2ListID = '#list';
        this.g_sTab2PageID = '#list_page';
        this.g_sTab2IdID = '#tab2_id';
        this.g_sTab2AccountListID = '#account_list';
    },

    fnTab2ChangeUrl: function (arg) {
        fnLoading();
        var that = this;
        window.history.pushState('', 'uselessTitle', arg);
        setTimeout(function () {
            that.g_groupEditPresenter.fnInitializationTab2();
        }, 300);
    },

    fnClearAccountList: function () {
        $(this.g_sTab2AccountListID).html('');
    },

    fnPushSelectAccount: function (jsonValue) {
        this.g_arrayHtml.push(" <option label='" + jsonValue.name + "' value='" + jsonValue.value + "' /> ");
    },

    fnShowAccountList: function () {
        $(this.g_sTab2AccountListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnClearTab2List: function () {
        $(this.g_sTab2ListMessageID).removeClass('show')
    },

    fnPushTab2Columns: function (jsonValue) {
        this.g_arrayHtml.push("   <tr> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.id + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.name + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.create_id + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.create_datetime + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.modify_id + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.modify_datetime + "</td> ");
        this.g_arrayHtml.push("      <td class='action'> ");
        this.g_arrayHtml.push("          <div> ");
        this.g_arrayHtml.push("               <button type='button' class='btn-img-style2' onclick='groupEditView.fnTab2Detele(\"" + jsonValue.id + "\")'><img src='Image/delete.png' /></button> ");
        this.g_arrayHtml.push("          </div> ");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("   </tr> ");
    },

    fnPushTab2PageNumber: function (name, page, select) {
        this.g_arrayHtml.push("  <li><a class='" + select + "' onclick='groupEditView.fnPageNumberChange(\"" + page + "\")' >" + name + "</a></li> ");
    },

    fnShowTab2List: function () {
        $(this.g_sTab2ListID).find('tbody').html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnShowTab2EmptyColumns: function () {
        $(this.g_sTab2ListID).find('tbody').html(" <tr> <td colspan='7' >無資料顯示</td> </tr> ");
    },

    fnShowTab2PageNumber: function () {
        $(this.g_sTab2PageID).find('ul').html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnTab2Insert: function (item, event) {
        event.preventDefault();
        var insert = {
            method: "fnInsertD",
            group_id: this.g_groupEditPresenter.g_sGroupId,
            id: $(this.g_sTab2IdID).val()
        };

        this.g_groupEditPresenter.fnTab2Insert(insert);
    },

    fnTab2Detele: function (id) {
        if (confirm("確定要刪除嗎!")) {
            this.g_groupEditPresenter.fnTab2Delete(id);
        }
    },

    fnMaxPageSizeChange: function (item) {
        this.g_groupEditPresenter.fnMaxPageSizeChange(item.value);
    },

    fnPageNumberChange: function (value) {
        this.g_groupEditPresenter.fnPageNumberChange(value);
    },

    /*--------------------------------------Tab3--------------------------------*/

    fnInitializationTab3: function () {
        this.g_sTab3SelectMenuItemID = '#tab_add';
        this.g_sTab3ProgramMenuID = '#program_menu';
        this.g_sTab3ProgramListID = '#program_list';
        this.g_sTab3ProgramContentID = '#program_content';
        this.g_arrayHtml2 = [];
    },

    fnPushSelectProgram: function (jsonValue) {
        this.g_arrayHtml.push(" <option label='" + jsonValue.name + "' value='" + jsonValue.value + "' /> ");
    },

    fnShowProgramList: function () {
        $(this.g_sTab3ProgramListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnTab3PushItem: function (jsonValue) {
        this.g_arrayHtml.push(" <li class='tab-item' id='tab_" + jsonValue.program_id + "' onclick='groupEditView.fnTab3ItemChange(this);'> ");
        this.g_arrayHtml.push("     <i class='mark'></i>" + jsonValue.program_id + "</li> ");
    },

    fnTab3ShowItem: function () {
        var sHtml = " <li class='tab-item select' id='tab_add' onclick='groupEditView.fnTab3ItemChange(this);'> ";
        sHtml += " <i class='mark'></i>新增</li> " + this.g_arrayHtml.join('');
        $(this.g_sTab3ProgramMenuID).html(sHtml);
        this.g_arrayHtml = [];

    },

    fnTab3PushContent: function (jsonValue) {
        var id = "tab_" + jsonValue.program_id + "_content";
        this.g_arrayHtml2.push("<form class='content-style1 tab-content hide' id='" + id + "' onsubmit='groupEditView.fnTab3Update(this, event)' >");
        this.g_arrayHtml2.push("    <div class='general'>");
        this.g_arrayHtml2.push("        <div class='col-2-left-r'>");
        this.g_arrayHtml2.push("            <label class='font-red'>*作業代碼</label>");
        this.g_arrayHtml2.push("        </div>");
        this.g_arrayHtml2.push("        <div class='col-10-right'>");
        this.g_arrayHtml2.push("            <label name='program_id' >" + jsonValue.program_id + "</label>");
        this.g_arrayHtml2.push("        </div>");
        this.g_arrayHtml2.push("    </div>");
        this.g_arrayHtml2.push("    <div class='general'>");
        this.g_arrayHtml2.push("        <div class='col-2-left-r'>");
        this.g_arrayHtml2.push("            <label>讀取權限</label>");
        this.g_arrayHtml2.push("        </div>");
        this.g_arrayHtml2.push("        <div class='col-10-right'>");
        this.g_arrayHtml2.push("            <input type='checkbox' name='read' class='input-checkbox' " + jsonValue.read + " />");
        this.g_arrayHtml2.push("        </div>");
        this.g_arrayHtml2.push("    </div>");
        this.g_arrayHtml2.push("    <div class='general'>");
        this.g_arrayHtml2.push("        <div class='col-2-left-r'>");
        this.g_arrayHtml2.push("            <label>寫入權限</label>");
        this.g_arrayHtml2.push("        </div>");
        this.g_arrayHtml2.push("        <div class='col-10-right'>");
        this.g_arrayHtml2.push("            <input type='checkbox' name='write' class='input-checkbox' " + jsonValue.write + " />");
        this.g_arrayHtml2.push("        </div>");
        this.g_arrayHtml2.push("    </div>");
        this.g_arrayHtml2.push("    <div class='general'>");
        this.g_arrayHtml2.push("        <div class='col-2-left-r'>");
        this.g_arrayHtml2.push("            <label>執行權限</label>");
        this.g_arrayHtml2.push("        </div>");
        this.g_arrayHtml2.push("        <div class='col-10-right'>");
        this.g_arrayHtml2.push("            <input type='checkbox' name='execute' class='input-checkbox' " + jsonValue.execute + " />");
        this.g_arrayHtml2.push("        </div>");
        this.g_arrayHtml2.push("    </div>");
        this.g_arrayHtml2.push("    <div class='general-right'>");
        this.g_arrayHtml2.push("        <input type='submit' class='col-2 button-style1' />");
        this.g_arrayHtml2.push("        <input type='button' class='col-2 button-style2' value='刪除' onclick='groupEditView.fnTab3Detele(\"" + jsonValue.program_id + "\")' />");
        this.g_arrayHtml2.push("    </div>");
        this.g_arrayHtml2.push("</form>");
    },

    fnTab3ShowContent: function () {
        var arrayHtml = [];
        arrayHtml.push("<div class='title'>作業權限</div>");
        arrayHtml.push("<form class='content-style1 tab-content' id='tab_add_content' onsubmit='groupEditView.fnTab3Insert(this, event);' >");
        arrayHtml.push("    <div class='general'>");
        arrayHtml.push("        <div class='col-2-left-r'>");
        arrayHtml.push("            <label class='font-red'>*作業代碼</label>");
        arrayHtml.push("        </div>");
        arrayHtml.push("        <div class='col-10-right'>");
        arrayHtml.push("            <input type='text' name='program_id' maxlength='15' placeholder='作業代碼' required='required' list='program_list' class='input-data-required' value='' />");
        arrayHtml.push("        </div>");
        arrayHtml.push("    </div>");
        arrayHtml.push("    <div class='general'>");
        arrayHtml.push("        <div class='col-2-left-r'>");
        arrayHtml.push("            <label>讀取權限</label>");
        arrayHtml.push("        </div>");
        arrayHtml.push("        <div class='col-10-right'>");
        arrayHtml.push("            <input type='checkbox' name='read' class='input-checkbox' checked='true' />");
        arrayHtml.push("        </div>");
        arrayHtml.push("    </div>");
        arrayHtml.push("    <div class='general'>");
        arrayHtml.push("        <div class='col-2-left-r'>");
        arrayHtml.push("            <label>寫入權限</label>");
        arrayHtml.push("        </div>");
        arrayHtml.push("        <div class='col-10-right'>");
        arrayHtml.push("            <input type='checkbox' name='write' class='input-checkbox' checked='true' />");
        arrayHtml.push("        </div>");
        arrayHtml.push("    </div>");
        arrayHtml.push("    <div class='general'>");
        arrayHtml.push("        <div class='col-2-left-r'>");
        arrayHtml.push("            <label>執行權限</label>");
        arrayHtml.push("        </div>");
        arrayHtml.push("        <div class='col-10-right'>");
        arrayHtml.push("            <input type='checkbox' name='execute' class='input-checkbox' checked='true' />");
        arrayHtml.push("        </div>");
        arrayHtml.push("    </div>");
        arrayHtml.push("    <div class='general-right'>");
        arrayHtml.push("        <input type='submit' class='col-2 button-style1' />");
        arrayHtml.push("    </div>");
        arrayHtml.push("</form>");
        var sHtml = arrayHtml.join('') + this.g_arrayHtml2.join('');
        $(this.g_sTab3ProgramContentID).html(sHtml);
        this.arrayHtml = [];
        this.g_arrayHtml2 = [];
    },


    fnTab3Detele: function (program_id) {
        if (confirm("確定要刪除嗎!")) {
            this.g_groupEditPresenter.fnTab3Delete(program_id);
        }
    },

    fnTab3Insert: function (item, event) {
        event.preventDefault();
        var insert = {
            method: "fnInsertD",
            group_id: this.g_groupEditPresenter.g_sGroupId,
            program_id: $(item).find("input[name='program_id']").val(),
            read: $(item).find("input[name='read']").prop("checked"),
            write: $(item).find("input[name='write']").prop("checked"),
            execute: $(item).find("input[name='execute']").prop("checked")
        };

        this.g_groupEditPresenter.fnTab3Insert(insert);
    },

    fnTab3Update: function (item, event) {
        event.preventDefault();
        var update = {
            method: "fnUpdateD",
            group_id: this.g_groupEditPresenter.g_sGroupId,
            program_id: $(item).find("label[name='program_id']").text(),
            read: $(item).find("input[name='read']").prop("checked"),
            write: $(item).find("input[name='write']").prop("checked"),
            execute: $(item).find("input[name='execute']").prop("checked")
        };
        this.g_groupEditPresenter.fnTab3Update(update);
    },

    fnTab3ItemChange: function (item) {
        $(this.g_sTab3SelectMenuItemID).removeClass('select');
        $(item).addClass('select');

        $(this.g_sTab3SelectMenuItemID + '_content').addClass('hide');
        $('#' + item.id + '_content').removeClass('hide');

        this.g_sTab3SelectMenuItemID = '#' + item.id;
    }
};

