import Table from "./table/table";
import React from 'react'

export default class Coins extends React.Component {

    render() {
        return <Table className='ct-react-coins' {...this.props} />
    }
};
