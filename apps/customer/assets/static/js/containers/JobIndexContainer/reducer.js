import {
  FETCH_JOBS,
  FETCH_INFINITE_JOBS,
  FETCH_TECH_KEYWORDS,
  RESET_ITEM,
  SELECT_ITEM,
  RESET_TECH_KEYWORDS,
  FAVORITE_JOB_INDEX,
  UNFAVORITE_JOB_INDEX,
} from './constants';

import {
  REMOVE_FAVORITE_JOB,
  UNFAVORITE_JOB,
} from 'constants';

const INITIAL_STATE = {
  jobs: [],
  loading: false,
  errorMessage: '',
  area: '',
  jobTitle: '',
  detail: '',
  techKeywords: [],
  updatedAt: '',
  suggestedTechKeywords: [],
  jobTitles: [],
  areas: [],
  page: 1,
  nextPage: 1,
  hasNext: true,
  total: 0,
};

export default function (state = INITIAL_STATE, action) {
  switch (action.type) {
    case FETCH_JOBS.REQUEST: {
      return { ...state, loading: true };
    }

    case FETCH_JOBS.SUCCESS: {
      const { jobTitles, areas, page, nextPage, hasNext, total } = action.payload;
      const jobs = page === 1 ? [...action.payload.jobs] : [...state.jobs, ...action.payload.jobs];
      return { ...state, jobs, jobTitles, areas, page, nextPage, hasNext, total, loading: false };
    }

    case FETCH_INFINITE_JOBS.SUCCESS: {
      const { jobTitles, areas, page, nextPage, hasNext, total } = action.payload;
      const jobs = [...state.jobs, ...action.payload.jobs];
      return { ...state, jobs, jobTitles, areas, page, nextPage, hasNext, total, loading: false };
    }

    case FETCH_JOBS.FAILURE:
    case FETCH_INFINITE_JOBS.FAILURE:
    case FETCH_TECH_KEYWORDS.FAILURE: {
      const { errorMessage } = action.payload;
      return { ...state, errorMessage, loading: false };
    }

    case SELECT_ITEM: {
      const { key, value, page } = action.payload;
      return { ...state, [key]: value, page };
    }

    case RESET_ITEM: {
      return { ...state, [action.payload.key]: '' };
    }

    case FETCH_TECH_KEYWORDS.SUCCESS: {
      const { suggestedTechKeywords } = action.payload;
      return { ...state, suggestedTechKeywords };
    }

    case RESET_TECH_KEYWORDS: {
      return { ...state, suggestedTechKeywords: [] };
    }

    case FAVORITE_JOB_INDEX.REQUEST:
    case UNFAVORITE_JOB_INDEX.REQUEST: {
      return { ...state, jobs: updateFavoriteJob(state.jobs, action.payload.sortRank, true) };
    }

    case FAVORITE_JOB_INDEX.SUCCESS: {
      return { ...state, jobs: updateFavoriteJob(state.jobs, action.payload.sortRank, false, true) };
    }

    case UNFAVORITE_JOB_INDEX.SUCCESS: {
      return { ...state, jobs: updateFavoriteJob(state.jobs, action.payload.sortRank, false, false) };
    }

    case FAVORITE_JOB_INDEX.FAILURE:
    case UNFAVORITE_JOB_INDEX.FAIURE: {
      return { ...state, jobs: updateFavoriteJob(state.jobs, action.payload.sortRank, false) };
    }

    case REMOVE_FAVORITE_JOB.SUCCESS:
    case UNFAVORITE_JOB.SUCCESS: {
      const { jobId } = action.payload;
      const sortRank = findSortRank(state.jobs, jobId);
      if (sortRank === -1) { return state; }
      return { ...state, jobs: updateFavoriteJob(state.jobs, sortRank, false, false) };
    }

    default: {
      return state;
    }
  }
}

function updateFavoriteJob(jobs, sortRank, submitting, favorited = null) {
  let job = { ...jobs[sortRank], submitting };
  if (favorited !== null) { job = { ...job, favorited }; }

  return [...jobs.slice(0, sortRank), job, ...jobs.slice(sortRank + 1)];
}

function findSortRank(jobs, jobId) {
  return jobs.findIndex((job, _index, _arr) => job.id === jobId);
}
