window.ga = window.ga or ->
  (ga.q = ga.q or []).push arguments

ga.l = +new Date

ga 'create', 'UA-38636233-1', 'auto'

# TODO configure plugins here
ga 'require', 'outboundLinkTracker' #, fieldsObj: { eventCategory: 'External Link' }, events: ['click', 'auxclick', 'contextmenu']
