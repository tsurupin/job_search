import { combineReducers } from 'redux';
import authentication from './containers/AuthenticationContainer/reducer';

const routeReducer = combineReducers({
  authentication
});

export default routeReducer;
