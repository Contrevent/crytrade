function dashboardConfig() {

    const tileSelect = $('#ct-tile-select');
    if (tileSelect.length) {
        function toogleGroup() {
            const screenerGroup = $('#screener-group');
            if (screenerGroup.length) {
                const currentTile = tileSelect.val();
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


}

module.exports = dashboardConfig;