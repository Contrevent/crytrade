import TableHead from "./table/thead";
import TableCellHead from "./table/th";
import React from 'react'
import TableBody from "./table/tbody";
import TableLine from "./table/tr";
import TableCell from "./table/td";
import DecoBounds from "./deco_bounds";
import orderBy from "lodash/orderBy";

export default class Trades extends React.Component {

    constructor(props) {
        super(props);
        this.state = props.order;
    }

    onSort = (name, dir) => {
        this.setState({field: name, dir: dir});
    };

    renderCell(item, col) {
        const value = item[col.name];
        if (col.link) {
            return <a className="btn btn-sm btn-outline-secondary" href={value}>{col.label}</a>
        } else {
            if (col.deco) {
                return <DecoBounds value={value} lower={col.red} upper={col.green}/>
            } else if(item[col.name + '_label']) {
                return <div className="ct-ellipsis p-1">{item[col.name + '_label']}</div>
            } else {
                return <div className="ct-ellipsis p-1">{value}</div>
            }

        }
    }


    render() {
        const {data, cols} = this.props;
        const order = this.state;
        const sortedData = orderBy(data, [order.field], [order.dir]);
        return <div className='ct-table-trade'>
            <TableHead key={'coins_header'}>
                {cols.map((col, index) => (
                    <TableCellHead key={'col_' + index} order={this.state} col={col} onSort={this.onSort}/>
                ))}
            </TableHead>
            <TableBody key={'coins_body'}>
                {sortedData.map((item, index) => (
                    <TableLine key={'item_' + index}>
                        {cols.map((col, index) => (
                            <TableCell key={'cell_' + index}>{this.renderCell(item, col)}</TableCell>
                        ))}
                    </TableLine>
                ))}
            </TableBody>
        </div>
    }
};
