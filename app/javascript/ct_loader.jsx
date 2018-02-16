import React from 'react';
import ReactDOM from 'react-dom';
import TickerUpdate from './ticker_update';
import Coins from './coins';
import Trades from './trades';
import Funds from './funds';
import Ledger from './ledger';
import History from "./history";
import remove from 'lodash/remove';
import throttle from 'lodash/throttle';
import utils from './util';
import createTrade from './forms/create_trade';
import updateTrade from './forms/update_trade';
import convert from './forms/ct_convert';
import dashboardConfig from './forms/dashboard';
import select from './forms/select';
import consumeFlash from './flash';
import primaryUtils from './primary';


class CTLoader {

    timeoutIds = [];

    queueTimeout(callback, seconds) {
        let id = setTimeout(function () {
            remove(this.timeoutIds, (item) => item === id);
            callback();
        }, 1000 * seconds);
        this.timeoutIds.push(id);
    }

    cancelTimeoutQueue() {
        this.timeoutIds.forEach((item) => {
            clearTimeout(item);
        });
        console.debug(`Cancelled ${this.timeoutIds.length} timeouts.`);
        this.timeoutIds.length = 0;
    }

    loadSuccess(view, elt, result) {
        if (result && result.component) {
            let component = null;
            switch (result.component) {
                case 'TickerUpdate':
                    component = <TickerUpdate {...result.props} />;
                    break;
                case 'Coins':
                    component = <Coins {...result.props} />;
                    break;
                case 'Trades':
                    component = <Trades {...result.props} />;
                    break;
                case 'Funds':
                    component = <Funds {...result.props} />;
                    break;
                case 'Ledger':
                    component = <Ledger {...result.props} />;
                    break;
                case 'History':
                    component = <History {...result.props} />;
            }
            if (component) {
                ReactDOM.render(component, elt);
                if (result.interval) {
                    this.queueTimeout(this.loadComponent(view, elt), result.interval);
                }
            }
        }
    }

    loadComponent(view, elt) {
        const self = this;
        return function (start = Date.now()) {
            $.get({
                url: view,
                dataType: 'json'
            }).then(function (result) {
                self.loadSuccess(view, elt, result);
                console.debug(`View ${view} loaded in ${Date.now() - start}ms.`);
            });
        }
    }

    loadViews() {
        const self = this;
        const views = $("[data-view]");
        views.each(function () {
            const view = $(this).attr('data-view');
            const primary = $(this).attr('data-primary');
            let trigger = true;
            if (primary !== undefined) {
                const isDevice = primaryUtils.isDevice();
                trigger = (primary === 'true' && !isDevice) || (primary === 'false' && isDevice);
            }
            if (trigger) {
                const elt = $(this).get()[0];
                self.loadComponent(view, elt)();
            }

        });
    }

    loadFunctions() {
        const funcs = $("[data-func]");
        funcs.each(function () {
            const func = $(this).attr('data-func');
            const name = utils.funcName(func);
            console.debug(`Firing function ${name}`);
            switch (name) {
                case 'flash':
                    consumeFlash();
                    break;
                case 'create-trade':
                    createTrade();
                    break;
                case 'update-trade':
                    updateTrade();
                    break;
                case 'dashboard-config':
                    dashboardConfig();
                    break;
                case 'select':
                    select();
                    break;
                case 'primary':
                    primaryUtils.primary();
                    break;
                case 'ct-converter':
                    convert();
                    break;
            }
        });
    }

    onLoad(source) {
        this.cancelTimeoutQueue();
        console.debug('Loading views... triggered by ' + source);
        this.loadViews();
        this.loadFunctions();
    }

}

const loaderSingleton = new CTLoader();

export default function queueLoad(source) {
    return throttle(() => loaderSingleton.onLoad(source));
}