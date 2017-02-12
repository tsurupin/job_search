import {
  LOGOUT,
  LOGOUT_PATH
} from './constants';

import axios from 'axios';

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
