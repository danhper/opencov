import riot from 'riot'

import dummyCoverage from '../../dummy-coverage'

const template = require('./file-coverage.jade')();

riot.tag('file-coverage', template, function (opts) {
  this.file = dummyCoverage
})
