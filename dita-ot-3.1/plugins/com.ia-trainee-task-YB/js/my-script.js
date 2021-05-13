
    $(document).ready(function () {

        /**
        * Check to see if the window is top if not then display button
        */
        $(window).scroll(function(){
            if ($(this).scrollTop() > 5) {
                $('#go2top').fadeIn('fast');
            } else {
                $('#go2top').fadeOut('fast');
            }
        });

        /**
        * Click event to scroll to top
        */
        $('#go2top').click(function(){
            $('html, body').animate({scrollTop : 0},800);
            return false;
        });
        console.log('#go2top');
    });