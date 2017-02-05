import { createRequestTypes } from 'constants';

export const LOGIN = createRequestTypes('LOGIN');
export const LOGOUT = createRequestTypes('LOGOUT');

const ROOT_PATH = '/api/v1/auth';
export const LOGIN_PATH = `${ROOT_PATH}/google`;
export const LOGOUT_PATH = ROOT_PATH;
