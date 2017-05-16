import { combineReducers } from 'redux';
import authentication from './containers/AuthenticationContainer/reducer';
import jobIndex from './containers/JobIndexContainer/reducer';
import jobShow from './containers/JobShowContainer/reducer';
import favoriteJobIndex from './containers/FavoriteJobIndexContainer/reducer';

const routeReducer = combineReducers({
  authentication,
  jobIndex,
  jobShow,
  favoriteJobIndex,
});

export default routeReducer;
