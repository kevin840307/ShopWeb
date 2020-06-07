
$(function () {

    var last_li = $('.item-tab > ul > li').eq(0);
    var last_div = '.item-tab-content > .tab1-div';
    $('.item-tab > ul > li').click(function () {
        if (last_li != null) {
            last_li.removeClass('select-tab');
        }
        $(last_div).addClass('hide');
        last_div = '.item-tab-content > .' + $(this).find('a').attr('href').replace('#', '') + '-div';
        $(last_div).removeClass('hide');
        $(this).addClass('select-tab');
        last_li = $(this);
    });
});