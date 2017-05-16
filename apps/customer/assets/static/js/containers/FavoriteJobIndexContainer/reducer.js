import {
  FETCH_FAVORITE_JOBS,
  UPDATE_FAVORITE_JOB,
} from './constants';

import { REMOVE_FAVORITE_JOB } from 'constants';

const INITIAL_STATE = {
  favoriteJobs: [],
  loading: false,
  errorMessage: undefined,
};

export default function (state = INITIAL_STATE, action) {
  switch (action.type) {
    case FETCH_FAVORITE_JOBS.REQUEST:
      return { ...state, loading: true };

    case FETCH_FAVORITE_JOBS.SUCCESS:
      const { favoriteJobs } = action.payload;
      return { ...state, favoriteJobs, loading: false };

    case FETCH_FAVORITE_JOBS.FAILURE:
    case REMOVE_FAVORITE_JOB.FAILURE:
    case UPDATE_FAVORITE_JOB.FAILURE:
      const { errorMessage } = action.payload;
      return { ...state, errorMessage, loading: false };

    case REMOVE_FAVORITE_JOB.SUCCESS:
      const { sortRank } = action.payload;
      const jobs = [...state.favoriteJobs.slice(0, sortRank), ...state.favoriteJobs.slice(sortRank + 1)];
      return { ...state, favoriteJobs: jobs };

    default:
      return state;
  }
}
