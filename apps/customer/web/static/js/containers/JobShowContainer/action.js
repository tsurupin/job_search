import {
  FETCH_JOB,
  JOBS_PATH
} from './constants';
import axios from 'axios';
import { createAuthorizeRequest } from 'utils';

export function fetchJob(id) {
  const request = axios.get(`${JOBS_PATH}/${id}`);

  return dispatch => {
    dispatch(fetchJobRequest());

    return request.then(response => {
      dispatch(fetchJobSuccess(response.data))
    })
    .catch(error => {
      console.log(error)
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
  console.log(errorMessage)
  return {
    type: FETCH_JOB.FAILURE,
    paylaod: { errorMessage }
  }
};

function fetchFavoriteJob() {
  const request = createAuthorizeRequest('get',`${FAVORITE_JOB_PATH}/${id}` )
}
