import {
  LOGIN,
  LOGOUT,
  AUTHENTICATE,
  LOGIN_PATH,
  LOGOUT_PATH
} from './constants';

import axios from 'axios';

export function login() {
  const request = axios.get(LOGIN_PATH);
  return dispatch => {
    return request
    .then(response => {
        dispatch(loginSuccess(response.data))
    })
    .catch(error => {
      dispatch(loginFailure(error.data))
    })
  }
}

function loginSuccess(accessToken) {
  localStorage.setItem('accessToken', accessToken);
  return {
    type: LOGIN.SUCCESS
  };
}

function loginFailure(errorMessage) {
  return {
    type: LOGIN.FAILURE,
    payload: { errorMessage }
  };
}

export function logout() {
  const request = axios.delete(LOGOUT_PATH);
  return dispatch => {
    return request
    .then(() => {
        dispatch(logoutSuccess())
    })
    .catch(error => {
      dispatch(logoutFailure(error.data))
    })
  }
}

function logoutSuccess() {
  localStorage.delete('accessToken');
  return {
    type: LOGOUT.SUCCESS
  }
}

function logoutFailure() {
  return {
    type: LOGOUT.FAILURE
  }
}
