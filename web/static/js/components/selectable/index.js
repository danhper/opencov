'use strict'

import riot from 'riot'

import './selectable.styl'

riot.tag('selectable',
  '<textarea readonly onclick="{ selectText }" rows="{ opts.rows }">{ opts.text }</textarea>',
  function (opts) {
    this.selectText = (e) => {
      e.stopPropagation()
      this.root.children[0].select()
    }
  }
)
