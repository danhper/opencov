import riot from 'riot'

import 'phoenix_html'

import '../css/main.styl'

import './components'

riot.mount('*')

// Fix logout link
$(document).off('click.bs.dropdown.data-api', '.dropdown form')
