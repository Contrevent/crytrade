function isDevice() {
    return (window.matchMedia("(max-width: 992px)").matches);
}


function primary() {
    let activeIndex = -1;
    $('#facets-tab li a').each((index, elt) => {
        console.debug(elt.className);
        if (elt.className.indexOf('active') > -1) {
            activeIndex = index;
        }
    });

    const device = isDevice();
    if (device && activeIndex === 1) {
        /* Display width <= 992px (lg media breakpoint); small device */
        $('#facets-tab li:first-child a').tab('show');
    } else if (!device && activeIndex === 0) {
        $('#facets-tab li:nth-child(2) a').tab('show');
    }
}


module.exports = {isDevice, primary};