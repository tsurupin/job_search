import React from 'react';
import { Router, Route, IndexRoute, browserHistory } from 'react-router';
import { Provider } from 'react-redux';
import {
  createStore,
  applyMiddleware
} from 'redux';
import thunk from 'redux-thunk';
import reducers from './reducers';

const store = createStore(reducers,applyMiddleware(thunk));
import App from './components/App';
import * as Pages from 'pages';

export default(
  <Provider store={store}>
    <Router
      onUpdate={ () => {
        document.getElementById('content').focus();
        window.scrollTo(0,0);
      }}
      history={browserHistory}
    >
    <Route path="/" component={ App } >
      <IndexRoute component={ Pages.IndexPage} />
      <Route path="/auth/:provider/callback" component={Pages.AuthCallbackPage} />
    </Route>
    </Router>
  </Provider>
)
