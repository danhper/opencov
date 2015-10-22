'use strict'

import riot from 'riot'
import _ from 'lodash'

import './file-coverage-list.styl'

import dummyCoverages from '../../dummy-coverages'

const template = require('./file-coverage-list.jade')()

riot.tag('file-coverage-list', template, function (opts) {
  this.files = dummyCoverages
  _.each(this.files, (file) => file
})
