module HearingsHelper
  def hearing_title(hearing)
    title(*hearing_identifiers(hearing) << hearing_type(hearing.type))
  end

  def hearing_headline(hearing, options = {})
    join_and_truncate hearing_identifiers(hearing), options.reverse_merge(separator: ', ')
  end

  def hearing_type(type)
    case type
    when HearingType.civil    then "#{t 'hearings.type.civil'} #{t 'hearings.common.hearing'}"
    when HearingType.criminal then "#{t 'hearings.type.criminal'} #{t 'hearings.common.hearing'}"
    when HearingType.special  then "#{t('hearings.common.hearing').upcase_first} #{t('hearings.type.special').downcase_first}"
    else
      raise
    end
  end

  def hearing_date(date, options = {}, &block)
    date = date.to_date if date.respond_to?(:hour) && date.hour.zero?

    time_tag date, { format: :long }.merge(options), &block
  end

  private

  def hearing_identifiers(hearing)
    [hearing.form, hearing.subject].reject(&:blank?).map(&:value)
  end
end
