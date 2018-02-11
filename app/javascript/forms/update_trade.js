function updateTrade() {

    const inputCount = $('#ct-edit-count');
    if (inputCount.length) {
        //var selectSymbol = $('#ct-select-symbol');
        const inputStart = $('#ct-start-usd');
        const inputStop = $('#ct-stop-usd');
        const inputGL = $('#ct-gain-loss-usd');
        const inputFees = $('#ct-fees-usd');

        function evalGainLoss() {
            try {
                const count = parseFloat(inputCount.val());
                const start = parseFloat(inputStart.val());
                const stop = parseFloat(inputStop.val());
                const fees = parseFloat(inputFees.val());
                let valid = true;
                if (isNaN(count) || isNaN(start) || isNaN(stop) || isNaN(fees)) {
                    valid = false;
                }
                if (!valid) {
                    inputGL.val("n.a.");
                } else {
                    const raw = (stop - start) * count - fees;
                    const display = Math.round(raw * 100) / 100;
                    inputGL.val(display);
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
}

module.exports = updateTrade;