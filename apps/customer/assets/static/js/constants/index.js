export function createRequestTypes(base) {
  const requestType = {};
  ['REQUEST', 'SUCCESS', 'FAILURE'].forEach((type) => {
    requestType[type] = `${base}_${type}`;
  });
  return requestType;
}

export const REMOVE_FAVORITE_JOB = createRequestTypes('remove_favorite_job');
export const UNFAVORITE_JOB = createRequestTypes('unfavorite_job');
export const TECH_KEYWORD = 'techKeyword';
export const FAVORITE_JOB_PATH = '/me/favorites/jobs';
export const ROOT_URL = '/api/v1';
