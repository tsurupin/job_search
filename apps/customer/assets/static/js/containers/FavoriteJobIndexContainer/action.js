import {
  FETCH_FAVORITE_JOBS,
  REMOVE_FAVORITE_JOB
} from './constants';
import { FAVORITE_JOB_PATH } from 'constants';

import { createAuthorizeRequest } from 'utils';

export function fetchFavoriteJobs() {
  const request = createAuthorizeRequest("get", FAVORITE_JOB_PATH);
  return dispatch => {
    dispatch(fetchFavoriteJobsRequest());

    return request
      .then(response => dispatch(fetchFavoriteJobsSuccess(response.data)))
      .catch(error => dispatch(fetchFavoriteJobsFailure(error)))
  }
}

function fetchFavoriteJobsRequest() {
  return {
    type: FETCH_FAVORITE_JOBS.REQUEST
  }
}

function fetchFavoriteJobsSuccess({favoriteJobs}) {
  return {
    type: FETCH_FAVORITE_JOBS.SUCCESS,
    payload: { favoriteJobs }
  }
}

function fetchFavoriteJobsFailure({errorMessage}) {
  return {
    type: FETCH_FAVORITE_JOBS.FAILURE,
    payload:{ errorMessage }
  }

}

export function updateFavoriteJob(jobId, params) {
  const request = createAuthorizeRequest('put', `${FAVORITE_JOB_PATH}/${jobId}`, params);
  return request
    .then(() => console.log("success"))
    .catch(error => console.error(error))
}


export function removeFavoriteJob(jobId, sortRank) {
  const request = createAuthorizeRequest('delete', `${FAVORITE_JOB_PATH}/${jobId}`);
  return dispatch => {
    return request
      .then(() => dispatch(removeFavoriteJobSuccess(sortRank)))
      .catch((error) => dispatch(removeFavoriteJobFailure(error)))
  }
}

function removeFavoriteJobSuccess(sortRank) {
  return {
    type: REMOVE_FAVORITE_JOB.SUCCESS,
    payload: { sortRank }
  }
}

function removeFavoriteJobFailure(errorMessage) {
  console.log(errorMessage);
  return {
    type: REMOVE_FAVORITE_JOB.FAILURE,
    payload: { errorMessage }
  }
}

