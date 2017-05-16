import {
  LOGIN,
  LOGOUT,
} from './constants';

const INITIAL_STATE = {
  errorMessage: '',
  authenticated: false,
};

export default function (state = INITIAL_STATE, action) {
  switch (action.type) {

    case LOGIN:
      return { ...state, authenticated: true };

    case LOGOUT.SUCCESS:
      return { ...state, authenticated: false };

    case LOGOUT.FAILURE:
      return { ...state, errorMessage: action.payload.errorMessage };

    default:
      return state;
  }
}
