function loadLedger () {

    const selectDeposit = $('#success-symbol');
    if (selectDeposit.length) {
        selectDeposit.select2({width: '100%'});
    }

    const selectWithdraw = $('#danger-symbol');
    if (selectWithdraw.length) {
        selectWithdraw.select2({width: '100%'});
    }

    const selectRegul = $('#regul-symbol');
    if (selectRegul.length) {
        selectRegul.select2({width: '100%'});
    }

}


module.exports = loadLedger;