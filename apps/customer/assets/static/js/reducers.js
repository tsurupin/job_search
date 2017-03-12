import { combineReducers } from 'redux';
import authentication from './containers/AuthenticationContainer/reducer';
import jobIndex from './containers/JobIndexContainer/reducer';
import jobShow from './containers/JobShowContainer/reducer';

const routeReducer = combineReducers({
  authentication,
  jobIndex,
  jobShow
});

export default routeReducer;
