const round = require('lodash/round');

function createTrade() {

    const inputCount = $('#ct-new-count');
    if (inputCount.length) {
        const selectSymbol = $('#ct-select-symbol');
        const inputStart = $('#ct-start-usd');
        const inputStop = $('#ct-stop-usd');
        const inputRisk = $('#ct-risk');
        let init = true;

        setTimeout(function () {
            init = false;
        }, 5000);

        function evalRisk() {
            const refreshBtn = $('#ct-refresh-btn');
            if (!init && refreshBtn.hasClass('btn-outline-danger')) {
                refreshBtn.click();
            }
            try {
                const count = parseFloat(inputCount.val());
                const start = parseFloat(inputStart.val());
                const stop = parseFloat(inputStop.val());
                let valid = true;
                if (isNaN(count) || isNaN(start) || isNaN(stop)) {
                    valid = false;
                }
                if (!valid) {
                    inputRisk.val("n.a.");
                } else {
                    inputRisk.val((start - stop) * count);
                }
            } catch
                (e) {
                inputRisk.val("n.a.");

            }
        }

        const sellStart = $('#ct-start-sell-usd');
        const sellSymbol = $('#ct-sell-select-symbol');

        function loadSellTicker() {
            sellStart.val(0);
            $.get("/ticker?symbol=" + sellSymbol.val(), function (result) {
                const price = result && result.price;
                if (price) {
                    sellStart.val(price);
                }
            });
        }

        loadSellTicker();
        sellSymbol.change(loadSellTicker);

        function loadTicker() {
            inputCount.val(0);
            $.get("/ticker?symbol=" + selectSymbol.val(), function (result) {
                const price = result && result.price;
                if (price) {
                    inputStart.val(price);
                    inputStop.val(round(price * .75, 4));
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
}

module.exports = createTrade;