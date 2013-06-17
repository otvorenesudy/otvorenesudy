module TranslationHelper
  def translate_with_count(count, key, options = {})
    translate "counts.#{key}", count: count < 5 ? count : number_with_delimiter(count, options)
  end
  
  def translate_without_count(count, key)
    translate key, count: count
  end
  
  def missing_translation?(key)
    translate(key, default: '__missing__') == '__missing__'
  end
end
