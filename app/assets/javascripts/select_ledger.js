$(function () {

    var selectDeposit = $('#success-symbol');
    if (selectDeposit.exists()) {
        selectDeposit.select2({width: '100%'});
    }

    var selectWithdraw = $('#danger-symbol');
    if (selectWithdraw.exists()) {
        selectWithdraw.select2({width: '100%'});
    }

});