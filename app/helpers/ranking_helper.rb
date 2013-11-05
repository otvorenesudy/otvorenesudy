# encoding: utf-8

module RankingHelper
  def rank(value)
    return number_with_delimiter(value) << '.' unless value.is_a? Range
    
    "#{number_with_delimiter value.min}. až #{number_with_delimiter value.max}."
  end
  
  def rank_with_order(hash, options = {})
    "#{rank hash[:rank]} #{hash[:order] == :desc ? options[:desc] : options[:asc]}"
  end
end
