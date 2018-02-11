function consumeFlash () {

    const flashNotice = $('#flash-notice');
    if (flashNotice.length) {
        flashNotice.delay(3000).fadeOut(200);
    }

    const flashAlert = $('#flash-alert');
    if (flashAlert.length) {
        flashAlert.delay(3000).fadeOut(200);
    }

    const flashError = $('#flash-error');
    if (flashError.length) {
        flashError.delay(3000).fadeOut(200);
    }

}

module.exports = consumeFlash;