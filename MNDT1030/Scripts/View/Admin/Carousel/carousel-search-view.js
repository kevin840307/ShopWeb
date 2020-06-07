

function CarouselSearchView(carouselSearchPresenter) {
    this.g_carouselSearchPresenter = carouselSearchPresenter;
    this.g_sHindFileID = '#file';
    this.g_sFileID = '#btn_file';
    this.g_sListID = '#list';
    this.g_sPageID = '#list_page';
    this.g_sFilterIdCarouselID = '#filter_carousel_id';
    this.g_sFilterStatusID = '#filter_status';
    this.g_arrayHtml = [];
}

CarouselSearchView.prototype = {

    TAG: 'CarouselSearchView',

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
            that.g_carouselSearchPresenter.fnInitList();
        }, 300);
    },

    fnGoUrl: function (arg) {
        window.location = 'MNDT1010.aspx' + arg;
    },

    fnShowFilterView: function (filter) {
        $(this.g_sFilterIdCarouselID).val(filter.carousel_id.toString());
        $(this.g_sFilterStatusID + ' option[value=' + filter.status.toString() + ']').attr('selected', 'selected');
    },


    fnPushColumns: function (jsonValue) {
        this.g_arrayHtml.push("   <tr> ");
        this.g_arrayHtml.push("      <td><input type='checkbox' class='checkbox-style1' name='checkbox_delete' /> </td> ");
        this.g_arrayHtml.push("      <td class='key'>" + jsonValue.carousel_id + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.name + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.status + "</td> ");
        this.g_arrayHtml.push("      <td>" + jsonValue.create_datetime + "</td> ");
        this.g_arrayHtml.push("      <td class='action'> ");
        this.g_arrayHtml.push("          <div> ");
        this.g_arrayHtml.push("               <button type='button' class='btn-img-style1' onclick='carouselSearchView.fnOpenEdit(\"" + jsonValue.carousel_id + "\", \"" + jsonValue.NUM + "\")' ><img src='Image/edit.png' /></button> ");
        this.g_arrayHtml.push("          </div> ");
        this.g_arrayHtml.push("      </td> ");
        this.g_arrayHtml.push("   </tr> ");
    },

    fnPushPageNumber: function (name, page, select) {
        this.g_arrayHtml.push("  <li><a class='" + select + "' onclick='carouselSearchView.fnPageNumberChange(\"" + page + "\")' >" + name + "</a></li> ");
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

    fnMaxPageSizeChange: function (item) {
        this.g_carouselSearchPresenter.fnMaxPageSizeChange(item.value);
    },

    fnOrderChange: function (value) {
        this.g_carouselSearchPresenter.fnOrderChange(value);
    },

    fnPageNumberChange: function (value) {
        this.g_carouselSearchPresenter.fnPageNumberChange(value);
    },

    fnFilterChange: function () {
        var filter = {
            carousel_id: $(this.g_sFilterIdCarouselID).val(),
            status: $(this.g_sFilterStatusID).find('option:selected').val(),
        };
        this.g_carouselSearchPresenter.fnFilterChange(filter);
    },

    fnOpenEdit: function (carousel_id, NUM) {
        var filter = window.location.search.substring(1);
        filter = (filter.length > 0) ? '&' + filter : filter;
        window.location = 'CarouselEditView.aspx?carousel_id=' + carousel_id + '&NUM=' + NUM + filter;
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
    }
};

