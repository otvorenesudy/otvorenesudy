module Bootstrap
  module TableHelper
    def sortable_table_tag(options = {}, &block)
      content_tag :table, options.merge(data: { sortable: true }), &block
    end

    def sortable_th_tag(content, options = {})
      content_tag :th, content, options.merge(data: { sorter: options.delete(:sorter) })
    end
  end
end
