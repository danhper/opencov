'use strict'

import riot from 'riot'

riot.tag('click-safe', '<div onclick="{ preventClick }"><yield /></div>', function (opts) {
  this.preventClick = (e) => {
    e.stopPropagation()
  }
})
