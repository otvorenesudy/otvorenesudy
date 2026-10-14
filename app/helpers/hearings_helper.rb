# frozen_string_literal: true

module HearingsHelper
  def hearing_title(hearing)
    title(*hearing_identifiers(hearing), hearing_type(hearing.type))
  end

  def hearing_headline(hearing, options = {})
    join_and_truncate hearing_identifiers(hearing), options.reverse_merge(separator: ', ')
  end

  # "Civilné pojednávanie", "Trestné pojednávanie", "Pojednávanie špecializovaného trestného súdu".
  def hearing_type(type)
    hearing = t('hearings.common.hearing')

    return "#{hearing.upcase_first} #{t('hearings.type.special').downcase_first}" if type == HearingType.special

    "#{t("hearings.type.#{type == HearingType.criminal ? 'criminal' : 'civil'}")} #{hearing}"
  end

  # A date and time, or only the date when the hour is midnight (unknown).
  def hearing_date(date, options = {})
    date = date.to_date if date.respond_to?(:hour) && date.hour.zero?

    time_tag date, { format: :long }.merge(options)
  end

  private

  def hearing_identifiers(hearing)
    [hearing.form, hearing.subject].compact.map(&:value).compact_blank
  end
end
