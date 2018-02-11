import Table from "./table/table";
import React from 'react'

export default class Trades extends React.Component {

    render() {
        return <Table className='ct-react-trades' {...this.props} />
    }
};
