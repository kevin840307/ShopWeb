
function QuotesInsertView(quotesInsertPresenter) {
    this.g_quotesInsertPresenter = quotesInsertPresenter;

    this.g_sTabID = "#tab";
    this.g_sTitleTabSelectID = '#tab1';
    this.g_sProductListID = '#product_list'

    this.g_bFirstInit = true;
    this.g_bTab2FirstInit = true;
    this.g_arrayHtml = [];
}

QuotesInsertView.prototype = {
    TAG: 'QuotesInsertView',

    fnErrorMessage: function (msg) {
        fnErrorMessage(msg);
    },

    fnGeneralMessage: function (msg) {
        fnGeneralMessage(msg);
    },

    fnPushSelectList: function (jsonValue) {
        this.g_arrayHtml.push(" <option label='" + jsonValue.name + "' value='" + jsonValue.value + "' /> ");
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
                    this.g_quotesInsertPresenter.fnInitializationTab2();
                    this.g_bTab2FirstInit = false;
                }
                break;
        }
    },

    /*-------------------------tab1--------------------------------*/

    fnInitializationTab1: function () {
        this.g_sTab1OrderIdID = '#lab_order_id';
        this.g_sTab1IdID = '#text_id';
        this.g_sTab1ClientIdID = '#text_client_id';
        this.g_sTab1DateTimeID = '#text_datetime';
        this.g_sTab1DescriptionID = '#text_description';
        this.g_sIdListID = '#id_list'
        this.g_sClientIdListID = '#client_id_list'
        var date = new Date();

        $(this.g_sTab1DateTimeID).val(date.Formate("yyyy-MM-DD"));
    },

    fnShowAccountList: function () {
        $(this.g_sIdListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnShowClientList: function () {
        $(this.g_sClientIdListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnSetOrderId: function (sOrderId) {
        $(this.g_sTab1OrderIdID).text(sOrderId);
    },

    fnTab1Insert: function (event) {
        event.preventDefault();
        var insert = {
            method: "fnInsert",
            order_id: $(this.g_sOrderIdID).val(),
            id: $(this.g_sTab1IdID).val(),
            client_id: $(this.g_sTab1ClientIdID).val(),
            dateTime: $(this.g_sTab1DateTimeID).val(),
            description: $(this.g_sTab1DescriptionID).val()
        };

        this.g_quotesInsertPresenter.fnTab1Insert(insert);
    },

    /*-------------------------------tab2-------------------------*/

    fnInitializationTab2: function () {
        this.g_sTab2ListID = '#list';
    },

    fnShowProductList: function () {
        $(this.g_sProductListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnTab2AppendInsert: function () {
        this.g_arrayHtml.push("   <tr name='insert'> ");
        this.g_arrayHtml.push("      <td> ");
        this.g_arrayHtml.push("          <input type='text' maxlength='13' placeholder='材料' list='product_list' name='product_id' required='required' oninput='quotesInsertView.fnTab2SelectPrice(this);' class='input-data-required' />");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("      <td> ");
        this.g_arrayHtml.push("          <input type='text' maxlength='15' placeholder='數量' pattern='[0-9]{1,7}[.]{0,1}[0-9]{0,1}' name='amount' required='required' class='input-data-required' oninput='quotesInsertView.fnTab2SelectPrice(this);'  />");
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
        this.g_arrayHtml.push("               <button type='button' class='btn-img-style3' onclick='quotesInsertView.fnTab2Insert(this);'><img src='Image/tick.png' /></button> ");
        this.g_arrayHtml.push("               <button type='button' class='btn-img-style2' onclick='quotesInsertView.fnTab2RemoveInsert(this);'><img src='Image/cancel.png' /></button> ");
        this.g_arrayHtml.push("          </div> ");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("   </tr> ");
        $(this.g_sTab2ListID).find('tbody').append(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnChangeReadOnly: function (tr, jsonValue) {
        this.g_arrayHtml.push("      <td name='product_id'>" + jsonValue.product_id + "</td> ");
        this.g_arrayHtml.push("      <td name='amount'>" + jsonValue.amount + "</td> ");
        this.g_arrayHtml.push("      <td name='price'>" + jsonValue.price + "</td> ");
        this.g_arrayHtml.push("      <td name='modify_amount'>" + jsonValue.amount + "</td> ");
        this.g_arrayHtml.push("      <td name='modify_price'>" + jsonValue.price + "</td> ");
        this.g_arrayHtml.push("      <td name='description'>" + jsonValue.description + "</td> ");
        this.g_arrayHtml.push("      <td class='action'> ");
        this.g_arrayHtml.push("          無 ");
        this.g_arrayHtml.push("      </td> ");
        tr.html(this.g_arrayHtml.join(''));
        tr.attr('name', '');
        this.g_arrayHtml = [];
    },

    fnTab2ShowPrice: function (tr, value) {
        //parseFloat(value).toFixed(3)
        $(tr).find("input[name='price']").val(value);
    },

    fnTab2RemoveInsert: function (item) {
        var tr = $(item).parent().parent().parent();
        tr.html('');
        tr.attr('name', '');
    },

    fnTab2Insert: function (item) {
        var tr = $(item).parent().parent().parent();
        var insert = {
            method: "fnInsertD",
            order_id: this.g_quotesInsertPresenter.g_sOrderId,
            product_id: tr.find("input[name='product_id']").val(),
            amount: tr.find("input[name='amount']").val(),
            price: tr.find("input[name='price']").val(),
            description: tr.find("input[name='description']").val()
        };

        this.g_quotesInsertPresenter.fnTab2Insert(tr, insert);
    },

    fnTab2Inserts: function (event) {
        event.preventDefault();
        var inserts = {
            method: "fnInsertsD",
            order_id: this.g_quotesInsertPresenter.g_sOrderId,
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
        this.g_quotesInsertPresenter.fnTab2Inserts(inserts);
    },

    fnTab2SelectPrice: function (ID) {
        var tr = $(ID).parents('tr');
        var select = {
            method: "fnSelectPrice",
            product_id: tr.find("input[name='product_id']").val(),
            amount: tr.find("input[name='amount']").val()
        };

        this.g_quotesInsertPresenter.fnTab2SelectPrice(tr, select);
    }

};

