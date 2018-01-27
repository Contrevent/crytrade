$(function () {

    var selectDeposit = $('#success-symbol');
    if (selectDeposit.length) {
        selectDeposit.select2({width: '100%'});
    }

    var selectWithdraw = $('#danger-symbol');
    if (selectWithdraw.length) {
        selectWithdraw.select2({width: '100%'});
    }

    var selectRegul = $('#regul-symbol');
    if (selectRegul.length) {
        selectRegul.select2({width: '100%'});
    }

});