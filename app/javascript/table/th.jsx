import React from 'react';
import Deco from '../deco';

const titleContent = (col) => col.label ?
    <span dangerouslySetInnerHTML={{__html: col.label}}/> :
    <span>{col.name}</span>;

class TableCellHead extends React.Component {
    sortClick = (name, dir) => (e) => {
        e.preventDefault();
        console.log('th click');
        this.props.onSort(name, dir);
    };

    render() {
        const {col, order} = this.props;
        if (col.allow_order) {
            if (order.field === col.name) {
                const desc = order.dir === 'desc';
                return <th>
                    <a href='#' onClick={this.sortClick(col.name, desc ? 'asc' : 'desc')} className="text-light">
                        <div className={'alert alert-' + (desc ? 'warning' : 'primary')}>
                            {titleContent(col)}
                            <Deco up={!desc}/>
                        </div>
                    </a>
                </th>
            } else {
                return <th>
                    <a href='#' onClick={this.sortClick(col.name, 'desc')} className="text-light">
                        <div className={'ct-th ct-th-order'}>
                            {titleContent(col)}
                        </div>

                    </a>

                </th>
            }
        } else {
            return <th>
                <div className={'ct-th'}>
                    {titleContent(col)}
                </div>
            </th>
        }
    }


};

export default TableCellHead;