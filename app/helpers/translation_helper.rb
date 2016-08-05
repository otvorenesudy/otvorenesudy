module TranslationHelper
  def missing_translation?(key)
    translate(key, default: '__missing__') == '__missing__'
  end

  def locale_specific_spaces(s)
    I18n.locale == :sk ? s.gsub(/\s([aikosuvz])\s/i, ' \1&nbsp;') : s
  end

  def translate_with_count(count, key, options = {})
    translate "counts.#{key}", count: count < 5 ? count : number_with_delimiter(count, options)
  end

  def translate_without_count(count, key)
    translate key, count: count
  end
end
