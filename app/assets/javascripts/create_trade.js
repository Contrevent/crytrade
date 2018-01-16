
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



        function evalRisk() {
            try {
                var count = parseFloat(inputCount.val());
                var start = parseFloat(inputStart.val());
                var stop = parseFloat(inputStop.val());
                if (isNaN(count) || isNaN(start) || isNaN(stop)) {
                    inputRisk.val("n.a.");
                } else {
                    inputRisk.val((start - stop) * count);
                }
            } catch (e) {
                inputRisk.val("n.a.");
            }

        }

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