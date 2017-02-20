import {
  FETCH_JOBS,
  JOBS_PATH,
  FETCH_TECH_KEYWORDS,
  TECH_KEYWORDS_PATH,
  RESET_ITEM,
  SELECT_ITEM
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
    .catch((error) => {
      console.log(error);
      dispatch(fetchJobsFailure(error.data))
    })
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

export function fetchTechKeywords(value) {
  const request = axios.get(`${TECH_KEYWORDS_PATH}?value=${value}`);

  return dispatch => {
    return request
      .then((response) => {
        console.log(response);
        dispatch(fetchTechKeywordsSuccess(response.data))
      })
      .catch((error) => {
        console.log(error);
        dispatch(fetchTechKeywordsFailure(error.data))
      })
  }
}

function fetchTechKeywordsSuccess(suggestedTechKeywords) {
  return {
    type: FETCH_TECH_KEYWORDS.SUCCESS.
    suggestedTechKeywords
  }
}

function fetchTechKeywordsFailure({ errorMessage }) {
  return {
    type: FETCH_TECH_KEYWORDS.FAILURE,
    errorMessage
  }
}

export function resetItem(key) {
  return {
    type: RESET_ITEM,
    key
  }
}

export function selectItem(key, value) {
  return {
    type: SELECT_ITEM,
    key,
    value
  }
}