import {
  FETCH_JOBS,
  JOBS_PATH
} from './constants';
import axios from 'axios';

export function fetchJobs(path = '') {
  const request = axios.get(`${JOBS_PATH}/${path}`);

  return dispatch => {
    dispatch(fetchJobsRequest());

    return request
    .then((response) => {
      console.log(response.data);
      dispatch(fetchJobsSuccess(response.data))
    })
    .catch(error => dispatch(fetchJobsFailure(error.data)))
  };
}

function fetchJobsRequest() {
  return {
    type: FETCH_JOBS.REQUEST
  }
}

function fetchJobsSuccess({ jobs, page, offset }) {
  return {
    type: FETCH_JOBS.SUCCESS,
    payload: { jobs, page, offset }
  }
}

function fetchJobsFailure({ errorMessage }) {
  return {
    type: FETCH_JOBS.FAILURE,
    paylaod: { errorMessage }
  }
}
