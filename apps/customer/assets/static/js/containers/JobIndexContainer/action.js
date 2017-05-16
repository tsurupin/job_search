import {
  FETCH_JOBS,
  FETCH_INFINITE_JOBS,
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

import { axios, createAuthorizeRequest, convertErrorToMessage } from 'utils';

function indexJobRequest(path) {
  let request;
  if (localStorage.getItem('token')) {
    request = createAuthorizeRequest('get', `${JOBS_PATH}/${path}`);
  } else {
    request = axios.get(`${JOBS_PATH}/${path}`);
  }
  return request;
}

export function fetchJobs(path = '') {
  return (dispatch) => {
    dispatch(fetchJobsRequest());

    return indexJobRequest(path)
    .then((response) => {
      dispatch(fetchJobsSuccess(response.data));
    })
    .catch((error) => {
      const errorMessage = convertErrorToMessage(error);
      dispatch(fetchJobsFailure(errorMessage));
    });
  };
}

function fetchJobsRequest() {
  return {
    type: FETCH_JOBS.REQUEST,
  };
}

function fetchJobsSuccess({ jobs, page, hasNext, nextPage, jobTitles, areas, total }) {
  return {
    type: FETCH_JOBS.SUCCESS,
    payload: { jobs, page, hasNext, nextPage, jobTitles, areas, total },
  };
}

function fetchJobsFailure(errorMessage) {
  return {
    type: FETCH_JOBS.FAILURE,
    payload: { errorMessage },
  };
}

export function fetchInfiniteJobs(path = '') {
  return (dispatch) => {
    dispatch(fetchJobsRequest());

    return indexJobRequest(path)
      .then((response) => {
        dispatch(fetchInfiniteJobsSuccess(response.data));
      })
      .catch((error) => {
        const errorMessage = convertErrorToMessage(error);
        dispatch(fetchInfiniteJobsFailure(errorMessage));
      });
  };
}

function fetchInfiniteJobsSuccess({ jobs, page, hasNext, nextPage, jobTitles, areas, total }) {
  return {
    type: FETCH_INFINITE_JOBS.SUCCESS,
    payload: { jobs, page, hasNext, nextPage, jobTitles, areas, total },
  };
}

function fetchInfiniteJobsFailure(errorMessage) {
  return {
    type: FETCH_INFINITE_JOBS.FAILURE,
    payload: { errorMessage },
  };
}


export function fetchTechKeywords(value) {
  const request = axios.get(`${TECH_KEYWORDS_PATH}?word=${value}`);

  return dispatch => request
      .then((response) => {
        dispatch(fetchTechKeywordsSuccess(response.data));
      })
      .catch((error) => {
        const errorMessage = convertErrorToMessage(error);

        dispatch(fetchTechKeywordsFailure(errorMessage));
      });
}

function fetchTechKeywordsSuccess(suggestedTechKeywords) {
  return {
    type: FETCH_TECH_KEYWORDS.SUCCESS,
    payload: { suggestedTechKeywords },
  };
}

function fetchTechKeywordsFailure(errorMessage) {
  return {
    type: FETCH_TECH_KEYWORDS.FAILURE,
    payload: { errorMessage },
  };
}

export function resetTechKeywords() {
  return { type: RESET_TECH_KEYWORDS };
}

export function favoriteJob(sortRank, jobId) {
  const request = createAuthorizeRequest('post', `${FAVORITE_JOB_PATH}?id=${jobId}`);
  return (dispatch) => {
    dispatch(favoriteJobRequest(sortRank));
    return request
        .then(() => dispatch(favoriteJobSuccess(sortRank)))
        .catch((error) => {
          const errorMessage = convertErrorToMessage(error);
          dispatch(favoriteJobFailure(sortRank, errorMessage));
        });
  };
}

function favoriteJobRequest(sortRank) {
  return {
    type: FAVORITE_JOB_INDEX.REQUEST,
    payload: { sortRank },
  };
}

function favoriteJobSuccess(sortRank) {
  return {
    type: FAVORITE_JOB_INDEX.SUCCESS,
    payload: { sortRank },
  };
}

function favoriteJobFailure(sortRank, errorMessage) {
  return {
    type: FAVORITE_JOB_INDEX.FAILURE,
    payload: { sortRank, errorMessage },
  };
}

export function unfavoriteJob(sortRank, jobId) {
  const request = createAuthorizeRequest('delete', `${FAVORITE_JOB_PATH}/${jobId}`);
  return (dispatch) => {
    dispatch(unfavoriteJobRequest(sortRank));
    return request
            .then(() => dispatch(unfavoriteJobSuccess(sortRank)))
            .catch((error) => {
              const errorMessage = convertErrorToMessage(error);
              dispatch(unfavoriteJobFailure(sortRank, errorMessage));
            });
  };
}


function unfavoriteJobRequest(sortRank) {
  return {
    type: UNFAVORITE_JOB_INDEX.REQUEST,
    payload: { sortRank },
  };
}

function unfavoriteJobSuccess(sortRank) {
  return {
    type: UNFAVORITE_JOB_INDEX.SUCCESS,
    payload: { sortRank },
  };
}

function unfavoriteJobFailure(sortRank, errorMessage) {
  return {
    type: UNFAVORITE_JOB_INDEX.FAILURE,
    payload: { sortRank, errorMessage },
  };
}


export function resetItem(key) {
  return {
    type: RESET_ITEM,
    payload: { key },
  };
}

export function selectItem(key, value) {
  const page = key !== 'page' ? 1 : value;
  return {
    type: SELECT_ITEM,
    payload: { key, value, page },
  };
}
