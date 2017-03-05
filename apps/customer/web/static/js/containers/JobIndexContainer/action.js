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

function fetchJobsSuccess({ jobs, page, hasNext, nextPage, jobTitles, areas }) {
  return {
    type: FETCH_JOBS.SUCCESS,
    payload: { jobs, page, hasNext, nextPage, jobTitles, areas }
  }
}

function fetchJobsFailure(errorMessage) {
  console.log(errorMessage);
  return {
    type: FETCH_JOBS.FAILURE,
    payload: { errorMessage }
  }
}

export function fetchTechKeywords(value) {
  const request = axios.get(`${TECH_KEYWORDS_PATH}?word=${value}`);

  return dispatch => {
    return request
      .then((response) => {
        dispatch(fetchTechKeywordsSuccess(response.data))
      })
      .catch((error) => {
        dispatch(fetchTechKeywordsFailure(error.data))
      })
  }
}

function fetchTechKeywordsSuccess(suggestedTechKeywords) {
  return {
    type: FETCH_TECH_KEYWORDS.SUCCESS,
    payload: { suggestedTechKeywords }
  }
}

function fetchTechKeywordsFailure(errorMessage) {
  console.log(errorMessage)
  return {
    type: FETCH_TECH_KEYWORDS.FAILURE,
    payload: { errorMessage }
  }
}

export function resetItem(key) {
  return {
    type: RESET_ITEM,
    payload: { key }
  }
}

export function selectItem(key, value) {
  return {
    type: SELECT_ITEM,
    payload: { key, value }
  }
}