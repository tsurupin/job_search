import {
  FETCH_JOBS,
  JOBS_PATH
} from './constants';
import axios from 'axios';

export function fetchJobs() {
  const request = axios.get(JOBS_PATH);

  return dispatch => {
    dispatch(fetchJobsRequest());

    return request
    .then(response => dispatch(fetchJobsSuccess(response.data))
    .catch(error => dispatch(fetchJobsFailure(error.data)))
  }
};

function fetchJobsRequest() {
  return {
    type: FETCH_JOBS.REQUEST
  }
}

function fetchJobsSuccess({ jobs }) {
  return {
    type: FETCH_JOBS.SUCCESS,
    payload: { jobs }
  }
}

function fetchJobsFailure({ errorMessage }) {
  return {
    type: FETCH_JOBS.FAILURE,
    paylaod: { errorMessage }
  }
};
