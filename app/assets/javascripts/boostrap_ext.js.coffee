$(document).ready ->
  $('[data-collapse="fold"], [data-collapse="unfold"]').click ->
    action = $(this).attr('data-collapse')

    $(this).parent().find("[data-collapse='#{if action == 'fold' then 'unfold' else 'fold'}']").show()
    $(this).parent().find("[data-collapse='#{action}']").hide()
