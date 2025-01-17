'use strict';

import 'babel-polyfill';

import React, { PropTypes } from 'react';
import { render } from 'react-dom';
import { createStore } from 'redux';
import { Provider } from 'react-redux';
import { Router, Route, browserHistory, IndexRoute } from 'react-router';
import { syncHistoryWithStore } from 'react-router-redux';

import AppContainer       from './containers/AppContainer';
import ApposContainer     from './containers/ApposContainer';
import AppoModalComponent from './components/AppoModalComponent';
import AppoFormComponent  from './components/AppoFormComponent';

import configureStore from './configureStore';

const my_store = configureStore();
const history  = syncHistoryWithStore(browserHistory, my_store);

render(
    <Provider store={my_store}>
    <div>
      { /* Tell the Router to use our enhanced history */ }
      <Router history={history}>
        <Route name="app" path="/groups/start" component={AppContainer} />
        <Route path="/appointments" component={ApposContainer}>
          <Route path="/appointment/:id" component={AppoModalComponent} />
          <Route path="/appointmentnew" component={AppoFormComponent} />
        </Route>
      </Router>
    </div>
  </Provider>,
  document.getElementById('reactroot')
);
