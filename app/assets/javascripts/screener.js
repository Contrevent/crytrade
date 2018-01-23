$(function () {

    var autoRefresh = $('#screener-refresh');
    if (autoRefresh.length) {
        function refreshPage() {
            location.reload();
        }
        window.setTimeout(refreshPage, 30000);
    }
});