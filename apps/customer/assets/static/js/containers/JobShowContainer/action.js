import {
  FETCH_JOB,
  JOBS_PATH,
  FETCH_FAVORITE_JOB,
  FAVORITE_JOB,
  UNFAVORITE_JOB
} from './constants';
import { FAVORITE_JOB_PATH } from 'constants';

import { axios, createAuthorizeRequest } from 'utils';

export function fetchJob(id) {
  let request;
  if (localStorage.getItem("token")) {
    request = createAuthorizeRequest("get",`${JOBS_PATH}/${id}`);
  } else {
    request = axios.get(`${JOBS_PATH}/${id}`);
  }

  return dispatch => {
    dispatch(fetchJobRequest());

    return request.then(response => {
      dispatch(fetchJobSuccess(response.data))
    })
    .catch(error => {
      console.log(error);
      dispatch(fetchJobFailure(error.data))
    })
  };
}

function fetchJobRequest() {
  return {
    type: FETCH_JOB.REQUEST
  }
}

function fetchJobSuccess( job ) {
  return {
    type: FETCH_JOB.SUCCESS,
    payload: { job }
  }
}

function fetchJobFailure(errorMessage ) {
  console.log(errorMessage);
  return {
    type: FETCH_JOB.FAILURE,
    paylaod: { errorMessage }
  }
}
export function fetchFavoriteJob(id) {
  const request = createAuthorizeRequest('get',`${FAVORITE_JOB_PATH}/${id}` );
  return dispatch => {
    dispatch(fetchFavoriteJobRequest());

    return request
      .then(() => dispatch(fetchFavoriteJobSuccess()))
      .catch(error => dispatch(fetchFavoriteJobFailure(error.data)))
  }
}

function fetchFavoriteJobRequest() {
  return {
    type: FETCH_FAVORITE_JOB.REQUEST
  }
}

function fetchFavoriteJobSuccess() {
  return {
    type: FETCH_FAVORITE_JOB.SUCCESS
  }
}

function fetchFavoriteJobFailure() {
  return {
    type: FETCH_FAVORITE_JOB.FAILURE
  }
}


export function favoriteJob(jobId) {
  const request = createAuthorizeRequest('post', `${FAVORITE_JOB_PATH}?id=${jobId}`);
  return dispatch => {
    dispatch(favoriteJobRequest());
    return request
      .then(() => dispatch(favoriteJobSuccess()))
      .catch((error) => {
      console.log(error);
      dispatch(favoriteJobFailure(error.data))
      })
  }
}

function favoriteJobRequest() {
  return {
    type: FAVORITE_JOB.REQUEST
  }
}

function favoriteJobSuccess() {
  return {
    type: FAVORITE_JOB.SUCCESS
  }
}

function favoriteJobFailure(errorMessage) {
  return {
    type: FAVORITE_JOB.FAILURE,
    payload: { errorMessage }
  }
}

export function unfavoriteJob(jobId) {
  const request = createAuthorizeRequest('delete', `${FAVORITE_JOB_PATH}/${jobId}`);
  return dispatch => {
    dispatch(unfavoriteJobRequest());
    return request
      .then(() => dispatch(unfavoriteJobSuccess()))
      .error((error) => dispatch(unfavoriteJobFailure(error.data)))
  }
}


function unfavoriteJobRequest() {
  return {
    type: UNFAVORITE_JOB.REQUEST
  }
}

function unfavoriteJobSuccess() {
  return {
    type: UNFAVORITE_JOB.SUCCESS
  }
}

function unfavoriteJobFailure(errorMessage) {
  return {
    type: UNFAVORITE_JOB.FAILURE,
    payload: { errorMessage }
  }
}