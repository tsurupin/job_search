import { combineReducers } from 'redux';

import header from './containers/HeaderContainer/reducer';
const routeReducer = combineReducers({
  header
});

export default routeReducer;
