

function ProductEditView(productEditPresenter) {
    this.g_productEditPresenter = productEditPresenter;
    this.g_sTabID = "#tab";
    this.g_sTitleTabSelectID = '#tab1';
    this.g_arrayHtml = [];
}

ProductEditView.prototype = {
    TAG: 'ProductEditView',

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
                //this.g_productEditPresenter.fnInitializationTab1();
                break;
            case 'tab2':
                if (this.g_bTab2FirstInit) {
                    this.g_productEditPresenter.fnInitializationTab2();
                    this.g_bTab2FirstInit = false;
                }
                break;
            case 'tab3':
                if (this.g_bTab3FirstInit) {
                    this.g_productEditPresenter.fnInitializationTab3();
                    this.g_bTab3FirstInit = false;
                }
                break;
        }
    },

    fnLast: function () {
        this.g_productEditPresenter.fnSelectProductId(-1);
    },

    fnNext: function () {
        this.g_productEditPresenter.fnSelectProductId(1);
    },

    //-------------------------------Tab1----------------------

    fnInitializationTab1: function () {
        this.g_sProductIdID = '#lab_product_id';
        this.g_sNameID = '#text_name';
        this.g_sCompanyIdID = '#text_company_id';
        this.g_sUnitID = '#text_unit';
        this.g_sCurrencyID = '#text_currency';
        this.g_sCostID = '#text_cost';
        this.g_sSuggestCostID = '#lab_suggest_cost';
        this.g_sPriceID = '#text_price';
        this.g_sShelfLifeID = '#text_shelf_life';
        this.g_sDescriptionID = '#text_description';
        this.g_sStatusID = '#select_status'

        this.g_sCompanyListID = '#company_list';
        this.g_sUnitListID = '#unit_list';
        this.g_sCurrencyListID = '#currency_list';
    },

    fnSetTab1View: function (jsonValue) {
        $(this.g_sProductIdID).text(jsonValue.product_id);
        $(this.g_sNameID).val(jsonValue.name);
        $(this.g_sCompanyIdID).val(jsonValue.company_id);
        $(this.g_sUnitID).val(jsonValue.unit);
        $(this.g_sCurrencyID).val(jsonValue.currency);
        $(this.g_sCostID).val(jsonValue.cost);
        $(this.g_sSuggestCostID).text('材料成本：' + jsonValue.suggest_cost);
        $(this.g_sPriceID).val(jsonValue.price);
        $(this.g_sShelfLifeID).val(jsonValue.shelf_life);
        $(this.g_sDescriptionID).val(jsonValue.description);
        $(this.g_sStatusID + ' option[value=' + jsonValue.status + ']').attr('selected', 'selected');
    },

    fnPushSelectList: function (jsonValue) {
        this.g_arrayHtml.push(" <option label='" + jsonValue.name + "' value='" + jsonValue.value + "' /> ");
    },

    fnShowCompanyList: function () {
        $(this.g_sCompanyListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnShowUnitList: function () {
        $(this.g_sUnitListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnShowCurrencyList: function () {
        $(this.g_sCurrencyListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnTab1Update: function (event) {
        event.preventDefault();
        var update = {
            method: "fnUpdate",
            product_id: $(this.g_sProductIdID).text(),
            name: $(this.g_sNameID).val(),
            company_id: $(this.g_sCompanyIdID).val(),
            unit: $(this.g_sUnitID).val(),
            currency: $(this.g_sCurrencyID).val(),
            cost: $(this.g_sCostID).val(),
            price: $(this.g_sPriceID).val(),
            shelf_life: $(this.g_sShelfLifeID).val(),
            description: $(this.g_sDescriptionID).val(),
            status: $(this.g_sStatusID).find('option:selected').val()
        };

        this.g_productEditPresenter.fnTab1Update(update);
    },


    //-------------------------------Tab2---------------------------------

    fnInitializationTab2: function () {
        this.g_sTab2ListID = '#list';
        this.g_sTab2PageID = '#list_page';
        this.g_sTab2IdID = '#tab2_id';

    },

    fnTab2ChangeUrl: function (arg) {
        fnLoading();
        var that = this;
        window.history.pushState('', 'uselessTitle', arg);
        setTimeout(function () {
            that.g_productEditPresenter.fnInitializationTab2();
        }, 300);
    },


    fnPushTab2Columns: function (jsonValue) {
        this.g_arrayHtml.push("   <tr> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.product_id + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.ip + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.status + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.create_datetime + "</td> ");
        this.g_arrayHtml.push("   </tr> ");
    },

    fnPushTab2PageNumber: function (name, page, select) {
        this.g_arrayHtml.push("  <li><a class='" + select + "' onclick='productEditView.fnPageNumberChange(\"" + page + "\")' >" + name + "</a></li> ");
    },

    fnShowTab2List: function () {
        $(this.g_sTab2ListID).find('tbody').html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnShowTab2EmptyColumns: function () {
        $(this.g_sTab2ListID).find('tbody').html(" <tr> <td colspan='4' >無資料顯示</td> </tr> ");
    },

    fnShowTab2PageNumber: function () {
        $(this.g_sTab2PageID).find('ul').html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },


    fnMaxPageSizeChange: function (item) {
        this.g_productEditPresenter.fnMaxPageSizeChange(item.value);
    },

    fnPageNumberChange: function (value) {
        this.g_productEditPresenter.fnPageNumberChange(value);
    },

    /*--------------------------------------Tab3--------------------------------*/

    fnInitializationTab3: function () {
        this.g_sTab3SelectMenuItemID = '#tab_add';
        this.g_sTab3MaterialMenuID = '#material_menu';
        this.g_sTab3MaterialListID = '#material_list';
        this.g_sTab3MaterialContentID = '#material_content';
        this.g_arrayHtml2 = [];
    },

    fnPushSelectMaterial: function (jsonValue) {
        this.g_arrayHtml.push(" <option label='" + jsonValue.name + "' value='" + jsonValue.value + "' /> ");
    },

    fnShowMaterialList: function () {
        $(this.g_sTab3MaterialListID).html(this.g_arrayHtml.join(''));
        this.g_arrayHtml = [];
    },

    fnTab3PushItem: function (jsonValue) {
        this.g_arrayHtml.push(" <li class='tab-item' id='tab_" + jsonValue.material_id + "' onclick='productEditView.fnTab3ItemChange(this);'> ");
        this.g_arrayHtml.push("     <i class='mark'></i>" + jsonValue.material_id + "</li> ");
    },

    fnTab3ShowItem: function () {
        var sHtml = " <li class='tab-item select' id='tab_add' onclick='productEditView.fnTab3ItemChange(this);'> ";
        sHtml += " <i class='mark'></i>新增</li> " + this.g_arrayHtml.join('');
        $(this.g_sTab3MaterialMenuID).html(sHtml);
        this.g_arrayHtml = [];

    },

    fnTab3PushContent: function (jsonValue) {
        var id = "tab_" + jsonValue.material_id + "_content";
        this.g_arrayHtml2.push("<form class='content-style1 tab-content hide' id='" + id + "' onsubmit='productEditView.fnTab3Update(this, event)' >");
        this.g_arrayHtml2.push("    <div class='general'>");
        this.g_arrayHtml2.push("        <div class='col-2-left-r'>");
        this.g_arrayHtml2.push("            <label class='font-red'>*材料 ID</label>");
        this.g_arrayHtml2.push("        </div>");
        this.g_arrayHtml2.push("        <div class='col-10-right'>");
        this.g_arrayHtml2.push("            <label name='material_id'>" + jsonValue.material_id + "</label>");
        this.g_arrayHtml2.push("        </div>");
        this.g_arrayHtml2.push("    </div>");
        this.g_arrayHtml2.push("    <div class='general'>");
        this.g_arrayHtml2.push("        <div class='col-2-left-r'>");
        this.g_arrayHtml2.push("            <label class='font-red'>*數量</label>");
        this.g_arrayHtml2.push("        </div>");
        this.g_arrayHtml2.push("        <div class='col-10-right'>");
        this.g_arrayHtml2.push("            <input type='text' name='amount' value='" + jsonValue.amount + "' oninput='productEditView.fnTab3SelectEditPrice(\"#" + id + "\", \"" + jsonValue.material_id + "\");' pattern='[0-9]{1,4}[.]{0,1}[0-9]{0,1}' maxlength='5' placeholder='數量' required='required' list='material_list' class='input-data-required' value='' />");
        this.g_arrayHtml2.push("        </div>");
        this.g_arrayHtml2.push("    </div>");
        this.g_arrayHtml2.push("    <div class='general'>");
        this.g_arrayHtml2.push("        <div class='col-2-left-r'>");
        this.g_arrayHtml2.push("            <label class='font-red'>價格</label>");
        this.g_arrayHtml2.push("        </div>");
        this.g_arrayHtml2.push("        <div class='col-10-right'>");
        this.g_arrayHtml2.push("            <label name='price' >" + jsonValue.price + "</label>");
        this.g_arrayHtml2.push("        </div>");
        this.g_arrayHtml2.push("    </div>");
        this.g_arrayHtml2.push("    <div class='general-right'>");
        this.g_arrayHtml2.push("        <input type='submit' class='col-2 button-style1' />");
        this.g_arrayHtml2.push("        <input type='button' class='col-2 button-style2' value='刪除' onclick='productEditView.fnTab3Detele(\"" + jsonValue.material_id + "\")' />");
        this.g_arrayHtml2.push("    </div>");
        this.g_arrayHtml2.push("</form>");
    },

    fnTab3ShowContent: function () {
        var arrayHtml = [];
        arrayHtml.push("<div class='title'>材料明細</div>");
        arrayHtml.push("<form class='content-style1 tab-content' id='tab_add_content' onsubmit='productEditView.fnTab3Insert(this, event);' >");
        arrayHtml.push("    <div class='general'>");
        arrayHtml.push("        <div class='col-2-left-r'>");
        arrayHtml.push("            <label class='font-red'>*材料 ID</label>");
        arrayHtml.push("        </div>");
        arrayHtml.push("        <div class='col-10-right'>");
        arrayHtml.push("            <input type='text' name='material_id' maxlength='15' placeholder='ID' oninput='productEditView.fnTab3SelectInsertPrice(\"#tab_add_content\");' required='required' list='material_list' class='input-data-required' value='' />");
        arrayHtml.push("        </div>");
        arrayHtml.push("    </div>");
        arrayHtml.push("    <div class='general'>");
        arrayHtml.push("        <div class='col-2-left-r'>");
        arrayHtml.push("            <label class='font-red'>*數量</label>");
        arrayHtml.push("        </div>");
        arrayHtml.push("        <div class='col-10-right'>");
        arrayHtml.push("            <input type='text' name='amount' pattern='[0-9]{1,4}[.]{0,1}[0-9]{0,1}' oninput='productEditView.fnTab3SelectInsertPrice(\"#tab_add_content\");' maxlength='5' placeholder='數量' required='required' list='material_list' class='input-data-required' value='' />");
        arrayHtml.push("        </div>");
        arrayHtml.push("    </div>");
        arrayHtml.push("    <div class='general'>");
        arrayHtml.push("        <div class='col-2-left-r'>");
        arrayHtml.push("            <label >價格</label>");
        arrayHtml.push("        </div>");
        arrayHtml.push("        <div class='col-10-right'>");
        arrayHtml.push("            <label name='price' ></label>");
        arrayHtml.push("        </div>");
        arrayHtml.push("    </div>");
        arrayHtml.push("    <div class='general-right'>");
        arrayHtml.push("        <input type='submit' class='col-2 button-style1' />");
        arrayHtml.push("    </div>");
        arrayHtml.push("</form>");
        var sHtml = arrayHtml.join('') + this.g_arrayHtml2.join('');
        $(this.g_sTab3MaterialContentID).html(sHtml);
        this.arrayHtml = [];
        this.g_arrayHtml2 = [];
    },


    fnTab3Detele: function (material_id) {
        if (confirm("確定要刪除嗎!")) {
            this.g_productEditPresenter.fnTab3Delete(material_id);
        }
    },

    fnTab3Insert: function (item, event) {
        event.preventDefault();
        var insert = {
            method: "fnInsertD",
            product_id: this.g_productEditPresenter.g_sProductId,
            material_id: $(item).find("input[name='material_id']").val(),
            amount: $(item).find("input[name='amount']").val()
        };

        this.g_productEditPresenter.fnTab3Insert(insert);
    },

    fnTab3Update: function (item, event) {
        event.preventDefault();
        var update = {
            method: "fnUpdateD",
            product_id: this.g_productEditPresenter.g_sProductId,
            material_id: $(item).find("label[name='material_id']").text(),
            amount: $(item).find("input[name='amount']").val()
        };
        this.g_productEditPresenter.fnTab3Update(update);
    },

    fnTab3ItemChange: function (item) {
        $(this.g_sTab3SelectMenuItemID).removeClass('select');
        $(item).addClass('select');

        $(this.g_sTab3SelectMenuItemID + '_content').addClass('hide');
        $('#' + item.id + '_content').removeClass('hide');

        this.g_sTab3SelectMenuItemID = '#' + item.id;
    },

    fnTab3SelectInsertPrice: function (ID) {
        var select = {
            method: "fnSelectPrice",
            material_id: $(ID).find("input[name='material_id']").val(),
            amount: $(ID).find("input[name='amount']").val()
        };

        this.g_productEditPresenter.fnTab3SelectPrice(ID, select);
    },

    fnTab3SelectEditPrice: function (ID, sMaterialId) {
        var select = {
            method: "fnSelectPrice",
            material_id: sMaterialId.toString(),
            amount: $(ID).find("input[name='amount']").val()
        };

        this.g_productEditPresenter.fnTab3SelectPrice(ID, select);
    },

    fnTab3ShowPrice: function (ID, value) {
        //parseFloat(value).toFixed(3)
        $(ID).find("label[name='price']").text(value);
    }
};

