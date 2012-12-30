module Resource::Similarity

  def similar_by(column, value, similarity)
    column = column.gsub(/[^a-zA-Z_\?]/, '')
        
    sql = <<-SQL
    SELECT id, similarity(#{column}, ?) as sml 
    FROM  #{self.name.downcase.pluralize}
    WHERE name % ?
    ORDER BY sml DESC, name 
    ;
    SQL
   
    ActiveRecord::Base.connection.exec_query("SELECT set_limit(#{similarity.to_f != 0.0 ? similarity.to_f : 1.0});")
    
    result = ActiveRecord::Base.connection.exec_query(sanitize_sql_array([sql, value, value]))

    result = result.to_hash

    result.map { |hash| self.find(hash['id']) }
  end
  
  def method_missing(method, *args, &block)
    match = method.to_s.match(/\Asimilar_by_(?<column>.*)\z/)
    
    if match
      value, similarity = args

      return similar_to(match[:column], value, similarity)
    end

    method_missing(m, *args, &block)
  end

end
