class DV.Documents extends Backbone.Collection
  model: DV.Document

  comparator: (document) ->
    document.getNumber()


