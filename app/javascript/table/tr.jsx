import React from 'react'
import PropTypes from 'prop-types'


const TableLine = (props) => {
    return <tr>
        {props.children}
    </tr>
};

export default TableLine;
