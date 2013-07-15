unless Array::remove
  Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1
