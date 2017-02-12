import {
  LOGIN,
  LOGOUT,
  LOGOUT_PATH
} from './constants';

import { createAuthorizeRequest } from 'utils';
import { browserHistory } from 'react-router';

export function fetchToken(token) {
  localStorage.setItem('token', token);
  return dispatch => {
    dispatch(login());
    browserHistory.push('/');
  }

}

function login() {
  return {
    type: LOGIN
  }
}

export function logout() {
  const request = createAuthorizeRequest('delete', LOGOUT_PATH);
  return dispatch => {
    return request
    .then(() => dispatch(logoutSuccess()))
    .catch((error) => dispatch(logoutFailure("Failed to logout")))
  }
}

function logoutSuccess() {
  localStorage.removeItem('token');
  return {
    type: LOGOUT.SUCCESS
  }
}

function logoutFailure(errorMessage) {
  return {
    type: LOGOUT.FAILURE,
    payload: { errorMessage }
  }
}
