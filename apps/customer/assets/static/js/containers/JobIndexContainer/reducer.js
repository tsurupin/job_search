import {
  FETCH_JOBS,
  FETCH_INFINITE_JOBS,
  FETCH_TECH_KEYWORDS,
  RESET_ITEM,
  SELECT_ITEM,
  RESET_TECH_KEYWORDS,
  FAVORITE_JOB_INDEX,
  UNFAVORITE_JOB_INDEX
} from './constants';

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
  hasNext: true
};

export default function(state = INITIAL_STATE, action) {
  switch(action.type) {
    case FETCH_JOBS.REQUEST: {
      return {...state, loading: true};
    }

    case FETCH_JOBS.SUCCESS: {
      const { jobTitles, areas, page, nextPage, hasNext } = action.payload;
      let jobs = page === 1 ? [...action.payload.jobs] : [...state.jobs, ...action.payload.jobs];
      return { ...state, jobs, jobTitles, areas, page, nextPage, hasNext, loading: false };
    }

    case FETCH_INFINITE_JOBS.SUCCESS: {
      const { jobTitles, areas, page, nextPage, hasNext } = action.payload;
      const jobs = [...state.jobs, ...action.payload.jobs];
      return { ...state, jobs, jobTitles, areas, page, nextPage, hasNext, loading: false };
    }

    case FETCH_JOBS.FAILURE, FETCH_INFINITE_JOBS.FAILURE, FETCH_TECH_KEYWORDS.FAILURE: {
      const { errorMessage } = action.payload;
      return { ...state, errorMessage, loading: false };
    }

    case SELECT_ITEM: {
      const {key, value, page} = action.payload;
      return {...state, [key]: value, page};
    }

    case RESET_ITEM: {
      return {...state, [action.payload.key]: ''};
    }

    case FETCH_TECH_KEYWORDS.SUCCESS: {
      const {suggestedTechKeywords} = action.payload;
      return {...state, suggestedTechKeywords};
    }

    case RESET_TECH_KEYWORDS: {
      return {...state, suggestedTechKeywords: []};
    }

    case FAVORITE_JOB_INDEX.REQUEST, UNFAVORITE_JOB_INDEX.REQUEST: {
      return {...state, jobs: update_favorite_job(state.jobs, action.payload.sortRank, true)};
    }

    case FAVORITE_JOB_INDEX.SUCCESS: {
      return {...state, jobs: update_favorite_job(state.jobs, action.payload.sortRank, false, true)};
    }

    case UNFAVORITE_JOB_INDEX.SUCCESS: {
      return {...state, jobs: update_favorite_job(state.jobs, action.payload.sortRank, false, false)};
    }

    case FAVORITE_JOB_INDEX.FAILURE, UNFAVORITE_JOB_INDEX.FAIURE: {
      return {...state, jobs: update_favorite_job(state.jobs, action.payload.sortRank, false)};
    }

    default: {
      return state;
    }
  }
}

function update_favorite_job(jobs, sortRank, submitting, favorited = null) {
  let job = { ...jobs[sortRank], submitting };
  if (favorited !== null) { job = {...job, favorited } }

  return [ ...jobs.slice(0, sortRank), job, ...jobs.slice(sortRank+1) ]
}
