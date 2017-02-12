import {
  LOGOUT
} from './constants';

const INITIAL_STATE = {
  errorMessage: '',
  submitting: false
};

export default function(state = INITIAL_STATE, action) {
  switch(action.type) {

    case LOGOUT.SUCCESS:
      return { ...state };

    case LOGOUT.FAILURE:
      return { ...state, errorMessage: action.payload.errorMessage };

    default:
        return state;
  }
}
