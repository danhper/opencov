import riot from 'riot'
import _ from 'lodash'
import highlight from 'highlight.js'

import './file-coverage.styl'

const template = require('./file-coverage.jade')()

riot.tag('file-coverage', template, function (opts) {
  this.file = window.file
  // Some clients only send a digest of the source, so it may be empty:
  // still show the per-line coverage, without the code.
  this.hasSource = !!this.file.source
  const code = this.hasSource ? highlight.highlightAuto(this.file.source).value : ''
  const lines = this.hasSource ? code.split('\n') : []
  const count = Math.max(lines.length, this.file.coverage.length)
  this.coverageInfo = _.times(count, (i) => [lines[i] || '', this.file.coverage[i]])
})
