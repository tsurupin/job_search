import {
  FETCH_JOB
} from './constants';

const INITIAL_STATE = {
  loading: false,
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

    default:
        return state;
  }
}
