$(function () {

    var inputCount = $('#ct-edit-count');
    if (inputCount.length) {
        //var selectSymbol = $('#ct-select-symbol');
        var inputStart = $('#ct-start-usd');
        var inputStop = $('#ct-stop-usd');
        var inputGL = $('#ct-gain-loss-usd');
        var inputFees = $('#ct-fees-usd');

        function evalGainLoss() {
            try {
                var count = parseFloat(inputCount.val());
                var start = parseFloat(inputStart.val());
                var stop = parseFloat(inputStop.val());
                var fees = parseFloat(inputFees.val());
                var valid = true;
                if (isNaN(count) || isNaN(start) || isNaN(stop) || isNaN(fees)) {
                    valid = false;
                }
                if (!valid) {
                    inputGL.val("n.a.");
                } else {
                    inputGL.val((stop - start) * count - fees);
                }
            } catch (e) {
                inputGL.val("n.a.");
            }
        }

        inputCount.on('input', evalGainLoss);
        inputStart.on('input', evalGainLoss);
        inputStop.on('input', evalGainLoss);
        inputFees.on('input', evalGainLoss);
        evalGainLoss();

    }
});