import {
  FETCH_JOB,
  FAVORITE_JOB,
  UNFAVORITE_JOB
} from './constants';

const INITIAL_STATE = {
  loading: true,
  job: {},
  errorMessage: ""
};

export default function(state = INITIAL_STATE, action) {
  switch(action.type) {
    case FETCH_JOB.REQUEST:
      return {...state, loading: true};

    case FETCH_JOB.SUCCESS:
      return {...state, job: action.payload.job, loading: false};

    case FETCH_JOB.FAILURE:
        return {...state, errorMessage: action.payload.errorMessage, loading: false};

    case FAVORITE_JOB.REQUEST, UNFAVORITE_JOB.REQUEST:
      return {...state, job: {...job, submitting: true }};

    case FAVORITE_JOB.SUCCESS:
      return {...state, job: {...job, favorited: true }};

    case UNFAVORITE_JOB.SUCCESS:
      return {...state, job: {...job, favorited: false }};

    case FAVORITE_JOB.FAILURE, UNFAVORITE_JOB.FAIURE:
      return {...state, errorMessage: action.payload.errorMessage };

    default:
        return state;
  }
}
