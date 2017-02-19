import {
  FETCH_JOBS
} from './constants';

const INITIAL_STATE = {
  jobs: [],
  loading: false,
  errorMessage: '',
  area: '',
  jobTitle: '',
  detail: '',
  techs: [],
  updatedAt: '',
  page: 1,
  nextPage: 1,
  hasNext: true
};

export default function(state = INITIAL_STATE, action) {
  switch(action.type) {
    case FETCH_JOBS.REQUEST:
      return { ...state, loading: true };

    case FETCH_JOBS.SUCCESS:
      const { jobs, page, offset } = action.payload;
      return { ...state, jobs, page, offset, loading: false };

    case FETCH_JOBS.FAILURE:
      const { errorMessage } = action.payload;
      return { ...state, errorMessage, loading: false };

    default:
      return state;
  }
}
