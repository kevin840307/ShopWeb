

function KindEditView(kindEditPresenter) {
    this.g_kindEditPresenter = kindEditPresenter;
    this.g_sTabID = "#tab";
    this.g_sTitleTabSelectID = '#tab1';
    this.g_arrayHtml = [];
}

KindEditView.prototype = {
    TAG: 'KindEditView',

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
                //this.g_kindEditPresenter.fnInitializationTab1();
                break;
            case 'tab2':
                if (this.g_bTab2FirstInit) {
                    this.g_kindEditPresenter.fnInitializationTab2();
                    this.g_bTab2FirstInit = false;
                }
                break;
            case 'tab3':
                if (this.g_bTab3FirstInit) {
                    this.g_kindEditPresenter.fnInitializationTab3();
                }
                break;
        }
    },

    fnLast: function () {
        this.g_kindEditPresenter.fnSelectKindId(-1);
    },

    fnNext: function () {
        this.g_kindEditPresenter.fnSelectKindId(1);
    },

    //-------------------------------Tab1----------------------

    fnInitializationTab1: function () {
        this.g_sTab1KindIdID = '#lab_kind_id';
        this.g_sTab1NameID = '#text_name';
        this.g_sTab1DescriptionID = '#text_description';
    },

    fnSetTab1View: function (jsonValue) {
        $(this.g_sTab1KindIdID).text(jsonValue.kind_id);
        $(this.g_sTab1NameID).val(jsonValue.name);
        $(this.g_sTab1DescriptionID).val(jsonValue.description);
    },

    fnTab1Update: function (event) {
        event.preventDefault();
        var update = {
            method: "fnUpdate",
            kind_id: $(this.g_sTab1KindIdID).text(),
            name: $(this.g_sTab1NameID).val(),
            description: $(this.g_sTab1DescriptionID).val()
        };

        this.g_kindEditPresenter.fnTab1Update(update);
    },

    fnTab1Event: function (type) {

    },

    //-------------------------------Tab2---------------------------------

    fnInitializationTab2: function () {
        this.g_sTab2ListID = '#list';
        this.g_sTab2PageID = '#list_page';
        this.g_sTab2IdID = '#tab2_id';
        this.g_sTab2AccountListID = '#account_list';
        this.g_sTab2FloatWindowID = '#float_window';
    },

    fnTab2ChangeUrl: function (arg) {
        fnLoading();
        var that = this;
        window.history.pushState('', 'uselessTitle', arg);
        setTimeout(function () {
            that.g_kindEditPresenter.fnInitializationTab2();
        }, 300);
    },

    fnClearAccountList: function () {
        $(this.g_sTab2AccountListID).html('');
    },

    fnClearTab2List: function () {
        $(this.g_sTab2ListMessageID).removeClass('show')
    },

    fnPushTab2Columns: function (jsonValue) {
        this.g_arrayHtml.push("   <tr ondblclick='kindEditView.fnChangeEdit(this);'> ");
        this.g_arrayHtml.push("      <td name='code_id'>" + jsonValue.code_id + "</td> ");
        this.g_arrayHtml.push("      <td name='name'>" + jsonValue.name + "</td> ");
        this.g_arrayHtml.push("      <td name='parameter'>" + jsonValue.parameter + "</td> ");
        this.g_arrayHtml.push("      <td class='action'> ");
        this.g_arrayHtml.push("          <div> ");
        this.g_arrayHtml.push("              <button type='button' class='btn-img-style1'><img src='Image/view.png' onclick='kindEditPresenter.fnInitializationFloat(\"" + jsonValue.code_id + "\");' /></button> ");
        this.g_arrayHtml.push("              <button type='button' class='btn-img-style1 drop-other'><img src='Image/drop.png' /></button> ");
        this.g_arrayHtml.push("              <ul> ");
        this.g_arrayHtml.push("                  <li> ");
        this.g_arrayHtml.push("                     <a onclick='kindEditView.fnChildChangeEdit(this);' ><i class='icon-edit' />編輯</a> ");
        this.g_arrayHtml.push("                  </li> ");
        this.g_arrayHtml.push("                  <li> ");
        this.g_arrayHtml.push("                     <a onclick='kindEditView.fnTab2Detele(\"" + jsonValue.code_id + "\")' ><i class='icon-delete' />刪除</a> ");
        this.g_arrayHtml.push("                  </li> ");
        this.g_arrayHtml.push("              </ul> ");
        //this.g_arrayHtml.push("               <button type='button' class='btn-img-style1' onclick='kindEditView.fnChangeEdit(this);'><img src='Image/edit.png' /></button> ");
        //this.g_arrayHtml.push("               <button type='button' class='btn-img-style2' onclick='kindEditView.fnTab2Detele(\"" + jsonValue.code_id + "\")'><img src='Image/delete.png' /></button> ");
        this.g_arrayHtml.push("          </div> ");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("      <td name='status'>" + jsonValue.status + "</td> ");
        this.g_arrayHtml.push("   </tr> ");
    },

    fnPushTab2EmptyColumns: function () {
        //this.g_arrayHtml.push(" <tr> <td colspan='5' >無資料顯示</td> </tr> ");
    },

    fnPushTab2PageNumber: function (name, page, select) {
        this.g_arrayHtml.push("  <li><a class='" + select + "' onclick='kindEditView.fnPageNumberChange(\"" + page + "\")' >" + name + "</a></li> ");
    },

    fnShowTab2List: function () {
        $(this.g_sTab2ListID).find('tbody').html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnShowTab2PageNumber: function () {
        $(this.g_sTab2PageID).find('ul').html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnMaxPageSizeChange: function (item) {
        this.g_kindEditPresenter.fnMaxPageSizeChange(item.value);
    },

    fnPageNumberChange: function (value) {
        this.g_kindEditPresenter.fnPageNumberChange(value);
    },

    fnTab2AppendInsert: function () {
        this.g_arrayHtml.push("   <tr name='insert'> ");
        this.g_arrayHtml.push("      <td> ");
        this.g_arrayHtml.push("          <input type='text' maxlength='5' placeholder='代碼' name='code_id' required='required' class='input-data-required' />");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("      <td> ");
        this.g_arrayHtml.push("          <input type='text' maxlength='15' placeholder='名稱' name='name' class='input-data'  />");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("      <td> ");
        this.g_arrayHtml.push("          <input type='text' maxlength='15' placeholder='參數' name='parameter' class='input-data' />");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("      <td class='action'> ");
        this.g_arrayHtml.push("          <div> ");
        this.g_arrayHtml.push("               <button type='button' class='btn-img-style3' onclick='kindEditView.fnTab2Insert(this);'><img src='Image/tick.png' /></button> ");
        this.g_arrayHtml.push("               <button type='button' class='btn-img-style2' onclick='kindEditView.fnTab2RemoveInsert(this);'><img src='Image/cancel.png' /></button> ");
        this.g_arrayHtml.push("          </div> ");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("      <td>N</td> ");
        this.g_arrayHtml.push("   </tr> ");
        $(this.g_sTab2ListID).find('tbody').append(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnTab2RemoveInsert: function (item) {
        var tr = $(item).parent().parent().parent();
        tr.html('');
        tr.attr('name', '');
    },

    fnTab2SelectsTran: function (code_id) {
        fnOpenView(this.g_sTab2FloatWindowID);
    },

    fnTab2Insert: function (item) {
        var tr = $(item).parent().parent().parent();
        var insert = {
            method: "fnInsertD",
            kind_id: this.g_kindEditPresenter.g_sKindId,
            code_id: tr.find("input[name='code_id']").val(),
            name: tr.find("input[name='name']").val(),
            parameter: tr.find("input[name='parameter']").val()
        };

        this.g_kindEditPresenter.fnTab2Insert(tr, insert);
    },

    fnTab2Inserts: function () {
        var inserts = {
            method: "fnInsertsD",
            kind_id: this.g_kindEditPresenter.g_sKindId,
            code_id: [],
            name: [],
            parameter: []
        };
        $(this.g_sTab2ListID).find(" > tbody > tr[name='insert']").each(function () {
            var sCodeId = $(this).find("input[name='code_id']").val();
            if (sCodeId.length > 0) {
                inserts.code_id.push(sCodeId);
                inserts.name.push($(this).find("input[name='name']").val());
                inserts.parameter.push($(this).find("input[name='parameter']").val());
            }
        });
        inserts.code_id = inserts.code_id.toString();
        inserts.name = inserts.name.toString();
        inserts.parameter = inserts.parameter.toString();
        this.g_kindEditPresenter.fnTab2Inserts(inserts);
    },

    fnTab2Update: function (item) {
        var tr = $(item).parent().parent().parent();
        var update = {
            method: "fnUpdateD",
            kind_id: this.g_kindEditPresenter.g_sKindId,
            code_id: tr.find("td[name='code_id']").text(),
            name: tr.find("input[name='name']").val(),
            parameter: tr.find("input[name='parameter']").val(),
            status: tr.find("select[name='status']").find('option:selected').val()
        };

        this.g_kindEditPresenter.fnTab2Update(tr, update);
    },

    fnTab2Updates: function () {
        var updates = {
            method: "fnUpdatesD",
            kind_id: this.g_kindEditPresenter.g_sKindId,
            code_id: [],
            name: [],
            parameter: [],
            status: [],
        };

        $(this.g_sTab2ListID).find(" > tbody > tr[name='edit']").each(function () {
            var sCodeId = $(this).find("td[name='code_id']").text();
            if (sCodeId.length > 0) {
                updates.code_id.push(sCodeId);
                updates.name.push($(this).find("input[name='name']").val());
                updates.parameter.push($(this).find("input[name='parameter']").val());
                updates.status.push($(this).find("select[name='status']").find('option:selected').val());
            }
        });
        updates.code_id = updates.code_id.toString();
        updates.name = updates.name.toString();
        updates.parameter = updates.parameter.toString();
        updates.status = updates.status.toString();
        this.g_kindEditPresenter.fnTab2Updates(updates);
    },

    fnTab2Detele: function (code_id) {
        if (confirm("確定要刪除嗎!")) {
            this.g_kindEditPresenter.fnTab2Delete(code_id);
        }
    },

    fnChangeReadOnly: function (tr, jsonValue) {
        this.g_arrayHtml.push("      <td name='code_id'>" + jsonValue.code_id + "</td> ");
        this.g_arrayHtml.push("      <td name='name'>" + jsonValue.name + "</td> ");
        this.g_arrayHtml.push("      <td name='parameter'>" + jsonValue.parameter + "</td> ");
        this.g_arrayHtml.push("      <td class='action'> ");
        this.g_arrayHtml.push("          <div> ");
        this.g_arrayHtml.push("              <button type='button' class='btn-img-style1'><img src='Image/view.png' onclick='kindEditPresenter.fnInitializationFloat(\"" + jsonValue.code_id + "\");' /></button> ");
        this.g_arrayHtml.push("              <button type='button' class='btn-img-style1 drop-other'><img src='Image/drop.png' /></button> ");
        this.g_arrayHtml.push("              <ul> ");
        this.g_arrayHtml.push("                  <li> ");
        this.g_arrayHtml.push("                     <a onclick='kindEditView.fnChildChangeEdit(this);' ><i class='icon-edit' />編輯</a> ");
        this.g_arrayHtml.push("                  </li> ");
        this.g_arrayHtml.push("                  <li> ");
        this.g_arrayHtml.push("                     <a onclick='kindEditView.fnTab2Detele(\"" + jsonValue.code_id + "\")' ><i class='icon-delete' />刪除</a> ");
        this.g_arrayHtml.push("                  </li> ");
        this.g_arrayHtml.push("              </ul> ");
        //this.g_arrayHtml.push("               <button type='button' class='btn-img-style1' onclick='kindEditView.fnChangeEdit(this);'><img src='Image/edit.png' /></button> ");
        //this.g_arrayHtml.push("               <button type='button' class='btn-img-style2' onclick='kindEditView.fnTab2Detele(\"" + jsonValue.code_id + "\")'><img src='Image/delete.png' /></button> ");
        this.g_arrayHtml.push("          </div> ");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("      <td name='status'>" + jsonValue.status + "</td> ");
        tr.html(this.g_arrayHtml.join(''));
        tr.attr('name', '');
        tr.attr('ondblclick', 'kindEditView.fnChangeEdit(this);');
        this.g_arrayHtml = [];
        this.fnAddListAction(tr);
    },

    fnChangeEdit: function (item) {
        var tr = $(item);
        var data = {
            code_id: tr.find("td[name='code_id']").text(),
            name: tr.find("td[name='name']").text(),
            parameter: tr.find("td[name='parameter']").text(),
            status: tr.find("td[name='status']").text()
        };
        this.fnPushEditColumn(tr, data);

    },

    fnChildChangeEdit: function (item) {
        var tr = $(item).parents('tr');
        var data = {
            code_id: tr.find("td[name='code_id']").text(),
            name: tr.find("td[name='name']").text(),
            parameter: tr.find("td[name='parameter']").text(),
            status: tr.find("td[name='status']").text()
        };
        this.fnPushEditColumn(tr, data);

    },

    fnPushEditColumn: function (tr, data) {
        var selected = data.status == 'N' ? '' : 'selected';

        this.g_arrayHtml.push("      <td name='code_id'>" + data.code_id + "</td> ");
        this.g_arrayHtml.push("      <td> ");
        this.g_arrayHtml.push("          <input type='text' maxlength='15' placeholder='名稱' name='name' class='input-data' value='" + data.name + "'  />");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("      <td> ");
        this.g_arrayHtml.push("          <input type='text' maxlength='15' placeholder='參數' name='parameter' class='input-data' value='" + data.parameter + "' />");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("      <td class='action'> ");
        this.g_arrayHtml.push("          <div> ");
        this.g_arrayHtml.push("               <button type='button' class='btn-img-style4' onclick='kindEditView.fnTab2Update(this);'><img src='Image/save.png' /></button> ");
        this.g_arrayHtml.push("               <button type='button' class='btn-img-style2' onclick='kindEditView.fnCloseEdit(this, " + JSON.stringify(data) + ");'><img src='Image/cancel.png' /></button> ");
        this.g_arrayHtml.push("          </div> ");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("      <td> ");
        this.g_arrayHtml.push("          <select class='drop-style1' name='status'> ");
        this.g_arrayHtml.push("               <option value='N'>正常</option> ");
        this.g_arrayHtml.push("               <option value='D' " + selected + ">作廢</option> ");
        this.g_arrayHtml.push("          </select> ");
        this.g_arrayHtml.push("      </td> ");
        tr.html(this.g_arrayHtml.join(''));
        tr.attr('name', 'edit');
        tr.attr('ondblclick', '');
        this.g_arrayHtml = [];

    },

    fnCloseEdit: function (item, data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        var tr = $(item).parents('tr');
        this.fnChangeReadOnly(tr, jsonValue);
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

    fnAddListAction: function (item) {
        var that = this;
        var bClose = true;

        // List其他下拉
        $(item).find('.drop-other').focus(function () {
            $(this).parent().find('> ul').slideDown(200);
        });

        $(item).find('.drop-other').focusout(function () {
            if (bClose) {
                $(this).parent().find('> ul').slideUp(50);
            }
        });

        $(item).find('.action li').mouseover(function () {
            bClose = false;
        });

        $(item).find('.action li').mouseout(function () {
            bClose = true;
        });

        $(item).find('.action li').click(function () {
            $(this).parent().slideUp(50);
        });
    },

    /*---------------------------------------------------------Float-------------------------------*/

    fnInitializationFloat: function () {
        this.g_sFloatListID = '#list_tran';
        this.g_sFloatID = '#float_window';
        this.g_sFloatMsgID = '#tran_message';
    },

    fnPushFloatColumns: function (jsonValue) {
        this.g_arrayHtml.push("   <tr> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.ip + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.status + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.create_id + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.create_datetime + "</td> ");
        this.g_arrayHtml.push("   </tr> ");
    },

    fnPushFloatEmptyColumns: function () {
        this.g_arrayHtml.push(" <tr> <td colspan='5' >無資料顯示</td> </tr> ");
    },

    fnShowFloatColumns: function (code_id) {
        $(this.g_sFloatMsgID).html('代碼：' + code_id);
        $(this.g_sFloatListID).find(' > tbody').html(this.g_arrayHtml.join());
        fnOpenView(this.g_sFloatID);
        this.g_arrayHtml = [];
    }

};

