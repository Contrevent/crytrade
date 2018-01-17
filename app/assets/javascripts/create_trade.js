
$(function () {

    $.fn.exists = function () {
        return this.length !== 0;
    };

    var inputCount = $('#ct-new-count');
    if (inputCount.exists()) {
        var selectSymbol = $('#ct-select-symbol');
        var inputStart = $('#ct-start-usd');
        var inputStop = $('#ct-stop-usd');
        var inputRisk = $('#ct-risk');
        var createButton = $('#ct-create');

        function evalRisk() {
            try {
                var count = parseFloat(inputCount.val());
                var start = parseFloat(inputStart.val());
                var stop = parseFloat(inputStop.val());
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
                if (!valid) {
                    inputRisk.val("n.a.");
                    createButton.attr('disabled', 'disabled');
                } else {
                    inputRisk.val((start - stop) * count);
                    createButton.removeAttr('disabled');
                }
            } catch (e) {
                inputRisk.val("n.a.");
                createButton.attr('disabled', 'disabled');
            }
        }

        var sellStart = $('#ct-start-sell-usd');
        var sellSymbol = $('#ct-sell-select-symbol');

        function loadSellTicker() {
            sellStart.val(0);
            $.get( "/application/ticker?symbol=" + sellSymbol.val(), function( result ) {
                var price = result && result.price;
                if (price) {
                    sellStart.val(price);
                }
            });
        }
        loadSellTicker();
        sellSymbol.change(loadSellTicker);

        function loadTicker() {
            inputCount.val(0);
            $.get( "/application/ticker?symbol=" + selectSymbol.val(), function( result ) {
                var price = result && result.price;
                if (price) {
                    inputStart.val(price);
                    inputStop.val(price*.75);
                    evalRisk();
                }
            });
        }
        loadTicker();

        selectSymbol.change(loadTicker);
        inputCount.on('input', evalRisk);
        inputStart.on('input', evalRisk);
        inputStop.on('input', evalRisk);
    }
});