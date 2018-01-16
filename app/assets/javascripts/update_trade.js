$(function () {

    $.fn.exists = function () {
        return this.length !== 0;
    };

    var inputCount = $('#ct-edit-count');
    if (inputCount.exists()) {
        //var selectSymbol = $('#ct-select-symbol');
        var inputStart = $('#ct-start-usd');
        var inputStop = $('#ct-stop-usd');
        var inputGL = $('#ct-gain-loss-usd');
        var inputFees = $('#ct-fees-usd');
        var closeButton = $('#ct-close-btn');

        function validateClose() {
            try {
                var count = parseFloat(inputCount.val());
                var start = parseFloat(inputStart.val());
                var stop = parseFloat(inputStop.val());
                var fees = parseFloat(inputFees.val());
                var valid = true;
                if (isNaN(count)) {
                    valid = false;
                    inputCount.addClass('is-invalid');
                } else {
                    inputCount.removeClass('is-invalid');
                }
                if (isNaN(start)) {
                    valid = false;
                    inputStart.addClass('is-invalid');
                } else {
                    inputStart.removeClass('is-invalid');
                }
                if (isNaN(stop)) {
                    valid = false;
                    inputStop.addClass('is-invalid');
                } else {
                    inputStop.removeClass('is-invalid');
                }
                if (isNaN(fees)) {
                    valid = false;
                    inputFees.addClass('is-invalid');
                } else {
                    inputFees.removeClass('is-invalid');
                }
                if (!valid) {
                    inputGL.val("n.a.");
                    closeButton.attr('disabled', 'disabled');
                } else {
                    inputGL.val((stop - start) * count - fees);
                    closeButton.removeAttr('disabled');
                }
            } catch (e) {
                inputGL.val("n.a.");
                closeButton.attr('disabled', 'disabled');
            }
        }

        inputCount.on('input', validateClose);
        inputStart.on('input', validateClose);
        inputStop.on('input', validateClose);
        inputFees.on('input', validateClose);
        validateClose();

        var saveButton = $('#ct-save-btn');
        var inputTrailing = $('#ct-trailing-usd');
        var inputInit = $('#ct-init-usd');

        function validateEdit() {
            try {
                var count = parseFloat(inputCount.val());
                var start = parseFloat(inputStart.val());
                var trailing = parseFloat(inputTrailing.val());
                var init = parseFloat(inputInit.val());
                var valid = true;
                if (isNaN(count)) {
                    valid = false;
                    inputCount.addClass('is-invalid');
                } else {
                    inputCount.removeClass('is-invalid');
                }
                if (isNaN(start)) {
                    valid = false;
                    inputStart.addClass('is-invalid');
                } else {
                    inputStart.removeClass('is-invalid');
                }
                if (isNaN(trailing)) {
                    valid = false;
                    inputTrailing.addClass('is-invalid');
                } else {
                    inputTrailing.removeClass('is-invalid');
                }
                if (isNaN(init)) {
                    valid = false;
                    inputInit.addClass('is-invalid');
                } else {
                    inputInit.removeClass('is-invalid');
                }
                if (!valid) {
                    saveButton.attr('disabled', 'disabled');
                } else {
                    saveButton.removeAttr('disabled');
                }
            } catch (e) {
                saveButton.attr('disabled', 'disabled');
            }
        }

        inputCount.on('input', validateEdit);
        inputStart.on('input', validateEdit);
        inputTrailing.on('input', validateEdit);
        inputInit.on('input', validateEdit);
    }
});