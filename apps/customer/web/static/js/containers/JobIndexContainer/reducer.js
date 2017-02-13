import {
  FETCH_JOBS
} from './constants';

const INITIAL_STATE = {
  jobs: [],
  loading: false,
  errorMessage: '',
  area: '',
  jobTitle: '',
  keywords: [],
  techs: []
};

export default function(state = INITIAL_STATE, action) {
  switch(action.type) {
    case FETCH_JOBS.REQUEST:
      return { ...state, loading: true };

    case FETCH_JOBS.SUCCESS:
      return { ...state, jobs: action.payload.jobs, loading: false };

    case FETCH_JOBS.FAILURE:
      return { ..state, errorMessage: action.payload.errorMessage, loading: false };

    default:
      return state;
  }
}
