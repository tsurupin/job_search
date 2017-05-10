import { createRequestTypes } from 'constants';

export const FETCH_JOBS = createRequestTypes('jobs');
export const FETCH_INFINITE_JOBS = createRequestTypes('infinite_jobs');
export const JOBS_PATH = '/jobs';
export const FAVORITE_JOB_INDEX = createRequestTypes('favorite_job_index');
export const UNFAVORITE_JOB_INDEX = createRequestTypes('unfavorite_job_index');
export const TECH_KEYWORDS_PATH = '/tech-keywords';
export const FETCH_TECH_KEYWORDS = createRequestTypes('techKeywords');
export const RESET_ITEM = 'resetItem';
export const SELECT_ITEM = 'selectItem';
export const RESET_TECH_KEYWORDS = 'resetTechKeywords';
