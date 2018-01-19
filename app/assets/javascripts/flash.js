$(function () {

    $.fn.exists = function () {
        return this.length !== 0;
    };

    var flashNotice = $('#flash-notice');

    if (flashNotice.exists()) {
        flashNotice.fadeOut(1500);
    }

    var flashAlert = $('#flash-alert');
    if (flashAlert.exists()) {
        flashAlert.fadeOut(1500);
    }

});