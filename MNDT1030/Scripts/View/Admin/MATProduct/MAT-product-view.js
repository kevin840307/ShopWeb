
function MATProductView(MATProductPresenter) {
    this.g_MATProductPresenter = MATProductPresenter;

    this.g_sTabID = "#tab";
    this.g_sTitleTabSelectID = '#tab1';

    this.g_arrayHtml = [];
}

MATProductView.prototype = {
    TAG: 'MATProductView',

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
                break;
        }
    },

    /*-------------------------tab1--------------------------------*/

    fnInitializationTab1: function () {
        this.g_sTab1ProductIdID = '#text_product_id';
        this.g_sTab1WarehouseIdID = '#text_warehouse_id';
        this.g_sTab1AmountID = '#text_amount';

        this.g_sProductListID = '#product_list';
        this.g_sWarehouseListID = '#warehouse_list';
    },

    fnShowProductList: function () {
        $(this.g_sProductListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnShowWarehouseList: function () {
        $(this.g_sWarehouseListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnTab1Select: function (event) {
        event.preventDefault();
        var data = {
            product_id: $(this.g_sTab1ProductIdID).val(),
            warehouse_id: $(this.g_sTab1WarehouseIdID).val(),
            amount: $(this.g_sTab1AmountID).val()
        };

        this.g_MATProductPresenter.fnTab1Next(data);
    },

    /*-------------------------------tab2-------------------------*/

    fnInitializationTab2: function () {
        this.g_sTab2ListID = '#list';
        this.g_sTab2ListNeed = '#list_need';
        this.g_sMaterialListID = '#material_list';

        this.g_mapNeedList = {};
    },

    fnShowMaterialList: function () {
        $(this.g_sMaterialListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnTab2PushColumns: function (jsonValue) {
        this.g_arrayHtml.push("   <tr name='change'> ");
        this.g_arrayHtml.push("      <td> ");
        this.g_arrayHtml.push("          <input type='text' maxlength='13' value='" + jsonValue.material_id + "' placeholder='材料' list='material_list' name='material_id' required='required' class='input-data-required' oninput='g_MATProductView.fnTab2Refresh();' />");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("      <td> ");
        this.g_arrayHtml.push("          <input type='text' maxlength='5' value='" + jsonValue.warehouse_id + "' placeholder='倉庫' list='warehouse_list' name='warehouse_id' required='required' class='input-data-required' />");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("      <td> ");
        this.g_arrayHtml.push("          <input type='text' maxlength='10'  value='" + jsonValue.amount + "' placeholder='數量' pattern='[0-9]{1,7}[.]{0,1}[0-9]{0,1}' name='amount' required='required' class='input-data-required' oninput='g_MATProductView.fnTab2Refresh();'  />");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("      <td class='action'> ");
        this.g_arrayHtml.push("          <div> ");
        this.g_arrayHtml.push("               <button type='button' class='btn-img-style2' onclick='g_MATProductView.fnTab2RemoveInsert(this);'><img src='Image/cancel.png' /></button> ");
        this.g_arrayHtml.push("          </div> ");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("   </tr> ");
    },

    fnTab2AppendInsert: function () {
        this.g_arrayHtml.push("   <tr name='change'> ");
        this.g_arrayHtml.push("      <td> ");
        this.g_arrayHtml.push("          <input type='text' maxlength='13' placeholder='材料' list='material_list' name='material_id' required='required' class='input-data-required' oninput='g_MATProductView.fnTab2Refresh();' />");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("      <td> ");
        this.g_arrayHtml.push("          <input type='text' maxlength='5' placeholder='倉庫' list='warehouse_list' name='warehouse_id' required='required' class='input-data-required' />");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("      <td> ");
        this.g_arrayHtml.push("          <input type='text' maxlength='10' placeholder='數量' pattern='[0-9]{1,7}[.]{0,1}[0-9]{0,1}' name='amount' required='required' class='input-data-required' oninput='g_MATProductView.fnTab2Refresh();'  />");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("      <td class='action'> ");
        this.g_arrayHtml.push("          <div> ");
        this.g_arrayHtml.push("               <button type='button' class='btn-img-style2' onclick='g_MATProductView.fnTab2RemoveInsert(this);'><img src='Image/cancel.png' /></button> ");
        this.g_arrayHtml.push("          </div> ");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("   </tr> ");
        $(this.g_sTab2ListID).find('tbody').append(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnTab2PushNeedColumns: function (jsonValue) {
        this.g_arrayHtml.push("   <tr name='need'> ");
        this.g_arrayHtml.push("      <td name='material_id' >" + jsonValue.material_id + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.name + "</td> ");
        this.g_arrayHtml.push("      <td name='need_amount' >" + jsonValue.amount + "</td> ");
        this.g_arrayHtml.push("      <td name='now_amount' >" + jsonValue.amount + "</td> ");
        this.g_arrayHtml.push("      <td name='less_amount' class='font-red' >0</td> ");
        this.g_arrayHtml.push("   </tr> ");

        this.g_mapNeedList[jsonValue.material_id.toString()] = 0;
    },


    fnTab2ShowList: function () {
        $(this.g_sTab2ListID).find('tbody').html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnTab2ShowNeedList: function () {
        $(this.g_sTab2ListNeed).find('tbody').html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnTab2RemoveInsert: function (item) {
        var tr = $(item).parent().parent().parent();
        tr.html('');
        tr.attr('name', '');
        this.fnTab2Refresh();
    },

    fnTab2Refresh: function () {
        var that = this;

        $(this.g_sTab2ListID).find(" > tbody > tr[name='change']").each(function () {
            var sMaterialId = $(this).find("input[name='material_id']").val();
            var sAmount = $(this).find("input[name='amount']").val();
            if (sAmount.length > 0) {
                that.g_mapNeedList[sMaterialId] += parseFloat(sAmount);
            }
        });

        $(this.g_sTab2ListNeed).find(" > tbody > tr[name='need']").each(function () {
            var sMaterialId = $(this).find("td[name='material_id']").text();
            var fAmount = $(this).find("td[name='need_amount']").text();
            var fNowAmount = that.g_mapNeedList[sMaterialId.toString()];
            var fLessAmount = fAmount - fNowAmount;

            $(this).find("td[name='now_amount']").text(fNowAmount);
            $(this).find("td[name='less_amount']").text(fLessAmount);
            that.g_mapNeedList[sMaterialId.toString()] = 0;
        });
    },

    fnTab2Change: function (event) {
        event.preventDefault();

        var change = {
            material_ids: [],
            amounts: [],
            warehouse_ids: []
        };

        $(this.g_sTab2ListID).find(" > tbody > tr[name='change']").each(function () {
            var sMaterialId = $(this).find("input[name='material_id']").val();
            var sAmount = $(this).find("input[name='amount']").val();
            var sWarehouseId = $(this).find("input[name='warehouse_id']").val();

            if (sMaterialId.length <= 0) {
                return;
            }

            change.material_ids.push(sMaterialId);
            change.amounts.push(sAmount);
            change.warehouse_ids.push(sWarehouseId);
        });

        var formData = new FormData();
        formData.append("method", "fnChange");
        formData.append("product_id", this.g_MATProductPresenter.g_sProductId.toString());
        formData.append("warehouse_id", this.g_MATProductPresenter.g_sWarehouseId.toString());
        formData.append("amount", this.g_MATProductPresenter.g_sAmount.toString());
        formData.append("material_ids", change.material_ids.toString());
        formData.append("amounts", change.amounts.toString());
        formData.append("warehouse_ids", change.warehouse_ids.toString());
        this.g_MATProductPresenter.fnTab2Change(formData);
    }

};

