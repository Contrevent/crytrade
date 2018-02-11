import React from 'react';

const Deco = (props) => (
    <span className="ct-table-cell-deco" dangerouslySetInnerHTML={{__html: props.up ? '&#9650;' : '&#9660;'}}/>
);

export default Deco;