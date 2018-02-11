
import React from 'react'
import PropTypes from 'prop-types'


const TableHead = (props) => {
    return <table className="table table-dark table-sm ct-table">
        <thead>
        <tr>
            {props.children}
        </tr>
        </thead>
    </table>
};

export default TableHead;
