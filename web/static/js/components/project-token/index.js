'use strict'

import riot from 'riot'

import './project-token.styl'

const template = require('./project-token.jade')()

riot.tag('project-token', template, function (opts) {
  this.token = opts.token
  this.shown = false

  this.toggleShown = () => {
    this.shown = !this.shown
    if (this.shown) {
      setTimeout(() => this['token-input'].select(), 10)
    } else {
      this.root.children[0].blur()
    }
  }

  this.computeWidth = () => {
    return this.token.length * 5
  }
})
