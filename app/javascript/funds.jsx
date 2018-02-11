import Table from "./table/table";
import React from 'react';
import TableCell from "./table/td";
import DecoBounds from "./deco_bounds";
import TableFoot from "./table/tfoot";
import round from 'lodash/round';

export default class Funds extends React.Component {

    render() {
        const {data} = this.props;
        const total_ref = round(data.reduce((sub, balance) => (sub + balance.count_ref), 0), 4);
        return <Table className='ct-react-funds' {...this.props}>
            <TableFoot>
                <TableCell>
                    <div className="ct-ellipsis p-1">Total</div>
                </TableCell>
                <TableCell/>
                <TableCell><DecoBounds lower={-1000} upper={100000} value={total_ref}/></TableCell>
            </TableFoot>
        </Table>
    }
};
