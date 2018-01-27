$(function () {

    var tileSelect = $('#ct-tile-select');
    if (tileSelect.length) {
        function toogleGroup() {
            var screenerGroup = $('#screener-group');
            if (screenerGroup.length) {
                var currentTile = tileSelect.val();
                if (currentTile === 'screener_last') {
                    screenerGroup.show();
                } else {
                    screenerGroup.hide();
                }
            }
        }

        tileSelect.change(toogleGroup);
        toogleGroup();
    }


});