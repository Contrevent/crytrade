import React from 'react';

const DecoBounds = (props) => {
    const lower = props.lower || -10;
    const upper = props.upper || 10;
    let className = 'alert alert-';
    const value = props.value;
    let code = '&#9650;';
    if (value <= lower) {
        code = '&#9660;&#9660;';
        className += 'danger';
    } else if (value < 0) {
        className += 'warning';
        code = '&#9660;';
    } else if (value >= upper) {
        code += '&#9650;';
        className += 'success'
    } else {
        className += 'info';
    }

    return <div className={className}>
        {props.value}
        <span className="ct-table-cell-deco" dangerouslySetInnerHTML={{__html: code}}/>
    </div>
};

export default DecoBounds;