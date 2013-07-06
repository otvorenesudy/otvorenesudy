# encoding: utf-8

module IndicatorHelper
  def rank(value)
    return number_with_delimiter(value) << '.' unless value.is_a? Range
    
    "#{number_with_delimiter value.min}. až #{number_with_delimiter value.max}."
  end  
end
