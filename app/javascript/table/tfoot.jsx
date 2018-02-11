import React from 'react'
import PropTypes from 'prop-types'


const TableFoot = (props) => {
    return <table className="table table-dark table-sm ct-table">
        <tfoot>
        <tr>
            {props.children}
        </tr>
        </tfoot>
    </table>
};

export default TableFoot;
