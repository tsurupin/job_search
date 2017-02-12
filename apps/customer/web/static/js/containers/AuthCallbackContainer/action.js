import { browserHistory } from 'react-router';

export function fetchToken(token) {
  localStorage.setItem('token', token);
  browserHistory.push('/');
  return {};
}
