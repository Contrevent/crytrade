import Table from "./table/table";
import React from 'react'

export default class Ledger extends React.Component {

    render() {
        return <Table className='ct-react-ledger' {...this.props} />
    }
};
