import {
  LOGIN,
  LOGOUT
} from './constants';

const INITIAL_STATE = {
  errorMessage: '',
  submitting: false
};

export default function(state = INITIAL_STATE, action) {
  switch(action.type) {
    case LOGIN.REQUEST:
      return { ...state, submitting: true };

    case LOGIN.SUCCESS:
      return { ...state, submitting: false };

    case LOGIN.FAILURE:
      return { ...state, submitting: false, errorMessage: action.payload.errorMessage };

    case LOGOUT.SUCCESS:
      return { ...state };

    case LOGOUT.FAILURE:
      return { ...state, errorMessage: action.payload.errorMessage };

    default:
        return state;
  }
}
