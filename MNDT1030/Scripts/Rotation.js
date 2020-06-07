
(function ($) {

    $.fn.rotation = function (options) {

        var settings = $.extend({
            speed: 1000, //換banner時間
            dot: '.page_dot',
            auto: true
        }, options);
        var $ulPic = this.find('ul.pic');
        var liPicHtml = $ulPic.html();//把裡面元素抓出來
        var img_width = this.find('ul.pic li').width();
        var nowIndex = 0;
        var timer;
        var picLen = $ulPic.find('li').length;
        var num = 0;
        var check_offset = -2;


        //生出page dot
        $ulPic.find('li').each(function () {
            $(settings.dot).append('<li id=\'' + num + '\'></li>');
            num++;
        })
        $(settings.dot).css({ width: $(settings.dot).find('li').outerWidth(true) * picLen });

        // 輪播效果圖片*2 left:0才不會跑特效
        $ulPic.html(liPicHtml + liPicHtml);
        picLen = this.find('ul.pic li').length;

        //init
        dot();
        if (settings.auto) {
            timer = setTimeout(function () { bannerMove(check_offset); }, settings.speed);
        }

        $(settings.dot).find('li').click(function () {
            nowIndex = this.id;
            bannerMove(nowIndex);

        })

        //---------------------------------------------------------------------

        //按左右
        this.find('h2').click(function () {
            bannerMove(check_offset);
        })
        this.find('h3').click(function () {

            clearTimeout(timer);

            //nowIndex=0 時回到最後一張
            if (nowIndex <= 0) {
                $ulPic.css({ left: picLen / 2 * img_width * -1 });
                nowIndex = picLen / 2;
            }

            nowIndex = (nowIndex - 1 + picLen) % picLen;//上一張圖魔法指令

            //圖向左移動
            $ulPic.animate({ left: nowIndex * img_width * -1 }, img_width, function () {
                if (settings.auto) {
                    timer = setTimeout(function () { bannerMove(check_offset); }, settings.speed)
                }
            });

            dot();
        })

        //圖片移動
        function bannerMove(offset) {

            clearTimeout(timer);
            if (offset == check_offset) {
                nowIndex = (nowIndex + 1) % picLen;
            } else {
                nowIndex = (offset) % picLen;
            }


            //圖向左移動
            $ulPic.animate({ left: nowIndex * img_width * -1 }, img_width, function () {
                //$ulPic瞬間移動到最左邊設定為0繼續輪播
                if (nowIndex >= picLen / 2) {
                    $ulPic.css({ left: 0 });
                    nowIndex = 0;
                }
                if (settings.auto) {
                    timer = setTimeout(function () { bannerMove(check_offset); }, settings.speed)
                }
            });

            dot();
        }

        function dot() {
            //dot change color
            $(settings.dot).find('li').removeClass('DotColor').eq(nowIndex).addClass('DotColor');
            if (nowIndex == picLen / 2) {
                $(settings.dot).find('li').eq(0).addClass('DotColor');
            }
        }
    };
}(jQuery));