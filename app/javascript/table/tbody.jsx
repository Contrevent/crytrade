import React from 'react'
import PropTypes from 'prop-types'


const TableBody = (props) => {
    return <div className="ct-table-react-body">
        <table className="table table-dark table-striped table-sm ct-table">
            <tbody>
                {props.children}
            </tbody>
        </table>
    </div>
};

export default TableBody;
