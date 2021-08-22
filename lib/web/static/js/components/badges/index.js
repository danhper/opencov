import riot from 'riot'

import './badges.styl'

const template = require('./badges.jade')()

riot.tag('badges', template, function (opts) {
  const splitted = opts.badgeUrl.split('.')
  const baseURL = splitted.slice(0, splitted.length - 1).join('.')

  const setFormat = (format) => {
    this.format = format
    this.badgeURL = [baseURL, this.format].join('.')
  }

  setFormat(splitted[splitted.length - 1])

  this.handleClickFormat = (e) => {
    setFormat(e.target.dataset.format)
  }
})
