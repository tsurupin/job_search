'use strict';

const debug = require('debug')('speed');

const startTime = 'appStartTime' in global ?
  global.appStartTime :
  Date.now();
const profilings = {};

exports.sinceStart = () => Date.now() - startTime;

exports.addEntry = (name) => {
  const ms = exports.sinceStart();
  profilings[name] = ms;
  return name + ' ' + ms + 'ms';
};

exports.profile = (name) => debug(exports.addEntry(name));
