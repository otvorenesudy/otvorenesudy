module Probe::Index
  module Alias
    # TODO: use when elasticsearch support percolating against index alias

    def index_alias(name = nil)
      Tire::Alias.new(name: name || index.name)
    end

    def alias_as(bulk_index)
      delete

      index = index_alias

      index.indices.clear
      index.index(bulk_index.name)

      index.save
    end

    def bulk_name
      "#{index_name}_#{Time.now.strftime("%Y%m%d%H%M")}"
    end
  end
end
