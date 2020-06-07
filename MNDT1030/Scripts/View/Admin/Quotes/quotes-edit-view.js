

function QuotesEditView(quotesEditPresenter) {
    this.g_quotesEditPresenter = quotesEditPresenter;
    this.g_sTabID = "#tab";
    this.g_sTitleTabSelectID = '#tab1';
    this.g_arrayHtml = [];
}

QuotesEditView.prototype = {
    TAG: 'QuotesEditView',

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
                //this.g_quotesEditPresenter.fnInitializationTab1();
                break;
            case 'tab2':
                if (this.g_bTab2FirstInit) {
                    this.g_quotesEditPresenter.fnInitializationTab2();
                    this.g_bTab2FirstInit = false;
                }
                break;
            case 'tab3':
                if (this.g_bTab3FirstInit) {
                    this.g_quotesEditPresenter.fnInitializationTab3();
                    this.g_bTab3FirstInit = false;
                }
                break;
        }
    },

    fnLast: function () {
        this.g_quotesEditPresenter.fnSelectOrderId(-1);
    },

    fnNext: function () {
        this.g_quotesEditPresenter.fnSelectOrderId(1);
    },

    fnChange: function () {
        this.g_quotesEditPresenter.fnChange();
    },

    fnPushSelectList: function (jsonValue) {
        this.g_arrayHtml.push(" <option label='" + jsonValue.name + "' value='" + jsonValue.value + "' /> ");
    },

    //-------------------------------Tab1----------------------

    fnInitializationTab1: function () {
        this.g_sTab1OrderIdID = '#lab_order_id';
        this.g_sTab1IdID = '#text_id';
        this.g_sTab1ClientIdID = '#text_client_id';
        this.g_sTab1DatetimeID = '#text_datetime';
        this.g_sTab1DescriptionID = '#text_description';
        this.g_sTab1CompleteID = '#select_complete';
        this.g_sTab1StatusID = '#select_status';

        this.g_sIdListID = '#id_list';
        this.g_sClientIdListID = '#client_id_list';
        client_id_list
    },

    fnShowAccountList: function () {
        $(this.g_sIdListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnShowClientList: function () {
        $(this.g_sClientIdListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnSetTab1View: function (jsonValue) {
        $(this.g_sTab1OrderIdID).text(jsonValue.order_id);
        $(this.g_sTab1IdID).val(jsonValue.id);
        $(this.g_sTab1ClientIdID).val(jsonValue.client_id);
        $(this.g_sTab1DatetimeID).val(jsonValue.datetime);
        $(this.g_sTab1DescriptionID).val(jsonValue.description);
        $(this.g_sTab1CompleteID + ' option[value=' + jsonValue.complete + ']').attr('selected', 'selected');
        $(this.g_sTab1StatusID + ' option[value=' + jsonValue.status + ']').attr('selected', 'selected');

        if (this.g_quotesEditPresenter.g_bComplete) {
            $(this.g_sTab1IdID).prop("readonly", "readonly");
            $(this.g_sTab1ClientIdID).prop("readonly", "readonly");
            $(this.g_sTab1DatetimeID).prop("readonly", "readonly");
            $(this.g_sTab1DescriptionID).prop("readonly", "readonly");
            $(this.g_sTab1CompleteID).prop("disabled", "disabled");

            $(this.g_sTab1IdID).addClass('readonly');
            $(this.g_sTab1ClientIdID).addClass('readonly');
            $(this.g_sTab1DatetimeID).addClass('readonly');
            $(this.g_sTab1DescriptionID).addClass('readonly');
        }

    },

    fnTab1Update: function (event) {
        event.preventDefault();

        var update = {
            method: "fnUpdate",
            order_id: $(this.g_sTab1OrderIdID).text(),
            id: $(this.g_sTab1IdID).val(),
            client_id: $(this.g_sTab1ClientIdID).val(),
            datetime: $(this.g_sTab1DatetimeID).val(),
            description: $(this.g_sTab1DescriptionID).val(),
            complete: $(this.g_sTab1CompleteID).find('option:selected').val(),
            status: $(this.g_sTab1StatusID).find('option:selected').val()
        };

        this.g_quotesEditPresenter.fnTab1Update(update);
    },

    fnTab1Event: function (type) {

    },

    //-------------------------------Tab2---------------------------------

    fnInitializationTab2: function () {
        this.g_sTab2ListID = '#list';
        this.g_sTab2PageID = '#list_page';
        this.g_sTab2IdID = '#tab2_id';

        this.g_sProductListID = '#product_list'
        this.g_sTab2FloatWindowID = '#float_window';
    },

    fnTab2ChangeUrl: function (arg) {
        fnLoading();
        var that = this;
        window.history.pushState('', 'uselessTitle', arg);
        setTimeout(function () {
            that.g_quotesEditPresenter.fnInitializationTab2();
        }, 300);
    },

    fnShowProductList: function () {
        $(this.g_sProductListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnPushTab2Columns: function (jsonValue) {
        this.g_arrayHtml.push("   <tr ondblclick='quotesEditView.fnChangeEdit(this);'> ");
        this.g_arrayHtml.push("      <td name='product_id'>" + jsonValue.product_id + "</td> ");
        this.g_arrayHtml.push("      <td name='amount'>" + jsonValue.amount + "</td> ");
        this.g_arrayHtml.push("      <td name='price'>" + jsonValue.price + "</td> ");
        this.g_arrayHtml.push("      <td name='modify_amount'>" + jsonValue.modify_amount + "</td> ");
        this.g_arrayHtml.push("      <td name='modify_price'>" + jsonValue.modify_price + "</td> ");
        this.g_arrayHtml.push("      <td name='description'>" + jsonValue.description + "</td> ");
        this.g_arrayHtml.push("      <td class='action'> ");
        this.g_arrayHtml.push("          <div> ");
        this.g_arrayHtml.push("              <button type='button' class='btn-img-style1'><img src='Image/edit.png' onclick='quotesEditView.fnChildChangeEdit(this);' /></button> ");
        this.g_arrayHtml.push("              <button type='button' class='btn-img-style2'><img src='Image/delete.png' onclick='quotesEditView.fnTab2Detele(\"" + jsonValue.product_id + "\");' /></button> ");
        this.g_arrayHtml.push("          </div> ");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("   </tr> ");
    },

    fnPushTab2EmptyColumns: function () {
        //this.g_arrayHtml.push(" <tr> <td colspan='5' >無資料顯示</td> </tr> ");
    },

    fnPushTab2PageNumber: function (name, page, select) {
        this.g_arrayHtml.push("  <li><a class='" + select + "' onclick='quotesEditView.fnTab2PageNumberChange(\"" + page + "\")' >" + name + "</a></li> ");
    },

    fnShowTab2List: function () {
        $(this.g_sTab2ListID).find('tbody').html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnShowTab2PageNumber: function () {
        $(this.g_sTab2PageID).find('ul').html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnTab2MaxPageSizeChange: function (item) {
        this.g_quotesEditPresenter.fnTab2MaxPageSizeChange(item.value);
    },

    fnTab2PageNumberChange: function (value) {
        this.g_quotesEditPresenter.fnTab2PageNumberChange(value);
    },

    fnTab2AppendInsert: function () {
        if (!this.g_quotesEditPresenter.g_bComplete) {
            this.g_arrayHtml.push("   <tr name='insert'> ");
            this.g_arrayHtml.push("      <td> ");
            this.g_arrayHtml.push("          <input type='text' maxlength='13' placeholder='產品' list='product_list' name='product_id' required='required' oninput='quotesEditView.fnTab2SelectInsertPrice(this);' class='input-data-required' />");
            this.g_arrayHtml.push("      </td> ");
            this.g_arrayHtml.push("      <td> ");
            this.g_arrayHtml.push("          <input type='text' maxlength='10' placeholder='數量' pattern='[0-9]{1,7}[.]{0,1}[0-9]{0,3}' name='amount' required='required' class='input-data-required' oninput='quotesEditView.fnTab2SelectInsertPrice(this);'  />");
            this.g_arrayHtml.push("      </td> ");
            this.g_arrayHtml.push("      <td> ");
            this.g_arrayHtml.push("          <input type='text' placeholder='價錢' name='price' pattern='[0-9]{1,7}[.]{0,1}[0-9]{0,3}' required='required' class='input-data-required' />");
            this.g_arrayHtml.push("      </td> ");
            this.g_arrayHtml.push("      <td> ");
            this.g_arrayHtml.push("          <label>同數量</label>");
            this.g_arrayHtml.push("      </td> ");
            this.g_arrayHtml.push("      <td> ");
            this.g_arrayHtml.push("          <label>同價錢</label>");
            this.g_arrayHtml.push("      </td> ");
            this.g_arrayHtml.push("      <td> ");
            this.g_arrayHtml.push("          <input type='text' maxlength='50' placeholder='描述' name='description' class='input-data' />");
            this.g_arrayHtml.push("      </td> ");
            this.g_arrayHtml.push("      <td class='action'> ");
            this.g_arrayHtml.push("          <div> ");
            this.g_arrayHtml.push("               <button type='button' class='btn-img-style3' onclick='quotesEditView.fnTab2Insert(this);'><img src='Image/tick.png' /></button> ");
            this.g_arrayHtml.push("               <button type='button' class='btn-img-style2' onclick='quotesEditView.fnTab2RemoveInsert(this);'><img src='Image/cancel.png' /></button> ");
            this.g_arrayHtml.push("          </div> ");
            this.g_arrayHtml.push("      </td> ");
            this.g_arrayHtml.push("   </tr> ");
            $(this.g_sTab2ListID).find('tbody').append(this.g_arrayHtml.join(''));
            this.g_arrayHtml = [];
        } else {
            this.fnErrorMessage("目前已審核，無法新增。")
        }
    },

    fnPushEditColumn: function (tr, data) {

        this.g_arrayHtml.push("      <td name='product_id'>" + data.product_id + "</td> ");
        this.g_arrayHtml.push("      <td name='amount'>" + data.amount + "</td> ");
        this.g_arrayHtml.push("      <td name='price'>" + data.price + "</td> ");
        this.g_arrayHtml.push("      <td> ");
        this.g_arrayHtml.push("          <input type='text' maxlength='10' placeholder='修訂數量' pattern='[0-9]{1,7}[.]{0,1}[0-9]{0,3}' name='modify_amount' class='input-data-required' required='required' oninput='quotesEditView.fnTab2SelectEditPrice(this);' value='" + data.modify_amount + "'  />");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("      <td> ");
        this.g_arrayHtml.push("          <input type='text' maxlength='10' placeholder='修訂金額' pattern='[0-9]{1,7}[.]{0,1}[0-9]{0,3}' name='modify_price' class='input-data-required' required='required' value='" + data.modify_price + "' />");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("      <td> ");
        this.g_arrayHtml.push("          <input type='text' maxlength='50' placeholder='描述' name='description' class='input-data' value='" + data.description + "' />");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("      <td class='action'> ");
        this.g_arrayHtml.push("          <div> ");
        this.g_arrayHtml.push("               <button type='button' class='btn-img-style4' onclick='quotesEditView.fnTab2Update(this);'><img src='Image/save.png' /></button> ");
        this.g_arrayHtml.push("               <button type='button' class='btn-img-style2' onclick='quotesEditView.fnCloseEdit(this, " + JSON.stringify(data) + ");'><img src='Image/cancel.png' /></button> ");
        this.g_arrayHtml.push("          </div> ");
        this.g_arrayHtml.push("      </td> ");
        tr.html(this.g_arrayHtml.join(''));
        tr.attr('name', 'edit');
        tr.attr('ondblclick', '');
        this.g_arrayHtml = [];

    },

    fnTab2ShowInsertPrice: function (tr, value) {
        $(tr).find("input[name='price']").val(value);
    },

    fnTab2ShowEditPrice: function (tr, value) {
        $(tr).find("input[name='modify_price']").val(value);
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
            order_id: this.g_quotesEditPresenter.g_sOrderId,
            product_id: tr.find("input[name='product_id']").val(),
            amount: tr.find("input[name='amount']").val(),
            price: tr.find("input[name='price']").val(),
            modify_amount: tr.find("input[name='amount']").val(),
            modify_price: tr.find("input[name='price']").val(),
            description: tr.find("input[name='description']").val()
        };

        this.g_quotesEditPresenter.fnTab2Insert(tr, insert);
    },

    fnTab2Inserts: function () {
        var inserts = {
            method: "fnInsertsD",
            order_id: this.g_quotesEditPresenter.g_sOrderId,
            product_id: [],
            amount: [],
            price: [],
            description: []
        };
        $(this.g_sTab2ListID).find(" > tbody > tr[name='insert']").each(function () {
            var sProductId = $(this).find("input[name='product_id']").val();
            if (sProductId.length > 0) {
                inserts.product_id.push(sProductId);
                inserts.amount.push($(this).find("input[name='amount']").val());
                inserts.price.push($(this).find("input[name='price']").val());
                inserts.description.push($(this).find("input[name='description']").val());
            }
        });
        inserts.product_id = inserts.product_id.toString();
        inserts.amount = inserts.amount.toString();
        inserts.price = inserts.price.toString();
        inserts.description = inserts.description.toString();
        this.g_quotesEditPresenter.fnTab2Inserts(inserts);
    },

    fnTab2Update: function (item) {
        var tr = $(item).parent().parent().parent();
        var update = {
            method: "fnUpdateD",
            order_id: this.g_quotesEditPresenter.g_sOrderId,
            product_id: tr.find("td[name='product_id']").text(),
            amount: tr.find("td[name='amount']").text(),
            price: tr.find("td[name='price']").text(),
            modify_amount: tr.find("input[name='modify_amount']").val(),
            modify_price: tr.find("input[name='modify_price']").val(),
            description: tr.find("input[name='description']").val()
        };

        this.g_quotesEditPresenter.fnTab2Update(tr, update);
    },

    fnTab2Updates: function () {
        var updates = {
            method: "fnUpdatesD",
            order_id: this.g_quotesEditPresenter.g_sOrderId,
            product_id: [],
            modify_amount: [],
            modify_price: [],
            description: []
        };

        $(this.g_sTab2ListID).find(" > tbody > tr[name='edit']").each(function () {
            var sProductId = $(this).find("td[name='product_id']").text();
            if (sProductId.length > 0) {
                updates.product_id.push(sProductId);
                updates.modify_amount.push($(this).find("input[name='modify_amount']").val());
                updates.modify_price.push($(this).find("input[name='modify_price']").val());
                updates.description.push($(this).find("input[name='description']").val());
            }
        });

        updates.product_id = updates.product_id.toString();
        updates.modify_amount = updates.modify_amount.toString();
        updates.modify_price = updates.modify_price.toString();
        updates.description = updates.description.toString();
        this.g_quotesEditPresenter.fnTab2Updates(updates);
    },

    fnTab2Detele: function (product_id) {
        if (!this.g_quotesEditPresenter.g_bComplete) {
            if (confirm("確定要刪除嗎!")) {
                this.g_quotesEditPresenter.fnTab2Delete(product_id);
            }
        } else {
            this.fnErrorMessage("目前已審核，無法刪除。")
        }
    },

    fnTab2SelectInsertPrice: function (ID) {
        var tr = $(ID).parents('tr');
        var select = {
            method: "fnSelectPrice",
            product_id: tr.find("input[name='product_id']").val(),
            amount: tr.find("input[name='amount']").val()
        };

        this.g_quotesEditPresenter.fnTab2SelectPrice(tr, select, 'I');
    },

    fnTab2SelectEditPrice: function (ID) {
        var tr = $(ID).parents('tr');
        var select = {
            method: "fnSelectPrice",
            product_id: tr.find("td[name='product_id']").text(),
            amount: tr.find("input[name='modify_amount']").val()
        };

        this.g_quotesEditPresenter.fnTab2SelectPrice(tr, select, 'E');
    },

    fnChangeReadOnly: function (tr, jsonValue) {
        this.g_arrayHtml.push("      <td name='product_id'>" + jsonValue.product_id + "</td> ");
        this.g_arrayHtml.push("      <td name='amount'>" + jsonValue.amount + "</td> ");
        this.g_arrayHtml.push("      <td name='price'>" + jsonValue.price + "</td> ");
        this.g_arrayHtml.push("      <td name='modify_amount'>" + jsonValue.modify_amount + "</td> ");
        this.g_arrayHtml.push("      <td name='modify_price'>" + jsonValue.modify_price + "</td> ");
        this.g_arrayHtml.push("      <td name='description'>" + jsonValue.description + "</td> ");
        this.g_arrayHtml.push("      <td class='action'> ");
        this.g_arrayHtml.push("          <div> ");
        this.g_arrayHtml.push("              <button type='button' class='btn-img-style1'><img src='Image/edit.png' onclick='quotesEditView.fnChildChangeEdit(this);' /></button> ");
        this.g_arrayHtml.push("              <button type='button' class='btn-img-style2'><img src='Image/delete.png' onclick='quotesEditView.fnTab2Detele(\"" + jsonValue.product_id + "\");' /></button> ");
        this.g_arrayHtml.push("          </div> ");
        this.g_arrayHtml.push("      </td> ");
        tr.html(this.g_arrayHtml.join(''));
        tr.attr('name', '');
        tr.attr('ondblclick', 'quotesEditView.fnChangeEdit(this);');
        this.g_arrayHtml = [];
    },

    fnChangeEdit: function (item) {
        if (!this.g_quotesEditPresenter.g_bComplete) {
            var tr = $(item);
            var data = {
                product_id: tr.find("td[name='product_id']").text(),
                amount: tr.find("td[name='amount']").text(),
                price: tr.find("td[name='price']").text(),
                modify_amount: tr.find("td[name='modify_amount']").text(),
                modify_price: tr.find("td[name='modify_price']").text(),
                description: tr.find("td[name='description']").text()
            };
            this.fnPushEditColumn(tr, data);
        } else {
            this.fnErrorMessage("目前已審核，無法變更。")
        }
    },

    fnChildChangeEdit: function (item) {
        if (!this.g_quotesEditPresenter.g_bComplete) {
            var tr = $(item).parents('tr');
            var data = {
                product_id: tr.find("td[name='product_id']").text(),
                amount: tr.find("td[name='amount']").text(),
                price: tr.find("td[name='price']").text(),
                modify_amount: tr.find("td[name='modify_amount']").text(),
                modify_price: tr.find("td[name='modify_price']").text(),
                description: tr.find("td[name='description']").text()
            };
            this.fnPushEditColumn(tr, data);
        } else {
            this.fnErrorMessage("目前已審核，無法變更。")
        }
    },

    fnCloseEdit: function (item, data) {
        var jsonValue = $.parseJSON(JSON.stringify(data));
        var tr = $(item).parents('tr');
        this.fnChangeReadOnly(tr, jsonValue);
    },

    /*---------------------------------------------------------Tab3-------------------------------*/

    fnInitializationTab3: function () {
        this.g_sTab3ListID = '#list_tran';
        this.g_sTab3PageID = '#list_tran_page';
    },

    fnTab3ChangeUrl: function (arg) {
        fnLoading();
        var that = this;
        window.history.pushState('', 'uselessTitle', arg);
        setTimeout(function () {
            that.g_quotesEditPresenter.fnInitializationTab3();
        }, 300);
    },

    fnPushTranColumns: function (jsonValue) {
        this.g_arrayHtml.push("   <tr> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.create_id + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.status + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.ip + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.create_datetime + "</td> ");
        this.g_arrayHtml.push("   </tr> ");
    },

    fnPushTranPageNumber: function (name, page, select) {
        this.g_arrayHtml.push("  <li><a class='" + select + "' onclick='quotesEditView.fnTab3PageNumberChange(\"" + page + "\")' >" + name + "</a></li> ");
    },

    fnShowTranList: function () {
        $(this.g_sTab3ListID).find('tbody').html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnShowTranEmptyColumns: function () {
        $(this.g_sTab3ListID).find('tbody').html(" <tr> <td colspan='4' >無資料顯示</td> </tr> ");
    },

    fnShowTranPageNumber: function (name, page, select) {
        $(this.g_sTab3PageID).find('ul').html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnTab3MaxPageSizeChange: function (item) {
        this.g_quotesEditPresenter.fnTab3MaxPageSizeChange(item.value);
    },

    fnTab3PageNumberChange: function (value) {
        this.g_quotesEditPresenter.fnTab3PageNumberChange(value);
    },

};

