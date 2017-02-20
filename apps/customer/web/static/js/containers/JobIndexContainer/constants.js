import { createRequestTypes } from 'constants';

export const FETCH_JOBS = createRequestTypes('jobs');
export const JOBS_PATH = '/api/v1/jobs';
export const TECH_KEYWORDS_PATH = '/api/v1/tech-keywords';
export const FETCH_TECH_KEYWORDS = createRequestTypes('techKeywords');
export const RESET_ITEM = 'resetItem';
export const SELECT_ITEM = 'selectItem';
