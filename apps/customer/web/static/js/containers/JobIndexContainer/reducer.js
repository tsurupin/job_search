import {
  FETCH_JOBS,
  FETCH_TECH_KEYWORDS,
  RESET_ITEM,
  SELECT_ITEM
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
    case FETCH_JOBS.REQUEST:
      return { ...state, loading: true };

    case FETCH_JOBS.SUCCESS:
      const { jobs, jobTitles, areas, page, nextPage, hasNext } = action.payload;
      return { ...state, jobs, jobTitles, areas, page, nextPage, hasNext, loading: false };

    case FETCH_JOBS.FAILURE:
      const { errorMessage } = action.payload;
      return { ...state, errorMessage, loading: false };

    case SELECT_ITEM:
      const { key, value } = action.payload;
      return { ...state, [key]: value };

    case RESET_ITEM:
      const { key } = action.payload;
      return { ...state, [key]: '' };

    case FETCH_TECH_KEYWORDS.SUCCESS:
      const { suggestedTechKeywords } = action.payload;
      return { ...state, suggestedTechKeywords };

    case FETCH_TECH_KEYWORDS.FAILURE:
      const { errorMessage } = action.payload;
      return { ...state, errorMessage };

    default:
      return state;
  }
}
