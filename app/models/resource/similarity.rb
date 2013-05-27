module Resource::Similarity
  extend ActiveSupport::Concern

  module ClassMethods
    def similar_by(column, value, options = {})
      limit        = options[:limit] ? options[:limit].to_f : 1.0
      table        = self.name.downcase.pluralize
      column       = column.to_s.gsub(/[^a-zA-Z_\?]/, '')
      substitution = '?'

      raise if limit <= 0.0 || limit > 1.0

      if options[:function]
        function     = options[:function]
        column       = "#{function}(#{column})"
        substitution = "#{function}(?)"
      end

      sql = <<-SQL
      SELECT id, similarity(#{column}, #{substitution}) as s 
      FROM  #{table}
      WHERE #{column} % #{substitution}
      ORDER BY s DESC;
      SQL

      ActiveRecord::Base.connection.exec_query("SELECT set_limit(#{limit});")

      values = ActiveRecord::Base.connection.exec_query(sanitize_sql_array([sql, value, value]))
      result = Hash.new

      values.to_hash.each do |hash| 
        key = hash['s'].to_f

        result[key] ||= []
        result[key] << self.find(hash['id'])
      end

      result
    end

    def method_missing(method, *args, &block)
      if match = method.to_s.match(/\Asimilar_by_(?<column>.*)\z/)
        value, options = args

        return similar_by(match[:column], value, options || {})
      end

      super(method, *args, &block)
    end
  end
end
