$(function () {

    var selectDeposit = $('#success-symbol');
    if (selectDeposit.length) {
        selectDeposit.select2({width: '100%'});
    }

    var selectWithdraw = $('#danger-symbol');
    if (selectWithdraw.length) {
        selectWithdraw.select2({width: '100%'});
    }

});