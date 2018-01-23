$(function () {

    var flashNotice = $('#flash-notice');
    if (flashNotice.length) {
        flashNotice.delay(3000).fadeOut(200);
    }

    var flashAlert = $('#flash-alert');
    if (flashAlert.length) {
        flashAlert.delay(3000).fadeOut(200);
    }

    var flashError = $('#flash-error');
    if (flashError.length) {
        flashError.delay(3000).fadeOut(200);
    }

});