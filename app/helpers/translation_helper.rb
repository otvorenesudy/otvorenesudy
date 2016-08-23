module TranslationHelper
  def translate(key, options = {})
    html_safe = options.delete :html_safe
    interpolations = options.except *I18n::RESERVED_KEYS
    translation = super key, options

    if translation.respond_to? :html_safe
      # mark as HTML safe with positive :html_safe option
      return translation.html_safe if html_safe

      # mark as HTML safe with no interpolations present and translation not containing HTML tag brackets
      return translation.html_safe if interpolations.none? && translation !~ /[<>]/

      # mark as HTML safe with some interpolations present and all marked as HTML safe
      return translation.html_safe if interpolations.any? && interpolations.inject(true) { |r, (_, v)| r && v.html_safe? }
    end

    translation
  end

  alias :t :translate

  def missing_translation?(key)
    translate(key, default: '__missing__') == '__missing__'
  end

  def guess_translation_key(translation, locale, keys)
    keys.each { |key| return key if translation == translate(key, locale: locale) }
  end

  def locale_specific_spaces(content)
    I18n.locale == :sk ? content.gsub(/\s([aikosuvz])\s/i, ' \1&nbsp;').html_safe : content
  end

  alias :s :locale_specific_spaces

  def translate_with_count(count, key, options = {})
    translate "counts.#{key}", count: count < 5 ? count : number_with_delimiter(count, options)
  end

  def translate_without_count(count, key)
    translate key, count: count
  end

  def two_words_connector
    translate('support.array.two_words_connector').strip
  end
end
