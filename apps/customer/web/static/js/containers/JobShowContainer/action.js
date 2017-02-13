import {
  FETCH_JOB,
  JOBS_PATH
} from './constants';
import axios from 'axios';

export function fetchJob(id) {
  const request = axios.get(`${JOBS_PATH}/${id}`);

  return dispatch => {
    dispatch(fetchJobRequest());

    return request
    .then({ data } => dispatch(fetchJobSuccess(data))
    .catch({ data } => dispatch(fetchJobFailure(data)))
  }
};

function fetchJobRequest() {
  return {
    type: FETCH_JOB.REQUEST
  }
}

function fetchJobSuccess({ job }) {
  return {
    type: FETCH_JOB.SUCCESS,
    payload: { job }
  }
}

function fetchJobFailure({ errorMessage }) {
  return {
    type: FETCH_JOB.FAILURE,
    paylaod: { errorMessage }
  }
};
