# frozen_string_literal: true

module TranslationHelper
  # Translations are HTML when asked (html_safe: true), when they have no interpolations and no tags, or when every
  # interpolated value is HTML already.
  def translate(key, **options)
    html_safe = options.delete(:html_safe)
    interpolations = options.except(*I18n::RESERVED_KEYS)
    translation = super

    return translation unless translation.respond_to?(:html_safe)
    return translation.html_safe if html_safe || safe_translation?(translation, interpolations) # rubocop:disable Rails/OutputSafety -- our own translations, see above

    translation
  end

  alias t translate

  def missing_translation?(key)
    translate(key, default: '__missing__') == '__missing__'
  end

  def guess_translation_key(translation, locale, keys)
    keys.find { |key| translation == translate(key, locale:) }
  end

  # Slovak typography: a one-letter preposition or conjunction keeps to the next word.
  def locale_specific_spaces(content)
    return content unless I18n.locale == :sk

    content = h(content) unless content.html_safe?
    content.to_str.gsub(/\s([aikosuvz])\s/i, ' \1&nbsp;').html_safe # rubocop:disable Rails/OutputSafety -- escaped above
  end

  alias s locale_specific_spaces

  def ordinalize(number)
    I18n.locale == :sk ? "#{number}." : number.to_i.ordinalize
  end

  def translate_with_count(count, key, options = {})
    translate("counts.#{key}", count: count < 5 ? count : number_with_delimiter(count, options))
  end

  def translate_without_count(count, key)
    translate(key, count:)
  end

  def two_words_connector
    translate('support.array.two_words_connector').strip
  end

  private

  def safe_translation?(translation, interpolations)
    return !translation.match?(/[<>]/) if interpolations.none?

    interpolations.values.all? { |value| value.respond_to?(:html_safe?) && value.html_safe? }
  end
end
