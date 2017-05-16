import {
  FETCH_JOB,
  FAVORITE_JOB,
} from './constants';

import { UNFAVORITE_JOB } from 'constants';

const INITIAL_STATE = {
  loading: true,
  job: {},
  errorMessage: '',
};

export default function (state = INITIAL_STATE, action) {
  switch (action.type) {
    case FETCH_JOB.REQUEST:
      return { ...state, loading: true };

    case FETCH_JOB.SUCCESS:
      return { ...state, job: action.payload.job, loading: false };

    case FETCH_JOB.FAILURE:
      return { ...state, errorMessage: action.payload.errorMessage, loading: false };

    case FAVORITE_JOB.REQUEST:
    case UNFAVORITE_JOB.REQUEST:
      return { ...state, job: { ...state.job, submitting: true } };

    case FAVORITE_JOB.SUCCESS:
      return { ...state, job: { ...state.job, favorited: true } };

    case UNFAVORITE_JOB.SUCCESS:
      return { ...state, job: { ...state.job, favorited: false } };

    case FAVORITE_JOB.FAILURE:
    case UNFAVORITE_JOB.FAIURE:
      return { ...state, errorMessage: action.payload.errorMessage };

    default:
      return state;
  }
}
