'use strict'

import riot from 'riot'
import _ from 'lodash'
import highlight from 'highlight.js'

import './file-coverage.styl'

import dummyCoverage from '../../dummy-coverage'

const template = require('./file-coverage.jade')()

riot.tag('file-coverage', template, function (opts) {
  this.file = dummyCoverage
  let code = highlight.highlightAuto(this.file.source).value
  this.coverageInfo = _.zip(code.split('\n'), this.file.coverage)
})
