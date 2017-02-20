export function createRequestTypes(base) {
  let requestType = {};
  ['REQUEST', 'SUCCESS', 'FAILURE'].forEach(type => {
    requestType[type] = `${base}_${type}`;
  });
  return requestType;
}

export const TECH_KEYWORD = 'techKeyword';
