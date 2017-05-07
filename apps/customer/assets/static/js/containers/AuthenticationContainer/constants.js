import { createRequestTypes } from 'constants';

export const LOGIN = 'login';
export const LOGOUT = createRequestTypes('LOGOUT');

export const LOGOUT_PATH = '/auth';
