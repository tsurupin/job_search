export function createRequestTypes(base) {
  let requestType = {};
  ['REQUEST', 'SUCCESS', 'FAILURE'].forEach(type => {
    requestType[type] = `${base}_${type}`;
  });
  return requestType;
}

export const TECH_KEYWORD = 'techKeyword';
export const FAVORITE_JOB_PATH = '/me/favorites/jobs';
export const ROOT_URL = '/api/v1';