import TableHead from "./table/thead";
import TableCellHead from "./table/th";
import React from 'react'
import TableBody from "./table/tbody";
import TableLine from "./table/tr";
import TableCell from "./table/td";
import DecoBounds from "./deco_bounds";
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
            return <a className="btn btn-sm btn-outline-secondary" href={value} target="_blank">{col.label}</a>
        } else {
            if (col.deco) {
                return <DecoBounds value={value}/>
            } else {
                return <div className="ct-ellipsis p-1">{value}</div>
            }

        }
    }


    render() {
        const {data, cols} = this.props;
        const order = this.state;
        const sortedData = orderBy(data, [order.field], [order.dir]);
        if (!data.length) {
            return <div className='alert alert-info'>Nothing to display</div>
        }
        return <div className='ct-react-coins'>
            <TableHead key={'coins_header'} className={'ct-table-coins'}>
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
