function funcArgs(input) {
    const questionMarkIndex = input.indexOf('?');
    const result = [];
    if (questionMarkIndex > -1) {
        const query = input.substring(questionMarkIndex);
        const vars = query.split('&');

        for (var i = 0; i < vars.length; i++) {
            const pair = vars[i].split('=');
            result.push(decodeURIComponent(pair[1]));
        }

    }
    return result;
}

function funcName(input) {
    const questionMarkIndex = input.indexOf('?');
    if (questionMarkIndex > -1) {
        return input.substring(0, questionMarkIndex);
    } else {
        return input;
    }
}

function turboLoad(callback) {
    $(document).on('turbolinks:load', callback);
}

module.exports = { funcArgs, funcName, turboLoad};
