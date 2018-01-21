$(function () {

    $.fn.exists = function () {
        return this.length !== 0;
    };

    var flashNotice = $('#flash-notice');

    if (flashNotice.exists()) {
        flashNotice.delay(3000).fadeOut(200);
    }

    var flashAlert = $('#flash-alert');
    if (flashAlert.exists()) {
        flashAlert.delay(3000).fadeOut(200);
    }

    var flashAlert = $('#flash-error');
    if (flashAlert.exists()) {
        flashAlert.delay(3000).fadeOut(200);
    }

});