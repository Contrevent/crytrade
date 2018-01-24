$(function () {

    function initAutoRefresh(initCount) {
        var count = -1;
        var refreshIntervalId = -1;
        var path = location.pathname;

        function refreshPage() {
            if (location.pathname !== path) {
                count = initCount;
                path = location.pathname;
            }
            count--;
            if (count === 0) {
                clearInterval(refreshIntervalId);
                location.reload();
            } else {
                var autoRefresh = $('#ct-refresh-count');
                autoRefresh.text(count);
            }
        }

        function start() {
            count = initCount;
            if (refreshIntervalId !== -1) {
                clearInterval(refreshIntervalId);
            }
            refreshIntervalId = setInterval(refreshPage, 1000);
            var autoRefresh = $('#ct-refresh-count');
            autoRefresh.text(count);
            var refreshBtn = $('#ct-refresh-btn');
            refreshBtn.removeClass('btn-outline-success');
            refreshBtn.addClass('btn-outline-danger');
        }

        function stop() {
            clearInterval(refreshIntervalId);
            count = -1;
            var autoRefresh = $('#ct-refresh-count');
            autoRefresh.text('');
            var refreshBtn = $('#ct-refresh-btn');
            refreshBtn.addClass('btn-outline-success');
            refreshBtn.removeClass('btn-outline-danger');
        }

        start();
        refreshPage();

        function refreshClick() {
            if (count > 0) {
                stop();
            } else {
                start();
            }
        }

        var refreshBtn = $('#ct-refresh-btn');
        refreshBtn.click(refreshClick);
    }

    var autoRefresh = $('#ct-refresh-count');
    if (autoRefresh.length) {
        initAutoRefresh(60);
    }
});