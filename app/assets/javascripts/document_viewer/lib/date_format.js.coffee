class DV.DateFormat
  @format = (date) ->
    if date
      "#{date.getDate()}.#{date.getMonth()}.#{date.getUTCFullYear()} #{date.getHours()}:#{date.getMinutes()}"
