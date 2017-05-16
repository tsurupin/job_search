import {
  FETCH_FAVORITE_JOBS,
  UPDATE_FAVORITE_JOB,
} from './constants';

import { FAVORITE_JOB_PATH, REMOVE_FAVORITE_JOB } from 'constants';

import { createAuthorizeRequest, convertErrorToMessage } from 'utils';

export function fetchFavoriteJobs() {
  const request = createAuthorizeRequest('get', FAVORITE_JOB_PATH);
  return (dispatch) => {
    dispatch(fetchFavoriteJobsRequest());

    return request
      .then(response => dispatch(fetchFavoriteJobsSuccess(response.data)))
      .catch((error) => {
        if (error.response.status === 401) { localStorage.removeItem('token'); }
        dispatch(fetchFavoriteJobsFailure(error.response.statusText));
      });
  };
}

function fetchFavoriteJobsRequest() {
  return {
    type: FETCH_FAVORITE_JOBS.REQUEST,
  };
}

function fetchFavoriteJobsSuccess({ favoriteJobs }) {
  return {
    type: FETCH_FAVORITE_JOBS.SUCCESS,
    payload: { favoriteJobs },
  };
}

function fetchFavoriteJobsFailure(errorMessage) {
  return {
    type: FETCH_FAVORITE_JOBS.FAILURE,
    payload: { errorMessage },
  };
}

export function updateFavoriteJob(jobId, params) {
  const request = createAuthorizeRequest('put', `${FAVORITE_JOB_PATH}/${jobId}`, params);
  return dispatch => request
      .then(() => dispatch(updateFavoriteJobSuccess()))
      .catch((error) => {
        dispatch(updateFavoriteJobFailure(error.response.statusText));
      });
}

function updateFavoriteJobSuccess() {
  return {
    type: UPDATE_FAVORITE_JOB.SUCCESS,
  };
}

function updateFavoriteJobFailure(errorMessage) {
  return {
    type: UPDATE_FAVORITE_JOB.FAILURE,
    payload: { errorMessage },
  };
}


export function removeFavoriteJob(jobId, sortRank) {
  const request = createAuthorizeRequest('delete', `${FAVORITE_JOB_PATH}/${jobId}`);
  return dispatch => request
      .then(() => dispatch(removeFavoriteJobSuccess(jobId, sortRank)))
      .catch((error) => {
        console.log(error);
        const errorMessage = convertErrorToMessage(error);
        dispatch(removeFavoriteJobFailure(errorMessage));
      });
}

function removeFavoriteJobSuccess(jobId, sortRank) {
  return {
    type: REMOVE_FAVORITE_JOB.SUCCESS,
    payload: { jobId, sortRank },
  };
}

function removeFavoriteJobFailure(errorMessage) {
  return {
    type: REMOVE_FAVORITE_JOB.FAILURE,
    payload: { errorMessage },
  };
}

