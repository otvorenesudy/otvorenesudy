module Resource::Similarity
  def similar_by(column, value, similarity)
    column = column.gsub(/[^a-zA-Z_\?]/, '')
        
    sql = <<-SQL
    SELECT id, similarity(#{column}, ?) as sml 
    FROM  #{self.name.downcase.pluralize}
    WHERE name % ?
    ORDER BY sml DESC  
    ;
    SQL
   
    ActiveRecord::Base.connection.exec_query("SELECT set_limit(#{similarity.to_f != 0.0 ? similarity.to_f : 1.0});")
    
    result = ActiveRecord::Base.connection.exec_query(sanitize_sql_array([sql, value, value]))

    result.to_hash.map { |hash| self.find(hash['id']) }
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
