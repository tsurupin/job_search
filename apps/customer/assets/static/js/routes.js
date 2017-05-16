import React from 'react';
import { Router, Route, IndexRoute, browserHistory } from 'react-router';
import { Provider } from 'react-redux';
import {
  createStore,
  applyMiddleware,
} from 'redux';
import thunk from 'redux-thunk';
import reducers from './reducers';

const store = createStore(reducers, applyMiddleware(thunk));
import * as Pages from 'pages';
import { AuthenticationContainer, App } from 'containers';

export default(
  <Provider store={store}>
    <Router
      onUpdate={() => {
        document.getElementById('app').focus();
        window.scrollTo(0, 0);
      }}
      history={browserHistory}
    >
      <Route path="/" component={App} >
        <IndexRoute component={Pages.JobIndexPage} />
        <Route path="/jobs/:id" component={Pages.JobShowPage} />
        <Route path="/auth/:provider/callback" component={AuthenticationContainer(Pages.AuthCallbackPage)} />
        <Route path="/favorite-jobs" component={Pages.FavoriteJobIndexPage} />
      </Route>
    </Router>
  </Provider>
);
