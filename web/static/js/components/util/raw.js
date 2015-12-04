import riot from 'riot'

riot.tag('raw', '<span></span>', function (opts) {
  this.root.innerHTML = opts.html
})
