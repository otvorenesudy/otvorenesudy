module Resource::Similarity
  extend ActiveSupport::Concern
  
  module ClassMethods
    def similar_by(column, value, similarity)
      column = column.to_s.gsub(/[^a-zA-Z_\?]/, '')
          
      sql = <<-SQL
      SELECT id, similarity(#{column}, ?) as sml 
      FROM  #{self.name.downcase.pluralize}
      WHERE name % ?
      ORDER BY sml DESC  
      ;
      SQL
      
      ActiveRecord::Base.connection.exec_query("SELECT set_limit(#{similarity.to_f != 0.0 ? similarity.to_f : 1.0});")
      
      values = ActiveRecord::Base.connection.exec_query(sanitize_sql_array([sql, value, value]))
      result = Hash.new
      
      values.to_hash.each do |hash| 
        key = hash['sml'].to_f

        result[key] ||= []
        result[key] << self.find(hash['id'])
      end

      result
    end
    
    def method_missing(method, *args, &block)
      match = method.to_s.match(/\Asimilar_by_(?<column>.*)\z/)
      
      if match
        value, similarity = args
  
        return similar_by(match[:column], value, similarity)
      end
  
      super(method, *args, &block)
    end
  end
end
