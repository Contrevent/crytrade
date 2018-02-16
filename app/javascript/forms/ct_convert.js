const round = require('lodash/round');

function ctConvert() {

    const fromCount = $('#ct-from-count');
    if (fromCount.length) {
        const fromSymbol = $('#ct-from-symbol');
        fromCount.val(1);
        const fromRate = $('#ct-from-rate');
        const toRate = $('#ct-to-rate');
        const toSymbol = $('#ct-to-symbol');
        const toCount = $('#ct-to-count');

        function convert() {
            try {
                const count = parseFloat(fromCount.val());
                const fromRateValue = parseFloat(fromRate.val());
                const toRateValue = parseFloat(toRate.val())
                let valid = true;
                if (isNaN(count) || isNaN(fromRateValue) || isNaN(toRateValue)) {
                    valid = false;
                }
                if (!valid) {
                    toCount.val("n.a.");
                } else {
                    toCount.val(round((fromRateValue * count) / toRateValue, 7));
                }
            } catch (e) {
                toCount.val("n.a.");
            }
        }



        function loadFromTicker() {
            fromRate.val(0);
            $.get("/ticker?symbol=" + fromSymbol.val(), function (result) {
                const price = result && result.price;
                if (price) {
                    fromRate.val(price);
                    convert();
                }
            });
        }

        function loadToTicker() {
            toRate.val(0);
            $.get("/ticker?symbol=" + toSymbol.val(), function (result) {
                const price = result && result.price;
                if (price) {
                    toRate.val(price);
                    convert();
                }
            });
        }

        loadFromTicker();
        loadToTicker();
        fromSymbol.change(loadFromTicker);
        toSymbol.change(loadToTicker);

        fromCount.on('input', convert);
        fromRate.on('input', convert);
        toRate.on('input', convert);
    }
}

module.exports = ctConvert;