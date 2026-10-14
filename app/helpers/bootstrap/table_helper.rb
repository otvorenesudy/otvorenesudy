# frozen_string_literal: true

module Bootstrap
  # Tables sortable by clicking their headers (the sortable-table controller). `sorter: 'digit'` sorts a column
  # numerically, `sorter: false` leaves it unsortable.
  module TableHelper
    def table_tag(options = {}, &)
      tag.table(**options.deep_merge(data: { controller: 'sortable-table' }), &)
    end

    def table_header_tag(content, options = {})
      sorter = options.delete(:sorter)

      return tag.th(content, **options, scope: 'col') if sorter == false

      data = { action: 'click->sortable-table#sort', sortable_table_type_param: sorter || 'text' }
      classes = Array.wrap(options.delete(:class)) << 'sortable'

      tag.th(content, **options.deep_merge(data:), class: classes, scope: 'col')
    end
  end
end
