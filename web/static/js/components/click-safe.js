import riot from 'riot'

const template = '<div onclick="{ preventClick }"><yield /></div>'

riot.tag('click-safe', template, function (opts) {
  this.preventClick = (e) => {
    e.stopPropagation()
  }
})
