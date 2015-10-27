'use strict'

import riot from 'riot'
import _ from 'lodash'
import highlight from 'highlight.js'

import './file-coverage.styl'

import dummyCoverages from '../../../../../test/fixtures/dummy-coverages.json'

const template = require('./file-coverage.jade')()

riot.tag('file-coverage', template, function (opts) {
  // jscs:disable
  this.file = dummyCoverages[0].source_files[1]
  // jscs:enable
  let code = highlight.highlightAuto(this.file.source).value
  this.coverageInfo = _.zip(code.split('\n'), this.file.coverage)
})
