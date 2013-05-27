class DV.Pages extends Backbone.Collection
  model: DV.Page

  comparator: (page) ->
    page.getNumber()
