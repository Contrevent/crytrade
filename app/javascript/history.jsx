import Table from "./table/table";
import React from 'react'

export default class History extends React.Component {

    render() {
        return <Table className='ct-react-history' {...this.props} />
    }
};
