function navAction() {

    function getActiveIndex() {
        const active = $('.ct-dashboard-xs .ct-panel .active');
        if (active.length) {
            return active.data('index');
        }
        return -1;
    }

    function exists(index) {
        const elt = $('#ct-dash-tile-' + index);
        return elt.length;
    }

    const next = $('.ct-dashboard-xs .btn-next');
    const previous = $('.ct-dashboard-xs .btn-previous');

    next.click(function () {
        const active = getActiveIndex();
        if (active > -1) {
            const next = active + 1;
            if (exists(next)) {
                $(`#dash-tab li:nth-child(${next}) a`).tab('show');
            }
        }
    });

    previous.click(function () {
        const active = getActiveIndex();
        if (active > 1) {
            const previous = active - 1;
            $(`#dash-tab li:nth-child(${previous}) a`).tab('show');
        }
    });

    function disable(elt) {
        elt.addClass("invisible");
    }

    function enable(elt) {
        elt.removeClass("invisible");
    }

    function checkPosition() {
        const index = getActiveIndex();
        const nextIndex = index + 1;
        if (exists(nextIndex)) {
            enable(next);
        } else {
            disable(next);
        }
        const previousIndex = index - 1;
        if (exists(previousIndex)) {
            enable(previous);
        } else {
            disable(previous);
        }
    }

    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        checkPosition();
    });

    checkPosition();

}

module.exports = navAction;