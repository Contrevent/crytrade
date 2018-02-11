import TableHead from "./thead";
import TableCellHead from "./th";
import React from 'react'
import TableBody from "./tbody";
import TableLine from "./tr";
import TableCell from "./td";
import DecoBounds from "../deco_bounds";
import orderBy from "lodash/orderBy";

export default class Coins extends React.Component {

    constructor(props) {
        super(props);
        this.state = props.order;
    }

    onSort = (name, dir) => {
        this.setState({field: name, dir: dir});
    };

    renderCell(item, col) {
        const value = item[col.name]
        if (col.link) {
            const addProps = col.target ? {target: col.target} : {};
            return <a className="btn btn-sm btn-outline-secondary" href={value} {...addProps}>{col.label}</a>
        } else {
            if (col.deco) {
                const addProps = (col.red && col.green) ? {lower: col.red, upper: col.green} : {};
                return <DecoBounds value={value} {...addProps}/>
            } else if (item[col.name + '_label']) {
                return <div className="ct-ellipsis p-1">{item[col.name + '_label']}</div>
            } else {
                return <div className="ct-ellipsis p-1">{value}</div>
            }

        }
    }


    render() {
        const {data, cols, children, className} = this.props;
        const order = this.state;
        const sortedData = orderBy(data, [order.field], [order.dir]);
        if (!data.length) {
            return <div className='alert alert-info'>Nothing to display</div>
        }
        return <div className={className}>
            <TableHead>
                {cols.map((col, index) => (
                    <TableCellHead key={'col_' + index} order={this.state} col={col} onSort={this.onSort}/>
                ))}
            </TableHead>
            <TableBody>
                {sortedData.map((item, index) => (
                    <TableLine key={'item_' + index}>
                        {cols.map((col, index) => (
                            <TableCell key={'cell_' + index}>{this.renderCell(item, col)}</TableCell>
                        ))}
                    </TableLine>
                ))}
            </TableBody>
            {children}
        </div>
    }
};
