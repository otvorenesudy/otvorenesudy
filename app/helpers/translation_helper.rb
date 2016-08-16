module TranslationHelper
  def missing_translation?(key)
    translate(key, default: '__missing__') == '__missing__'
  end

  def guess_translation_key(translation, locale, keys)
    keys.each { |key| return key if translation == translate(key, locale: locale) }
  end

  def locale_specific_spaces(content)
    I18n.locale == :sk ? content.gsub(/\s([aikosuvz])\s/i, ' \1&nbsp;') : content
  end

  def translate_with_count(count, key, options = {})
    translate "counts.#{key}", count: count < 5 ? count : number_with_delimiter(count, options)
  end

  def translate_without_count(count, key)
    translate key, count: count
  end
end
