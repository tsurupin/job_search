import client from 'axios';
import { ROOT_URL } from 'constants';

export const axios = client.create({
  baseURL: ROOT_URL,
  headers: {
    Accept: 'application/json',
    'Content-Type': 'application/json',
    'X-CSRF-Token': getCSRFToken(),
  },
});

function getCSRFToken() {
  const el = document.querySelector('meta[name="csrf-token"]');
  return el ? el.getAttribute('content') : '';
}

export function createAuthorizeRequest(method, path, params = {}) {
  switch (method) {
    case 'get':
      return axios.get(path, config());
    case 'post':
      return axios.post(path, params, config());
    case 'patch':
      return axios.patch(path, params, config());
    case 'put' :
      return axios.put(path, params, config());
    case 'delete' :
      return axios.delete(path, config());
  }
}

function config() {
  return { headers: { Authorization: `Bearer ${localStorage.getItem('token')}` } };
}

export function convertErrorToMessage(error) {
  return error.response ? error.response.data.errorMessage : 'something wrong';
}

// Make axios path for job-= favorites absolute
// DELETE /jobs/api/v1/me/favorites/jobs/1
// DELETE /api/v1~

