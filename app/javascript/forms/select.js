function loadSelect2() {

    const symbols = $('.symbols');
    if (symbols.length) {
        symbols.each((index, elt) => {
            $(elt).select2({width: '100%'});
        });
    }

}


module.exports = loadSelect2;