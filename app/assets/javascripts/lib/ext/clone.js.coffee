window.clone = (o) ->
  if not o? or typeof o isnt 'object'
    return o

  if o instanceof Date
    return new Date(o.getTime())

  if o instanceof RegExp
    flags = ''
    flags += 'g' if o.global?
    flags += 'i' if o.ignoreCase?
    flags += 'm' if o.multiline?
    flags += 'y' if o.sticky?
    return new RegExp(o.source, flags)

  instance = new o.constructor()

  for key of o
    instance[key] = clone o[key]

  return instance
