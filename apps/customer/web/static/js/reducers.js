import { combineReducers } from 'redux';
import authentication from './containers/AuthenticationContainer/reducer';
import jobIndex from './containers/JobIndexContainer';
import jobShow from './containers/JobShowContainer';

const routeReducer = combineReducers({
  authentication,
  jobIndex,
  jobShow
});

export default routeReducer;
