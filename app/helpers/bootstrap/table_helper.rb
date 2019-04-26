module Bootstrap
  module TableHelper
    def table_tag(options = {}, &block)
      content_tag :table, options.deep_merge(data: { sortable: true }), &block
    end

    def table_header_tag(content, options = {})
      content_tag :th, content, options.deep_merge(data: { sorter: options.delete(:sorter) }, scope: 'col')
    end
  end
end
