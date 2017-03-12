import { createRequestTypes } from 'constants';
export const FETCH_JOB = createRequestTypes('job');
export const JOBS_PATH = '/api/v1/jobs';

export const FAVORITE_JOB = createRequestTypes('favorite_job');
export const UNFAVORITE_JOB = createRequestTypes('unfavorite_job');
