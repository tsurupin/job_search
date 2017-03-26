import {
  FETCH_JOBS,
  JOBS_PATH,
  FETCH_TECH_KEYWORDS,
  TECH_KEYWORDS_PATH,
  RESET_ITEM,
  SELECT_ITEM,
  RESET_TECH_KEYWORDS,
  FAVORITE_JOB_INDEX,
  UNFAVORITE_JOB_INDEX,
} from './constants';
import { FAVORITE_JOB_PATH } from 'constants';

import axios from 'axios';
import { createAuthorizeRequest } from 'utils';

export function fetchJobs(path = '') {
  let request;
  if (localStorage.getItem("token")) {
    request = createAuthorizeRequest("get",`${JOBS_PATH}/${path}`);
  } else {
    request = axios.get(`${JOBS_PATH}/${path}`);
  }

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
  return {
    type: FETCH_TECH_KEYWORDS.FAILURE,
    payload: { errorMessage }
  }
}

export function resetTechKeywords() {
  return { type: RESET_TECH_KEYWORDS };
}

export function favoriteJob(sortRank, jobId) {
  const request = createAuthorizeRequest('post', `${FAVORITE_JOB_PATH}?id=${jobId}`);
  return dispatch => {
    dispatch(favoriteJobRequest(sortRank));
    return request
        .then(() => dispatch(favoriteJobSuccess(sortRank)))
        .catch((error) => {
        console.log(error)
        dispatch(favoriteJobFailure(sortRank, error.data))
        })
  }
}

function favoriteJobRequest(sortRank) {
  return {
    type: FAVORITE_JOB_INDEX.REQUEST,
      payload: { sortRank }
  }
}

function favoriteJobSuccess(sortRank) {
    return {
        type: FAVORITE_JOB_INDEX.SUCCESS,
        payload: { sortRank }
    }
}

function favoriteJobFailure(sortRank, errorMessage) {
    return {
        type: FAVORITE_JOB_INDEX.FAILURE,
        payload: { sortRank, errorMessage }
    }
}

export function unfavoriteJob(sortRank, jobId) {
    const request = createAuthorizeRequest('delete', `${FAVORITE_JOB_PATH}/${jobId}`);
    return dispatch => {
        dispatch(unfavoriteJobRequest(sortRank));
        return request
            .then(() => dispatch(unfavoriteJobSuccess(sortRank)))
            .catch((error) => dispatch(unfavoriteJobFailure(sortRank, error.data)))
    }
}


function unfavoriteJobRequest(sortRank) {
    return {
        type: UNFAVORITE_JOB_INDEX.REQUEST,
        payload: { sortRank }
    }
}

function unfavoriteJobSuccess(sortRank) {
    return {
        type: UNFAVORITE_JOB_INDEX.SUCCESS,
        payload: { sortRank }
    }
}

function unfavoriteJobFailure(sortRank, errorMessage) {
    return {
        type: UNFAVORITE_JOB_INDEX.FAILURE,
        payload: { sortRank, errorMessage }
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